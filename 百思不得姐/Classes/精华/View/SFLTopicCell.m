//
//  SFLTopicCell.m
//  百思不得姐
//
//  Created by Light on 5-5.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTopicCell.h"
#import "SFLTopic.h"
#import "SFLTopicPictureView.h"

#import <UIImageView+WebCache.h>

@interface SFLTopicCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;

@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 帖子的文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *text_label;

/** 图片帖子中间的内容 */
@property (nonatomic,weak) SFLTopicPictureView *pictureView;

@end

@implementation SFLTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgImgView;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = SFLTopicCellMargin;
    frame.origin.y += SFLTopicCellMargin;
    frame.size.width  -= SFLTopicCellMargin * 2;
    frame.size.height -= SFLTopicCellMargin;
    [super setFrame:frame];
}

- (SFLTopicPictureView *)pictureView{
    if (_pictureView == nil) {
       SFLTopicPictureView *pv = [SFLTopicPictureView pictureView];
        [self.contentView addSubview:pv];
        _pictureView = pv;
    }
    return _pictureView;
}

- (void)setTopic:(SFLTopic *)topic{
    _topic = topic;
    
    // 新浪加V
    self.sinaVView.hidden = !topic.isSina_v;
    
    // 设置头像
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    // 设置名字
    self.nameLabel.text = topic.name;
    
    // 设置帖子的创建时间
    self.createTimeLabel.text = topic.create_time;
    
    // 设置按钮文字
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
    
    // 设置帖子文字内容
    self.text_label.text = topic.text;
    
    // 根据模型类型(帖子类型)添加对应的内容到 cell 的中间
    if (topic.type == SFLTopicTypePicture) { // 图片帖子
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureFrame;
    } else if (topic.type == SFLTopicTypeVoice) { // 声音帖子
        //        self.voiceView.topic = topic;
        //        self.voiceView.frame = topic.voiceF;
    } else {
        self.pictureView.hidden = YES;
    }

}

- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder {
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
}

@end
