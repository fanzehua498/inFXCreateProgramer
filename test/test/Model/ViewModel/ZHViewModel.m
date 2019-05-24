//
//  ZHViewModel.m
//  test
//
//  Created by rrjj on 2019/5/22.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHViewModel.h"



@implementation ZHViewModel

-(instancetype)init
{
    if (self = [super init]) {
        [self initZHViewModel];
    }
    return self;
}

- (void)initZHViewModel
{
    @weakify(self);
    _command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [self getDataList:^(NSArray *array) {
                [subscriber sendNext:array];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
    
}



- (void)getDataList:(void(^)(NSArray *array))success
{
    NSLog(@"getdata");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"getSuccess");
        if (success) {
            success(@[@"a",@"b",@"c"]);
        }
    });
    
}

@end
