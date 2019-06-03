//
//  ZHTextField.h
//  test
//
//  Created by rrjj on 2019/5/15.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, FieldType) {
    FieldTypeIDNumber,//身份证
    FieldTypeChinese,//中文+字母
    FieldTypeDecimal,//数字
    FieldTypeLetter,//字母
    FieldTypeNone,//含emoji
    FieldTypeAll,//中文 数字 字母
};

NS_ASSUME_NONNULL_BEGIN

@interface ZHTextField : UITextField
/**
 * 获取光标位置
 */
- (NSInteger)curOffset;

/**
 * 从当前位置偏移
 */
- (void)makeOffset:(NSInteger)offset;

/**
 * 从头偏移
 */
- (void)makeOffsetFromBeginning:(NSInteger)offset;

/**
 * 构造函数
 */
-(instancetype)initWithFrame:(CGRect)frame WithDelegate:(id)object;

/**
 * 输入类型
 */
@property (nonatomic,assign) FieldType type;

/**
 * 可输入最长长度
 */
@property (nonatomic,assign) CGFloat MaxLength;
@end

NS_ASSUME_NONNULL_END
