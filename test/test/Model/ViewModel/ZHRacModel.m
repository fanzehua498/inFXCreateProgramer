//
//  ZHRacModel.m
//  test
//
//  Created by rrjj on 2019/5/22.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHRacModel.h"

@implementation ZHRacModel

- (void)arrayRac
{
    NSArray *array = @[@"123",@"456",@1];
    RACSequence *seqce = array.rac_sequence;
    
    RACSignal *signal = seqce.signal;
    [signal subscribeNext:^(id x) {
        NSLog(@"遍历:%@",x);
    }];
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"遍历2:%@",x);
    }];
    
    
    NSDictionary *dict = @{@"sex":@"哈",@"name":@"你爸爸",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"字典遍历:%@",x);
    }];
    
    [array.rac_sequence map:^id(NSDictionary *value) {
        
        return nil;
    }];
}


@end
