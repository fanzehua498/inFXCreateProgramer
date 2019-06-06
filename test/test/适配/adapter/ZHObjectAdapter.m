//
//  ZHObjectAdapter.m
//  test
//
//  Created by rrjj on 2019/6/5.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHObjectAdapter.h"

@interface ZHObjectAdapter ()

@property (nonatomic,strong) ZHAdapteeUSD *usdAdaptee;

@end

@implementation ZHObjectAdapter

-(instancetype)initWithAdaptee:(ZHAdapteeUSD *)adaptee
{
    self = [super init];
    if (self) {
        _usdAdaptee = adaptee;
    }
    return self;
}

-(float)getCny
{
    return [self.usdAdaptee getUSD] *8.1;
}
@end
