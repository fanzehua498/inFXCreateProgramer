//
//  Student.m
//  test
//
//  Created by rrjj on 2019/5/15.
//Copyright © 2019 rrjj. All rights reserved.
//

#import "Student.h"

@interface Student ()

@end

@implementation Student

+(NSString *)primaryKey
{
    return @"ID";
}

+(NSArray<NSString *> *)indexedProperties
{
    return @[@"ID"];
}
// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
