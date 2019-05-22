//
//  ZHVerifyView.m
//  test
//
//  Created by rrjj on 2019/5/21.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHVerifyView.h"
#import "NSString+Category.h"
#import <Masonry.h>

#define ZHVerifyViewallCount 7
#define ZHVerifyViewSelectCount 4

@interface ZHVerifyView ()

@property (nonatomic,strong) UIImageView *imageView;
/** 目标文字 */
@property (copy, nonatomic) NSString *resultChinese;
/** 选中文字 */
@property (copy, nonatomic) NSString *selectChinese;
/** 所有文字 */
@property (copy, nonatomic) NSString *allChinese;

@property (nonatomic,assign) CGPoint point;

@end

@implementation ZHVerifyView

-(instancetype)initWithFrame:(CGRect)frame bgImage:(NSString *)image
{
    if (self = [super initWithFrame:frame]) {
        self.imageView.image = [UIImage imageNamed:image];
    }
    return self;
}

#pragma mark -
- (void)setup{
    [self addSubview:self.imageView];
}



#pragma mark - 懒加载
-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

-(NSString *)resultChinese
{
    if (!_resultChinese) {
        _resultChinese = [NSString getRandomChinese:ZHVerifyViewSelectCount];
    }
    return _resultChinese;
}

-(NSString *)allChinese
{
    if (!_allChinese) {
        _allChinese = [NSString stringWithFormat:@"%@%@",self.resultChinese,[NSString getRandomChinese:ZHVerifyViewallCount - ZHVerifyViewSelectCount]];
    }
    return _allChinese;
}

#pragma mark - end

@end
