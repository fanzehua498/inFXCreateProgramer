//
//  FFUIPageControlView.m
//  test
//
//  Created by rrjj on 2019/5/8.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "FFUIPageControlView.h"


#define scrW ([UIScreen mainScreen].bounds.size.width)
@interface FFUIPageControlView ()

@property (nonatomic,strong) CAShapeLayer *shapLayer;
@property (nonatomic,strong) CADisplayLink *display;   //定时器
@property (nonatomic,assign) CGFloat offset;           //x方向位移

@end

@implementation FFUIPageControlView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)setupTimer{
//    self.shapLayer = [CAShapeLayer layer];
//    self.shapLayer.fillColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:self.shapLayer];
    
//    CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawWaveLine)];
//    [display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(drawWaveLin1) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
    
//    self.display = display;
    self.offset = 0;
}

- (void)drawWaveLine
{
//    //创建一个路径
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGFloat y = 100;
//    //将点移动到 x=0,y=currentK的位置
//    CGPathMoveToPoint(path, nil, 0, y);
//    CGFloat i = arc4random() % 2;
//    for (NSInteger x = 0.0f; x<=scrW; x++) {
//        //标准正玄波浪公式
////        y = (100) * sin((1/30.0)*x+ self.offset)+100;
//
//        y = i * 3 * sin((M_PI/scrW)*x) * (20 * sin((1/30.0)*x + 0)) + 100;
//        //将点连成线
//        CGPathAddLineToPoint(path, nil, x, y);
//    }
//    CGPathAddLineToPoint(path, nil, scrW, self.frame.size.height);
//    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
//
//    CGPathCloseSubpath(path);
//    self.shapLayer.path = path;
//    CGPathRelease(path);
//
//    self.offset += 0.1;
//    if (self.offset > 60*M_PI) {
//        self.offset = 0;
//    }
    
}

- (void)drawWaveLin1
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGFloat y = [UIScreen mainScreen].bounds.size.height/2;
    [path moveToPoint:CGPointMake(0, y)];
    CGFloat arc1 = arc4random()%10 * 0.05 + 0.1;
    CGFloat arc2 = arc4random()%10 * 0.06 + 0.1;
    for (NSInteger x = 1.0f; x<=scrW/7; x++) {
            //标准正玄波浪公式
    //        y = (100) * sin((1/30.0)*x+ self.offset)+100;
        
//            y =  arc * sin((M_PI/scrW)*x) * (20 * sin((1/30.0)*x + 0)) + 100;
        y =   arc1 *sin((0.6)*x) * (20 * sin((1/30.0)*x + 0)) * (sin((1/30.0)*x + 10)) + y;
            //将点连成线
            [path addLineToPoint:CGPointMake(x, y)];
    }
    for (NSInteger x = scrW/7; x<=scrW/2; x++) {
        //标准正玄波浪公式
        //        y = (100) * sin((1/30.0)*x+ self.offset)+100;
        
        //            y =  arc * sin((M_PI/scrW)*x) * (20 * sin((1/30.0)*x + 0)) + 100;
        y =   arc2 *sin((0.3)*x) * (20 * sin((1/30.0)*x + 0)) + y;
        //将点连成线
        [path addLineToPoint:CGPointMake(x, y)];
    }
    
    for (NSInteger x = scrW/2; x<=scrW/2 + scrW/7-1; x++) {
        y =   arc1 *sin((0.6)*x) * (20 * sin((1/30.0)*x + 0)) * (sin((1/30.0)*x + 10)) + y;
        //将点连成线
        [path addLineToPoint:CGPointMake(x, y)];
    }
    [path addLineToPoint:CGPointMake(scrW/2 + scrW/7-1, [UIScreen mainScreen].bounds.size.height/2)];
    path.lineCapStyle = kCGLineCapRound;
    self.shapLayer.path = path.CGPath;

}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
}
- (CAShapeLayer *)shapLayer
{
    if(!_shapLayer){
        _shapLayer = [CAShapeLayer layer];
        _shapLayer.strokeColor = [UIColor greenColor].CGColor;
        _shapLayer.lineWidth = 1.0;
        _shapLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _shapLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
