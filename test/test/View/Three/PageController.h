//
//  PageController.h
//  CHDSeatModule
//
//  Created by Weelh on 16/8/2.
//  Copyright © 2016年 Weelh. All rights reserved.
//

 /*
  ==============================================================
  高度可复用的pageViewController,相比于使用collectionView,方便很多
  有问题call me - Weelh
  ==============================================================
  */

#import <UIKit/UIKit.h>

@class PageController;
@protocol PageControllerDataSource <NSObject>

@required
- (NSInteger)numberOfControllersInPagerController;
- (UIViewController *)pagerController:(PageController *)pagerController controllerForIndex:(NSInteger)index;

@end

@protocol PageControllerDelegate <NSObject>

@optional
//这两个方法是在滚动页面的时候会一直调用,给等于给外界暴露了一个滚动进度的方法,可以利用此给你添加的menu菜单做一些menu切换动画.
- (void)pagerController:(PageController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated;
- (void)pagerController:(PageController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

@end

@interface PageController : UIViewController

@property (nonatomic, weak) id<PageControllerDataSource> dataSource;
@property (nonatomic, weak) id<PageControllerDelegate> delegate;

@property (nonatomic, weak, readonly) UIScrollView *contentView;
//缓存池,可以设置最多放多少个控制器缓存
@property (nonatomic, strong, readonly) NSCache *memoryCache;
//总共页码(viewDidload之后才有值)
@property (nonatomic, assign, readonly) NSInteger countOfControllers;
//当前页码
@property (nonatomic, assign, readonly) NSInteger curIndex;
//可见页码
@property (nonatomic, assign, readonly) NSRange visibleRange;
//TopEdgInset
@property (nonatomic, assign) CGFloat contentTopEdging;
//当拖拽到多少的时候触发滚动到下一页(默认0.5)
@property (nonatomic, assign) CGFloat changeIndexWhenScrollProgress;

- (void)registerClass:(Class)clss forViewContorllerIdentify:(NSString *)identify;
- (UIViewController *)dequeueReusableViewControllerWithID:(NSString *)identify index:(NSInteger)index;

- (void)reloadData;
- (void)moveToControllerAtIndex:(NSInteger)index animated:(BOOL)animated;
- (NSArray *)visibleViewControllers;
- (BOOL)isProgressScrollEnabel;
//子类调用的时候必须调用super
- (void)updateContentView;

//滚动切换页面时触发(当继承这个控制器的时候,请在子类中实现这个方法)
- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated;
- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

@end
