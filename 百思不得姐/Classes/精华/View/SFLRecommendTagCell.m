//
//  SFLRecommendTagCell.m
//  百思不得姐
//
//  Created by Light on 5-3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLRecommendTagCell.h"
#import "SFLRecommendTag.h"

#import <UIImageView+WebCache.h>

@interface SFLRecommendTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgListImgV;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end

@implementation SFLRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame{
    NSInteger margin = 6;
    frame.origin.x = margin;
    frame.size.width -= 2 * margin;
    frame.size.height -= 1;
    
    [super setFrame:frame];
}


- (void)setRecmdTag:(SFLRecommendTag *)recmdTag{
    _recmdTag = recmdTag;
    [self.imgListImgV setCircleHeaderWithURLString:recmdTag.image_list];
    
    self.themeNameLabel.text = recmdTag.theme_name;
    
    NSInteger subNumber = recmdTag.sub_number;
    if (subNumber < 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%zd人订阅",subNumber];
    } else {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅",subNumber/10000.0];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
