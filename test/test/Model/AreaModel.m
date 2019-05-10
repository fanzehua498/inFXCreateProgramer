//
//  AreaModel.m
//  test
//
//  Created by rrjj on 2019/4/15.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel


+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"area":@"areaCityModel"};
}

@end
@implementation areaCityModel

-(void)setName:(NSString *)name
{
    _name = name;
    
    _readOnlyHeight = [_name boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{} context:nil].size.height;
    _readOnlyStr = name;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id": @"id"};
}

#pragma mark - 设置kvc修改只读不可用
+ (BOOL)accessInstanceVariablesDirectly
{
    return NO;
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"readOnlyHeight"] || [key isEqualToString:@"readOnlyStr"]) {
        NSLog(@"只读属性不允许修改");
        return;
    }
    [super setValue:value forKey:key];
}
@end
