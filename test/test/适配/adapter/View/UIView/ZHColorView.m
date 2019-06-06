//
//  ZHColorView.m
//  test
//
//  Created by rrjj on 2019/6/5.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHColorView.h"

@implementation ZHColorView

-(instancetype)initWithModel:(ZHLeftRightModel *)model
{
    self = [super init];
    if (self) {
        ZHColorAdapterModel *adpModel = [[ZHColorAdapterModel alloc] initWithModel:model];
       
        [self addSubview:[adpModel getRightView]];
        [self addSubview:[adpModel getLeftView]];
    }
    return self;
}

@end
