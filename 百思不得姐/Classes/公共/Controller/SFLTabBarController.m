//
//  SFLTabBarController.m
//  百思不得姐
//
//  Created by Light on 4-20.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTabBarController.h"

#import "SFLTabBar.h"
#import "SFLNavigationController.h"
#import "SFLEssenceVC.h"
#import "SFLNewsVC.h"
#import "SFLFriendsVC.h"
#import "SFLMeVC.h"

@interface SFLTabBarController ()

@end

@implementation SFLTabBarController

+ (void)initialize{
    // 禁用系统渲染
    //    UIImage *img = [UIImage imageNamed:@"tabBar_essence_icon"];
    //    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    NSMutableDictionary *attrsSelected = [NSMutableDictionary dictionary];
    attrsSelected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 后面带有 UI_APPEARANCE_SELECTOR 宏的方法，都可以通过 appearance 对象统一设置
    UITabBarItem *itmAppearnce = [UITabBarItem appearance];
    [itmAppearnce setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [itmAppearnce setTitleTextAttributes:attrsSelected forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    [self setupChildVC:[[SFLEssenceVC alloc] init] title:@"精华" img:@"tabBar_essence_icon" selectedImg:@"tabBar_essence_click_icon"];
    [self setupChildVC:[[SFLNewsVC alloc] init] title:@"新帖" img:@"tabBar_new_icon" selectedImg:@"tabBar_new_click_icon"];
    [self setupChildVC:[[SFLFriendsVC alloc] init] title:@"关注" img:@"tabBar_friendTrends_icon" selectedImg:@"tabBar_friendTrends_click_icon"];
    [self setupChildVC:[[SFLMeVC alloc] initWithStyle:UITableViewStyleGrouped] title:@"我的" img:@"tabBar_me_icon" selectedImg:@"tabBar_me_click_icon"];
    
    // 更换 TabBar
    [self setValue:[[SFLTabBar alloc] init] forKey:@"tabBar"];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
}

- (void)setupChildVC:(UIViewController *)viewController title:(NSString *)title img:(NSString *)img selectedImg:(NSString *)selectedImg
{
    // 会导致所有的控制器被创建
//    viewController.view.backgroundColor = [UIColor colorWithRed:233.0/255 green:233.0/255 blue:233.0/255 alpha:1.0];
    
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:img];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImg];
    // viewController.navigationItem.title = title;
    // 设置导航控制器的根控制器，并将导航控制器添加到 UIBarButton 上
    SFLNavigationController *nav = [[SFLNavigationController alloc] initWithRootViewController:viewController];

    [self addChildViewController:nav];
}

@end
