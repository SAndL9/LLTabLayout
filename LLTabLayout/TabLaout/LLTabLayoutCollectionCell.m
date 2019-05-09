//
//  LLTabLayoutCollectionCell.m
//  LLTabLayout
//
//  Created by LiLei on 9/5/2019.
//  Copyright © 2019 李磊. All rights reserved.
//

#import "LLTabLayoutCollectionCell.h"
#import <Masonry/Masonry.h>
@interface LLTabLayoutCollectionCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *figureLabel;

@end

@implementation LLTabLayoutCollectionCell

#pragma mark-
#pragma mark- View Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviewsContraints];
        //        self.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

#pragma mark-
#pragma mark- <#代理类名#> delegate

#pragma mark-
#pragma mark- Event response


#pragma mark-
#pragma mark- Private Methods


#pragma mark-
#pragma mark- Getters && Setters
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.titleLabel.textColor = selected ? _ll_selectedColor : _ll_normalColor;
    self.titleLabel.font = selected ? _ll_selectedFont : _ll_normalFont;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)figureLabel{
    if (!_figureLabel) {
        _figureLabel = [[UILabel alloc]init];
        _figureLabel.backgroundColor = [UIColor redColor];
        _figureLabel.textColor = [UIColor whiteColor];
        _figureLabel.font = [UIFont systemFontOfSize:10];
        _figureLabel.layer.masksToBounds = YES;

    }
    return _figureLabel;
}

- (void)setLl_badgeNumber:(NSInteger)ll_badgeNumber{
    _ll_badgeNumber = ll_badgeNumber;
    if (ll_badgeNumber > 0) {
        self.figureLabel.hidden = NO;
        self.figureLabel.text = [NSString stringWithFormat:@"%ld",(long)ll_badgeNumber];
    }else{
        self.figureLabel.hidden = YES;
    }
    [self.contentView layoutIfNeeded];
    self.figureLabel.layer.cornerRadius = self.figureLabel.bounds.size.height / 2.0;
}


#pragma mark-
#pragma mark- SetupConstraints
- (void)setupSubviewsContraints {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel addSubview:self.figureLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        //        make.height.mas_equalTo(32);
        //        make.left.mas_lessThanOrEqualTo(self.contentView.mas_left).offset(8);
        //        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-8);
        make.width.mas_lessThanOrEqualTo(self.contentView.mas_width).offset(-16);
    }];
    [self.figureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.titleLabel.mas_right).offset(- 12.5);
        make.centerX.equalTo(self.titleLabel.mas_right).offset(4);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(12);
    }];
    
}

@end
