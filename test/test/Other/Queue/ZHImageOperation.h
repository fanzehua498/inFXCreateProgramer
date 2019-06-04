//
//  ZHImageOperation.h
//  test
//
//  Created by rrjj on 2019/6/4.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHImageOperation : NSOperation
+ (instancetype)currentIndexPath:(NSIndexPath *)indexPath imageUrl:(NSString *)url WithBlock:(void(^)(UIImage *image,NSIndexPath *indexPath))block;

@end

NS_ASSUME_NONNULL_END
