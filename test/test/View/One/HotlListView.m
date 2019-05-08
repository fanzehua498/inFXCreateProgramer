//
//  HotlListView.m
//  test
//
//  Created by rrjj on 2018/10/12.
//  Copyright © 2018 rrjj. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#import "HotlListView.h"

@interface HotlListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *mainTitleView;
@property (nonatomic,strong) UIView *detailTitleView;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSMutableArray *selectLocal;


@end

@implementation HotlListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainTitleView];
        [self addSubview:self.detailTitleView];
        [self.detailTitleView addSubview:self.table];
        
        self.detailTitleView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15].CGColor;//阴影颜色
        self.detailTitleView.layer.shadowOffset = CGSizeMake(0, 5);//偏移距离
        self.detailTitleView.layer.shadowOpacity = 1.0;//不透明度
        self.detailTitleView.layer.shadowRadius = 4.0;//半径
        
        
        
    }
    return self;
}

- (void)changeData:(UIButton *)sender
{
    //移除其他选项卡选择的数据
    [self.selectLocal removeAllObjects];
    //选中第几个
    NSInteger index = sender.tag -  10086;

    for (UIButton *btn in self.mainTitleView.subviews) {
        btn.selected = NO;
    }
    sender.selected = YES;
    
    //改变dataSource中的数据并刷新表格
    NSArray *arr1 = @[@[@"不限",@"滨江地区",@"城北",@"城战",@"不限",@"滨江地区",@"城北",@"城战",@"不限",@"滨江地区",@"城北",@"城战",@"不限",@"滨江地区",@"城北",@"城战",@"不限",@"滨江地区",@"城北",@"城战"],@[@"不限",@"滨江",@"淳安",@"拱墅",@"江干"],@[@"不限",@"1",@"2",@"3",@"4",@"滨江地区",@"城北",@"城战"]];
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:arr1[index]];
//    self.table i
    [self.table reloadData];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *title = self.dataSource[indexPath.row];
    cell.textLabel.text = title;
    if (self.selectLocal.count > 0 && indexPath == self.selectLocal[0][@"index"]) {
        cell.textLabel.textColor = [UIColor greenColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectLocal.count == 0) {
        [self.selectLocal addObject:@{@"index":indexPath,@"data":self.dataSource[indexPath.row]}];
    }
    [self.selectLocal replaceObjectAtIndex:0 withObject:@{@"index":indexPath,@"data":self.dataSource[indexPath.row]}];
    [tableView reloadData];
}

#pragma mark - 懒加载
-(UIView *)mainTitleView
{
    if (!_mainTitleView) {
        _mainTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, self.frame.size.height)];
//        _mainTitleView.backgroundColor = [UIColor grayColor];
    }
    return _mainTitleView;
}

- (UIView *)detailTitleView
{
    if (!_detailTitleView) {
        _detailTitleView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, kScreenWidth - 80, self.frame.size.height)];
    }
    return _detailTitleView;
}

-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:self.detailTitleView.bounds style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)selectLocal
{
    if (!_selectLocal) {
        _selectLocal = [NSMutableArray array];
    }
    return _selectLocal;
}



@end
