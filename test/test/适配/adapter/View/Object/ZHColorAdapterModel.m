//
//  ZHColorAdapterModel.m
//  test
//
//  Created by rrjj on 2019/6/5.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHColorAdapterModel.h"


@implementation ZHColorAdapterModel

-(UIView *)getLeftView
{
    ZHLeftRightModel *model = self.model;
   
   return model.viewL;
}

-(UIView *)getRightView
{
    ZHLeftRightModel *model = self.model;
    return model.viewR;
}

@end


