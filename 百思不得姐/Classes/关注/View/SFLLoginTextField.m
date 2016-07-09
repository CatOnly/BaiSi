//
//  SFLLoginTextField.m
//  百思不得姐
//
//  Created by Light on 5-3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLLoginTextField.h"

@implementation SFLLoginTextField

- (void)awakeFromNib{
    // 设置光标和文字颜色保持一致
    self.tintColor = self.textColor;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
}

// 成为第一响应者
- (BOOL)becomeFirstResponder{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:self.textColor}];
    return [super becomeFirstResponder];
}

// 不再是第一响应者
- (BOOL)resignFirstResponder{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    return [super resignFirstResponder];
}

@end
