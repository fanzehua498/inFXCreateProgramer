//
//  ZHColorModel.m
//  test
//
//  Created by rrjj on 2019/6/5.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHColorModel.h"

@implementation ZHColorModel
-(instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

-(UIView *)getLeftView
{
    return nil;
}
-(UIView *)getRightView
{
    return nil;
}
@end
