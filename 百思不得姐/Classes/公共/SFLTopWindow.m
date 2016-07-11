//
//  SFLTopWindow.m
//  百思不得姐
//
//  Created by Light on 7-11.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTopWindow.h"
static UIWindow *window_;

@implementation SFLTopWindow

+ (void)initialize {
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, 0, SFLScreenW, 20);
    window_.windowLevel = UIWindowLevelAlert;
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];

}

+ (void)show{
    window_.hidden = NO;
}
+ (void)hide{
    window_.hidden = YES;
}
/**
 *  监听窗口点击
 */
+ (void)windowClick{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:keyWindow];
}

+ (void)searchScrollViewInView:(UIView *)superview{
    for (UIScrollView *subview in superview.subviews) {
        // 如果是 scrollview，滚到最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = -subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        // 递归查找子控件
        [self searchScrollViewInView:subview];
    }

}
@end
