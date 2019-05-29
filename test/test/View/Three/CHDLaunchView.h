//
//  LaunchView.h
//  LaunchAnimation
//
//  Created by xiongan on 2017/8/10.
//  Copyright © 2017年 xiongan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TextAnimatinStyle) {
    TextLaunchAnimatinStyleDefault,
    TextLaunchAnimatinStyleFillColor,
    TextLaunchAnimatinStyleStrokeEnd,
};

@interface CHDLaunchView : UIView
///显示launch图，执行动画
-(void)startAnimationWithDuration:(NSTimeInterval)duration;
///显示launch图，不执行动画
-(void)launchLayer;

@end


/**
 M
 子机登录页动画
 */
@interface XLLaunchView : UIView
- (void)drawCorporateLogoOfAnimation;
- (void)drawCorporateLogo;
@end



