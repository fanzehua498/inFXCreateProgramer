//
//  ViewController.m
//  test
//
//  Created by rrjj on 2018/10/10.
//  Copyright © 2018 rrjj. All rights reserved.
//

#import "ViewController.h"
#import "ClickViewController.h"
#import "SiftView.h"
#import "HotlListView.h"
#import <WebKit/WebKit.h>
#import "ProblemOne.h"
#import <Masonry.h>
#import <ShellSDK/CustomObj.h>
#import <AppTestFrameWorkSDK/AppTestFrameWorkSDK.h>
#import "ZipViewController.h"
#import "CityListViewController.h"
#import "FFPlayerButton.h"
#import "AnLineView.h"
#import <UserNotifications/UserNotifications.h>

#import "FFUIPageControlView.h"

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,UNUserNotificationCenterDelegate>
{
    SiftView *sift;
    UILabel *anLabel;
}
@end
static void*queueKey = "QueueKey";
@implementation ViewController

- (void)loggg
{
    NSLog(@"main Thread:%d %@",[NSThread currentThread].isMainThread,dispatch_get_current_queue());
    void *result = dispatch_get_specific(queueKey);
    if (dispatch_get_specific(queueKey)) {
        NSLog(@"no empty");
        NSLog(@"2. 当前线程是: %@, 当前队列是: %@ 。",[NSThread currentThread],dispatch_get_current_queue());
        
    }else{
        NSLog(@"empty");
        NSLog(@"3. 当前线程是: %@, 当前队列是: %@ 。",[NSThread currentThread],dispatch_get_current_queue());
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AppSayHello *hello = [[AppSayHello alloc] init];
    [hello sayHello];
    
    CustomObj *obj = [[CustomObj alloc] init];
    [obj sayHello];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self loggg];
//        });
//    });
//    dispatch_main();
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    label.backgroundColor = [UIColor redColor];
    label.text = @"我是alabel";
    [self.view addSubview:label];
    [NSTimer scheduledTimerWithTimeInterval:4 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        CATransition *tran = [CATransition animation];
        tran.type = kCATransitionPush;
        tran.subtype = kCATransitionFromRight;
//        tran.duration = 2;
        [label.layer addAnimation:tran forKey:@"trans"];
        
//        NSInteger idx = arc4random()%data.count;
//        label.text = data[idx];
    }];
//
//
//    CAShapeLayer *layerTop = [CAShapeLayer layer];
////    NSLog(@"%@",NSStringFromCGSize(self.detailTop.bounds.size));
//    layerTop.frame = label.bounds;
//    layerTop.lineWidth = 1;
//    //RGBA(111, 139, 253, 1)
//    layerTop.strokeColor = [UIColor redColor].CGColor;
//    layerTop.borderColor = [UIColor redColor].CGColor;
//    layerTop.fillColor = [UIColor clearColor].CGColor;
//    layerTop.path = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(3, 3)].CGPath;
////    label.layer.mask = layerTop ;
//    [label.layer addSublayer:layerTop];
//    sift = [[SiftView alloc] initWithFrame:CGRectMake(0, 30, 375, 400) WithTitle:@"星级（可多选）" singleBack:YES];
////    [self.view addSubview:sift];
//
//    sift.isSingle = NO;
//    sift.level = @[@"星级不限",@"经济/客栈",@"三星/舒适",@"四星/高档",@"五星/豪华"];
//    sift.block = ^(NSString *choose){
//        NSLog(@"选择了:%@",choose);
//    };
//
//    SiftView *bottom = [[SiftView alloc] initWithFrame:CGRectMake(0, 200, 375, 400) WithTitle:@"价格" singleBack:NO];
////    [self.view addSubview:bottom];
//    bottom.level = @[@"价格不限",@"￥0-150",@"￥150-300",@"￥300-450",@"￥450-700",@"￥700以上"];
//
//    HotlListView *list = [[HotlListView alloc] initWithFrame:CGRectMake(0, 64, 375, 667-64)];
////    [self.view addSubview:list];
//
//    UILabel *tiplabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 375, 20)];
//    tiplabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
//    tiplabel.textColor = [UIColor redColor];
//    [self.view addSubview:tiplabel];
//
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"今晨0-6点入住，入住日期请选择"];
//    [attr addAttribute:NSKernAttributeName value:@(10) range:NSMakeRange(0, 8)];
//    tiplabel.attributedText = attr;
    
    ProblemOne *one = [[ProblemOne alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    one.backgroundColor = [UIColor redColor];
//    [self.view addSubview:one];
    
    void *p =malloc(100);
    NSLog(@"%lu",sizeof(p));
    
    int a[5] = {2,4,6,8,10};
    int *ptr = (int *)(&a + 1);
    printf("%d,%d,%d",*a,*(a + 1),*(ptr -  1));
//    printf("%s %s",&a);
    char str[100];
    printf("%lu",sizeof(str));
    
//    for (int i = 0; i < 10000; i++) {
//        @autoreleasepool {
//            NSString *string = @"Abc";
//            string = [string lowercaseString];
//            string = [string stringByAppendingString:@"xyz"];
//            NSLog(@"%@",string);
//        }
//    }
//    switch (TargetType) {
//        case 1:{
//            UIView *test = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
//            test.backgroundColor = [UIColor greenColor];
//            [self.view addSubview:test];
//            [test mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(200);
//            }];
//        }
//
//            break;
//        case 2:{
//            UIView *test = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
//            test.backgroundColor = [UIColor greenColor];
//            [self.view addSubview:test];
//            [test mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.view).offset(200);
//                make.top.equalTo(self.view).offset(200);
//                make.width.mas_equalTo(200);
//                make.height.mas_equalTo(200);
//            }];
//        }
//            break;
//        default:
//            break;
//    }
//    anLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 300, 100, 100)];
//    anLabel.text = @"wowowo";
//    anLabel.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:anLabel];
//    
//    FFPlayerButton *button = [[FFPlayerButton alloc] initWithFrame:CGRectMake(100, 300, 30, 30)];
//    button.backgroundColor = [UIColor redColor];
//    [button addTarget:self action:@selector(onclickBuutton:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:button];
//    AnLineView *lin = [[AnLineView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:lin];
//    lin.backgroundColor = [UIColor grayColor];
//    
//    NSMutableArray *pointArr = [NSMutableArray array];
//    for (NSInteger i = 0; i < 30; i ++) {
//        NSInteger pointY = i % 2 == 0 ? 100 + 10 : 100 - 10;
//        CGPoint point = CGPointMake(pointY, 0 + i * 20);
//        [pointArr addObject:[NSValue valueWithCGPoint:point]];
//    }
//    
//    lin.array = [NSArray arrayWithArray:pointArr];
    
    FFUIPageControlView  *page = [[FFUIPageControlView alloc] initWithFrame:self.view.bounds];
    [page setupTimer];
    [self.view addSubview:page];
    
}
- (void)onclickBuutton:(UIButton*)button {
    NSLog(@"点击自定义按钮");
    button.selected        = !button.isSelected;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [sift getSelectData];

    CABasicAnimation    *round                  = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    round.fromValue                             = @0
    ;
    round.toValue                               = @(20.0);
    round.duration                              = 2 * .5;
    [anLabel.layer addAnimation:round forKey:nil];
    anLabel.layer.cornerRadius                 = 20.;
    
//    ClickViewController *z = [ClickViewController new];
//    [self presentViewController:z animated:YES completion:^{
//
//    }];
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 ) {
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
                notification.repeatInterval = NSCalendarUnitDay;
                notification.alertBody = @"本地通知1";
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            } else {
                //必须写代理，不然无法监听通知的接收与点击事件
//                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//                center.delegate = self;
//                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//                content.body = @"本地通知2";
//                content.userInfo = @{};
//                content.sound = [UNNotificationSound defaultSound];
//                //ios 12 后失败，会导致闪退
//                //[content setValue:@(YES) forKeyPath:@"shouldAlwaysAlertWhileAppIsForeground"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Notif" content:content trigger:nil];
//                    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//                    }];
//                });
                // 1.创建通知内容
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//                [content setValue:@(YES) forKeyPath:@"shouldAlwaysAlertWhileAppIsForeground"];
                content.sound = [UNNotificationSound defaultSound];
                content.title = @"title";
                content.subtitle = @"subTitle";
                content.body = @"body";
                content.badge = @(1);
                
                content.userInfo = @{};
                
                // 2.设置通知附件内容
                NSError *error = nil;
                NSString *path = [[NSBundle mainBundle] pathForResource:@"logo_img_02@2x" ofType:@"png"];
                UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
                if (error) {
                    NSLog(@"attachment error %@", error);
                }
                content.attachments = @[att];
                content.launchImageName = @"icon_certification_status1@2x";
                // 2.设置声音
                UNNotificationSound *sound = [UNNotificationSound soundNamed:@"sound01.wav"];// [UNNotificationSound defaultSound];
                content.sound = sound;
                
                // 3.触发模式
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                
                // 4.设置UNNotificationRequest
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"identifier" content:content trigger:trigger];
                
                //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                }];

            }
            
            
        } else {
            
        }
    }];
    
    
    
//    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"13758140932"];
//    
//    WKWebView *wkVie = [[WKWebView alloc] init];
//    [wkVie loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    wkVie.UIDelegate = self;
//    wkVie.navigationDelegate = self;
//    [self.view addSubview:wkVie];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    UIApplication *app = [UIApplication sharedApplication];
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    if ([scheme isEqualToString:@"tel"]) {
        if ([app canOpenURL:url]) {
            CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
            if (version >= 10.0) {
                /// 大于等于10.0系统使用此openURL方法
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    /* 这句话一定要实现 不然会异常 */
    decisionHandler(actionPolicy);
}



@end
