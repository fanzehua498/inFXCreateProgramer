//
//  UIApplication+Memory.h
//  test
//
//  Created by rrjj on 2019/5/16.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Memory)

/** 使用的内存 */
@property (nonatomic,assign,readonly) double memoryUsed;
/** 可用内存 */
@property (nonatomic,assign,readonly) double availableMemory;

@end


