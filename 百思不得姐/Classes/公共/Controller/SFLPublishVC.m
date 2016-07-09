//
//  SFLPublishVC.m
//  百思不得姐
//
//  Created by Light on 5-7.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLPublishVC.h"
#import "SFLVerticalBtn.h"
#import <POP.h>

@interface SFLPublishVC ()

@end

@implementation SFLPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加标语图片
    UIImageView *solganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    solganView.y = SFLScreenH * 0.2;
    solganView.centerX = SFLScreenW * 0.5;
    [self.view addSubview:solganView];
    
    // 中间 6 个按钮
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    int maxCols = 3;
    CGFloat btnW = 72;
    CGFloat btnH = btnW + 40;
    CGFloat btnStartX = 25;
    CGFloat btnStartY = (SFLScreenH - 2 * btnH) * 0.5;
    CGFloat xMargin = (SFLScreenW - 2 * btnStartX - maxCols * btnW) / (maxCols - 1);
    for (int i = 0; i < images.count; i++) {
        SFLVerticalBtn *btn = [[SFLVerticalBtn alloc] init];
        [self.view addSubview:btn];
        // 设置内容
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]]  forState:UIControlStateNormal];
        // 设置 frame
        btn.width = btnW;
        btn.height = btnH;
        int row = i / maxCols;
        int col = i % maxCols;
        btn.x = btnStartX + col * (xMargin + btnW);
        btn.y = btnStartY + row * (btnStartX + btnH);
        
    }
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
