//
//  ZHVerifyView.h
//  test
//
//  Created by rrjj on 2019/5/21.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHVerifyView : UIView

+ (instancetype)shareWithImage:(NSString *)image ;
- (instancetype)initWithFrame:(CGRect)frame bgImage:(NSString *)image;

- (void)show;

@end

NS_ASSUME_NONNULL_END
