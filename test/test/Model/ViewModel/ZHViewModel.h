//
//  ZHViewModel.h
//  test
//
//  Created by rrjj on 2019/5/22.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>


NS_ASSUME_NONNULL_BEGIN

@interface ZHViewModel : NSObject

@property (nonatomic,strong,readonly) RACCommand *command;

- (void)viewModelTestFunc;

@end

NS_ASSUME_NONNULL_END
