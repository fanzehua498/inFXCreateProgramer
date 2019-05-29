//
//  LaunchView.m
//  LaunchAnimation
//
//  Created by xiongan on 2017/8/10.
//  Copyright © 2017年 xiongan. All rights reserved.
//

#import "CHDLaunchView.h"
#import <CoreText/CoreText.h>
//#import <XKSCommonSDK/XKSCommonFunction.h>

@interface CHDLaunchViewDelegateManager:NSObject<CAAnimationDelegate>
@property (nonatomic,weak)id <CAAnimationDelegate>delegate;
@end

@implementation CHDLaunchViewDelegateManager

- (void)animationDidStart:(CAAnimation *)anim {
    if ([self.delegate respondsToSelector:@selector(animationDidStart:)]) {
        [self.delegate animationDidStart:anim];
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self.delegate respondsToSelector:@selector(animationDidStop:finished:)]) {
        [self.delegate animationDidStop:anim finished:flag];
    }
}

@end

@interface CHDLaunchView ()<CAAnimationDelegate>
@property (nonatomic,weak)CAShapeLayer *outsideLayer;
@property (nonatomic,weak)CAShapeLayer *innerLayer;
@property (nonatomic,weak)CAShapeLayer *leftBottomLayer;
@property (nonatomic,weak)CAShapeLayer *rightTopLayer;
@property (nonatomic,weak)CAShapeLayer *textLayer;
@property (nonatomic,weak)CAShapeLayer *hoderLayer;
@property (nonatomic,assign)NSTimeInterval durationText1;
@property (nonatomic,assign)NSTimeInterval durationText2;
@property (nonatomic,assign)NSTimeInterval durationText3;
@property (nonatomic,assign)NSTimeInterval durationLaunch1;
@property (nonatomic,assign)NSTimeInterval durationLaunch2;
@property (nonatomic,assign)NSTimeInterval durationLaunch3;
@property (nonatomic,strong)CALayer *animationLayer;
@property (nonatomic,assign)TextAnimatinStyle animationStyle;


@end

@implementation CHDLaunchView

static CGFloat scale = 7.4;
static CGFloat margin = 10;
static CGFloat outSideRadius = 73;

UIColor *deepBuleColor (){
    
    return  [UIColor colorWithRed:26/255.0 green:156/255.0 blue:229/255.0 alpha:1];
}
UIColor *buleColor (){
    
    return [UIColor colorWithRed:155/255.0 green:215/255.0 blue:244/255.0 alpha:1];
}
UIColor *grayColor (){
    
    return [UIColor colorWithRed:118/255.0 green:124/255.0 blue:128/255.0 alpha:1];
//    return [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1];
}
- (CALayer *)animationLayer {
    if (!_animationLayer) {
        _animationLayer = [[CALayer alloc]init];
        _animationLayer.frame = self.layer.bounds;
        [self.layer addSublayer:_animationLayer];
    }
    
    return _animationLayer;
}

-(void)startAnimationWithDuration:(NSTimeInterval)duration {
    
    scale = self.frame.size.height * 7.4 / 768.0;
    int x = arc4random() % 2 +1;
    self.animationStyle = x;
    
    self.durationLaunch1 = duration / 3.0;
    self.durationLaunch2 = duration / 3.0;
    self.durationLaunch3 = duration / 3.0;

    self.durationText1 = (duration / 3.0 *2) / 3.0 ;
    self.durationText2 = (duration / 3.0 *2)  / 3.0 ;
    self.durationText3 = (duration / 3.0 *2)  / 3.0 -0.2;
    
    [self initializeCircleLayers];
    [self initializeTextLayers];
    [self startTextAnimition1];
    [self startLaunchAnimation1];
    
}
- (void)startTextAnimition1 {
   
    CABasicAnimation *pathAnima ;
    if (self.animationStyle == TextLaunchAnimatinStyleStrokeEnd) {
        pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnima.fromValue =[NSNumber numberWithFloat:0.0f];
        pathAnima.toValue = [NSNumber numberWithFloat:1.0];
    }else {
        pathAnima = [CABasicAnimation animationWithKeyPath:@"fillColor"];
        pathAnima.fromValue =(__bridge id _Nullable)([UIColor whiteColor].CGColor);
        pathAnima.toValue = (__bridge id _Nullable)(grayColor().CGColor);
    }
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.duration = self.durationText1;
    CHDLaunchViewDelegateManager *delegateManager = [CHDLaunchViewDelegateManager new];
    delegateManager.delegate = self;
    pathAnima.delegate = delegateManager;
    [pathAnima setValue:@"textLayer_fillColor" forKey:@"textLayer_fillColor"];
    [self.textLayer addAnimation:pathAnima forKey:@"textLayer_fillColor"];
}

- (void)startTextAnimition2{
    if (self.animationStyle == TextLaunchAnimatinStyleStrokeEnd) {
        self.textLayer.fillColor = deepBuleColor().CGColor;
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"fillColor"];
        pathAnima.duration = self.durationText2;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnima.fromValue =(__bridge id _Nullable)(buleColor().CGColor);
        pathAnima.toValue = (__bridge id _Nullable)(deepBuleColor().CGColor);
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = NO;
        CHDLaunchViewDelegateManager *delegateManager = [CHDLaunchViewDelegateManager new];
        delegateManager.delegate = self;
        pathAnima.delegate = delegateManager;
        
        [pathAnima setValue:@"textLayer_fillColor2" forKey:@"textLayer_fillColor2"];
        [self.textLayer addAnimation:pathAnima forKey:@"textLayer_fillColor"];
        
    }else {
        CAShapeLayer *hoderLayer = [CAShapeLayer layer];
        hoderLayer.path = self.textLayer.path;
        hoderLayer.geometryFlipped = YES;
        hoderLayer.fillColor = grayColor().CGColor;
        hoderLayer.lineWidth = 1.f;
        hoderLayer.lineJoin = kCALineJoinBevel;
        hoderLayer.strokeStart = 0.0f;
        hoderLayer.strokeEnd = 1.0f;
        hoderLayer.frame = self.textLayer.frame;
        hoderLayer.bounds = self.textLayer.bounds;
        [self.layer addSublayer:hoderLayer];
        self.hoderLayer = hoderLayer;

        CALayer *layer = [CALayer layer];
        layer.anchorPoint = CGPointMake(0, 0);
        layer.frame = self.hoderLayer.bounds;
        layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.hoderLayer.strokeColor = [UIColor clearColor].CGColor;
        self.hoderLayer.fillColor = buleColor().CGColor;
        self.hoderLayer.mask = layer;
        // 添加关键帧动画
        // 此处的KeyPath 必须为bounds.size.width 否则无效果
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size.width"];
        animation.values = @[@(0),@(self.textLayer.frame.size.width)];
        animation.keyTimes = @[@(0),@(1)];
        animation.duration = self.durationText2;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = YES;
        // 此处关键帧需要添加在sub上
        
        CHDLaunchViewDelegateManager *delegateManager = [CHDLaunchViewDelegateManager new];
        delegateManager.delegate = self;
        animation.delegate = delegateManager;
        [animation setValue:@"textLayer_fillColor2" forKey:@"textLayer_fillColor2"];
        [layer addAnimation:animation forKey:@"Animation"];
    }
}
- (void)startTextAnimition3 {
    if (self.animationStyle == TextLaunchAnimatinStyleStrokeEnd) {
        
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
        pathAnima.duration = self.durationText3;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        pathAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];;
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = NO;
        CHDLaunchViewDelegateManager *delegateManager = [CHDLaunchViewDelegateManager new];
        delegateManager.delegate = self;
        pathAnima.delegate = delegateManager;
        [pathAnima setValue:@"textLayer_fillColor3" forKey:@"textLayer_fillColor3"];
        [self.textLayer addAnimation:pathAnima forKey:@"textLayer_fillColor"];
    }else {
        [self.hoderLayer.mask removeFromSuperlayer];
        [self.hoderLayer removeFromSuperlayer];
        self.hoderLayer = nil;
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
        pathAnima.duration = self.durationText3;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        pathAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];;
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = NO;
        CHDLaunchViewDelegateManager *delegateManager = [CHDLaunchViewDelegateManager new];
        delegateManager.delegate = self;
        pathAnima.delegate = delegateManager;
        [pathAnima setValue:@"textLayer_fillColor3" forKey:@"textLayer_fillColor3"];
        [self.textLayer addAnimation:pathAnima forKey:@"textLayer_fillColor"];
    }
}
-(void)initializeTextLayers{
    NSString *text = @"爱客仕" ;
    //创建NSAttributedString并生成CTLineRef
    // 定义字体属性
    CGFloat fontSize = 46;
    UIFont *font =  [UIFont fontWithName:@".SFUIDisplay-Thin" size:fontSize];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    // 创建NSAttributedString
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:text attributes:attrs];
    //使用CTLineRef生成CTRunRef数组
    CFAttributedStringRef strRef = (__bridge CFAttributedStringRef)str;
    CTLineRef line = CTLineCreateWithAttributedString(strRef);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    //遍历CTRunRef数组，得到每个CTRunRef
    CGMutablePathRef letters = CGPathCreateMutable();
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        //
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        //遍历CTRunRef中每个长度为1的区间生成CGGlyph并转换为CGPath路径，将所有路径拼接起来
        for (CFIndex glyphIndex = 0; glyphIndex < CTRunGetGlyphCount(run); glyphIndex++) {
            
            CGGlyph glyph;
            CGPoint position;
            CFRange currentRange = CFRangeMake(glyphIndex, 1);
            CTRunGetGlyphs(run, currentRange, &glyph);
            CTRunGetPositions(run, currentRange, &position);
            
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    CFRelease(line);
    //创建ShapeLayer并将生成的路径赋值给该ShapeLayer
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    CGPathRelease(letters);
    // 创建并配置CAShapeLayer
    CAShapeLayer *textLayer = [CAShapeLayer layer];
    textLayer.frame = CGRectMake(self.center.x - outSideRadius, self.center.y + outSideRadius + 20, outSideRadius *2, 50);;
    textLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    textLayer.geometryFlipped = YES;
    textLayer.path = path.CGPath;
    if (self.animationStyle == TextLaunchAnimatinStyleStrokeEnd) {
        textLayer.strokeColor = deepBuleColor().CGColor;
        textLayer.fillColor = [UIColor whiteColor].CGColor;
    }else {
        textLayer.fillColor = grayColor().CGColor;
    }
    textLayer.lineWidth = 1.f;
    textLayer.lineJoin = kCALineJoinBevel;
    textLayer.strokeStart = 0.0f;
    textLayer.strokeEnd = 1.0f;
    _textLayer = textLayer;
    
    [self.layer addSublayer:textLayer];
}
-(void)initializeCircleLayers {
    //1、创建动画贝塞尔路径
    //外圆
    CGPoint outSideCenter = self.center;
    CGFloat outSideRadiusHalf = outSideRadius / 2;
    CGPoint leftCenter = (CGPoint){outSideCenter.x - outSideRadiusHalf,outSideCenter.y};
    CGPoint rightCenter = (CGPoint){outSideCenter.x + outSideRadiusHalf,outSideCenter.y};
    
    CGFloat smallRadius = outSideRadiusHalf - margin/2.0;
    CGFloat bigRadius = outSideRadiusHalf + margin/2.0;
    
    CGFloat litterRadius = margin / 2;
    CGPoint rbLitterCenter = (CGPoint){outSideCenter.x+outSideRadiusHalf,outSideCenter.y+outSideRadiusHalf};
    CGPoint ltLitterCenter = (CGPoint){outSideCenter.x-outSideRadiusHalf,outSideCenter.y-outSideRadiusHalf};
    CGPoint lbrLitterCenter = (CGPoint){leftCenter.x+ sqrt(outSideRadiusHalf*outSideRadiusHalf/2) ,leftCenter.y+sqrt(outSideRadiusHalf*outSideRadiusHalf/2)};
    
    CGPoint lblLitterCenter = (CGPoint){leftCenter.x,leftCenter.y+outSideRadiusHalf};
    CGPoint rtlLitterCenter = (CGPoint){rightCenter.x- sqrt(outSideRadiusHalf*outSideRadiusHalf/2) ,leftCenter.y-sqrt(outSideRadiusHalf*outSideRadiusHalf/2)};
    
    CGPoint rtrLitterCenter = (CGPoint){rightCenter.x,leftCenter.y-outSideRadiusHalf};
    
    UIBezierPath *bigCriclePath = [UIBezierPath bezierPathWithArcCenter:outSideCenter radius:outSideRadius startAngle:0 endAngle:-2*M_PI clockwise:NO];
    
    UIBezierPath *innerPath = [UIBezierPath bezierPath];
    [innerPath addArcWithCenter:leftCenter radius:smallRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    
    [innerPath addArcWithCenter:rightCenter radius:bigRadius startAngle:-M_PI endAngle:-M_PI-M_PI_2 clockwise:NO];
    
    [innerPath addArcWithCenter:rbLitterCenter radius:litterRadius startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:NO];
    
    [innerPath addArcWithCenter:rightCenter radius:smallRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    [innerPath addArcWithCenter:leftCenter radius:bigRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
    
    [innerPath addArcWithCenter:ltLitterCenter radius:litterRadius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:NO];
    
    //左下角和右上角的形状
    //左下角
    UIBezierPath *leftBottomBigCriclePath = [UIBezierPath bezierPathWithArcCenter:leftCenter radius:bigRadius startAngle:M_PI_2 endAngle:M_PI_4 clockwise:NO];
    [leftBottomBigCriclePath addArcWithCenter:lbrLitterCenter radius:litterRadius startAngle:M_PI_4 endAngle:-M_PI_2-M_PI_4 clockwise:NO];
    [leftBottomBigCriclePath addArcWithCenter:leftCenter radius:smallRadius startAngle:M_PI_4 endAngle:M_PI_2 clockwise:YES];
    [leftBottomBigCriclePath addArcWithCenter:lblLitterCenter radius:litterRadius startAngle: M_PI+M_PI_2 endAngle:M_PI_2 clockwise:NO];
    //右上角
    UIBezierPath *rightTopBigCriclePath = [UIBezierPath bezierPathWithArcCenter:rightCenter radius:bigRadius startAngle:-M_PI_2-M_PI_4 endAngle:-M_PI_2 clockwise:YES];
    
    [rightTopBigCriclePath addArcWithCenter:rtrLitterCenter radius:litterRadius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    [rightTopBigCriclePath addArcWithCenter:rightCenter radius:smallRadius startAngle:-M_PI_2 endAngle:-M_PI_2-M_PI_4 clockwise:NO];
    [rightTopBigCriclePath addArcWithCenter:rtlLitterCenter radius:litterRadius startAngle:M_PI_4 endAngle:M_PI+M_PI_4  clockwise:YES];
    
    
    CAShapeLayer *outsideLayer = [self shapeLayerWithPath:bigCriclePath ];
    _outsideLayer = outsideLayer;
    CAShapeLayer *innerLayer = [self shapeLayerWithPath:innerPath ];
    _innerLayer = innerLayer;
    CAShapeLayer *leftBottomLayer = [self shapeLayerWithPath:leftBottomBigCriclePath ];
    _leftBottomLayer = leftBottomLayer;
    CAShapeLayer *rightTopLayer = [self shapeLayerWithPath:rightTopBigCriclePath ];
    _rightTopLayer = rightTopLayer;
    [self.animationLayer addSublayer:_outsideLayer];
    [_outsideLayer addSublayer:_innerLayer];
    [_outsideLayer addSublayer:_leftBottomLayer];
    [_outsideLayer addSublayer:_rightTopLayer];

}
-(void)startLaunchAnimation1 {
    
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = self.durationLaunch1;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue =[NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    CHDLaunchViewDelegateManager *delegateManager = [CHDLaunchViewDelegateManager new];
    delegateManager.delegate = self;
    pathAnima.delegate = delegateManager;
    [self.outsideLayer addAnimation:pathAnima forKey:@"outsideLayer_strokeEnd"];
    [self.innerLayer addAnimation:pathAnima forKey:@"strokeEndAnimation2"];
    [self.leftBottomLayer addAnimation:pathAnima forKey:@"strokeEndAnimation3"];
    [pathAnima setValue:@"outsideLayer_strokeEnd" forKey:@"outsideLayer_strokeEnd"];
    [self.rightTopLayer addAnimation:pathAnima forKey:@"strokeEndAnimation4"];
    
}

- (void)startLaunchAnimation2 {
    self.outsideLayer.fillColor = deepBuleColor().CGColor;
    self.outsideLayer.strokeColor = deepBuleColor().CGColor;

    CABasicAnimation *fillColorAnima = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    fillColorAnima.duration =  self.durationLaunch2;;
    fillColorAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fillColorAnima.fromValue = (__bridge id _Nullable)([UIColor whiteColor].CGColor);
    fillColorAnima.toValue = (__bridge id _Nullable)(deepBuleColor().CGColor);
    fillColorAnima.fillMode = kCAFillModeForwards;
    fillColorAnima.removedOnCompletion = NO;
    CHDLaunchViewDelegateManager *delegateManager = [CHDLaunchViewDelegateManager new];
    delegateManager.delegate = self;
    fillColorAnima.delegate = delegateManager;
    [fillColorAnima setValue:@"outsideLayer_fillColor" forKey:@"outsideLayer_fillColor"];
    [self.outsideLayer addAnimation:fillColorAnima forKey:@"outsideLayer_fillColor"];
}

- (void)startLaunchAnimation3 {
    //缩放动画
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D to = CATransform3DScale(CATransform3DMakeTranslation(-(scale - 1)*outSideRadius+20, 0, 0), scale, scale, 1);
    scaleAnim.toValue = [NSValue valueWithCATransform3D:to];
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:scaleAnim, nil];
    animGroup.duration =  self.durationLaunch3;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.removedOnCompletion = NO;
    animGroup.timingFunction  =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.outsideLayer addAnimation:animGroup forKey:nil];
    
    self.outsideLayer.fillColor = buleColor().CGColor;
    self.outsideLayer.strokeColor = buleColor().CGColor;
    self.innerLayer.strokeColor = buleColor().CGColor;
    self.leftBottomLayer.strokeColor = buleColor().CGColor;
    self.rightTopLayer.strokeColor = buleColor().CGColor;

    //透明动画
    CABasicAnimation *fillColorAnima = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    fillColorAnima.fromValue = (__bridge id _Nullable)(deepBuleColor().CGColor);
    fillColorAnima.toValue = (__bridge id _Nullable)(buleColor().CGColor);
    fillColorAnima.fillMode = kCAFillModeForwards;
    fillColorAnima.removedOnCompletion = NO;
    fillColorAnima.duration = self.durationLaunch3;
    fillColorAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.outsideLayer addAnimation:fillColorAnima forKey:nil];

    self.outsideLayer.fillColor = buleColor().CGColor;
    self.innerLayer.strokeColor = buleColor().CGColor;
    self.leftBottomLayer.strokeColor = buleColor().CGColor;
    self.rightTopLayer.strokeColor = buleColor().CGColor;
    self.outsideLayer.strokeColor = buleColor().CGColor;
    
    CABasicAnimation *strokeColorAnima = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    strokeColorAnima.fromValue = (__bridge id _Nullable)(deepBuleColor().CGColor);
    strokeColorAnima.toValue = (__bridge id _Nullable)(buleColor().CGColor);
    strokeColorAnima.fillMode = kCAFillModeForwards;
    strokeColorAnima.removedOnCompletion = NO;
    strokeColorAnima.duration = self.durationLaunch3;
    strokeColorAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.outsideLayer addAnimation:strokeColorAnima forKey:nil];
    [self.innerLayer addAnimation:strokeColorAnima forKey:nil];
    [self.leftBottomLayer addAnimation:strokeColorAnima forKey:nil];
    [self.rightTopLayer addAnimation:strokeColorAnima forKey:nil];
}

- (CAShapeLayer *)shapeLayerWithPath:(UIBezierPath *)path{
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;
    layer.frame = self.bounds;
    layer.strokeColor = deepBuleColor().CGColor ;//边沿线色
    layer.fillColor = [UIColor whiteColor].CGColor ;//填充色
    layer.lineJoin = kCALineJoinMiter;//线拐点的类型
    layer.lineCap = kCALineCapSquare;//线终点
    //线条宽度
    layer.lineWidth = 1;
    //起始和终止
    layer.strokeStart = 0.0;
    layer.strokeEnd = 1.0;
    return layer;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([[anim valueForKey:@"outsideLayer_strokeEnd"]isEqualToString:@"outsideLayer_strokeEnd"]) {
        [self startLaunchAnimation2];;
    }else if  ([[anim valueForKey:@"outsideLayer_fillColor"]isEqualToString:@"outsideLayer_fillColor"]) {
        [self startLaunchAnimation3];;
    } else if  ([[anim valueForKey:@"textLayer_fillColor"]isEqualToString:@"textLayer_fillColor"]) {
        [self startTextAnimition2];;
    }  else if  ([[anim valueForKey:@"textLayer_fillColor2"]isEqualToString:@"textLayer_fillColor2"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startTextAnimition3];
        });
    }  else if  ([[anim valueForKey:@"textLayer_fillColor3"]isEqualToString:@"textLayer_fillColor3"]) {
        [self.textLayer removeFromSuperlayer];;
    }  else {
        
    }
}

-(void)launchLayer {
    
    [self initializeCircleLayers];
    self.outsideLayer.fillColor = buleColor().CGColor;
    self.outsideLayer.strokeColor = buleColor().CGColor;
    self.innerLayer.fillColor = [UIColor whiteColor].CGColor;
    self.innerLayer.strokeColor = buleColor().CGColor;
    self.leftBottomLayer.fillColor = [UIColor whiteColor].CGColor;
    self.leftBottomLayer.strokeColor = buleColor().CGColor;
    self.rightTopLayer.fillColor = [UIColor whiteColor].CGColor;
    self.rightTopLayer.strokeColor = buleColor().CGColor;
    self.outsideLayer.transform = CATransform3DScale(CATransform3DMakeTranslation(-(scale - 1)*outSideRadius+20, 0, 0), scale, scale, 1);
}

@end



/*********************************************************/


#define  IconScale 0.41
#define TextScale  0.75
#define LineWidth  1.0
#define LightBlueColor  [UIColor colorWithRed:155/255.0 green:215/255.0 blue:244/255.0 alpha:1].CGColor
#define DeepBlueColor  [UIColor colorWithRed:0/255.0 green:156/255.0 blue:229/255.0 alpha:1].CGColor
#define GrayColor         [UIColor colorWithRed:114/255.0 green:114/255.0 blue:114/255.0 alpha:1].CGColor


NSString *const outsidCircleAnimationWithStrokeEnd = @"outsidCircleAnimationWithStrokeEnd";
NSString *const xMiddleShapeLayerStrokeEnd = @"xMiddleShapeLayerStrokeEnd";
NSString *const xMiddleShapeLayerFillColor = @"xMiddleShapeLayerFillColor";
NSString *const xRightShapeLayerStrokeEnd = @"xRightShapeLayerStrokeEnd";
NSString *const xRightShapeLayerFillColor = @"xRightShapeLayerFillColor";
NSString *const xLeftShapeLayerStrokeEnd = @"xLeftShapeLayerStrokeEnd";
NSString *const xLeftShapeLayerFillColor = @"xLeftShapeLayerFillColor";
NSString *const iconLayerBaseAnimationWithPosition = @"iconLayerBaseAnimationWithPosition";
NSString *const iconLayerBaseAnimationWithTransform = @"iconLayerBaseAnimationWithTransform";
NSString *const outsidCircleAnimationWithFillColor = @"outsidCircleAnimationWithFillColor";
NSString *const animationWithTextFillColor = @"animationWithTextFillColor";
NSString *const animationWithTextPosition = @"animationWithTextPosition";
NSString *const animationWithTextTransform = @"animationWithTextTransform";

static CGFloat arcRadius = 50;
@interface XLLaunchView ( ) <CAAnimationDelegate>
@property (nonatomic, strong)CAShapeLayer *iconShapeLayer;
@property (nonatomic, strong)CAShapeLayer *textShapLayer;
@property (nonatomic, strong)CAShapeLayer *outsideCircleShapLayer;
@property (nonatomic, strong)CAShapeLayer *xMiddleShapeLayer;
@property (nonatomic, strong)CAShapeLayer *xRightShapeLayer;
@property (nonatomic, strong)CAShapeLayer *xLeftShapeLayer;
@end

@implementation XLLaunchView

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"home"];
    [image drawInRect:self.bounds];
}

- (void)drawCorporateLogobBezierPath{
    // 图标图层
    _iconShapeLayer = [CAShapeLayer layer];
    _iconShapeLayer.frame = CGRectMake(0, 0, 2 * arcRadius,2 *  arcRadius);
    _iconShapeLayer.position = CGPointMake(self.center.x, 158 + arcRadius);
    [self.layer addSublayer:_iconShapeLayer];
    
    // 2.外圆
    _outsideCircleShapLayer = [CAShapeLayer layer];
    _outsideCircleShapLayer.frame = _iconShapeLayer.bounds;
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    CGPoint arcCenter = CGPointMake(CGRectGetMidX(_outsideCircleShapLayer.bounds), CGRectGetMidY(_outsideCircleShapLayer.bounds));
    [bezierPath appendPath:[UIBezierPath bezierPathWithArcCenter:arcCenter radius:arcRadius startAngle:-M_PI_2  endAngle:M_PI + M_PI_2 clockwise:YES]];
    _outsideCircleShapLayer.path = bezierPath.CGPath;
    _outsideCircleShapLayer.strokeColor = DeepBlueColor;
    _outsideCircleShapLayer.fillColor = [UIColor clearColor].CGColor;
    _outsideCircleShapLayer.lineWidth = LineWidth;
    [_iconShapeLayer addSublayer:_outsideCircleShapLayer];
    
    // 3. 中间图标
    _xMiddleShapeLayer = [CAShapeLayer layer];
    _xMiddleShapeLayer.frame = _iconShapeLayer.bounds;
    _xMiddleShapeLayer.strokeColor = DeepBlueColor;
    _xMiddleShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _xMiddleShapeLayer.lineWidth = LineWidth;
    [_iconShapeLayer addSublayer:_xMiddleShapeLayer];
    // 路径
    UIBezierPath* xMiddlePath = [UIBezierPath bezierPath];
    xMiddlePath.lineWidth = 2.0;
    xMiddlePath.lineCapStyle = kCGLineCapRound;
    xMiddlePath.lineJoinStyle = kCGLineCapRound;
    CGFloat space_2 = arcRadius / 13;
    CGFloat radiusOfInterpolationSmallArc = (arcRadius - space_2) / 2;
    CGFloat radiusOfInterpolationGreatArc = radiusOfInterpolationSmallArc + 2 * space_2;
    CGPoint leftArcCenterPoint = CGPointMake( arcCenter.x - radiusOfInterpolationSmallArc - space_2, arcCenter.y);
    CGPoint rightArcCenterPoint = CGPointMake(arcCenter.x + space_2 + radiusOfInterpolationSmallArc , arcCenter.y);
    [xMiddlePath addArcWithCenter:leftArcCenterPoint radius:radiusOfInterpolationSmallArc startAngle:- M_PI_2  endAngle:0 clockwise:YES];
    [xMiddlePath addArcWithCenter:rightArcCenterPoint radius:radiusOfInterpolationGreatArc startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    [xMiddlePath addArcWithCenter:CGPointMake(rightArcCenterPoint.x, rightArcCenterPoint.y + radiusOfInterpolationGreatArc - space_2) radius:space_2 startAngle:M_PI_2 endAngle:M_PI_2 + M_PI clockwise:NO];
    [xMiddlePath addArcWithCenter:rightArcCenterPoint radius:radiusOfInterpolationSmallArc startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [xMiddlePath addArcWithCenter:leftArcCenterPoint radius:radiusOfInterpolationGreatArc startAngle:0 endAngle:M_PI_2 + M_PI clockwise:NO];
    [xMiddlePath addArcWithCenter:CGPointMake(leftArcCenterPoint.x, leftArcCenterPoint.y - radiusOfInterpolationSmallArc - space_2) radius:space_2 startAngle:M_PI_2 + M_PI endAngle:M_PI_2 clockwise:NO];
    _xMiddleShapeLayer.path = xMiddlePath.CGPath;
    
    //4. 右边图标
    _xRightShapeLayer = [CAShapeLayer layer];
    _xRightShapeLayer.frame = _iconShapeLayer.bounds;
    _xRightShapeLayer.strokeColor = DeepBlueColor;
    _xRightShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _xRightShapeLayer.lineWidth = LineWidth;
    [_iconShapeLayer addSublayer:_xRightShapeLayer];
    UIBezierPath* xRightPath = [UIBezierPath bezierPath];
    xRightPath.lineWidth = LineWidth;
    xRightPath.lineCapStyle = kCGLineCapRound;
    xRightPath.lineJoinStyle = kCGLineCapRound;
    [xRightPath addArcWithCenter:leftArcCenterPoint radius:radiusOfInterpolationSmallArc startAngle:M_PI_2 endAngle:M_PI_2 / 2 clockwise:NO];
    CGFloat angleSideLength = sqrt(pow(radiusOfInterpolationSmallArc + space_2, 2) /2);
    [xRightPath addArcWithCenter:CGPointMake(leftArcCenterPoint.x + angleSideLength, leftArcCenterPoint.y + angleSideLength) radius:space_2 startAngle:M_PI + M_PI_2 / 2   endAngle:M_PI_2 / 2 clockwise:YES];
    [xRightPath addArcWithCenter:leftArcCenterPoint radius:radiusOfInterpolationGreatArc startAngle:M_PI_2 / 2 endAngle:M_PI_2 clockwise:YES];
    [xRightPath addArcWithCenter:CGPointMake(leftArcCenterPoint.x, leftArcCenterPoint.y + radiusOfInterpolationSmallArc + space_2) radius:space_2 startAngle:M_PI_2 endAngle:M_PI + M_PI_2 clockwise:YES];
    _xRightShapeLayer.path = xRightPath.CGPath;
    
    // 5. 左边图标
    _xLeftShapeLayer = [CAShapeLayer layer];
    _xLeftShapeLayer.frame = _iconShapeLayer.bounds;
    _xLeftShapeLayer.strokeColor = DeepBlueColor;
    _xLeftShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _xLeftShapeLayer.lineWidth = LineWidth;
    [_iconShapeLayer addSublayer:_xLeftShapeLayer];
    // 路径
    UIBezierPath* xLeftPath = [UIBezierPath bezierPath];
    xLeftPath.lineWidth = LineWidth;
    xLeftPath.lineCapStyle = kCGLineCapRound;
    xLeftPath.lineJoinStyle = kCGLineCapRound;
    [xLeftPath addArcWithCenter:rightArcCenterPoint radius:radiusOfInterpolationGreatArc startAngle:M_PI + M_PI_2 / 2 endAngle:M_PI + M_PI_2 clockwise:YES];
    [xLeftPath addArcWithCenter:CGPointMake(rightArcCenterPoint.x, rightArcCenterPoint.y - radiusOfInterpolationSmallArc - space_2) radius:space_2 startAngle:M_PI + M_PI_2 endAngle:M_PI_2 clockwise:YES];
    [xLeftPath addArcWithCenter:rightArcCenterPoint radius:radiusOfInterpolationSmallArc startAngle:- M_PI_2 endAngle:-(M_PI_2 + M_PI_2/2)  clockwise:NO];
    [xLeftPath addArcWithCenter:CGPointMake(rightArcCenterPoint.x - angleSideLength, rightArcCenterPoint.y - angleSideLength) radius:space_2 startAngle:M_PI_2 / 2 endAngle:M_PI + M_PI_2 / 2 clockwise:YES];
    _xLeftShapeLayer.path = xLeftPath.CGPath;
}


// 1. 绘制图标路径
- (void)drawCorporateLogoOfAnimation{
    [self drawCorporateLogobBezierPath];
    [self animationWithStrokeEndWithShapLayer:_outsideCircleShapLayer keyString:outsidCircleAnimationWithStrokeEnd];
    [self animationWithStrokeEndWithShapLayer:_xMiddleShapeLayer keyString:xMiddleShapeLayerStrokeEnd];
    [self animationWithStrokeEndWithShapLayer:_xRightShapeLayer keyString:xRightShapeLayerStrokeEnd];
    [self animationWithStrokeEndWithShapLayer:_xLeftShapeLayer keyString:xLeftShapeLayerStrokeEnd];
}

// 2. 显示文字
- (void)drawCorporateNameBezierPath{
    // 文字图层
    _textShapLayer = [CAShapeLayer layer];
    CGFloat textShapLayerW = arcRadius * 2 + 20;
    CGFloat textShapLayerH = arcRadius;
    _textShapLayer.bounds = CGRectMake(0, 0, textShapLayerW, textShapLayerH);
    _textShapLayer.position = CGPointMake(_iconShapeLayer.position.x, 10 + _iconShapeLayer.position.y + arcRadius + textShapLayerH / 2);
    [self.layer addSublayer:_textShapLayer];
    
    _textShapLayer.strokeColor = [UIColor clearColor].CGColor;
    _textShapLayer.fillColor = [UIColor whiteColor].CGColor;
    _textShapLayer.lineWidth = 1.30f;
    //字体正过来
    _textShapLayer.geometryFlipped = YES;
    _textShapLayer.lineJoin = kCALineJoinBevel;
    _textShapLayer.strokeStart = 0.0f;
    _textShapLayer.strokeEnd = 1.0f;
    
    CGMutablePathRef letters = CGPathCreateMutable();
    CTFontRef font = CTFontCreateWithName(CFSTR(".SFUIDisplay-Thin"), 38.0f, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"爱客仕" attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        for (CFIndex glyphIndex = 0; glyphIndex < CTRunGetGlyphCount(run); glyphIndex++) {
            CGGlyph glyph;
            CGPoint position;
            CFRange currentRange = CFRangeMake(glyphIndex, 1);
            CTRunGetGlyphs(run, currentRange, &glyph);
            CTRunGetPositions(run, currentRange, &position);
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    CFRelease(line);
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    CGPathRelease(letters);
    CFRelease(font);
    _textShapLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    _textShapLayer.path = path.CGPath;
}

- (void)showCorporateNameAnimation{
    [self drawCorporateNameBezierPath];
    
    [self animationWithTextFillColor];
}

// 3. 填充图标颜色
- (void)fillColorForCorporateLogoAnimation{
    [self outsidCircleAnimationWithFillColor];
    [self textOfXAnimationFillColorWithShaperLayer:_xMiddleShapeLayer keyString:xMiddleShapeLayerFillColor];
    [self textOfXAnimationFillColorWithShaperLayer:_xLeftShapeLayer keyString:xLeftShapeLayerFillColor];
    [self textOfXAnimationFillColorWithShaperLayer:_xRightShapeLayer keyString:xRightShapeLayerFillColor];
}

// 4. 移动位置
- (void)transformForCorporateLogoAnimation{
    [self iconLayerBaseAnimationWithPosition];
    [self iconLayerBaseAnimationWithTransform];
    [self animationWithTextPosition];
    [self animationWithTextTransform];
}

#pragma mark - 动画
#pragma mark  Icon基础动画
- (void)iconLayerBaseAnimationWithPosition{
    CABasicAnimation *pAnimatiom = [CABasicAnimation animationWithKeyPath:@"position"];
    pAnimatiom.duration =  0.3;
    pAnimatiom.beginTime = 0;
    pAnimatiom.removedOnCompletion = NO;
    pAnimatiom.fillMode = kCAFillModeForwards;
    pAnimatiom.fromValue = [NSValue valueWithCGPoint:_iconShapeLayer.position];
    CGFloat toValuePointY = 87 + (_iconShapeLayer.bounds.size.width * IconScale)/2;
    CGFloat space = (self.layer.bounds.size.width - _iconShapeLayer.bounds.size.width * IconScale - _textShapLayer.bounds.size.width * TextScale - 5) / 2;
    CGFloat toValuePointX = space + (_iconShapeLayer.bounds.size.width * IconScale)/2;
    pAnimatiom.toValue = [NSValue valueWithCGPoint:CGPointMake(toValuePointX, toValuePointY)];
    pAnimatiom.delegate = self;
    [pAnimatiom setValue:iconLayerBaseAnimationWithPosition forKey:iconLayerBaseAnimationWithPosition];
    [_iconShapeLayer addAnimation:pAnimatiom forKey:nil];
}

- (void)iconLayerBaseAnimationWithTransform{
    CABasicAnimation *tAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    tAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    tAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.41, 0.41, 1)];
    tAnimation.removedOnCompletion = NO;
    tAnimation.fillMode = kCAFillModeForwards;
    tAnimation.duration =  0.3;
    tAnimation.beginTime = 0;
    tAnimation.delegate = self;
    [tAnimation setValue:iconLayerBaseAnimationWithTransform forKey:iconLayerBaseAnimationWithTransform];
    [_iconShapeLayer addAnimation:tAnimation forKey:nil];
}

#pragma mark 外圆动画
- (void)outsidCircleAnimationWithFillColor{
    CABasicAnimation *fillColorAnima = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    fillColorAnima.duration =  0.5;
    fillColorAnima.beginTime = 0;
    fillColorAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fillColorAnima.fromValue = (__bridge id _Nullable)([UIColor clearColor].CGColor);
    fillColorAnima.toValue = (__bridge id _Nullable)DeepBlueColor;
    fillColorAnima.fillMode = kCAFillModeForwards;
    fillColorAnima.removedOnCompletion = NO;
    [fillColorAnima setValue:outsidCircleAnimationWithFillColor forKey:outsidCircleAnimationWithFillColor];
    [_outsideCircleShapLayer addAnimation:fillColorAnima forKey:nil];
}

#pragma  mark X 图片动画
- (void)textOfXAnimationFillColorWithShaperLayer:(CAShapeLayer *)shapeLayer keyString:(NSString *)keyString{
    CABasicAnimation *fillColor = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    fillColor.duration =  0.5;
    fillColor.beginTime = 0;
    fillColor.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fillColor.fromValue = (__bridge id _Nullable)([UIColor whiteColor].CGColor);
    fillColor.toValue = (__bridge id _Nullable)([UIColor whiteColor].CGColor);
    fillColor.fillMode = kCAFillModeForwards;
    fillColor.removedOnCompletion = NO;
    fillColor.delegate = self;
    [fillColor setValue:keyString forKey:keyString];
    [shapeLayer addAnimation:fillColor forKey:nil];
}

#pragma mark  爱客仕 文字动画
- (void)animationWithTextFillColor{
    CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    fillColorAnimation.fromValue =(__bridge id _Nullable)([UIColor whiteColor].CGColor);
    fillColorAnimation.toValue = (__bridge id _Nullable)GrayColor;
    fillColorAnimation.duration = 1;
    fillColorAnimation.fillMode = kCAFillModeForwards;
    fillColorAnimation.removedOnCompletion = NO;
    // 速度控制函数
    //    1.kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉
    //    2.kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开
    //    3.kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地
    //    4.kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，
    //
    fillColorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fillColorAnimation.delegate = self;
    [_textShapLayer setValue:animationWithTextFillColor forKey:animationWithTextFillColor];
    [_textShapLayer addAnimation:fillColorAnimation forKey:nil];
}

- (void)animationWithTextPosition{
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:_textShapLayer.position];
    CGFloat toValuePointY = 87 + (_iconShapeLayer.bounds.size.width * IconScale)/2;
    CGFloat space = (self.layer.bounds.size.width - _iconShapeLayer.bounds.size.width * IconScale - _textShapLayer.bounds.size.width * TextScale - 5) / 2;
    CGFloat toValuePointX = self.layer.bounds.size.width - space - (_textShapLayer.bounds.size.width * TextScale) / 2;
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(toValuePointX, toValuePointY)];
    positionAnimation.duration = 0.3;
    positionAnimation.beginTime = 0;
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.delegate = self;
    [_textShapLayer setValue:animationWithTextPosition forKey:animationWithTextPosition];
    [_textShapLayer addAnimation:positionAnimation forKey:nil];
}

- (void)animationWithTextTransform{
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.75, 0.75, 1)];
    transformAnimation.removedOnCompletion = NO;
    transformAnimation.fillMode = kCAFillModeForwards;
    transformAnimation.duration =  0.3;
    transformAnimation.beginTime = 0;
    transformAnimation.delegate = self;
    [_textShapLayer setValue:animationWithTextTransform forKey:animationWithTextTransform];
    [_textShapLayer addAnimation:transformAnimation forKey:nil];
}


#pragma mark 通用动画
- (void)animationWithStrokeEndWithShapLayer:(CAShapeLayer *)shapeLayer keyString:(NSString *)keyString{
    CABasicAnimation *sAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    sAnimation.duration = 0.8;
    sAnimation.fromValue = @0;
    sAnimation.toValue = @1;
    sAnimation.repeatCount = 1;
    sAnimation.autoreverses = NO;
    sAnimation.delegate = self;
    [sAnimation setValue:keyString forKey:keyString];
    [shapeLayer addAnimation:sAnimation forKey:nil];
}

#define mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if  ([[anim valueForKey:@"xLeftShapeLayerStrokeEnd"]isEqualToString:@"xLeftShapeLayerStrokeEnd"]) {
        [self fillColorForCorporateLogoAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showCorporateNameAnimation];
            
        });
    }else if ([[anim valueForKey:@"xRightShapeLayerFillColor"]isEqualToString:@"xRightShapeLayerFillColor"]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self transformForCorporateLogoAnimation];
        });
        
    }
}

- (void)drawCorporateLogo{
    [self drawCorporateLogobBezierPath];
    [self drawCorporateNameBezierPath];
    self.outsideCircleShapLayer.fillColor = DeepBlueColor;
    self.xMiddleShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    self.xRightShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    self.xLeftShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    self.textShapLayer.fillColor = GrayColor;
    CGFloat toValuePointY = 87 + (_iconShapeLayer.bounds.size.width * IconScale)/2 - _iconShapeLayer.position.y;
    CGFloat space = (self.layer.bounds.size.width - _iconShapeLayer.bounds.size.width * IconScale - _textShapLayer.bounds.size.width * TextScale - 5) / 2;
    CGFloat toValuePointX = space + (_iconShapeLayer.bounds.size.width * IconScale)/2 - _iconShapeLayer.position.x;
    self.iconShapeLayer.transform = CATransform3DScale(CATransform3DMakeTranslation(toValuePointX, toValuePointY, 0), IconScale, IconScale, 1);
    
    CGFloat textToValuePointY = 87 + (_iconShapeLayer.bounds.size.width * IconScale)/2 - _textShapLayer.position.y;
    CGFloat textSpace = (self.layer.bounds.size.width - _iconShapeLayer.bounds.size.width * IconScale - _textShapLayer.bounds.size.width * TextScale - 5) / 2;
    CGFloat textToValuePointX = self.layer.bounds.size.width - textSpace - (_textShapLayer.bounds.size.width * TextScale) / 2 - _textShapLayer.position.x;
    self.textShapLayer.transform = CATransform3DScale(CATransform3DMakeTranslation(textToValuePointX, textToValuePointY, 0), TextScale, TextScale, 1);
}
@end
