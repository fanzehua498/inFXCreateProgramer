//
//  ZHExtentionViewController.m
//  test
//
//  Created by rrjj on 2019/5/24.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHExtentionViewController.h"
#import "ZHArchiveModel.h"
#import "ZHSubArcModel.h"
@interface ZHExtentionViewController ()

@end

@implementation ZHExtentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"oh hoo";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    ZHArchiveModel *model = [ZHArchiveModel new];
//    model.name = @"nnnnn";
    ZHSubArcModel *model = [ZHSubArcModel new];
    model.name = @"sub";
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
 
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"ios.archiver1"];
    NSLog(@"%@",path);
    //创建文件
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    [data writeToFile:path atomically:YES];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"ios.archiver1"];
    //读取文件的内容
    NSData *data = [NSData dataWithContentsOfFile:path];
    //将二进制数据转化为对应的对象类型
    NSError *error;
    ZHSubArcModel *model = [NSKeyedUnarchiver unarchivedObjectOfClass:[ZHSubArcModel class] fromData:data error:&error];
    NSLog(@"%@",model.name);
    if (error) {
        NSLog(@"%@",error);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
