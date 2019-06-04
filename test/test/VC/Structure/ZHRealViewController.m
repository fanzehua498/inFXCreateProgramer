//
//  ZHRealViewController.m
//  test
//
//  Created by rrjj on 2019/5/15.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import "ZHRealViewController.h"
#import "Student.h"
#import <Realm.h>
#import "Books.h"
#import "specialShapeView.h"
#import "NSString+Category.h"
@interface ZHRealViewController ()
@property (nonatomic,strong) specialShapeView *specView;

@end

@implementation ZHRealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self readRealmObj];
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    //修改路径（删除后两个路径path）
    NSLog(@"%@",config.fileURL);

}

- (void)readRealmObj
{
    //全部
    RLMResults *allRes = [Student allObjects];
    NSLog(@"%@",allRes);
    
    
    RLMResults *result = [Student objectsWhere:@" num < 4 "];
    Student *stu = result.firstObject;
    
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"num < 4 AND name == 'jack'"];
    RLMResults *prRes = [Student objectsWithPredicate:pre];
    
    NSArray *between = @[@1,@3];
    NSPredicate *pre1 = [NSPredicate predicateWithFormat:@"num BETWEEN %@",between];
    RLMResults *prRes1 = [Student objectsWithPredicate:pre1];
    
    
    NSPredicate *pre2 = [NSPredicate predicateWithFormat:@"name IN {'jack','ma','doudou'}"];
    RLMResults *prRes2 = [Student objectsWithPredicate:pre2];
    
    
    
//    NSArray *names1 = @[@"Herbie",@"Snugs",@"Badger",@"Flag"];
//    NSArray *names2 = @[@"Judge",@"Paper Car" ,@"Badger",@"Phoenix"];
    NSArray *names1 = @[@1,@2,@3,@4];
    NSArray *names2 = @[@3,@4 ,@5,@6];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@",names1];
    NSArray *myFavCars = [names2 filteredArrayUsingPredicate:predicate];
    NSLog(@"%@",myFavCars);
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"name LIKE '*a'"];
    RLMResults *prRes3 = [Student objectsWithPredicate:filterPredicate];
    NSLog(@"%@ %@ %@ %@ %@",stu,prRes.realm,prRes1.realm,prRes2.realm,prRes3.realm);
}

-(void)reChange{
    RLMRealm *realm1 = [RLMRealm defaultRealm];
    RLMResults *result = [Student objectsWhere:@" ID == 0 "];
    Student *stu = result.firstObject;
    
//    [realm1 transactionWithBlock:^{
//        stu.name = @"changeNamezehua";
//    }];
    
    NSError *error;
    BOOL success = [realm1 transactionWithBlock:^{
        stu.name = @"notzehua";
    } error:&error];
    NSLog(@"%d\n%@",success,error);
//    Student createOrUpdateInRealm:realm1 withValue:<#(nonnull id)#>
    
}

//增
- (void)addRealmObj
{
    //写入操作会阻塞线程，放入子线程操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 方式一: 接受一个数组对象
        Student *stu1 = [[Student alloc] initWithValue:@[@10,@(1),@"zehua"]];
        
        // 方式二: 接受一个字典对象
        Student *stu2 = [[Student alloc] initWithValue:@{@"ID":@1,@"num":@2,@"name":@"jacka"}];
        //方式三: 属性赋值
        Student *stu3 = [[Student alloc] init];
        stu3.num = 3;
        stu3.name = @"oho";
        //方式一: 提交事务处理
        RLMRealm *realm1 = [RLMRealm defaultRealm];
        [realm1 beginWriteTransaction];
//        [realm1 addObject:stu1];
        [realm1 addOrUpdateObject:stu1];
        [realm1 commitWriteTransaction];
        
        //方式二：在事务中调用addObject：方法
        RLMRealm *realm2 = [RLMRealm defaultRealm];
        [realm2 transactionWithBlock:^{
            [realm2 addOrUpdateObject:stu2];
        }];
        
        //方式三: 在事务中创建新的对象并添加
        
        RLMRealm *realm3 = [RLMRealm defaultRealm];
        [realm3 transactionWithBlock:^{
            [Student createOrUpdateInRealm:realm3 withValue:@{@"ID":@4,@"num":@5,@"name":@"sos"}];
        }];
    });
}

- (void)sortModel{
    
    RLMResults *res = [Student.allObjects sortedResultsUsingKeyPath:@"num" ascending:YES];
    NSLog(@"%@",res.realm);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self reChange];
//    
//    [self setDefaultRealm:@"zehua"];
    
    NSLog(@"%@",[RLMRealmConfiguration defaultConfiguration].fileURL);
    NSLog(@"%@",[NSString getRandomChinese:4]);
//    RLMRealm
}

- (void)setDefaultRealm:(NSString *)userName
{
//       aaaaaa
}
@end
