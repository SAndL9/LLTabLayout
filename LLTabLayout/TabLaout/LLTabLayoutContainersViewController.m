//
//  LLTabLayoutContainersViewController.m
//  LLTabLayout
//
//  Created by LiLei on 9/5/2019.
//  Copyright © 2019 李磊. All rights reserved.
//

#import "LLTabLayoutContainersViewController.h"
#import <Masonry/Masonry.h>
#import "LLTabLayoutCollectionCell.h"
#import <Foundation/Foundation.h>
static NSInteger const topViewHeight = 50;
static NSInteger const kItemMinWidth = 34;
static NSInteger const kItemMaxWidth = 120;
static NSInteger const kItemSpeacWidth = 12.5;
static NSInteger const kItemWidth = 20;
static NSInteger const kSlideLineHeight = 3;
static NSInteger const kConllectionEdgSpeac = 15;
static NSInteger const kTitleCollectionTag = 1111;
static NSInteger const kContainersCollectionTag = 1112;


#define  Color5  [UIColor colorWithRed:44/255.0 green:47/255.0 blue:50/255.0 alpha:1]
#define  Color1  [UIColor colorWithRed:64/255.0 green:94/255.0 blue:193/255.0 alpha:1]
#define normalFont [UIFont fontWithName:@"HelveticaNeue-Medium" size:14]
#define selectedFont [UIFont fontWithName:@"HelveticaNeue-Medium" size:17]
@interface LLTabLayoutContainersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) NSInteger currentIndex;  //当前位置
@property (nonatomic, assign) NSInteger preIndex;//上一次的位置
@property (nonatomic, strong) UICollectionView *titleCollectionView;  //标题
@property (nonatomic, strong) UICollectionView *contentCollectionView; //内容
@property (nonatomic, strong) NSMutableDictionary *statusDic;   //位置选择状态
@property (nonatomic, strong) UIView *sliderLine;   //title底部滚动条
@property (nonatomic, assign) BOOL isFixedItemWidth;
@property (nonatomic, strong) NSMutableDictionary *titleWidthCache;//标题文字宽度缓存
@property (nonatomic, strong) UIColor *ll_normalColor;
@property (nonatomic, strong) UIColor *ll_selectedColor;
@property (nonatomic, strong) UIFont *ll_normalFont;
@property (nonatomic, strong) UIFont *ll_selectedFont;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LLTabLayoutContainersViewController



#pragma mark-
#pragma mark- View Life Cycle

- (instancetype)initWithTabLayoutItemType:(LLTabLayoutFormat)tabLayoutFormat withUiStyle:(LLTabLayoutUIStyle)tabLayoutUiStyle{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        if (tabLayoutFormat == LLTabLayoutFormatFixed) {
            self.isFixedItemWidth = YES;
        }else{
            self.isFixedItemWidth = NO;
        }
        if (tabLayoutUiStyle == LLTabLayoutUIStyleDefault) {
            self.ll_normalColor = Color5;
            self.ll_selectedColor = Color1;
            self.ll_normalFont = normalFont;
            self.ll_selectedFont = normalFont;
            self.lineView.hidden = NO;
        }else{
            self.ll_normalColor = [Color5 colorWithAlphaComponent:0.8];
            self.ll_selectedColor = Color5;
            self.ll_normalFont = normalFont;
            self.ll_selectedFont = selectedFont;
            self.lineView.hidden = YES;
        }
        
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
  

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self reloadData];
}
#pragma mark-
#pragma mark- Request


#pragma mark-
#pragma mark- LLNetworkResponseProtocol

#pragma mark-
#pragma mark- UICollectionViewDelegate  &&  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numbersOfPageInTabViewController:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (collectionView.tag ) {
        case kTitleCollectionTag: {
            LLTabLayoutCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LLTabLayoutCollectionCell class]) forIndexPath:indexPath];
            cell.ll_selectedColor = self.ll_selectedColor;
            cell.ll_normalColor = self.ll_normalColor;
            cell.ll_selectedFont = self.ll_selectedFont;
            cell.ll_normalFont = self.ll_normalFont;
            BOOL isSelected = [[self.statusDic objectForKey:[NSNumber numberWithInteger:indexPath.row]] boolValue];
            cell.selected = isSelected;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(tabViewController:titleAtIndex:)]) {
                cell.title = [self.dataSource tabViewController:self titleAtIndex:indexPath.row];
            }
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(tabViewController:badgeNumberAtIndex:)]) {
                cell.ll_badgeNumber = [self.dataSource tabViewController:self badgeNumberAtIndex:indexPath.row];
            }
            
            return cell;
        }
            break;
        case kContainersCollectionTag: {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
            UIViewController *vc = [self.dataSource tabViewController:self childViewControllerAtIndex:indexPath.row];
            vc.view.frame = cell.bounds;
            [self addChildViewController:vc];
            [cell addSubview:vc.view];
            return cell;
        }
            break;
        default:
            return [[UICollectionViewCell alloc]init];
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == kTitleCollectionTag) {
        [self modifyCllSelectdStatus:indexPath.item];
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self.titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self updateSliderLinePosition:indexPath.item];
        [self.titleCollectionView reloadData];
        self.currentIndex = indexPath.item;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(tabViewController:currentViewController:atIndex:)]) {
            [self.dataSource tabViewController:self currentViewController:[self.dataSource tabViewController:self childViewControllerAtIndex:indexPath.row] atIndex:indexPath.row];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.titleCollectionView) {
        
        NSNumber *itemWidth = [self.titleWidthCache objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        if (itemWidth) {
            return CGSizeMake([itemWidth doubleValue], topViewHeight);
        }else{
            NSInteger totalNum = [self.dataSource numbersOfPageInTabViewController:self];
            CGFloat width = 0;
            if (self.isFixedItemWidth) {
                
                [self.titleWidthCache setObject:@((collectionView.bounds.size.width - kConllectionEdgSpeac * 2) / totalNum) forKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
                width = (collectionView.bounds.size.width - kConllectionEdgSpeac * 2) / totalNum;
            }else{
                width = [self LL_CalculateItemWithAtIndex:indexPath.row];
            }
            return CGSizeMake(width, topViewHeight);
        }
    } else {
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
    }
}

- (CGFloat)LL_CalculateItemWithAtIndex:(NSInteger)index {
    
    NSString *title = [self.dataSource tabViewController:self titleAtIndex:index];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{NSFontAttributeName:normalFont, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0};
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:title attributes:dic];
    CGFloat itemWidth = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:dic context:nil].size.width;
    
    if (itemWidth < kItemMinWidth) {
        itemWidth = kItemMinWidth + kItemSpeacWidth * 2;
    }else if (itemWidth > kItemMaxWidth) {
        itemWidth = kItemMaxWidth + kItemSpeacWidth * 2;
    }else{
        itemWidth = ceil(itemWidth) + kItemSpeacWidth * 2;
    }
    
    [self.titleWidthCache setObject:@(itemWidth) forKey:[NSString stringWithFormat:@"%ld", index]];
    return itemWidth;
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView.tag == kContainersCollectionTag) {
        NSInteger index = (NSInteger)(scrollView.contentOffset.x / self.view.bounds.size.width);
        self.currentIndex = index;
        [self.titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self modifyCllSelectdStatus:index];
        [self.titleCollectionView reloadData];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == kContainersCollectionTag) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x / self.view.bounds.size.width;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(tabViewController:currentViewController:atIndex:)]) {
            [self.dataSource tabViewController:self currentViewController:[self.dataSource tabViewController:self childViewControllerAtIndex:index] atIndex:index];
        }
    }else{
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == kContainersCollectionTag) {
        CGFloat indexValue = (CGFloat)(scrollView.contentOffset.x / self.view.bounds.size.width);
        CGFloat currentIndexValue = 0.00;
        if (indexValue > self.currentIndex) {
            currentIndexValue = floor(indexValue);
        } else {
            currentIndexValue = ceil(indexValue);
        }
        [self updateSliderLinePosition:indexValue fromIndex:currentIndexValue];
        //        if (self.dataSource && [self.dataSource respondsToSelector:@selector(tabViewController:currentViewController:atIndex:)]) {
        //            [self.dataSource tabViewController:self currentViewController:[self.dataSource tabViewController:self childViewControllerAtIndex:currentIndexValue] atIndex:currentIndexValue];
        //        }
    }else{
        
    }
}

#pragma mark-
#pragma mark- Event response




- (void)reloadData {
    [self.contentCollectionView reloadData];
    [self.titleCollectionView reloadData];
    [self.titleWidthCache removeAllObjects];
}

- (void)updateItemBadgeNumber:(NSInteger)badgeNumber atIndex:(NSInteger)index{
    LLTabLayoutCollectionCell *cell = (LLTabLayoutCollectionCell *)[self.titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    cell.ll_badgeNumber = badgeNumber;
}

#pragma mark-
#pragma mark- Private Methods

/**
 *  更新下划线位置
 *
 *  @param index 当前位置
 */
- (void)updateSliderLinePosition:(CGFloat)index fromIndex:(CGFloat)preIndex{
    NSIndexPath *indexPath;
    if (index == preIndex) {return;}
    if (index > preIndex) {
        indexPath = [NSIndexPath indexPathForItem:preIndex + 1 inSection:0];
    } else if (index < preIndex){
        indexPath = [NSIndexPath indexPathForItem:preIndex - 1 inSection:0];
    }
    
    LLTabLayoutCollectionCell *cell = [self.titleCollectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LLTabLayoutCollectionCell class]) forIndexPath:indexPath];
    CGRect cellFrame = [self.titleCollectionView convertRect:cell.frame toView:self.titleCollectionView];
    CGFloat startPointX = cellFrame.origin.x + (cellFrame.size.width - kItemWidth) / 2;
    
    LLTabLayoutCollectionCell *preCell = [self.titleCollectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LLTabLayoutCollectionCell class]) forIndexPath:[NSIndexPath indexPathForItem:preIndex inSection:0]];
    CGRect preCellFrame = [self.titleCollectionView convertRect:preCell.frame toView:self.titleCollectionView];
    CGFloat preStartPointX = preCellFrame.origin.x + (preCellFrame.size.width - kItemWidth) / 2;
    
    CGFloat rate = fabs(index - preIndex);
    [self.sliderLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kItemWidth);
        make.left.mas_equalTo(preStartPointX + (startPointX - preStartPointX) * rate);
    }];
}

- (void)updateSliderLinePosition:(CGFloat)index {
    LLTabLayoutCollectionCell *cell = [self.titleCollectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LLTabLayoutCollectionCell class]) forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    CGRect cellFrame = [self.titleCollectionView convertRect:cell.frame toView:self.titleCollectionView];
    [self.sliderLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kItemWidth);
        make.left.mas_equalTo(cellFrame.origin.x + (cellFrame.size.width - kItemWidth) / 2);
    }];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self modifyCllSelectdStatus:indexPath.item];
    [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    [self.titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    [self updateSliderLinePosition:indexPath.item fromIndex:self.currentIndex];
    [self.titleCollectionView reloadData];
    self.currentIndex = indexPath.item;
}

- (void)modifyCllSelectdStatus:(NSInteger)index {
    for (NSNumber *number in self.statusDic.allKeys) {
        if ([number integerValue] == index) {
            [self.statusDic setObject:[NSNumber numberWithBool:YES] forKey:number];
        } else {
            [self.statusDic setObject:[NSNumber numberWithBool:NO] forKey:number];
        }
    }
}

- (void)scrollTabLayoutToIndex:(NSInteger)index animated:(BOOL)animated{
    [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    [self.titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    [self updateSliderLinePosition:index fromIndex:self.currentIndex];
    [self.titleCollectionView reloadData];
    self.currentIndex = index;
}
#pragma mark-
#pragma mark- Getters && Setters
- (UICollectionView *)titleCollectionView {
    if (!_titleCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, kConllectionEdgSpeac, 0, kConllectionEdgSpeac);
        _titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.contentInsets.left, self.contentInsets.top, self.view.frame.size.width - self.contentInsets.left - self.contentInsets.right, topViewHeight) collectionViewLayout:layout];
        _titleCollectionView.tag = kTitleCollectionTag;
        _titleCollectionView.bounces = NO;
        _titleCollectionView.showsHorizontalScrollIndicator = NO;
        _titleCollectionView.delegate = self;
        _titleCollectionView.dataSource = self;
        _titleCollectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_titleCollectionView];
        [_titleCollectionView registerClass:[LLTabLayoutCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([LLTabLayoutCollectionCell class])];
        
    }
    return _titleCollectionView;
}

- (UICollectionView *)contentCollectionView {
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.titleCollectionView.frame.size.height + 0.5 + _contentInsets.top, self.view.frame.size.width, self.view.frame.size.height - topViewHeight - _contentInsets.top) collectionViewLayout:layout];
        _contentCollectionView.tag = kContainersCollectionTag;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        [self.view addSubview:_contentCollectionView];
        [_contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _contentCollectionView;
}


- (void)setContentInsets:(UIEdgeInsets)contentInsets{
    _contentInsets = contentInsets;
}

- (void)setIsHorizontalScrollEnable:(BOOL)isHorizontalScrollEnable {
    _isHorizontalScrollEnable = isHorizontalScrollEnable;
    self.contentCollectionView.scrollEnabled = isHorizontalScrollEnable;
}

- (UIView *)sliderLine {
    if (_sliderLine == nil) {
        _sliderLine = [[UIView alloc] init];
        _sliderLine.layer.masksToBounds =  YES;
        _sliderLine.layer.cornerRadius = 2;
        _sliderLine.backgroundColor = Color1;
        [self.titleCollectionView addSubview:_sliderLine];
        [_sliderLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kSlideLineHeight);
            make.top.mas_equalTo(self.titleCollectionView.mas_top).mas_offset(topViewHeight-kSlideLineHeight);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kItemWidth);
        }];
    }
    return _sliderLine;
}

/**
 *  存储初始化选择状态
 *
 *  @return 状态字典
 */
- (NSMutableDictionary *)statusDic {
    if (_statusDic == nil) {
        _statusDic = [[NSMutableDictionary alloc] init];
        for (int num = 0; num < [self.dataSource numbersOfPageInTabViewController:self]; num++) {
            [_statusDic setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:num]];
            //带指定页面的初始化
            if (num == _ll_defaultIndex) {
                self.currentIndex = num;
                [_statusDic setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInt:num]];
                [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:num inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                [self.titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:num inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                [self updateSliderLinePosition:num];
            }
        }
    }
    return _statusDic;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:238/255.0 alpha:1];
        _lineView.frame = CGRectMake(0, CGRectGetMaxY(_titleCollectionView.frame) - 0.5, self.view.bounds.size.width - _contentInsets.left - _contentInsets.right, 0.5);
        [self.view addSubview:_lineView];
    }
    return _lineView;
}
#pragma mark-
#pragma mark- SetupConstraints
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
