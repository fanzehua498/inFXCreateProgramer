//
//  ZHAdapterCNY.m
//  test
//
//  Created by rrjj on 2019/6/5.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHAdapterCNY.h"

@implementation ZHAdapterCNY

-(float)getCny
{
    return [self getUSD] *8.1;
}
@end
