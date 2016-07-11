//
//  SFLInsertLabel.m
//  百思不得姐
//
//  Created by Light on 7-9.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLInsertLabel.h"
#define margin 3

@implementation SFLInsertLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {margin, margin, margin, margin};
//    rect = CGRectMake(0, 0, rect.size.width + margin, rect.size.height + margin);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (void)awakeFromNib{
    self.adjustsFontSizeToFitWidth = YES;
    self.textAlignment = NSTextAlignmentNatural;
}
@end
