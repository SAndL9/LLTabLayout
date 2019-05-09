//
//  ViewController.m
//  LLTabLayout
//
//  Created by LiLei on 9/5/2019.
//  Copyright © 2019 李磊. All rights reserved.
//

#import "ViewController.h"
#import "LLMainViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可滑动标签";
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"固定宽度";        }
            break;
        case 1:{
            cell.textLabel.text = @"根据文字自适应";
            
        }
            break;
        case 2:{
            cell.textLabel.text = @"默认下标";

        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LLMainViewController *vc = [[LLMainViewController alloc]init];
    switch (indexPath.row) {
        case 0:{
            vc.demoType = LLDemoTypeFixedWidth;
        }
            break;
        case 1:{
            vc.demoType = LLDemoTypeAutomatic;

        }
            break;
        case 2:{
            vc.demoType = LLDemoTypeDefaultIndex;
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];

}

@end
