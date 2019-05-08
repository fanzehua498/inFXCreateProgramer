//
//  FFPlayerButton.m
//  test
//
//  Created by rrjj on 2019/4/23.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "FFPlayerButton.h"
#import <objc/message.h>

@interface FFPlayerButton ()

@property (nonatomic,strong) CAShapeLayer *layer1;
@property (nonatomic,strong) CAShapeLayer *layer2;
@property (nonatomic,strong) CAShapeLayer *layer3;

/** 忽略方法 */
@property (nonatomic,assign,getter=isIgnoreEvent) BOOL ignoreEvent;
/** 响应时间间隔 */
@property (nonatomic,assign) NSTimeInterval acceptEventInterval;
@end

@implementation FFPlayerButton

+(void)load
{
    //替换系统方法
    //系统按钮方法
    SEL actionA = @selector(sendAction:to:forEvent:);
    Method aMethod = class_getInstanceMethod([FFPlayerButton class], actionA);
    //自定义按钮方法
    SEL actionB = @selector(FFsendAction:to:forEvent:);
    Method bMethod = class_getInstanceMethod([FFPlayerButton class], actionB);
    
//    method_getTypeEncoding(<#Method  _Nonnull m#>)
//    method_getImplementation(<#Method  _Nonnull m#>)
    BOOL add = class_addMethod([FFPlayerButton class], actionA, method_getImplementation(bMethod), method_getTypeEncoding(bMethod));
    if (add) {
        class_replaceMethod([FFPlayerButton class], actionB, method_getImplementation(aMethod), method_getTypeEncoding(aMethod));
    }else{
        method_exchangeImplementations(aMethod, bMethod);
    }
}

//自定义按钮方法实现
-(void)FFsendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event
{
//    [self FFsendAction:action to:target forEvent:event];
    if (self.ignoreEvent) {
        NSLog(@"设置忽略方法");
        return;
    }
    
    if (self.acceptEventInterval > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(setIgnoreEvent:) withObject:@(NO) afterDelay:self.acceptEventInterval];
        
        if (self.isSelected) {
            //播放动画
            [self playingAnimation];
        }else{
            //关闭动画
            [self stopAnimation];
        }
        [self FFsendAction:action to:target forEvent:event];
    }
}

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _acceptEventInterval = .5;
        self.layer1 = [CAShapeLayer layer];
        self.layer1.strokeColor = [UIColor blackColor].CGColor;
        self.layer1.lineCap = kCALineCapRound;
        self.layer1.lineWidth = 2;

        self.layer2 = [CAShapeLayer layer];
        self.layer2.strokeColor = [UIColor blackColor].CGColor;
        self.layer2.lineCap = kCALineCapRound;
        self.layer2.lineWidth = 2;
        
        self.layer3 = [CAShapeLayer layer];
        self.layer3.strokeColor = [UIColor blackColor].CGColor;
        self.layer3.lineCap = kCALineCapRound;
        self.layer3.lineWidth = 2;
        self.layer3.opacity = 0;
        
        [self.layer addSublayer:self.layer1];
        [self.layer addSublayer:self.layer2];
        [self.layer addSublayer:self.layer3];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    UIBezierPath *path1 =[UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(self.frame.size.width * 0.25, self.frame.size.height * 0.2)];
    [path1 addLineToPoint:CGPointMake(self.frame.size.width * 0.25, self.frame.size.height * 0.8)];
    
    path1.lineWidth = 2;
    self.layer1.path = path1.CGPath;
    self.layer2.path = [self bezirePathLayer2Playing].CGPath;
    self.layer3.path = [self bezierPathLayer3Playing].CGPath;
}



#pragma mark - 动画
/**

 @param layer 执行动画的layer
 @param fromValue 开始值
 @param toValue 结束值
 */
- (void)opacityAnimationWithLayer:(CALayer *)layer fromValue:(CGFloat)fromValue Tovalue:(CGFloat)toValue
{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(fromValue);
    opacityAnimation.toValue = @(toValue);
    opacityAnimation.duration =.2;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    [layer addAnimation:opacityAnimation forKey:nil];
}

- (UIBezierPath *)bezierPathLayer2Stop
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(self.frame.size.width * 0.75, self.frame.size.height *0.5)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width * 0.25, self.frame.size.height *0.8)];
    bezierPath.lineWidth = 2;
    return bezierPath;
}

- (UIBezierPath *)bezirePathLayer2Playing
{
    UIBezierPath *bezirePath = [UIBezierPath bezierPath];
    [bezirePath moveToPoint:CGPointMake(self.frame.size.width *0.75, self.frame.size.height * 0.2)];
    [bezirePath addLineToPoint:CGPointMake(self.frame.size.width *0.75, self.frame.size.height *0.8)];
    bezirePath.lineWidth = 2;
    
    return bezirePath;
}


- (UIBezierPath *)bezierPathLayer3Stop{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(self.frame.size.width * 0.75, self.frame.size.height * 0.5)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width *0.25, self.frame.size.height * 0.2)];
    bezierPath.lineWidth = 2;
    return bezierPath;
}
- (UIBezierPath *)bezierPathLayer3Playing{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(self.frame.size.width * 0.25, self.frame.size.height * 0.2)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width * 0.75, self.frame.size.height * 0.2)];
    bezierPath.lineWidth = 2;
    return bezierPath;
}

/**
 
 
 */
- (CABasicAnimation *)animationPath:(UIBezierPath *)path during:(NSTimeInterval )duration
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.toValue = (__bridge id _Nullable)(path.CGPath);
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = duration;
    
    return pathAnimation;
}

#pragma mark - private


- (void)playingAnimation
{
    CABasicAnimation *layer2Playing = [self animationPath:[self bezirePathLayer2Playing] during:.2];
    [self.layer2 addAnimation:layer2Playing forKey:nil];
    [self opacityAnimationWithLayer:self.layer3 fromValue:1. Tovalue:0.];
    
    CABasicAnimation *layer3Playing = [self animationPath:[self bezierPathLayer3Playing] during:.2];
    [self.layer3 addAnimation:layer3Playing forKey:nil];
}

- (void)stopAnimation
{
    CABasicAnimation *layer2Stop = [self animationPath:[self bezierPathLayer2Stop] during:.2];
    [self.layer2 addAnimation:layer2Stop forKey:nil];
    [self opacityAnimationWithLayer:self.layer3 fromValue:0. Tovalue:1.];
    
    CABasicAnimation *layer3Stop = [self animationPath:[self bezierPathLayer3Stop] during:.2];
    [self.layer3 addAnimation:layer3Stop forKey:nil];
}

@end
