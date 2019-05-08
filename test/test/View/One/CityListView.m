//
//  CityListView.m
//  test
//
//  Created by rrjj on 2018/10/12.
//  Copyright © 2018 rrjj. All rights reserved.
//

#import "CityListView.h"

@interface CityListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;


@end

@implementation CityListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.table.delegate = self;
        self.table.dataSource = self;
        [self addSubview:self.table];
    }
    return self;
}



#pragma mark - UITableViewDelegate UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 27;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return nil;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
