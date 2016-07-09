//
//  SFLRecommendDisplayCell.m
//  百思不得姐
//
//  Created by Light on 5-2.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLRecommendDisplayCell.h"
#import "SFLRecommendDisplay.h"

#import <UIImageView+WebCache.h>

@interface SFLRecommendDisplayCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation SFLRecommendDisplayCell

- (void)setDisplayCard:(SFLRecommendDisplay *)displayCard{
    _displayCard = displayCard;
    
    self.screenNameLabel.text = displayCard.screen_name;
    NSInteger fansCount = displayCard.fans_count;
    if (fansCount < 10000) {
        self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注",fansCount];
    } else {
        self.fansCountLabel.text = [NSString stringWithFormat:@"%.1f万人关注",fansCount/10000.0];
    }

    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:displayCard.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
