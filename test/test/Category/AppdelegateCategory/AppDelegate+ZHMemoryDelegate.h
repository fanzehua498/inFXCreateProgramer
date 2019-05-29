//
//  AppDelegate+ZHMemoryDelegate.h
//  test
//
//  Created by rrjj on 2019/5/29.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (ZHMemoryDelegate)
@property (nonatomic,strong) UILabel *label;
- (BOOL)ZH_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end

NS_ASSUME_NONNULL_END
