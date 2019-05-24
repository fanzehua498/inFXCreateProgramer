//
//  NSString+Category.m
//  test
//
//  Created by rrjj on 2019/5/21.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

+(NSString *)getRandomChinese:(NSInteger)count
{
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    NSStringEncoding encodomh = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    /**
     枚举CFStringEncodings中定义了很多编码方式。简体中文相关的是这三个
     1     kCFStringEncodingGB_2312_80 = 0x0630,
     2     kCFStringEncodingGBK_95 = 0x0631,         annex to GB 13000-93; for Windows 95
     3     kCFStringEncodingGB_18030_2000 = 0x0632,
    */
    for (NSInteger i = 0; i < count; i ++) {
        NSInteger randomH = 0xa1 + arc4random()%(0xfe - 0xa1 + 1);
        NSInteger randomL = 0xb0 + arc4random()%(0xf7 - 0xb0 + 1);
        NSInteger number = (randomH<<8) + randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        NSString *string = [[NSString alloc] initWithData:data encoding:encodomh];
        if (string) {
            [mutableString appendString:string];
        }
    }
    
    return [NSString stringWithFormat:@"%@",mutableString];
}

@end
