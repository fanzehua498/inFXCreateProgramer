//
//  SiftView.h
//  test
//
//  Created by rrjj on 2018/10/11.
//  Copyright © 2018 rrjj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseBlock)(NSString *chooseArea);
@interface SiftView : UIView

-(instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title singleBack:(BOOL)back;

/** 选项个数 */
@property (nonatomic,strong) NSArray *level;
/** 是否可多选 */
@property (nonatomic,assign) BOOL isSingle;
/** 主标题 */
@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) ChooseBlock block;

- (NSMutableArray *)getSelectData;

@end

NS_ASSUME_NONNULL_END
