//
//  SFLNavigationController.m
//  百思不得姐
//
//  Created by Light on 4-20.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLNavigationController.h"

@implementation SFLNavigationController

// 第一次使用类的使用调用
+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad{
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

// 拦截所有 push 进来的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    SFLLOG(@"%@",viewController);

    if (self.childViewControllers.count > 0){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@" 返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        btn.size = CGSizeMake(80, 30);
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
//        [btn sizeToFit]; // 按钮大小适应文字的大小「不实用可以增加点击面积，便于点击」
//        [btn setBackgroundColor:[UIColor redColor]]; // 查看实际点击区域

        btn.contentMode = UIViewContentModeLeft; // UIImageView 受影响
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; // 按钮内容左对齐
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }

    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}
@end
