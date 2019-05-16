//
//  Books.m
//  test
//
//  Created by rrjj on 2019/5/16.
//Copyright © 2019 rrjj. All rights reserved.
//

#import "Books.h"

@implementation Books

+(NSString *)primaryKey
{
    return @"BOOKID";
}
+(NSArray<NSString *> *)indexedProperties
{
    return @[@"BOOKID"];
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
