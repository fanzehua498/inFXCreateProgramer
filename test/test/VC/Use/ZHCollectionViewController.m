//
//  ZHCollectionViewController.m
//  test
//
//  Created by rrjj on 2019/6/5.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//  参考来源 https://blog.csdn.net/u011361385/article/details/80680170

#import "ZHCollectionViewController.h"
#import "ZHLayout.h"
#import "ZHCircleLayout.h"
#import "ZHNotifyObject.h"
@interface ZHCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) ZHNotifyObject *nObj;

@end

@implementation ZHCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view addSubview:self.collectionView];
    self.nObj = [ZHNotifyObject new];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    
    self.nObj.name = NSStringFromCGPoint([touch locationInView:self.view]);
}

#pragma mark - private
- (BOOL)isChinese:(NSString *)str{
    NSString *pattern = @"[\u4e00-\u9fa5]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

- (NSArray *)stringLenth:(NSString *)str{
    NSMutableArray *resultArr = [NSMutableArray array];
    if (!str || str.length == 0) {
        return resultArr;
    }
    NSInteger cheseL = 0;
    NSInteger index = 0;
    for (NSInteger i = 0; i < str.length; i ++) {
        NSString *chinese = [str substringWithRange:NSMakeRange(i, 1)];
        BOOL result = [self isChinese:chinese];
        if (result) {
            cheseL = cheseL + 2;
            if (cheseL == 9 || cheseL == 10) {
                index = i-1;
            }
        }else{
            cheseL ++;
            if (cheseL == 9) {
                index = i;
            }
        }
    }
    [resultArr addObject:@(cheseL)];
    [resultArr addObject:@(index)];
    return resultArr;
}



#pragma mark - delegate datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.layer.cornerRadius = 25;
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return cell;
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
//        ZHLayout *layout = [[ZHLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.itemCount = 100;
        
        ZHCircleLayout *layout = [[ZHCircleLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _collectionView;
}

@end
