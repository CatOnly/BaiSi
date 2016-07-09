//
//  SFLNewsVC.m
//  百思不得姐
//
//  Created by Light on 4-20.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLNewsVC.h"

@interface SFLNewsVC ()

@end

@implementation SFLNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏内容
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    self.view.backgroundColor = SFLGlobalBG;
}

- (void)tagClick{
    SFLShowCurrentFunction;
}

@end
