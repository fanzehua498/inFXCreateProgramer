//
//  AreaModel.h
//  test
//
//  Created by rrjj on 2019/4/15.
//  Copyright © 2019 rrjj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import <UIKit/UIKit.h>
@class areaCityModel;

@interface AreaModel : NSObject

@property (nonatomic,strong) areaCityModel *city;

@property (nonatomic,strong) NSArray *area;

@end


@interface areaCityModel : NSObject

@property (copy, nonatomic) NSString *Id;
@property (copy, nonatomic) NSString *name;

@property (nonatomic,assign,readonly) CGFloat readOnlyHeight;

@property (copy, nonatomic) NSString *readOnlyStr;
- (void)readWithHeight;
@end



