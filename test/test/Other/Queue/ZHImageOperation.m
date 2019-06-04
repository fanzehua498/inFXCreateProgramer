//
//  ZHImageOperation.m
//  test
//
//  Created by rrjj on 2019/6/4.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHImageOperation.h"

@interface ZHImageOperation ()
{
    /** 主要作用是在线程状态改变时，产生适当的KVO通知 */
    BOOL executing;//执行中
    BOOL finished;//是否执行完成
}
@property (copy, nonatomic) void (^opBlcok)(UIImage *image,NSIndexPath *indexPath) ;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (copy, nonatomic) NSString *imageUrl;

@end

@implementation ZHImageOperation

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
+ (instancetype)currentIndexPath:(NSIndexPath *)indexPath imageUrl:(NSString *)url WithBlock:(void(^)(UIImage *image,NSIndexPath *indexPath))block;
{
    ZHImageOperation *op = [[ZHImageOperation alloc] init];
    op.opBlcok = block;
    op.indexPath = indexPath;
    op.imageUrl = url;
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
                NSURL *url=[NSURL URLWithString:self.imageUrl];
                NSData *data=[NSData dataWithContentsOfURL:url];
                UIImage *imgae=[UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.opBlcok(imgae,self.indexPath);
                });
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
