//
//  PageController.m
//  CHDSeatModule
//
//  Created by Weelh on 16/8/2.
//  Copyright © 2016年 Weelh. All rights reserved.
//

/*+++++++++++++++++关于一些源码的解析和说明+++++++++++++++++++++++
 
 内联函数(NS_INLINE 修饰)
 传统的宏定义函数可能会引起一些麻烦。
 ex：
 #define F(x) x+x
 void main(){int i=1;F(i++);}
 这里x将被加两次。而内联函数被编译器自动的用函数的形势添加进代码，而不会出现这种情况。而且内敛函数会检查参数类型,宏定义中不会检查参数类型而导致一些不必要的麻烦.
 
 delegate结构体应该是用来判断代理方法是否响应了相应方法.
 
 ++++++++++++++++++++++++++++++++++++++++*/



#import "PageController.h"

//滚动方向
typedef NS_ENUM(NSUInteger, PageControllerDirection) {
    PageControllerDirectionLeft,
    PageControllerDirectionRight,
};

NS_INLINE CGRect frameForControllerAtIndex(NSInteger index, CGRect frame) {
    return CGRectMake(index * CGRectGetWidth(frame), 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
}

NS_INLINE NSRange visibleRangWithOffset(CGFloat offset,CGFloat width, NSInteger maxIndex) {
    NSInteger startIndex = offset/width;
    NSInteger endIndex = ceil((offset + width)/width);\
    
    if (startIndex < 0) {
        startIndex = 0;
    }
    
    if (endIndex > maxIndex) {
        endIndex = maxIndex;
    }
    return NSMakeRange(startIndex, endIndex - startIndex);
}

@interface PageController ()<UIScrollViewDelegate>
{
    struct {
        unsigned int transitionFromIndexToIndex :1;
        unsigned int transitionFromIndexToIndexProgress :1;
    }_delegateFlags;
    
    struct {
        unsigned int transitionFromIndexToIndex :1;
        unsigned int transitionFromIndexToIndexProgress :1;
    }_methodFlags;
}

@property (nonatomic, assign) BOOL      avoidCycleInvoke; //避免循环调用

@property (nonatomic, assign) BOOL      needLayoutContentView;
@property (nonatomic, assign) BOOL      scrollAnimated;
@property (nonatomic, assign) BOOL      isTapScrollMoved;
@property (nonatomic, assign) BOOL      adjustStatusBarHeight;
@property (nonatomic, assign) CGFloat   preOffsetX;
@property (nonatomic, weak) UIScrollView *contentView;

@property (nonatomic, strong) NSMutableDictionary *registerClasses;
@property (nonatomic, strong) NSMutableDictionary *visibleControllers;
@property (nonatomic, strong) NSCache *memoryCache;
@property (nonatomic, assign) NSInteger countOfControllers;
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, assign) NSInteger curProgressIndex;
@property (nonatomic, assign) NSRange visibleRange;

@end

@implementation PageController

#pragma mark - Life Cycle
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureInitPropertys];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configureInitPropertys];
    }
    return self;
}

- (void)configureInitPropertys {
    _memoryCache = [[NSCache alloc]init];
    _changeIndexWhenScrollProgress = 0.5;
    _contentTopEdging = 0;
    self.registerClasses = [NSMutableDictionary dictionary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addContentView];
    [self configurePropertys];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutContentViewIfNeed];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self layoutContentViewIfNeed];
}

#pragma mark - init view && propety
- (void)addContentView
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    [self.view addSubview:contentView];
    _contentView = contentView;
}

- (void)configurePropertys
{
    _visibleControllers = [NSMutableDictionary dictionary];
    _curIndex = 0;
    _curProgressIndex = 0;
    _preOffsetX = 0;
    _scrollAnimated = YES;
//    [self configureMethods];
}

- (void)resetPropertys
{
    [_memoryCache removeAllObjects];
    [_visibleControllers removeAllObjects];
    for (UIViewController *viewController in self.childViewControllers) {
        [self removeViewController:viewController];
    }
    
    _curIndex = 0;
    _curProgressIndex = 0;
    _preOffsetX = 0;
}

- (void)setDelegate:(id<PageControllerDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateFlags.transitionFromIndexToIndex = [_delegate respondsToSelector:@selector(pagerController:transitionFromIndex:toIndex:animated:)];
    _delegateFlags.transitionFromIndexToIndexProgress = [_delegate respondsToSelector:@selector(pagerController:transitionFromIndex:toIndex:progress:)];
}
#pragma mark --注册复用类
- (void)registerClass:(Class)clss forViewContorllerIdentify:(NSString *)identify {
    _registerClasses[identify] = clss;
}

#pragma mark - Public Method
- (void)reloadData
{
    [self resetPropertys];
    
    [self updateContentView];
}

- (void)moveToControllerAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index < 0 || index >= _countOfControllers) {
        return;
    }
    _avoidCycleInvoke = YES;
    _isTapScrollMoved = YES;
    _scrollAnimated = animated;
    [_contentView setContentOffset:CGPointMake(index * CGRectGetWidth(_contentView.frame),0) animated:animated];
    
}

- (NSArray *)visibleViewControllers
{
    return [_visibleControllers allValues];
}

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    NSAssert(NO, @"you must impletement method in subclass");
}

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    NSAssert(NO, @"you must impletement method in subclass");
}

#pragma mark - layout content
- (void)layoutContentViewIfNeed
{
    if (!CGSizeEqualToSize(_contentView.frame.size, CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - _contentTopEdging - [self statusBarHeight]))) {
        // size changed
        [self updateContentView];
    }
}

- (NSInteger)statusBarHeight
{
    return (_adjustStatusBarHeight && (!self.navigationController || self.navigationController.isNavigationBarHidden) && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ? 20:0;
}

- (void)updateContentView
{
    _needLayoutContentView = YES;
    _countOfControllers = [_dataSource numberOfControllersInPagerController];
    [self reSizeContentView];
    [self layoutContentView];
}

- (void)reSizeContentView
{
    CGFloat contentTopEdging = _contentTopEdging + [self statusBarHeight];
    _contentView.frame = CGRectMake(0, contentTopEdging, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - contentTopEdging);
    _contentView.contentSize = CGSizeMake(_countOfControllers * CGRectGetWidth(_contentView.frame), 0);
    _contentView.contentOffset = CGPointMake(_curIndex*CGRectGetWidth(_contentView.frame), 0);
}

// layout content subViews
- (void)layoutContentView
{
    CGFloat offsetX = _contentView.contentOffset.x;
    // 获取可见range
    NSRange visibleRange = visibleRangWithOffset(offsetX, CGRectGetWidth(_contentView.frame), _countOfControllers);
    if (NSEqualRanges(_visibleRange, visibleRange) && !_needLayoutContentView) {
        return;
    }
    _needLayoutContentView = NO;
    _visibleRange = visibleRange;
    
    [self removeControllersOutOfVisibleRange:_visibleRange];
    [self addControllersInVisibleRange:_visibleRange];
}

//计算要滚动到的目标页码(触发时机是停止滚动之后)
- (void)configurePagerIndex
{
    CGFloat offsetX = _contentView.contentOffset.x;
    CGFloat width = CGRectGetWidth(_contentView.frame);
    
    //滚动方向
    PageControllerDirection direction = offsetX >= _preOffsetX ? PageControllerDirectionLeft : PageControllerDirectionRight;
    
    NSInteger index = 0;
    //当滚动的时候随着滚动进度,会改变当前的index
    CGFloat percentChangeIndex = 1.0-_changeIndexWhenScrollProgress;
    //计算要滚动到的index
    if (direction == PageControllerDirectionLeft) {
        index = offsetX / width + percentChangeIndex;
    }else {
        index = ceil(offsetX / width - percentChangeIndex);
    }
    if (index < 0) {
        index = 0;
    }else if (index >= _countOfControllers) {
        index = _countOfControllers - 1;
    }
    
    // if index not same,change index
    //如果滚动到了另一个index(页面),这时候让代理执行相应方法
    if (index != _curIndex) {
        NSInteger fromIndex = _curIndex;
        _curIndex = index;
        
        if (_delegateFlags.transitionFromIndexToIndex) {
            if (_avoidCycleInvoke) {
                return;
            }
            [_delegate pagerController:self transitionFromIndex:fromIndex toIndex:_curIndex animated:_scrollAnimated];
        } else {
//            if (_methodFlags.transitionFromIndexToIndex) {
                [self transitionFromIndex:fromIndex toIndex:_curIndex animated:_scrollAnimated];
//            }
        }
    }
    _scrollAnimated = YES;
}

//滚动过程中计算滚动进度(在滚动过程中一直触发)
- (void)configurePagerIndexByProgress
{
    CGFloat offsetX = _contentView.contentOffset.x;
    CGFloat width = CGRectGetWidth(_contentView.frame);
    CGFloat floorIndex = floor(offsetX/width);
    CGFloat progress = offsetX/width-floorIndex;
    
    if (floorIndex < 0 || floorIndex >= _countOfControllers || progress == 0) {
        return;
    }
    
    PageControllerDirection direction = offsetX >= _preOffsetX ? PageControllerDirectionLeft : PageControllerDirectionRight;
    
    NSInteger fromIndex = 0, toIndex = 0;
    
    if (direction == PageControllerDirectionLeft) {
        if (floorIndex >= _countOfControllers -1) {
            return;
        }
        fromIndex = floorIndex;
        toIndex = MIN(_countOfControllers-1, fromIndex + 1);
    }else {
        if (floorIndex < 0 ) {
            return;
        }
        toIndex = floorIndex;
        fromIndex = MIN(_countOfControllers-1, toIndex +1);
        progress = 1.0 - progress;
    }
    
    if (_delegateFlags.transitionFromIndexToIndexProgress) {
        [_delegate pagerController:self transitionFromIndex:fromIndex toIndex:toIndex progress:progress];
    } else {
//        if (_methodFlags.transitionFromIndexToIndexProgress) {
            [self transitionFromIndex:fromIndex toIndex:toIndex progress:progress];
//        }
    }
}

//这个方法和这个什么scrollEnable是TM什么意思
// is scrolling and caculate progess ?
- (BOOL)isProgressScrollEnabel
{
    return (_delegateFlags.transitionFromIndexToIndexProgress || _methodFlags.transitionFromIndexToIndexProgress) && !_isTapScrollMoved ;
}

#pragma mark - remove controller
- (void)removeControllersOutOfVisibleRange:(NSRange)range
{
    NSMutableArray *deleteArray = [NSMutableArray array];
    [_visibleControllers enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, UIViewController *viewController, BOOL * stop) {
        NSInteger indexOfController = [key integerValue];
        
        if (!NSLocationInRange(indexOfController, range)) {
            // unvisible
            [self removeViewController:viewController atIndex:indexOfController];
            [deleteArray addObject:key];
        }else {
            [self addViewController:viewController atIndex:indexOfController];
        }
    }];
    
    [_visibleControllers removeObjectsForKeys:deleteArray];
}

- (UIViewController *)dequeueReusableViewControllerWithID:(NSString *)identify index:(NSInteger)index {
    
    UIViewController *vc = [_memoryCache objectForKey:_registerClasses[identify]];
    if (vc) {
        [_memoryCache removeObjectForKey:_registerClasses[identify]];
        return vc;
    }else {
        return nil;
    }
}

- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index
{
    if (viewController.parentViewController) {
        [self removeViewController:viewController];
        // remove and cache
        NSArray *keys = _registerClasses.allKeys;
        for (NSString *key in keys) {
            if (_registerClasses[key] == viewController.class) {
                [_memoryCache setObject:viewController forKey:_registerClasses[key]];
            }
        }
    }
}

- (void)removeViewController:(UIViewController *)viewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

#pragma mark - add controller
// add pager controller if it in visible range
- (void)addControllersInVisibleRange:(NSRange)range
{
    NSInteger endIndex = range.location + range.length;
    for (NSInteger idx = range.location ; idx < endIndex; ++idx) {
        
        UIViewController *viewController = [_visibleControllers objectForKey:@(idx)];
        
//        if (!viewController) {
//            // if cache have VC
//            viewController = [_memoryCache objectForKey:@(idx)];
//        }
        if (!viewController) {
            // from datasource get VC
            viewController = [_dataSource pagerController:self controllerForIndex:idx];
        }
        [self addViewController:viewController atIndex:idx];
    }
}

// add pager controller at index
- (void)addViewController:(UIViewController *)viewController atIndex:(NSInteger)index
{
    if (!viewController.parentViewController) {
        // addChildViewController
        [self addChildViewController:viewController];
        viewController.view.frame = frameForControllerAtIndex(index, _contentView.frame);
        [_contentView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        if (![_visibleControllers objectForKey:@(index)]) {
            [_visibleControllers setObject:viewController forKey:@(index)];
        }
    }else {
        // if VC have parentViewController，change the frame
        viewController.view.frame = frameForControllerAtIndex(index, _contentView.frame);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _contentView && _countOfControllers > 0) {
        if ([self isProgressScrollEnabel] && !_needLayoutContentView) {
            //  caculate scroll progress
            [self configurePagerIndexByProgress];
        }
        if (!_needLayoutContentView) {
            // caculate scroll index
            [self configurePagerIndex];
        }
        // layout
        [self layoutContentView];
        _isTapScrollMoved = NO;
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView == _contentView && _countOfControllers > 0) {
//        if (!_needLayoutContentView) {
//            // caculate scroll index
//            [self configurePagerIndex];
//        }
//    }
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    
//    if (scrollView == _contentView && _countOfControllers > 0) {
//        if (!_needLayoutContentView) {
//            // caculate scroll index
//            [self configurePagerIndex];
//        }
//    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _contentView) {
        _avoidCycleInvoke = NO;
        // save offsetX ,judge scroll direction
        _preOffsetX = scrollView.contentOffset.x;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_memoryCache removeAllObjects];
}

- (void)dealloc
{
    [_memoryCache removeAllObjects];
    [_visibleControllers removeAllObjects];
}

@end
