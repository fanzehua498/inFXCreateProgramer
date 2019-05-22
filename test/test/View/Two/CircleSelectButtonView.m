//
//  CircleSelectButtonView.m
//  test
//
//  Created by rrjj on 2019/5/13.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "CircleSelectButtonView.h"
#import "specialShapeView.h"
@interface CircleSelectButtonView ()

@property (nonatomic,strong) UIBezierPath *path1;
@property (nonatomic,strong) UIBezierPath *path2;
@property (nonatomic,strong) UIBezierPath *path3;
@property (nonatomic,strong) UIBezierPath *path4;
@property (nonatomic,strong) UIBezierPath *path5;

@property (nonatomic,strong) NSMutableArray *mutableArr;


@end

@implementation CircleSelectButtonView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCircle];
    }
    return self;
}

- (void)setUP
{
    [self createCircle];
}

- (void)createCircle
{
    CGFloat raduis = self.frame.size.width / 2;
    [self addSubCircleLayer:CGPointMake(self.frame.size.width / 2, 0) linePoint:CGPointMake(raduis, raduis/2)  linePoint2:CGPointMake(raduis - raduis*cos(M_PI / 10), raduis - raduis*sin(M_PI / 10)) startAngle:1.5 * M_PI endAngle:M_PI / 10 + M_PI Color:[UIColor blueColor] path:1];

    [self addSubCircleLayer:CGPointMake(raduis - raduis*cos(M_PI / 10), raduis - raduis*sin(M_PI / 10)) linePoint:CGPointMake(raduis - raduis*cos(M_PI / 10)/2, raduis - raduis*sin(M_PI / 10)/2) linePoint2:CGPointMake(raduis - raduis * cos(3*M_PI/10), raduis + raduis* sin(3*M_PI/10)) startAngle:M_PI / 10 + M_PI endAngle: 7*M_PI/10 Color:[UIColor grayColor] path:2];
    
    [self addSubCircleLayer:CGPointMake(raduis - raduis * cos(3*M_PI/10), raduis + raduis* sin(3*M_PI/10)) linePoint:CGPointMake(raduis - raduis * cos(3*M_PI/10)/2, raduis + raduis* sin(3*M_PI/10)/2) linePoint2:CGPointMake(raduis + raduis * cos(3*M_PI/10), raduis + raduis* sin(3*M_PI/10)) startAngle:7*M_PI/10 endAngle:3*M_PI/10 Color:[UIColor greenColor] path:3];
    
    [self addSubCircleLayer:CGPointMake(raduis + raduis * cos(3*M_PI/10), raduis + raduis* sin(3*M_PI/10)) linePoint:CGPointMake(raduis + raduis * cos(3*M_PI/10)/2, raduis + raduis* sin(3*M_PI/10)/2) linePoint2:CGPointMake(raduis + raduis*cos(M_PI / 10), raduis - raduis*sin(M_PI / 10)) startAngle:3*M_PI/10 endAngle:-M_PI/10 Color:[UIColor cyanColor] path:4];
    
    [self addSubCircleLayer:CGPointMake(raduis + raduis*cos(M_PI / 10), raduis - raduis*sin(M_PI / 10)) linePoint:CGPointMake(raduis + raduis*cos(M_PI / 10)/2, raduis - raduis*sin(M_PI / 10)/2) linePoint2:CGPointMake(self.frame.size.width / 2, 0) startAngle:-M_PI/10 endAngle:1.5 * M_PI Color:[UIColor orangeColor] path:5];
    
    
}

- (void)addSubCircleLayer:(CGPoint )startPoint linePoint:(CGPoint)linePoint linePoint2:(CGPoint)linePoint2 startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle Color:(UIColor *)fillColor path:(NSInteger)pathNum
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
//    layer.frame = self.frame;
    layer.fillColor = fillColor.CGColor;
    path.lineCapStyle = kCGLineCapRound;
    layer.path = path.CGPath;
    
//    self.layer.mask = layer;
    [self.layer addSublayer:layer];
    NSLog(@"%@",NSStringFromCGRect(layer.bounds));
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = path.bounds;
    [button setTitle:@"normal" forState:UIControlStateNormal];
    [button setTitle:@"select" forState:UIControlStateSelected];

//    [button addTarget:self action:@selector(selectActiom:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:button];
//    self.path = path;
    UILabel *label = [[UILabel alloc] initWithFrame:path.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"模块 %ld",pathNum];
    [self addSubview:label];
    switch (pathNum) {
        case 1:
            self.path1 = path;
            break;
        case 2:
            self.path2 = path;
            break;
        case 3:
            self.path3 = path;
            break;
        case 4:
            self.path4 = path;
            break;
        case 5:
            self.path5 = path;
            break;
            
        default:
            break;
    }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//    [self createCircle];
}

- (void)selectActiom:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
//    NSLog(@"%@",NSStringFromCGPoint(point));
    
    if ([self.path1 containsPoint:point]) {
        NSLog(@"模块1");
        [[self.undoManager prepareWithInvocationTarget:self] addobjectMethod:@"mk1"];
        
        [self becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        
        [menuController setTargetRect:self.bounds inView:self];
        menuController.menuItems = @[
                           [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)],
                           [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)],
                           [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(warn:)],
                           [[UIMenuItem alloc] initWithTitle:@"顶1" action:@selector(ding:)],
                           [[UIMenuItem alloc] initWithTitle:@"回复1" action:@selector(reply:)],
                           [[UIMenuItem alloc] initWithTitle:@"举报1" action:@selector(warn:)]
                           ];
        
        [menuController setMenuVisible:YES animated:YES];
    }else if ([self.path2 containsPoint:point]){
        NSLog(@"模块2");
        [[self.undoManager prepareWithInvocationTarget:self] addobjectMethod:@"mk2"];
    }else if ([self.path3 containsPoint:point]){
        NSLog(@"模块3");
        [[self.undoManager prepareWithInvocationTarget:self] addobjectMethod:@"mk3"];
    }else if ([self.path4 containsPoint:point]){
        NSLog(@"模块4");
        [self.undoManager redo];//重做
        NSLog(@"%@",self.mutableArr);
    }else if ([self.path5 containsPoint:point]){
        NSLog(@"模块5");
        [self.undoManager undo];//取消
        NSLog(@"%@",self.mutableArr);
       
        NSLog(@"commands:%@",self.keyCommands);
        
    }
    
//    NSLog(@"%d",[specialShapeView in_circular_sector:CGPointMake(self.frame.size.width / 2, self.frame.size.width / 2 + self.frame.size.width / 4) direction:CGPointMake(0, 0) r:self.frame.size.width / 2 angle:2/5*360 point:point]);
    

    
}
/** 撤销管理器，NSUndoManger内部维护两个栈，undo栈和redo栈 */
- (void)addobjectMethod:(NSString *)str
{
    [[self.undoManager prepareWithInvocationTarget:self] removeObjectMethod:str];//逆向删除
     [self.mutableArr addObject:str];
}


- (void)removeObjectMethod:(NSString *)str
{
    [[self.undoManager prepareWithInvocationTarget:self] addobjectMethod:str];//逆向添加
    if ([self.mutableArr containsObject:str]) {
        [self.mutableArr removeObject:str];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    
    
    return YES;
}

#pragma mark - UIMENUCONTROLLER
//必须实现
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(action));
    if (action == @selector(cut:) || action == @selector(copy:) || action == @selector(paste:) || action == @selector(ding:) || action == @selector(reply:) || action == @selector(warn:)) {
        return YES;
    }
    return NO;
}

- (void)cut:(UIMenuController *)sender
{
    NSLog(@"%s %@",__func__,sender);
}
- (void)copy:(UIMenuController *)menu
{
    UIPasteboard *past = [UIPasteboard generalPasteboard];
    past.string = @"copy";
    NSLog(@"%s %@", __func__, menu);
}

- (void)paste:(UIMenuController *)menu
{
    NSLog(@"%s %@", __func__, menu);
    UIPasteboard *past = [UIPasteboard generalPasteboard];
    NSLog(@"%@",past.string);
}

- (void)ding:(UIMenuController *)menu
{
    NSLog(@"%s %@", __func__, menu);
}
- (void)reply:(UIMenuController *)menu
{
    NSLog(@"%s %@", __func__, menu);
}
- (void)warn:(UIMenuController *)menu
{
    NSLog(@"%s %@", __func__, menu);
}
#pragma mark - 懒加载
-(NSMutableArray *)mutableArr
{
    if (!_mutableArr) {
        _mutableArr = [NSMutableArray array];
    }
    return _mutableArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
