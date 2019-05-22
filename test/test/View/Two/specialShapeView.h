//
//  specialShapeView.h
//  test
//
//  Created by rrjj on 2019/5/20.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface specialShapeView : UIButton
+ (CGPoint)absolute_to_relative:(CGPoint)origin point:(CGPoint)point;

+ (BOOL)in_circular_sector:(CGPoint)center direction:(CGPoint)direction r:(double)r angle:(float)angle point:(CGPoint)point;
@end

NS_ASSUME_NONNULL_END
