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

static CGFloat const SFLAnimationDelay = 0.1;
static CGFloat const SFLSpringFactor = 8;

@interface SFLPublishVC ()

@end

@implementation SFLPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 动画结束前不能点击
    self.view.userInteractionEnabled = NO;
    
    // 中间 6 个按钮
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    int row = 0;
    int col = 0;
    int maxCols = 3;
    CGFloat btnW = 72;
    CGFloat btnH = btnW + 40;
    CGFloat btnBeginX = 25;
    CGFloat btnBeginY = (SFLScreenH - 2 * btnH) * 0.5;
    CGFloat xMargin = (SFLScreenW - 2 * btnBeginX - maxCols * btnW) / (maxCols - 1);
    for (int i = 0; i < images.count; i++) {
        SFLVerticalBtn *btn = [[SFLVerticalBtn alloc] init];
        [self.view addSubview:btn];
        
        // 设置内容
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]]  forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置开始和结束位置
        row = i / maxCols;
        col = i % maxCols;
        CGFloat btnX = btnBeginX + col * (xMargin + btnW);
        CGFloat btnPEndY = btnBeginY + row * (btnBeginX + btnH);
        CGFloat btnPBeginY = btnPEndY - SFLScreenH * 0.5;

        // 添加按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(btnX, btnPBeginY, btnW, btnH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(btnX, btnPEndY, btnW, btnH)];
        anim.springBounciness = SFLSpringFactor;
        anim.springSpeed = SFLSpringFactor;
        anim.beginTime = CACurrentMediaTime() + SFLAnimationDelay * i;
        [btn pop_addAnimation:anim forKey:nil];
    }
    
    // 添加标语图片
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:sloganView];

    // 设置开始和结束位置
    CGFloat centerX = SFLScreenW * 0.5;
    CGFloat centerEndY = SFLScreenH * 0.2;
    CGFloat centerBeginY = centerEndY - SFLScreenH * 0.5;
    // 在创建对象时会有初始位置，先把初始位置覆盖掉
    sloganView.center = CGPointMake(centerX, centerBeginY);
    
    // 标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * SFLAnimationDelay;
    anim.springBounciness = SFLSpringFactor;
    anim.springSpeed = SFLSpringFactor;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 标语动画执行完毕, 恢复点击事件
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];

}

- (void)btnClick:(UIButton *)btn {
    [self cancelWithCompletionBlock:^{
        [SFLoginTool getUID];
        if (btn.tag == 0) {
            SFLLOG(@"发视频");
        } else if (btn.tag == 1) {
            SFLLOG(@"发图片");
        }
    }];
}


- (IBAction)cancel:(id)sender {
    [self cancelWithCompletionBlock:nil];
}

// 先执行退出动画, 动画完毕后执行 completionBlock
- (void)cancelWithCompletionBlock:(void (^)())completionBlock
{
    // 动画开始不能点击
    self.view.userInteractionEnabled = NO;
    
    // 索引号是取决与 viewDidLoad 添加的先后顺序
    int beginIdx = 2;
    
    for (int i = beginIdx; i < self.view.subviews.count; i++) {
        UIView *subview = self.view.subviews[i];
        
        // 基本动画
        CGFloat centerY = subview.centerY + SFLScreenH;

        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        [subview pop_addAnimation:anim forKey:nil];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIdx) * SFLAnimationDelay * 0.5;
        // 动画的执行节奏(一开始很慢, 后面很快)
//        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        // 监听最后一个动画
        if (i == self.view.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];
                // 传进来的 Block 如果有值就执行「没有值程序会崩溃」
                !completionBlock ? : completionBlock();
            }];
        }
    }
}

// 点击屏幕其他地方，控制器退回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelWithCompletionBlock:nil];
}
@end
