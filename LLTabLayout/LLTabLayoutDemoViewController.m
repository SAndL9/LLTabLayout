//
//  LLTabLayoutDemoViewController.m
//  LLTabLayout
//
//  Created by LiLei on 9/5/2019.
//  Copyright © 2019 李磊. All rights reserved.
//

#import "LLTabLayoutDemoViewController.h"
#import <Masonry/Masonry.h>

@interface LLTabLayoutDemoViewController ()
@property (nonatomic, strong) UILabel *label;

@end

@implementation LLTabLayoutDemoViewController
-(void)setLableTitle:(NSString *)lableTitle{
    _lableTitle = lableTitle;
    self.label.text = lableTitle;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    self.view.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    _label = [[UILabel alloc]init];
    _label.textColor = [UIColor whiteColor];
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
