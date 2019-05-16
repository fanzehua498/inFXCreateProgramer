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

-(instancetype)initWithFrame:(CGRect)frame WithDelegate:(id)object;

@property (nonatomic,assign) FieldType type;
@property (nonatomic,assign) CGFloat MaxLength;
@end

NS_ASSUME_NONNULL_END
