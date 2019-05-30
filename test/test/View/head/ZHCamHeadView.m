//
//  ZHCamHeadView.m
//  test
//
//  Created by rrjj on 2019/5/30.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHCamHeadView.h"

@interface ZHCamHeadView ()

@end

@implementation ZHCamHeadView

+ (instancetype)shareHeadView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
- (IBAction)backAction:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}


@end
