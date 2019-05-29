//
//  AppDelegate+ZHMemoryDelegate.m
//  test
//
//  Created by rrjj on 2019/5/29.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "AppDelegate+ZHMemoryDelegate.h"
#import "UIApplication+Memory.h"
#import <objc/message.h>


@implementation AppDelegate (ZHMemoryDelegate)

-(UILabel *)label
{
    return  objc_getAssociatedObject(self, "label");
}

-(void)setLabel:(UILabel *)label
{
    objc_setAssociatedObject(self, "label", label, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)ZH_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 80, Screenheight/2, 80, 80)];
    self.label.backgroundColor = [UIColor redColor];
    self.label.numberOfLines = 0;
    [[UIApplication sharedApplication].delegate.window addSubview:self.label];
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(reloadLink:)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    

    return YES;
}


- (void)reloadLink:(CADisplayLink *)link
{
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self.label];
    self.label.text = [NSString stringWithFormat:@"可用%.fMB,已用%.fMB",[UIApplication sharedApplication].availableMemory,[UIApplication sharedApplication].memoryUsed];
}
@end
