//
//  AppDelegate.m
//  test
//
//  Created by rrjj on 2018/10/10.
//  Copyright © 2018 rrjj. All rights reserved.
//

#import "AppDelegate.h"
#import <Realm.h>
#import "Student.h"
#import "Books.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerLocalNotification];
    [DCURLRouter loadConfigDictFromPlist:@"DCURLRouter.plist"];
    [self dataVersion];
//    [self bookData];
    return YES;
}
- (void)dataVersion
{
    //数据迁移
    int newVersion = 12;
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
    config.schemaVersion = newVersion;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
        if (oldSchemaVersion <= newVersion) {
            // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
            NSLog(@"数据结构会自动迁移");
            
            // enumerateObjects:block: 遍历了存储在 Realm 文件中的每一个“Person”对象
            [migration enumerateObjects:[Student className] block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
                // 只有当 Realm 数据库的架构版本为 0 的时候，才添加 “fullName” 属性
                if (oldSchemaVersion < 1) {
                    newObject[@"fullName"] = [NSString stringWithFormat:@"%@ %@", oldObject[@"firstName"], oldObject[@"lastName"]];
                }
                // 只有当 Realm 数据库的架构版本为 0 或者 1 的时候，才添加“email”属性
                if (oldSchemaVersion < 2) {
                    newObject[@"email"] = @"";
                }
                
            }];
            // 替换属性名(原字段重命名)
            if (oldSchemaVersion < 12) { // 重命名操作应该在调用 `enumerateObjects:` 之外完成
                [migration renamePropertyForClass:[Student className] oldName:@"sex" newName:@"age"];
            }
        }
    };
    config.objectClasses = @[NSClassFromString(@"Student"),NSClassFromString(@"Books")];
    config.inMemoryIdentifier = @"memory";//配置内存数据库，应用杀死之后数据不会保存。
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
    
    //每次修改了数据的模型的时候 就需改一次schemaVersion属性（版本号 注意：版本号不能低于上一次的版本）
}

- (void)bookData
{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    //    config.readOnly = YES;
    config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"zehua"] URLByAppendingPathExtension:@"realm"];
    
    int newVersion = 0;
    
    // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
    config.schemaVersion = newVersion;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
        if (oldSchemaVersion <= newVersion) {
            // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
            NSLog(@"数据结构会自动迁移");
            
            // enumerateObjects:block: 遍历了存储在 Realm 文件中的每一个“Person”对象
            [migration enumerateObjects:[Books className] block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
                // 只有当 Realm 数据库的架构版本为 0 的时候，才添加 “fullName” 属性
//                if (oldSchemaVersion < 1) {
//                    newObject[@"fullName"] = [NSString stringWithFormat:@"%@ %@", oldObject[@"firstName"], oldObject[@"lastName"]];
//                }
//                // 只有当 Realm 数据库的架构版本为 0 或者 1 的时候，才添加“email”属性
//                if (oldSchemaVersion < 2) {
//                    newObject[@"email"] = @"";
//                }
                
            }];
            // 替换属性名(原字段重命名)
//            if (oldSchemaVersion < 12) { // 重命名操作应该在调用 `enumerateObjects:` 之外完成
//                [migration renamePropertyForClass:[Student className] oldName:@"sex" newName:@"age"];
//            }
        }
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm realmWithURL:config.fileURL];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)registerLocalNotification {
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    NSLog(@"didRegisterUserNotificationSettings");
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"app收到本地推送(didReceiveLocalNotification:):%@", notification.userInfo);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // 获取并处理deviceToken
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"DeviceToken:%@\n", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error.description);
}

// 注：iOS10以上如果不使用UNUserNotificationCenter时，也将走此回调方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // iOS6及以下系统
    if (userInfo) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {// app位于前台通知
            NSLog(@"app位于前台通知(didReceiveRemoteNotification:):%@", userInfo);
        } else {// 切到后台唤起
            NSLog(@"app位于后台通知(didReceiveRemoteNotification:):%@", userInfo);
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler NS_AVAILABLE_IOS(7_0) {
    // iOS7及以上系统
    if (userInfo) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            NSLog(@"app位于前台通知(didReceiveRemoteNotification:fetchCompletionHandler:):%@", userInfo);
        } else {
            NSLog(@"app位于后台通知(didReceiveRemoteNotification:fetchCompletionHandler:):%@", userInfo);
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark - iOS>=10 中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (userInfo) {
        NSLog(@"app位于前台通知(willPresentNotification:):%@", userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (userInfo) {
        NSLog(@"点击通知进入App时触发(didReceiveNotificationResponse:):%@", userInfo);
    }
    completionHandler();
}

#endif

@end
