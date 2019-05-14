//
//  CircleSelectButtonView.m
//  test
//
//  Created by rrjj on 2019/5/13.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "CircleSelectButtonView.h"

@implementation CircleSelectButtonView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCircle];
    }
    return self;
}

- (void)createCircle
{
    CGFloat raduis = self.frame.size.width / 2;
    [self addSubCircleLayer:CGPointMake(self.frame.size.width / 2, 0) linePoint:CGPointMake(raduis, raduis/2)  linePoint2:CGPointMake(raduis - raduis*cos(M_PI / 10), raduis - raduis*sin(M_PI / 10)) startAngle:1.5 * M_PI endAngle:M_PI / 10 + M_PI Color:[UIColor blueColor]];

    [self addSubCircleLayer:CGPointMake(raduis - raduis*cos(M_PI / 10), raduis - raduis*sin(M_PI / 10)) linePoint:CGPointMake(raduis - raduis*cos(M_PI / 10)/2, raduis - raduis*sin(M_PI / 10)/2) linePoint2:CGPointMake(raduis - raduis * cos(3*M_PI/10), raduis + raduis* sin(3*M_PI/10)) startAngle:M_PI / 10 + M_PI endAngle: 7*M_PI/10 Color:[UIColor grayColor]];
    
    [self addSubCircleLayer:CGPointMake(raduis - raduis * cos(3*M_PI/10), raduis + raduis* sin(3*M_PI/10)) linePoint:CGPointMake(raduis - raduis * cos(3*M_PI/10)/2, raduis + raduis* sin(3*M_PI/10)/2) linePoint2:CGPointMake(raduis + raduis * cos(3*M_PI/10), raduis + raduis* sin(3*M_PI/10)) startAngle:7*M_PI/10 endAngle:3*M_PI/10 Color:[UIColor greenColor]];
    
    [self addSubCircleLayer:CGPointMake(raduis + raduis * cos(3*M_PI/10), raduis + raduis* sin(3*M_PI/10)) linePoint:CGPointMake(raduis + raduis * cos(3*M_PI/10)/2, raduis + raduis* sin(3*M_PI/10)/2) linePoint2:CGPointMake(raduis + raduis*cos(M_PI / 10), raduis - raduis*sin(M_PI / 10)) startAngle:3*M_PI/10 endAngle:-M_PI/10 Color:[UIColor cyanColor]];
    
    [self addSubCircleLayer:CGPointMake(raduis + raduis*cos(M_PI / 10), raduis - raduis*sin(M_PI / 10)) linePoint:CGPointMake(raduis + raduis*cos(M_PI / 10)/2, raduis - raduis*sin(M_PI / 10)/2) linePoint2:CGPointMake(self.frame.size.width / 2, 0) startAngle:-M_PI/10 endAngle:1.5 * M_PI Color:[UIColor orangeColor]];
    
    
}

- (void)addSubCircleLayer:(CGPoint )startPoint linePoint:(CGPoint)linePoint linePoint2:(CGPoint)linePoint2 startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle Color:(UIColor *)fillColor
{
    CGFloat raduis = self.frame.size.width / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:linePoint];
    [path addArcWithCenter:CGPointMake(raduis, raduis) radius:raduis/2 startAngle:startAngle endAngle: endAngle clockwise:NO];
    [path addLineToPoint:linePoint2];
    [path addArcWithCenter:CGPointMake(raduis, raduis) radius:raduis startAngle:endAngle endAngle:startAngle clockwise:YES];
    CAShapeLayer *layer = [CAShapeLayer layer];
    //    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.lineWidth = 1.0;
    
    layer.fillColor = fillColor.CGColor;
    path.lineCapStyle = kCGLineCapRound;
    layer.path = path.CGPath;
    
    [self.layer addSublayer:layer];
    NSLog(@"%@",NSStringFromCGRect(layer.bounds));
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = path.bounds;
    [button setTitle:@"normal" forState:UIControlStateNormal];
    [button setTitle:@"select" forState:UIControlStateSelected];

//    [button addTarget:self action:@selector(selectActiom:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];

//    UILabel *label = [[UILabel alloc] initWithFrame:path.bounds];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"label";
//    [self addSubview:label];
    
}

- (void)selectActiom:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(point));
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
