//
//  ZHQueueViewController.m
//  test
//
//  Created by rrjj on 2019/6/4.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//
/**
 NSOperation  GCD
 
 NSOperation 是个抽象类不能用来封装操作。只能使用它的子类来封装操作。1.NSInvocationOperation 2.NSBlockOperation 3.自定义继承自NSOperation的子类，通过实现内部的方法来封装
一、关系
1.NSOperationQueue用GCDf构建封装，是GCD的高级抽象
2.GCD仅支持先进先出队列，NSOperationQueue中的队列可被重新设置优先级,调整执行顺序调整。GCD不支持异步操作之间的依赖关系设置。某个操作依赖另一个操作的数据（生产者-消费者模型）,使用NSOperationQueue可正确的顺序执行操作。GCD则不没有内建的依赖关系支持。
3.NSOperationQueue支持KVO，可以观察任务的执行状态
二、性能
 1.GCD更接近底层，NSOperationQueue更高级抽象。GCD在追求性能的底层操作是速度更快的。
 2.从异步操作之间的事务性，顺序行，依赖关系。GCD需要自己实现更多的代码，NSOperationQueue已经内建了这些支持
 3.如果异步操作的过程需要更多的被交互和UI呈现出来，NSOperationQueue会是更好的选择。底层代码中任务之间不太相互依赖，而需要更高的并发能力，GCD则更有优势。

 */
#import "ZHQueueViewController.h"
#import "ZHOperation.h"
@interface ZHQueueViewController ()

@end

@implementation ZHQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    dispatch_queue_t queue = dispatch_queue_create("lalaal", DISPATCH_QUEUE_SERIAL);
//    NSLog(@"之前线程 － %@", [NSThread currentThread]);
//    dispatch_sync(queue, ^{
//        NSLog(@"同步操作的线程 - %@", [NSThread currentThread]);
//    });
//    NSLog(@"之后线程 - %@", [NSThread currentThread]);

    [self customOperation];
}

/** 在没有使用 NSOperationQueue、NSBlockOperation 在主线程中单独使用使用子类 NSInvocationOperation 执行一个操作的情况下，操作是在当前线程执行的，并没有开启新线程。 */
#pragma mark - NSInvocationOperation
- (void)InvocationoperationNOqueue{
    //创建
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationAction) object:nil];
    //执行
    [op start];
}
- (void)invocationOperationAction
{
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    }
}

#pragma mark - NSBlockOperation
/** NSBlockOperation 还提供了一个方法 addExecutionBlock:，通过 addExecutionBlock: 就可以为 NSBlockOperation 添加额外的操作。这些操作（包括 blockOperationWithBlock 中的操作）可以在不同的线程中同时（并发）执行。只有当所有相关的操作已经完成执行时，才视为完成。
 
 blockOperationWithBlock:方法中的操作 和 addExecutionBlock: 中的操作是在不同的线程中异步执行的。而且，这次执行结果中 blockOperationWithBlock:方法中的操作也不是在当前线程（主线程）中执行的。从而印证了blockOperationWithBlock: 中的操作也可能会在其他线程（非当前线程）中执行。
  */
- (void)BlockOperationNOqueue
{
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        
        [self invocationOperationAction];
    }];
    
    // 2.添加额外的操作
    [blockOp addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [blockOp addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [blockOp addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [blockOp addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [blockOp start];
    
}

#pragma mark - 自定义Operation
- (void)customOperation
{
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    ZHOperation *op1 = [ZHOperation currentThdWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    ZHOperation *op2 = [ZHOperation currentThdWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    ZHOperation *op3 = [ZHOperation currentThdWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op1 addDependency:op2];
    [op1 addDependency:op3];
    
    [queue addOperations:@[op1,op2,op3] waitUntilFinished:NO];
}



#pragma mark - OPeration
/** 任务依赖 */
- (void)orderOperation
{
    NSOperationQueue *opQ = [[NSOperationQueue alloc] init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务1开始");
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务1完成");
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务2开始");
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务2完成");
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务3开始");
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务3完成");
    }];
    
    //设置依赖 1、3完成后 调用2
    [op2 addDependency:op3];
    [op2 addDependency:op1];
    
    [opQ addOperations:@[op1,op2,op3] waitUntilFinished:NO];
    
    //相关方法
    [opQ setSuspended:YES];//YES暂停queue NO继续queue
   
    [op1 waitUntilFinished];//等到某个operation执行完毕 会阻塞当前线程
    
    [opQ waitUntilAllOperationsAreFinished];//阻塞当前线程，等待QUEUE所有操作执行完毕
    
    [op1 cancel];//取消某个操作
    
    [opQ cancelAllOperations];//取消所有操作
}

#pragma mark - perform
- (void)Queueperform
{
    [self performSelector:@selector(mainperAction1) withObject:nil];
    [self performSelectorOnMainThread:@selector(mainperAction2) withObject:nil waitUntilDone:NO];
    [self performSelector:@selector(mainperAction3) withObject:nil afterDelay:0];//只可在主线程调用
    
    dispatch_queue_t queue = dispatch_queue_create("la", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        
        [self performSelector:@selector(queueperAction1) withObject:nil];
        [self performSelectorOnMainThread:@selector(queueperAction2) withObject:nil waitUntilDone:NO];
        [self performSelector:@selector(queueperAction3) withObject:nil afterDelay:0];
    });
    
}
- (void)mainperAction1
{NSLog(@"%s",__func__);}
- (void)mainperAction2
{NSLog(@"%s",__func__);}
- (void)mainperAction3
{NSLog(@"%s",__func__);}

- (void)queueperAction1
{NSLog(@"%s",__func__);}
-(void)queueperAction2
{NSLog(@"%s",__func__);}
-(void)queueperAction3
{NSLog(@"%s",__func__);}


#pragma mark - 死锁  在 某线程中 同步这个线程 就会死锁
- (void)lock
{
    NSLog(@"之前线程 － %@", [NSThread currentThread]);
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"同步操作的线程 - %@", [NSThread currentThread]);
    });
    NSLog(@"之后线程 - %@", [NSThread currentThread]);
    
    
    
    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", NULL);
    NSLog(@"之前线程 - %@", [NSThread currentThread]);
    dispatch_async(myQueue, ^{
        NSLog(@"同步操作之前线程 - %@", [NSThread currentThread]);
        dispatch_sync(myQueue, ^{
            NSLog(@"同步操作时线程 - %@", [NSThread currentThread]);
        });
        NSLog(@"同步操作之后线程 - %@", [NSThread currentThread]);
    });
    NSLog(@"之后线程 - %@", [NSThread currentThread]);
}

@end
