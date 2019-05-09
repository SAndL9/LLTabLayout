//
//  LLTabLayoutContainersViewController.h
//  LLTabLayout
//
//  Created by LiLei on 9/5/2019.
//  Copyright © 2019 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UI 字体 大小 颜色(可自定义)

 - LLTabLayoutUIStyleDefault: 默认 选中颜色蓝色 非选中黑色  font 28
 - LLTabLayoutUIStyleSpecific: 特定 选中颜色蓝色 非选中黑色 透明度0.8  font 32 28
 */
typedef NS_ENUM(NSInteger, LLTabLayoutUIStyle) {
    LLTabLayoutUIStyleDefault,
    LLTabLayoutUIStyleSpecific,
};

/**
 布局格式配置
 
 - LLTabLayoutTypeAutomatic: 根据文字自动布局
 - LLTabLayoutTypeFixed: 固定宽度布局
 */

typedef NS_ENUM(NSInteger, LLTabLayoutFormat){
    LLTabLayoutFormatAutomatic,
    LLTabLayoutFormatFixed,
};
@protocol LLTabLayoutContainersViewControllerDataSource;

@interface LLTabLayoutContainersViewController : UIViewController

- (instancetype)initWithTabLayoutItemType:(LLTabLayoutFormat)tabLayoutFormat withUiStyle:(LLTabLayoutUIStyle)tabLayoutUiStyle NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, weak) id<LLTabLayoutContainersViewControllerDataSource> dataSource;

/**
 top展示的可视范围
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

@property (nonatomic, assign , getter = ll_isDefaultIndex) NSInteger ll_defaultIndex;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isHorizontalScrollEnable;
/**
 设置手动滚动
 
 @param index 滚动下标
 
 */
- (void)scrollTabLayoutToIndex:(NSInteger)index animated:(BOOL)animated;
/**
 刷新
 */
- (void)reloadData;

/**
 更新下标对应气泡的值
 
 @param badgeNumber 对应的气泡
 @param index 对应下标
 */
- (void)updateItemBadgeNumber:(NSInteger)badgeNumber atIndex:(NSInteger)index;

@end

@protocol LLTabLayoutContainersViewControllerDataSource <NSObject>

@required

/**
 返回总的个数
 
 @param tabLayoutViewController self
 @return 个数
 */
- (NSInteger)numbersOfPageInTabViewController:(LLTabLayoutContainersViewController *)tabLayoutViewController;

/**
 返回每个item对应的标题
 
 @param tabLayoutViewController self
 @param index 对应的下标
 @return 标题
 */
- (NSString *)tabViewController:(LLTabLayoutContainersViewController *)tabLayoutViewController titleAtIndex:(NSUInteger)index;

/**
 对应的控制器
 
 @param tabLayoutViewController self
 @param index 对应的下标
 @return 返回每个下标对应的viewController
 */
- (UIViewController *)tabViewController:(LLTabLayoutContainersViewController *)tabLayoutViewController childViewControllerAtIndex:(NSUInteger)index;

@optional

/**
 返回气泡
 
 @param tabLayoutViewController self
 @param index 对应的下标
 @return 返回每个对应下标的气泡数字 最大999+, 当为0 时隐藏
 */
- (NSUInteger)tabViewController:(LLTabLayoutContainersViewController *)tabLayoutViewController badgeNumberAtIndex:(NSUInteger)index;

/**
 当前所处的下标
 
 @param tabLayoutViewController
 @param currentViewController 当前所处下标的控制器
 @param index 当前下标
 */
- (void)tabViewController:(LLTabLayoutContainersViewController *)tabLayoutViewController currentViewController:(UIViewController *)currentViewController atIndex:(NSUInteger)index;

//- (UIView *)pageViewController:(LLTabLayoutContentViewController *)pageViewController headerCustomViewAtIndex:(NSUInteger)index;
@end


