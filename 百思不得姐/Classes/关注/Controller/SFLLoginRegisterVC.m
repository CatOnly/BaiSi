//
//  SFLLoginRegisterVC.m
//  百思不得姐
//
//  Created by Light on 5-3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLLoginRegisterVC.h"

@interface SFLLoginRegisterVC ()
/** 距离控制器View 左边的间距*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMagin;

@end

@implementation SFLLoginRegisterVC

- (IBAction)showLoginOrRegisterBoard:(UIButton *)btn {
    // 界面切换，退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMagin.constant == 0) {
        self.loginViewLeftMagin.constant =- self.view.width;
        btn.selected = YES;
    }else{
        self.loginViewLeftMagin.constant = 0;
        btn.selected = NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)back:(id)sender {
    // 界面切换，退出键盘
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

// 修改状态栏的颜色,白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
