//
//  ZHImageOperationManager.m
//  test
//
//  Created by rrjj on 2019/6/4.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import "ZHImageOperationManager.h"
#import "ZHImageOperation.h"

@interface ZHImageOperationManager ()
@property (nonatomic,strong) NSOperationQueue *operationQueue;
//正在操作的imageOperation
@property (nonatomic,strong) NSMutableDictionary *operations;
//已下载的图片
@property (nonatomic,strong) NSMutableDictionary *images;

@property (nonatomic,strong) NSCache *cache;

@end

@implementation ZHImageOperationManager

+(instancetype)shareManager
{
    static  ZHImageOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZHImageOperationManager alloc] init];
    });
    return manager;
}

- (void)downLoadImageWithIndexPath:(NSIndexPath *)indexPath imageUrl:(NSString *)url placeholder:(NSString *)placeholderImage WithBlock:(void(^)(UIImage *image,NSIndexPath *indexPath))block
{
    __weak typeof(self) weakSelf = self;
    if (url.length <= 0) {
        //图片链接有问题
//        将默认图片传出去
        if (block) {
            block([UIImage imageNamed:placeholderImage],indexPath);
        }
        return;
    }
    UIImage *image = self.images[url];
    
    if (image) {
        // 已下载过 将数据传出去
        if (block) {
            block(image,indexPath);
        }
    }else{
        ZHImageOperation *op = self.operations[url];
        if (op) {
        }else{
            op = [ZHImageOperation currentIndexPath:indexPath imageUrl:url WithBlock:^(UIImage * _Nonnull image, NSIndexPath * _Nonnull indexPath) {
                NSURL *urlstr=[NSURL URLWithString:url];
                NSData *data=[NSData dataWithContentsOfURL:urlstr];
                UIImage *imgae1=[UIImage imageWithData:data];
                weakSelf.images[url] = imgae1;
                if ([weakSelf.operations objectForKey:url]) {
                    [weakSelf.operations removeObjectForKey:url];
                }
                //下载完成 将数据传出去
                if (block) {
                    block(imgae1,indexPath);
                }
            }];
            [self.operationQueue addOperation:op];
            self.operations[url] = op;
        }
    }
}


#pragma mark - lazy
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
