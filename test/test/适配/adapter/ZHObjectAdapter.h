//
//  ZHObjectAdapter.h
//  test
//
//  Created by rrjj on 2019/6/5.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHTargetProtocol.h"
#import "ZHAdapteeUSD.h"


@interface ZHObjectAdapter : NSObject<ZHTargetProtocol>

- (instancetype)initWithAdaptee:(ZHAdapteeUSD *)adaptee;

@end


