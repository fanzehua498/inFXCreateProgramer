//
//  ZHTextField.m
//  test
//
//  Created by rrjj on 2019/5/15.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "ZHTextField.h"
#import <objc/message.h>
@interface ZHTextField ()<UITextFieldDelegate>
@property (copy, nonatomic) NSString *lastStr;
@end

@implementation ZHTextField

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame WithDelegate:(id)object
{
    if (self = [super initWithFrame:frame]) {

        self.lastStr = @"";
    }
    return self;
}

-(void)setType:(FieldType)type
{
    _type = type;
    if (type == FieldTypeNone) {
    }else{
        if (type == FieldTypeLetter) {
            self.keyboardType  = UIKeyboardTypeASCIICapable;
        }else if (type == FieldTypeDecimal){
             self.keyboardType = UIKeyboardTypeNumberPad;
        }
        self.delegate = self;
        [self addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
}
#pragma mark - public
- (NSInteger)curOffset{
    // 基于文首计算出到光标的偏移数值。
    return [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
}
- (void)makeOffset:(NSInteger)offset{
    // 实现原理是先获取一个基于文尾的偏移，然后加上要施加的偏移，再重新根据文尾计算位置，最后利用选取来实现光标定位。
    UITextRange *selectedRange = [self selectedTextRange];
    NSInteger currentOffset = [self offsetFromPosition:self.endOfDocument toPosition:selectedRange.end];
    currentOffset += offset;
    UITextPosition *newPos = [self positionFromPosition:self.endOfDocument offset:currentOffset];
    self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];
}
- (void)makeOffsetFromBeginning:(NSInteger)offset{
    // 先把光标移动到文首，然后再调用上面实现的偏移函数。
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:begin offset:0];
    UITextRange *range = [self textRangeFromPosition:start toPosition:start];
    [self setSelectedTextRange:range];
    [self makeOffset:offset];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[self makeOffset:-5];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        self.lastStr = textField.text;
        return YES;
    } else {
        return NO;
    }
}

- (void)textFieldChange:(UITextField *)textField
{
    NSString *toBeString = textField.text;

    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    if([lang isEqualToString:@"zh-Hans"])
    { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                if (self.type == FieldTypeNone) {
                    textField.text = getStr;
                    self.lastStr = getStr;
                }else{
                    textField.text = [self disable_emoji:getStr];
                    self.lastStr = [self disable_emoji:getStr];
                }
            }
        }
    }
    else
    {
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            if (self.type == FieldTypeNone) {
                textField.text = getStr;
                self.lastStr = getStr;
            }else{
                textField.text = [self disable_emoji:getStr];
                self.lastStr = [self disable_emoji:getStr];
            }
        }
    }
}
#pragma mark - private
/**
 * 字母、数字、中文正则判断（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 */
- (BOOL)isInputRuleNotBlank:(NSString *)str {
    
    NSString *pattern = @"";
    switch (self.type) {
        case FieldTypeNone:
            return YES;
            break;
        case FieldTypeLetter:
        {
            pattern = @"^[a-zA-Z]*$";
        }
            break;
        case FieldTypeDecimal:
        {
            pattern = @"^[➋➌➍➎➏➐➑➒]*$";
        }
            break;
        case FieldTypeIDNumber:
        {
            pattern = @"^[➋➌➍➎➏➐➑➒xX\\d]*$";
        }
        case FieldTypeChinese:
        {
            pattern = @"^[a-zA-Z\u4E00-\u9FA5]*$";
            return YES;
        }
            break;
        case FieldTypeAll:
        {
            pattern = @"^[➋➌➍➎➏➐➑➒a-zA-Z\u4E00-\u9FA5\\d]*$";
        }
            break;
            
        default:
            break;
    }
    if (pattern.length == 0) {
        return YES;
    }
    //    NSString *pattern = @"^[➋➌➍➎➏➐➑➒a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
-(NSString *)getSubString:(NSString*)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (self.MaxLength==0 || !self.MaxLength) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, length)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];
        return content;
    }
    if (length > self.MaxLength) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, self.MaxLength)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//注意：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, self.MaxLength - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return string;
}

- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}



@end
