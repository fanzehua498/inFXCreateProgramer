//
//  UIView+ZHCategory.h
//  test
//
//  Created by rrjj on 2019/5/24.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZHCategory)

-(UIViewController *)getViewController;

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CGPoint origin;

@end

