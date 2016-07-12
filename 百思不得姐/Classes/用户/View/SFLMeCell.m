
//
//  SFLMeCell.m
//  百思不得姐
//
//  Created by Light on 7-11.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLMeCell.h"

@implementation SFLMeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgImgView;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 5;
    if (self.imageView.image != nil) {
        self.imageView.height = self.height - 2 * margin;
        self.imageView.width = self.imageView.height;
        self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + SFLTopicCellMargin;
    }
}
@end
