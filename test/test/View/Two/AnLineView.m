//
//  AnLineView.m
//  test
//
//  Created by rrjj on 2019/4/24.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "AnLineView.h"

@interface AnLineView ()

@property (nonatomic,strong) CAShapeLayer *lineAnimationLayer;

@end

@implementation AnLineView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.lineAnimationLayer];
        self.userInteractionEnabled = YES;
        [self marquee2];
    }
    return self;
}


/*直线进度条*/
- (CAShapeLayer *)lineAnimationLayer
{
    if(!_lineAnimationLayer){
        _lineAnimationLayer = [CAShapeLayer layer];
        _lineAnimationLayer.strokeColor = [UIColor greenColor].CGColor;
        _lineAnimationLayer.lineWidth = 1.0;
        _lineAnimationLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _lineAnimationLayer;
}

-(void)setArray:(NSArray *)array
{
    _array = array;
    UIBezierPath * path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < array.count; i ++) {
        if (i==0) {
            NSValue *value = [array objectAtIndex:0]; //例如取出第一项
            CGPoint point = [value CGPointValue];
            [path moveToPoint:point];
        }else{
            NSValue *value = [array objectAtIndex:i]; //取出第i项
            CGPoint point = [value CGPointValue];
            [path addLineToPoint:point];
        }
    }
    NSValue *value = [array objectAtIndex:0]; //例如取出第一项
    CGPoint point = [value CGPointValue];
    [path addLineToPoint:point];
    path.lineCapStyle = kCGLineCapRound;
    _lineAnimationLayer.path = path.CGPath;
    
    /*动画,keyPath是系统定的关键词，可以自己去帮助文档里面查看*/
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //        animation的动画时长
    animation.duration = 4.0;
    //        动画的其实位置
    animation.fromValue = @(0);
    //        动画的结束位置
    animation.toValue = @(1);
    //        动画执行次数
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.autoreverses = YES;
    //        添加动画并设置key；这个key值是自己定义的
    [_lineAnimationLayer addAnimation:animation forKey:@"lineAnimationLayer"];
}

-(void)marquee2{
    //创建一个shaperLayer
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.bounds = CGRectMake(0, 0, 10, 5);
    shaperLayer.position = CGPointMake((self.frame.size.width-300)/2, (self.frame.size.height-200)/2);
    shaperLayer.strokeColor = [UIColor whiteColor].CGColor;
    shaperLayer.fillColor = [UIColor clearColor].CGColor;
    shaperLayer.lineDashPattern = @[@(10),@(10)];
    //    虚线结尾处的类型
    shaperLayer.lineCap = kCALineCapRound;
    //    拐角处layer的类型
    shaperLayer.lineJoin = kCALineJoinRound;
    shaperLayer.lineWidth = 5;
    
    //创建动画路径
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 300, 200)];
    shaperLayer.path = path.CGPath;
    //    CGPathRelease(path.CGPath);
    
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.duration = 8;
    animation2.repeatCount = MAXFLOAT;
    animation2.values = @[@(0),@(1),@(0)];
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    
    /**
     * 上述的animation2的动画和效果和下面的animation动画效果是一样的
     */
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 4;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    //    这个设置是在一个动画完成时，是否需要反向动画，默认是NO
    animation.autoreverses = YES;
    
    [shaperLayer addAnimation:animation2 forKey:nil];
    
    [self.layer addSublayer:shaperLayer];
}

@end
