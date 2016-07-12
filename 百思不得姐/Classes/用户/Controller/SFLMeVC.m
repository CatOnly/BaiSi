//
//  SFLMeVC.m
//  百思不得姐
//
//  Created by Light on 4-20.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLMeVC.h"
#import "SFLMeCell.h"
#import "SFLMeFooterView.h"

@interface SFLMeVC ()

@end
static NSString * const SLFMeViewCell = @"me";
@implementation SFLMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupTableView];
}

- (void)setupNavi{
    self.navigationItem.title = @"我的";
    self.navigationItem.rightBarButtonItems =@[
                                               [UIBarButtonItem itemWithImage:@"mine-setting-icon"
                                                                    highImage:@"mine-setting-icon-click"
                                                                       target:self
                                                                       action:@selector(settingClick)],
                                               [UIBarButtonItem itemWithImage:@"mine-moon-icon"
                                                                    highImage:@"mine-moon-icon-click"
                                                                       target:self
                                                                       action:@selector(moonClick)]
                                               
                                               ];
}

- (void)setupTableView{
    self.tableView.backgroundColor = SFLGlobalBG;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SFLMeCell class] forCellReuseIdentifier:SLFMeViewCell];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = SFLTopicCellMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, self.tabBarController.tabBar.height, 0);
    SFLMeFooterView *footerView = [[SFLMeFooterView alloc] init];
    footerView.tableView = self.tableView;
    self.tableView.tableFooterView = footerView;
}

- (void)settingClick{
    
}

- (void)moonClick{
    
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFLMeCell *cell = [tableView dequeueReusableCellWithIdentifier:SLFMeViewCell];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
        cell.textLabel.text = @"登入/注册";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"离线下载";
    }
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [SFLoginTool getUID];
    }
}
@end
