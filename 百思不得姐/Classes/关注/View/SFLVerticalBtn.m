//
//  SFLVerticalBtn.m
//  百思不得姐
//
//  Created by Light on 5-3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLVerticalBtn.h"

@implementation SFLVerticalBtn

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger width = self.width;
    // 调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = width;
    self.imageView.height = width;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = width;
    self.titleLabel.width = width;
    self.titleLabel.height = self.height - width;
}

- (void)setup{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

// xib 创建效果
- (void)awakeFromNib{
    [self setup];
}

// 代码创建效果
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
@end
