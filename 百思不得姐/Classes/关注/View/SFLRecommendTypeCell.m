//
//  SFLRecommendTypeCell.m
//  百思不得姐
//
//  Created by Light on 5-1.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLRecommendTypeCell.h"
#import "SFLRecommendType.h"
@interface SFLRecommendTypeCell()
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end

@implementation SFLRecommendTypeCell

- (void)setCategory:(SFLRecommendType *)category{
    _category = category;
    self.textLabel.text = category.name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = SFLRGBColor(244, 244, 244);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 设置选中风格
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.y = 1;
    self.textLabel.height = self.contentView.height - 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected ? SFLRGBColor(219, 21, 26) : SFLRGBColor(78, 78, 78);
//    SFLLOG(@"----- setSelected");

}

@end
