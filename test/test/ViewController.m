//
//  ViewController.m
//  test
//
//  Created by rrjj on 2018/10/10.
//  Copyright © 2018 rrjj. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>
#import <ShellSDK/CustomObj.h>
#import <AppTestFrameWorkSDK/AppTestFrameWorkSDK.h>
#import <UserNotifications/UserNotifications.h>
#import "ZHAnimationCell.h"
#import "FFUIPageControlView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *table;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,assign,getter=isTableViewLoadData)BOOL tableViewLoadData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"MAIN";
    [self.view addSubview:self.table];
 
    [self dataAdd];
    
}


- (void)dataAdd{
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DCURLRouter" ofType:@"plist"]];
    NSDictionary *zhtest = dict[@"ZHTest"];
    for (NSInteger i = 0; i < zhtest.allKeys.count; i ++) {
        [self.dataSource addObject:zhtest.allValues[i]];
    }
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableArray *indexPathArr = [NSMutableArray array];
        for (NSInteger i = 0; i < self.dataSource.count; i ++) {
            NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
            [indexPathArr addObject:index];
        }
        self.tableViewLoadData = YES;
        [self.table insertRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
        
    });
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isTableViewLoadData ? self.dataSource.count:0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 44;
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHAnimationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[ZHAnimationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]];
    if (indexPath.row%2==0) {
        cell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DCURLRouter" ofType:@"plist"]];
    NSDictionary *zhtest = dict[@"ZHTest"];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [DCURLRouter pushURLString:zhtest.allKeys[indexPath.row] query:@{} animated:YES];
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

@end
