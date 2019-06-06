//
//  ZHColorModel.h
//  test
//
//  Created by rrjj on 2019/6/5.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHViewProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHColorModel : NSObject<ZHViewProtocol>

@property (nonatomic,strong) id model;

- (instancetype)initWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
