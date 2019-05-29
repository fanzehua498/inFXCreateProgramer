//
//  ZHSDKTestViewController.m
//  test
//
//  Created by rrjj on 2019/5/27.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHSDKTestViewController.h"
#import <ZHSDKDemo/ZHSDKDemoViewController.h>
#import <UserNotifications/UserNotifications.h>
#import "CHDLaunchView.h"
#import "UIView+ZHCategory.h"
@interface ZHSDKTestViewController ()

@property (nonatomic,strong) UIView *redView;

@end

@implementation ZHSDKTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    XLLaunchView *launchView = [[XLLaunchView alloc] initWithFrame:self.view.frame];
//    launchView.backgroundColor = [UIColor redColor];
//
//    [self.view addSubview:launchView];
//    [launchView drawCorporateLogoOfAnimation];
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
   
}

- (void)animationFun{
    
    /**
     @param dampingRatio 弹簧阻力
     @param velocity     初速度
     */
    [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.redView.centerX = self.view.bounds.size.width - self.redView.center.x;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ZHSDKDemoViewController *vc = [[ZHSDKDemoViewController alloc] init];
    
    [self animationFun];
//    [self presentViewController:vc animated:YES completion:nil];
    

   
}

- (void)localNotifi1
{
    UILocalNotification *localNote = [[UILocalNotification alloc] init];

    // 2.设置本地通知的内容
    // 2.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    // 2.2.设置通知的内容
    localNote.alertBody = @"alertBody";
    // 2.4.决定alertAction是否生效
    localNote.hasAction = NO;
    // 2.6.设置alertTitle
    localNote.alertTitle = @"alertTitle";
    // 2.7.设置有通知时的音效
    localNote.soundName = UILocalNotificationDefaultSoundName;
    // 2.8.设置应用程序图标右上角的数字
    localNote.applicationIconBadgeNumber = 0;
    // 2.9.设置额外信息
    localNote.userInfo = @{};
    localNote.alertLaunchImage = @"icon_certification_status1@2x";

    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

- (void)localNotifi2
{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
