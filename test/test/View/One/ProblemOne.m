//
//  ProblemOne.m
//  test
//
//  Created by rrjj on 2019/2/26.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "ProblemOne.h"

@implementation ProblemOne

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect
{
    CGRect inframe = CGRectMake(0, 0, 100, 100);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextAddEllipseInRect(ctx, inframe);
    CGContextMoveToPoint(ctx, CGRectGetMidX(inframe), CGRectGetMinY(inframe));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(inframe), CGRectGetMidY(inframe));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(inframe), CGRectGetMidY(inframe));
    CGContextAddLineToPoint(ctx, CGRectGetMidX(inframe), CGRectGetMinY(inframe));
    CGContextStrokePath(ctx);
}

@end
