//
//  ReadOnlyModel.h
//  test
//
//  Created by rrjj on 2019/5/10.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ReadOnlyModel : NSObject

-(instancetype)initWithStr:(NSString *)str;

@property (copy, nonatomic,readonly) NSString *readOnlyStr;
@end

