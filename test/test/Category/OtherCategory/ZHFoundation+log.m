//
//  ZHFoundation+log.m
//  test
//
//  Created by 范泽华 on 2019/5/24.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSDictionary (log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *mstr = [NSMutableString string];
    
    [mstr appendFormat:@"{\n"];
    //遍历字典键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mstr appendFormat:@"\t%@ = %@,\n",key,obj];
    }];
    
    [mstr appendFormat:@"}"];
    
    //查出最后一个,的范围
    NSRange range = [mstr rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        //删除最后一个,
        [mstr deleteCharactersInRange:range];
    }
    
    return mstr;
}

@end


@implementation NSArray (log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *mstr = [NSMutableString string];
    [mstr appendFormat:@"[\n"];
    //遍历
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mstr appendFormat:@"%@,\n",obj];
        
    }];
    [mstr appendFormat:@"]\n"];
    //删除,
    NSRange rang = [mstr rangeOfString:@"," options:NSBackwardsSearch];
    if (rang.length != 0) {
        [mstr deleteCharactersInRange:rang];
    }
    
    return mstr;
}

@end
