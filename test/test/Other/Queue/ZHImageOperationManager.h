//
//  ZHImageOperationManager.h
//  test
//
//  Created by rrjj on 2019/6/4.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHImageOperationManager : NSObject

+ (instancetype)shareManager;

- (void)downLoadImageWithIndexPath:(NSIndexPath *)indexPath imageUrl:(NSString *)url placeholder:(NSString *)placeholderImage WithBlock:(void(^)(UIImage *image,NSIndexPath *indexPath))block;

@end

NS_ASSUME_NONNULL_END
