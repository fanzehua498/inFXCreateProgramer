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
@property (nonatomic,strong) NSArray *Array;
@property (nonatomic,strong) UILabel *inLabel;

@end

@implementation ZHCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.cache = [[NSCache alloc] init];
    self.cache.countLimit = 10;
    self.cache.delegate = self;
    
    self.Array = [NSArray arrayWithObjects:@"aaa", nil];
    
    self.inLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:self.inLabel];
    self.inLabel.text = @"inlabel";
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
    
    self.Array = nil;
    [self callJS];
}
- (void)injected{
    
    NSLog(@"I've been injected: %@", self);
    self.view.backgroundColor = [UIColor blueColor];
    self.inLabel.text = @"cccc";
}

- (void)callJS{
    JSContext *context = [[JSContext alloc] init];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"controllers" ofType:@"js"];
    NSData *data=[NSData dataWithContentsOfFile:file];
    NSString *responData =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [context evaluateScript:responData];
    JSValue *addjs = context[@"showTimeBox"];
    
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
