//
//  ZHExtentionViewController.m
//  test
//
//  Created by rrjj on 2019/5/24.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHExtentionViewController.h"
#import "ZHArchiveModel.h"
#import "ZHSubArcModel.h"
#import "ZHPageTestViewController.h"
#import <SGPagingView.h>
@interface ZHExtentionViewController ()<SGPageContentScrollViewDelegate,SGPageTitleViewDelegate>
@property (nonatomic,strong) SGPageTitleView *pageTitleView;
@property (nonatomic,strong) SGPageContentScrollView *contentS;


@end

@implementation ZHExtentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"oh hoo";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    ZHArchiveModel *model = [ZHArchiveModel new];
//    model.name = @"nnnnn";
    ZHSubArcModel *model = [ZHSubArcModel new];
    model.name = @"sub";
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
 
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"ios.archiver1"];
    NSLog(@"%@",path);
    //创建文件
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    [data writeToFile:path atomically:YES];
    
    [self setupPageView];
}

- (void)setupPageView
{
    NSMutableArray *titleArr = [NSMutableArray array];
    NSMutableArray *vcArr = [NSMutableArray array];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DCURLRouter" ofType:@"plist"]];
    NSDictionary *zhtest = dict[@"ZHTest"];
    for (NSInteger i = 0; i < zhtest.allKeys.count; i ++) {
        [titleArr addObject:zhtest.allValues[i]];
//        Class class = NSClassFromString(zhtest.allValues[i]);
        ZHPageTestViewController *viewC = [[ZHPageTestViewController alloc] init];
        viewC.labelTitle = [NSString stringWithFormat:@"%@",zhtest.allValues[i]];
        [vcArr addObject:viewC];
    }
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 64, ScreenWidth, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:self.pageTitleView];
    
    self.contentS = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), ScreenWidth, Screenheight - CGRectGetMaxY(self.pageTitleView.frame)) parentVC:self childVCs:vcArr];
    self.contentS.delegatePageContentScrollView = self;
    
    [self.view addSubview:self.contentS];
    self.contentS.isAnimated = YES;
    
}

#pragma mark - touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"ios.archiver1"];
    //读取文件的内容
    NSData *data = [NSData dataWithContentsOfFile:path];
    //将二进制数据转化为对应的对象类型
    NSError *error;
    ZHSubArcModel *model = [NSKeyedUnarchiver unarchivedObjectOfClass:[ZHSubArcModel class] fromData:data error:&error];
    NSLog(@"%@",model.name);
    if (error) {
        NSLog(@"%@",error);
    }
}

#pragma mark - SGPageContentScrollViewDelegate,SGPageTitleViewDelegate


- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.contentS setPageContentScrollViewCurrentIndex:selectedIndex];
}

-(void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}








@end
