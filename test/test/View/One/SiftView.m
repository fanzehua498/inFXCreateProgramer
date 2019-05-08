//
//  SiftView.m
//  test
//
//  Created by rrjj on 2018/10/11.
//  Copyright © 2018 rrjj. All rights reserved.
//


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#import "SiftView.h"

@interface SiftView ()
@property (nonatomic,strong) UIView *levelView;
@property (nonatomic,strong) NSMutableArray *selectLevel;
@property (nonatomic,strong) UILabel *titleLabel;
///** 单选且返回 */
@property (nonatomic,assign) BOOL back;


@end

@implementation SiftView

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title singleBack:(BOOL)back
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.levelView];
        [self addSubview:self.titleLabel];
        self.back = back;
        self.isSingle = YES;
//        self.backgroundColor = [UIColor purpleColor];
        self.title = title;
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    NSAssert(self.subviews.count <= 0, @"SiftView不允许在xib中自己添加视图");
    [self addSubview:self.levelView];
    [self addSubview:self.titleLabel];
    self.isSingle = YES;
    
}

-(void)setLevel:(NSArray *)level
{
    _level = level;
    
    if (self.levelView.subviews.count > 0) {
        for (UIButton * btn in self.levelView.subviews) {
            [btn removeFromSuperview];
        }
    }
    NSInteger padding = 10;
    CGFloat bwidth = (self.levelView.frame.size.width - 4 * padding) / 3;
    CGFloat bheight = 30;
    for (int i = 0; i < level.count; i ++) {
        NSInteger lie = i/3;
        NSInteger row = i%3;
        
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(padding + (bwidth+padding) * row, padding + (bheight + padding) * lie, bwidth, bheight);
        [btn setTitle:[NSString stringWithFormat:@"%@",level[i]] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectLevel:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 10086;
        [self.levelView addSubview:btn];
        [self createCorner:btn];
    }
    CGRect frmae = self.frame;
    CGFloat numberRow = level.count%3 == 0 ? level.count / 3 : (level.count / 3 + 1);
    frmae.size.height = (bheight + padding) * numberRow + padding;
    self.frame = !_title ? frmae : CGRectMake(frmae.origin.x, frmae.origin.y, frmae.size.width, frmae.size.height + 40);
    self.levelView.frame = CGRectMake(frmae.origin.x, self.levelView.frame.origin.y, frmae.size.width, frmae.size.height);
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    if (!self.level) {
        NSAssert(!self.level, @"先设置选项");
    }
    self.titleLabel.text = title;
}

-(void)setIsSingle:(BOOL)isSingle
{
    if (self.back) {
        _isSingle = YES;
    }else{
        _isSingle = isSingle;
    }
}

#pragma mark
- (void)selectLevel:(UIButton *)sender
{
    NSInteger tag = sender.tag - 10086;
    if (self.back) {
        if (self.block) {
            self.block(sender.titleLabel.text);
        }
        
    }else{
        
        if (self.isSingle) {
            
            for (UIButton *btn in self.selectLevel) {
                btn.backgroundColor = [UIColor grayColor];
            }
            sender.backgroundColor = [UIColor blueColor];
            [self.selectLevel removeAllObjects];
            [self.selectLevel addObject:sender];
        }else{
            BOOL isExist = NO;
            if (tag == 0) {
                
                for (UIButton *btn in self.selectLevel) {
                    btn.backgroundColor = [UIColor grayColor];
                }
                sender.backgroundColor = [UIColor blueColor];
                [self.selectLevel removeAllObjects];
            }else{
                
                for (UIButton *btn in self.selectLevel) {
                    if (btn.tag ==  sender.tag) {
                        isExist = YES;
                    }
                }
                if (!isExist) {
                    [self.selectLevel addObject:sender];
                    UIButton *btn = [_levelView viewWithTag:10086];
                    btn.backgroundColor = [UIColor grayColor];
                    sender.backgroundColor = [UIColor blueColor];
                }
            }
            
            NSLog(@"selectLevel:%@",self.selectLevel);
        }
    }

}

#pragma mark - 私有
-(NSMutableArray *)getSelectData
{
    NSMutableArray *nameArr = [NSMutableArray array];
    [nameArr removeAllObjects];
    for (UIButton *btn in self.selectLevel) {
        [nameArr addObject:btn.titleLabel.text];
    }
    
    return nameArr;
}

#pragma mark  懒加载
-(UIView *)levelView
{
    if (!_levelView) {
        _levelView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 0)];
        
    }
    return _levelView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth - 30, 30)];
    }
    return _titleLabel;
}

- (NSMutableArray *)selectLevel
{
    if (!_selectLevel) {
        _selectLevel = [NSMutableArray array];
    }
    return _selectLevel;
}

- (void)createCorner:(UIView *)view
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:3];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = view.bounds;
    shape.path = path.CGPath;
    
    view.layer.mask = shape;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
