//
//  ZHViewModelController.m
//  test
//
//  Created by rrjj on 2019/5/22.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHViewModelController.h"
#import "ZHViewModel.h"
#import <ReactiveCocoa.h>
#import "ZHVerifyView.h"
#import "ZHRacModel.h"
@interface ZHViewModelController ()

@property (nonatomic,strong) ZHViewModel *viewModel;

@property (copy, nonatomic) NSString *myName;

@property (nonatomic,strong) id<RACSubscriber> subscriber;


@end

@implementation ZHViewModelController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"MVVM&ReactCocoa";
    self.view.backgroundColor = [UIColor whiteColor];
    [self bind];
    
    [self textSignal];
//    [self viewSingal];
//    [self buttonSingal];
    [self delegateSign];
    
    
    ZHRacModel *model = [ZHRacModel new];
    [model arrayRac];
    
}
#pragma mark - rac 监听
- (void)textSignal
{
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 60, 20)];
    field.placeholder = @"plaa";
    [self.view addSubview:field];
    [field.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
   
}

-(void)viewSingal
{
    ZHVerifyView *view = [[ZHVerifyView alloc] initWithFrame:CGRectMake(100, 120, 20, 20)];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
    
    [[view rac_signalForSelector:@selector(show)] subscribeNext:^(id x) {
       
        NSLog(@"方法监听%@",x);
    }];
    
    [[view rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id x) {
        NSLog(@"kvo:%@",x);
    }];
}

- (void)buttonSingal
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 140, 60, 20);
    [btn setTitle:@"title" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"按钮事件监听:%@",x);
    }];
    
    //键盘监听
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification object:nil] subscribeNext:^(id x) {
       //
        NSLog(@"键盘hide");
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘show");
    }];
    
    //定时器
//    [[RACSignal interval:1.0 onScheduler:[RACScheduler scheduler]] subscribeNext:^(id x) {
//        NSLog(@"定时器：%@",x);
//    }];
    RACSignal *rep = [[RACSignal interval:1 onScheduler:[RACScheduler    mainThreadScheduler]] subscribeNext:^(NSDate *time) {
        NSLog(@"定时器：%@",time);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];

        NSLog(@"riqi:：%@",[formatter stringFromDate:time]);
    }];
    
    //申请注册一个时间属性的信号量
    RACSignal *timeSignal = [self rac_valuesForKeyPath:@"time" observer:self];
    //为信号量添加执行代码端
//    [timeSignal subscribeNext:^(NSDate* time) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"HH:mm:ss"];
//
//
//        NSLog(@"riqi:：%@",[formatter stringFromDate:time]);
////        RELEASESAFELY(formatter);
//    }];
    
}

- (void)delegateSign{
    
//    [[self rac_signalForSelector:@selector(webViewDidStartLoad:) fromProtocol:@protocol(UIWebViewDelegate)] subscribeNext:^(id x) {
//        NSLog(@"web加载完成");
//    }];
//
//    [[self rac_signalForSelector:@selector(tableView:numberOfRowsInSection:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(id x) {
//
//    }];
    
    
    [RACObserve(self, myName) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [[[RACSignal combineLatest:@[RACObserve(self, myName)] reduce:^(NSString *myName){
        return @(myName.length > 0);
        
    }] distinctUntilChanged] subscribeNext:^(NSNumber *valid) {
        
        if (valid.boolValue) {
            NSLog(@"可以shiyong");
        }else{
            NSLog(@"不可使用");
        }
    }];
    
    
//    [NSObject rac_liftSelector:<#(SEL)#> withSignalsFromArray:<#(NSArray *)#>]
}

#pragma mark - end

- (void)bindString
{

}

- (void)bind{
    @weakify(self);
    [self.viewModel.command.executionSignals.switchToLatest subscribeNext:^(NSArray *array) {
        @strongify(self);
        NSLog(@"控制器获取到了");
        NSLog(@"%@",array);
        
    }];
    //执行command  才能监听
    [self.viewModel.command execute:nil];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint po = [touch locationInView:self.view];
    self.myName = self.myName.length > 0 ? @"" : NSStringFromCGPoint(po);
}


#pragma mark - 懒加载
-(ZHViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[ZHViewModel alloc] init];
    }
    return _viewModel;
}

@end
