//
//  LLMainViewController.m
//  LLTabLayout
//
//  Created by LiLei on 9/5/2019.
//  Copyright © 2019 李磊. All rights reserved.
//

#import "LLMainViewController.h"
#import "LLTabLayoutContainersViewController.h"
#import <Masonry/Masonry.h>
#import "LLTabLayoutDemoViewController.h"
@interface LLMainViewController ()<LLTabLayoutContainersViewControllerDataSource>
@property (nonatomic, strong) LLTabLayoutContainersViewController *tabLayoutVC;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *viewControllerArraySource;
@property (nonatomic, strong) NSMutableArray *bageNumberArray;

@end

@implementation LLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    switch (_demoType) {
        case LLDemoTypeFixedWidth:{
             _tabLayoutVC = [[LLTabLayoutContainersViewController alloc]initWithTabLayoutItemType:LLTabLayoutFormatFixed withUiStyle:LLTabLayoutUIStyleDefault];
          
        }
            break;
        case LLDemoTypeAutomatic:{
             _tabLayoutVC = [[LLTabLayoutContainersViewController alloc]initWithTabLayoutItemType:LLTabLayoutFormatAutomatic withUiStyle:LLTabLayoutUIStyleSpecific];

        }
            break;
        case LLDemoTypeDefaultIndex:{
             _tabLayoutVC = [[LLTabLayoutContainersViewController alloc]initWithTabLayoutItemType:LLTabLayoutFormatFixed withUiStyle:LLTabLayoutUIStyleDefault];
            _tabLayoutVC.ll_defaultIndex = 1;

        }
            break;
        default:{
             _tabLayoutVC = [[LLTabLayoutContainersViewController alloc]initWithTabLayoutItemType:LLTabLayoutFormatFixed withUiStyle:LLTabLayoutUIStyleDefault];
        }
            break;
    }
    
    
    _tabLayoutVC.dataSource = self;
    [self addChildViewController:_tabLayoutVC];
    [self.view addSubview:_tabLayoutVC.view];
    
    [_tabLayoutVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark----
#pragma mark-----

- (NSInteger)numbersOfPageInTabViewController:(LLTabLayoutContainersViewController *)tabLayoutViewController{
    return self.viewControllerArraySource.count;
}

/**
 返回每个item对应的标题
 
 @param tabLayoutViewController self
 @param index 对应的下标
 @return 标题
 */
- (NSString *)tabViewController:(LLTabLayoutContainersViewController *)tabLayoutViewController titleAtIndex:(NSUInteger)index{
    LLTabLayoutDemoViewController *vc = self.viewControllerArraySource[index];
    vc.lableTitle = self.titleArray[index];
    return self.titleArray[index];
}

/**
 对应的控制器
 
 @param tabLayoutViewController self
 @param index 对应的下标
 @return 返回每个下标对应的viewController
 */
- (UIViewController *)tabViewController:(LLTabLayoutContainersViewController *)tabLayoutViewController childViewControllerAtIndex:(NSUInteger)index{
    return self.viewControllerArraySource[index];
}



/**
 返回气泡
 
 @param tabLayoutViewController self
 @param index 对应的下标
 @return 返回每个对应下标的气泡数字 最大999+, 当为0 时隐藏
 */
- (NSUInteger)tabViewController:(LLTabLayoutContainersViewController *)tabLayoutViewController badgeNumberAtIndex:(NSUInteger)index{
    return [self.bageNumberArray[index] integerValue];
}

/**
 当前所处的下标
 
 @param tabLayoutViewController
 @param currentViewController 当前所处下标的控制器
 @param index 当前下标
 */
- (void)tabViewController:(LLTabLayoutContainersViewController *)tabLayoutViewController currentViewController:(UIViewController *)currentViewController atIndex:(NSUInteger)index{
    NSLog(@"currentSelectedIndex----%ld----%@",index,currentViewController);
    
}





- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc]initWithObjects:@"关注",@"广场",@"同城",nil];
    }
    return _titleArray;
}

- (NSMutableArray *)viewControllerArraySource{
    if (!_viewControllerArraySource) {
        _viewControllerArraySource = [[NSMutableArray alloc]init];
        for (int i = 0; i < 3; i++) {
            LLTabLayoutDemoViewController *vc = [[LLTabLayoutDemoViewController alloc]init];
            [_viewControllerArraySource addObject:vc];
        }
    }
    return _viewControllerArraySource;
}

- (NSMutableArray *)bageNumberArray{
    if (!_bageNumberArray) {
        _bageNumberArray = [[NSMutableArray alloc]initWithObjects:@(56),@(922),@(0),nil];
    }
    return _bageNumberArray;
}

//- (NSMutableArray *)dataSourceArray{
//    if (!_dataSourceArray) {
//        _dataSourceArray = [[NSMutableArray alloc]init];
//    }
//    return _dataSourceArray;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
