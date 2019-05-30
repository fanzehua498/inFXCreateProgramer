//
//  ZHCamHeadView.h
//  test
//
//  Created by rrjj on 2019/5/30.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^BackBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface ZHCamHeadView : UIView
@property (copy, nonatomic) BackBlock block;


+ (instancetype)shareHeadView;


@end

NS_ASSUME_NONNULL_END
