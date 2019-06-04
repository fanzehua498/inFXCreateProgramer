//
//  ZHOperation.m
//  test
//
//  Created by rrjj on 2019/6/4.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//
/**
 自定义并发的NSOperation需要以下步骤：
 
1.start方法：该方法必须实现，

2.main:该方法可选，如果你在start方法中定义了你的任务，则这个方法就可以不实现，但通常为了代码逻辑清晰，通常会在该方法中定义自己的任务

3.isExecuting  isFinished 主要作用是在线程状态改变时，产生适当的KVO通知

4.isConcurrent :必须覆盖并返回YES;
 
 */
#import "ZHOperation.h"

@interface ZHOperation ()
{
    /** 主要作用是在线程状态改变时，产生适当的KVO通知 */
    BOOL executing;//执行中
    BOOL finished;//是否执行完成
}
@property (copy, nonatomic) void (^opBlcok)(void) ;

@property (nonatomic,strong) UIImage *image;


@end

@implementation ZHOperation

#pragma mark - 构造
- (instancetype)init
{
    self = [super init];
    if (self) {
       executing = NO;
       finished = NO;
    }
    return self;
}
+ (instancetype)currentThdWithBlock:(void (^)(void))block
{
    ZHOperation *op = [[ZHOperation alloc] init];
    op.opBlcok = block;
    return op;
}

#pragma mark - reload
-(void)start
{
    //是否被取消
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    //开始执行
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

-(void)main
{
    @try {
        @autoreleasepool {
            if (self.opBlcok) {
                self.opBlcok();
            }
            [self willChangeValueForKey:@"isFinished"];
            [self willChangeValueForKey:@"isExecuting"];
            
            executing = NO;
            finished = YES;
            
            [self didChangeValueForKey:@"isFinished"];
            [self didChangeValueForKey:@"isExecuting"];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
}
#pragma mark
-(BOOL)isExecuting
{
    return executing;
}

-(BOOL)isFinished
{
    return finished;
}
//必须覆盖并返回YES;
-(BOOL)isConcurrent
{
    return YES;
}
@end
