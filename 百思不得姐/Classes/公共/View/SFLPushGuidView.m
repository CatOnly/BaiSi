//
//  SFLPushGuidView.m
//  百思不得姐
//
//  Created by Light on 5-4.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLPushGuidView.h"

@implementation SFLPushGuidView

+ (instancetype)guideView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

+ (void)show{
    NSString *versionKey = @"CFBundleShortVersionString";
    // 获得当前软件版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    // 获得沙盒里早已存储好的版本号
    NSString *sandBoxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:versionKey];
    
    if (![currentVersion isEqualToString:sandBoxVersion]) {
        // 显示指南界面
        SFLPushGuidView *guidView = [SFLPushGuidView guideView];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        guidView.frame = window.bounds;
        [window addSubview:guidView];
        
        // 存储版本号「不知道什么时候同步到系统」
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        // 马上同步到系统
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
