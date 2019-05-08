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

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id": @"id"};
}
@end
