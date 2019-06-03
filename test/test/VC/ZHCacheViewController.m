//
//  ZHCacheViewController.m
//  test
//
//  Created by rrjj on 2019/6/3.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHCacheViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ZHCacheViewController ()<NSCacheDelegate>
@property (nonatomic,strong) NSCache *cache;

@end

@implementation ZHCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.cache = [[NSCache alloc] init];
    self.cache.countLimit = 10;
    self.cache.delegate = self;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (NSInteger i = 0; i < 20; i ++) {
        NSString *str = [NSString stringWithFormat:@"cache - %ld",i];
        NSLog(@"增加cache %@",str);
        [self.cache setObject:str forKey:[NSString stringWithFormat:@"%ld",i]];
    }
    
    for (NSInteger j = 0; j < 20; j ++) {
        NSLog(@"查看cache %@",[self.cache objectForKey:[NSString stringWithFormat:@"%ld",j]]);
    }
    [self callJS];
}


- (void)callJS{
    JSContext *context = [[JSContext alloc] init];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"my" ofType:@"js"];
    NSData *data=[NSData dataWithContentsOfFile:file];
    NSString *responData =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [context evaluateScript:responData];
    JSValue *addjs = context[@"reduce"];
    
    JSValue *sum = [addjs callWithArguments:@[@(17),@(10)]];
    NSInteger intsum = [sum toInt32];
    NSLog(@"%zi",intsum);
    
}

#pragma mark - NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    NSLog(@"清除了：%@",obj);
}

@end
