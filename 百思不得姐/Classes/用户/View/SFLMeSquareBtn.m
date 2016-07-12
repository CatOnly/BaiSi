//
//  SFLMeSquareBtn.m
//  百思不得姐
//
//  Created by Light on 7-11.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLMeSquareBtn.h"
#import "SFLMeSquare.h"

#import <UIButton+WebCache.h>

@implementation SFLMeSquareBtn

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger width = self.width;
    // 调整图片
    self.imageView.y = self.height * 0.15;
    self.imageView.width = width * 0.5;
    self.imageView.height = width * 0.5;
    self.imageView.centerX = width * 0.5;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

- (void)setup{
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
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

- (void)setSquare:(SFLMeSquare *)square {
    _square = square;
    
    [self setTitle:square.name forState:UIControlStateNormal];
    // 利用SDWebImage给按钮设置image
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}

@end
