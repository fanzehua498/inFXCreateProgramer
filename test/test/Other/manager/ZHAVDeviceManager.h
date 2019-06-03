//
//  ZHAVDeviceManager.h
//  test
//
//  Created by rrjj on 2019/5/30.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol ZHScanOutPutMetaDelegate <NSObject>

- (void)ZHScanDataWithArray:(NSArray<__kindof AVMetadataObject *> * __nullable)array;

@end

typedef void(^CanUseBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ZHAVDeviceManager : NSObject

@property (copy, nonatomic) CanUseBlock block;
@property (nonatomic,weak) id<ZHScanOutPutMetaDelegate> delegate;

+ (instancetype)shareManager;

- (void)initWithFrame:(CGRect)frame view:(UIView *)view;

- (void)registerAvDevice;
/** 调整焦距 */
- (void)focalLength;

- (void)startRunning;
- (void)stopRunning;


@end

NS_ASSUME_NONNULL_END
