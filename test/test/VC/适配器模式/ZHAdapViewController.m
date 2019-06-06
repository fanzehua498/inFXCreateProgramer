//
//  ZHAdapViewController.m
//  test
//
//  Created by rrjj on 2019/6/5.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHAdapViewController.h"
#import "ZHAdapterCNY.h"
#import "ZHObjectAdapter.h"
#import "ZHAdapteeUSD.h"


#pragma mark -- 适配器视图
#import "ZHColorAdapterModel.h"
#import "ZHLeftRightModel.h"
#import "ZHColorView.h"

@implementation ZHAdapViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    ZHAdapterCNY *adCNY = [[ZHAdapterCNY alloc] init];
    float cny = [adCNY getCny];
    NSLog(@"cny:%.2f %.2f",cny,[adCNY getUSD]);
    
    
    ZHObjectAdapter *obj = [[ZHObjectAdapter alloc] initWithAdaptee:[ZHAdapteeUSD new]];
    float cny2 = [obj getCny];
    NSLog(@"cny:%.2f",cny2);
    
    [self viewviewview];
}

- (void)viewviewview
{
    ZHLeftRightModel *model = [ZHLeftRightModel new];
    model.viewL = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    model.viewR = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 50, 50)];
    
    ZHColorView *color = [[ZHColorView alloc] initWithModel:model];
    color.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:color];
}


@end
