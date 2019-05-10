
//
//  ReadOnlyModel.m
//  test
//
//  Created by rrjj on 2019/5/10.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "ReadOnlyModel.h"

@implementation ReadOnlyModel

-(instancetype)initWithStr:(NSString *)str
{
    self = [super init];
    if (self) {
        _readOnlyStr = str;
    }
    return self;
}

+(BOOL)accessInstanceVariablesDirectly
{
    return NO;
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"readOnlyStr"]) {
        NSLog(@"只读不可修改");
        return;
    }
    [super setValue:value forKey:key];
}

@end
