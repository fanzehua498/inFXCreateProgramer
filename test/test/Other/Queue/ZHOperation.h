//
//  ZHOperation.h
//  test
//
//  Created by rrjj on 2019/6/4.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZHOperation : NSOperation

+ (instancetype)currentThdWithBlock:(void(^)(void))block;

@end

