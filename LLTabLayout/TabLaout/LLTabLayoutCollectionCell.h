//
//  LLTabLayoutCollectionCell.h
//  LLTabLayout
//
//  Created by LiLei on 9/5/2019.
//  Copyright © 2019 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLTabLayoutCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIColor *ll_selectedColor;
@property (nonatomic, strong) UIColor *ll_normalColor;
@property (nonatomic, strong) UIFont *ll_normalFont;
@property (nonatomic, strong) UIFont *ll_selectedFont;
@property (nonatomic, assign) NSInteger ll_badgeNumber;
@end

NS_ASSUME_NONNULL_END
