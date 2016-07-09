//
//  SFLTabBar.m
//  百思不得姐
//
//  Created by Light on 4-20.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTabBar.h"
#import "SFLPublishVC.h"
@interface SFLTabBar()

@property (strong, nonatomic) UIButton *publishBtn;

@end

@implementation SFLTabBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.width;
    CGFloat height = self.height;
    // 设置发布按扭的 frame
    self.publishBtn.size = self.publishBtn.currentBackgroundImage.size;
    self.publishBtn.center = CGPointMake(width * 0.5, height * 0.5);
    // 设置其他 UITabBarButton 的 frame
    NSInteger idx = 0;
    CGFloat btnX = 0;
    CGFloat btnW = width / 5.0;
    CGFloat btnH = height;
    for (UIView *btn in self.subviews) {
        if (![btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        btnX = btnW * (idx > 1 ? (idx + 1) : idx);
        btn.frame = CGRectMake(btnX, 0, btnW, btnH);
        idx++;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [publishBtn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishBtn];
        self.publishBtn = publishBtn;
    }
    return self;
}

- (void)publishClick {
    SFLPublishVC *publishVC = [[SFLPublishVC alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publishVC animated:YES completion:nil];
}

@end
