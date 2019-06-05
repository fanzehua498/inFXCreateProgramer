//
//  ZHCustomOperationVC.m
//  test
//
//  Created by rrjj on 2019/6/4.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//
#define kUrl @"http://live.9158.com/Room/GetNewRoomOnline?page="

#import "ZHCustomOperationVC.h"
#import "ZHOperation.h"
#import <AFNetworking.h>
#import "ZHAllnumDataModel.h"
#import "ZHImageOperationManager.h"
@interface ZHCustomOperationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSMutableDictionary *operations;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableDictionary *images;

@property (nonatomic,strong) NSOperationQueue *operationQueue;

@end

@implementation ZHCustomOperationVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    
    [self.view addSubview:self.tableView];
    [self loadData];
}
#pragma mark - data
- (void)loadData{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *man = [[AFHTTPSessionManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@%ld",kUrl,self.page];
    man.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [man GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZHAllnumDataModel *model = [ZHAllnumDataModel mj_objectWithKeyValues:responseObject];
        if (weakSelf.page==1) {
            [weakSelf.dataSource removeAllObjects];
        }
        [weakSelf.dataSource addObjectsFromArray:model.data.list];
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}



#pragma mark - UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.dataSource.count > 0) {
        ZHAllnumDataModelDataList *model = self.dataSource[indexPath.row];
        [[ZHImageOperationManager shareManager] downLoadImageWithIndexPath:indexPath imageUrl:model.photo placeholder:@"home" WithBlock:^(UIImage * _Nonnull image, NSIndexPath * _Nonnull indexPath) {
           
            cell.imageView.image = image;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        
        
        
        cell.textLabel.text = model.nickname;
//        UIImage *image = self.images[model.photo];
//        if (image) {
//            cell.imageView.image = image;
//        }else{
//            cell.imageView.image = [UIImage imageNamed:@""];
//            ZHOperation *op = self.operations[model.photo];
//            if (op) {
//            }else{
//                op = [ZHOperation currentThdWithBlock:^ {
//                    NSURL *url=[NSURL URLWithString:model.photo];
//                    NSData *data=[NSData dataWithContentsOfURL:url];
//                    UIImage *imgae1=[UIImage imageWithData:data];
//                    weakSelf.images[model.photo] = imgae1;
//                    if ([weakSelf.operations objectForKey:model.photo]) {
//                        [weakSelf.operations removeObjectForKey:model.photo];
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                    });
//                }];
//                [self.operationQueue addOperation:op];
//                self.operations[model.photo] = op;
//            }
//        }
    }
    
    
    return cell;
}


#pragma mark - lazy
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableDictionary *)operations
{
    if (!_operations) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

-(NSMutableDictionary *)images
{
    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

-(NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 6;
    }
    return _operationQueue;
}

@end
