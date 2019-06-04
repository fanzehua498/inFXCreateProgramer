//
//  ZHAllnumDataModel.h
//  test
//
//  Created by rrjj on 2019/6/4.
//  Copyright © 2019 真羡慕你们这些长的好看的. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@class ZHAllnumDataModelData;
NS_ASSUME_NONNULL_BEGIN

@interface ZHAllnumDataModel : NSObject
@property (copy, nonatomic) NSString *code;
@property (nonatomic,strong) ZHAllnumDataModelData *data;
@property (copy, nonatomic) NSString *msg;
@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN
@interface ZHAllnumDataModelData : NSObject
@property (nonatomic,strong) NSArray *list;
@property (nonatomic,assign) NSInteger totalPage;

@end
NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface ZHAllnumDataModelDataList : NSObject
@property (copy, nonatomic) NSString *allnum;
@property (nonatomic,assign) NSInteger anchorLevel;
@property (copy, nonatomic) NSString *familyName;
@property (copy, nonatomic) NSString *flv;
@property (nonatomic,assign) NSInteger isOnline;

@property (nonatomic,assign) NSInteger lianMaiStatus;
@property (nonatomic,assign) NSInteger newL;
@property (copy, nonatomic) NSString *nickname;
@property (nonatomic,assign) NSInteger phonetype;
@property (copy, nonatomic) NSString *photo;

@property (copy, nonatomic) NSString *position;
@property (copy, nonatomic) NSString *roomid;
@property (nonatomic,assign) NSInteger serverid;
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,assign) NSInteger starlevel;

@property (copy, nonatomic) NSString *useridx;
@end
NS_ASSUME_NONNULL_END
