//
//  SFLTopicCell.m
//  百思不得姐
//
//  Created by Light on 5-5.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTopicCell.h"
#import "SFLTopic.h"
#import "SFLTopicTableVC.h"

#import "SFLTopicPictureView.h"
#import "SFLTopicVoiceView.h"
#import "SFLTopicVideoView.h"
#import "SFLCommentVC.h"
#import "SFLComment.h"
#import "SFLUser.h"

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
/** 声音帖子内容 */
@property (nonatomic,weak) SFLTopicVoiceView *voiceView;
/** 视频帖子内容 */
@property (nonatomic,weak) SFLTopicVideoView *videoView;
/** 最热评论整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
/** 最热评论内容*/
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;


@end

@implementation SFLTopicCell

+ (instancetype)cell {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgImgView;
    
    // btn 设置
    [self.dingButton addTarget:self action:@selector(dingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.caiButton addTarget:self action:@selector(caiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = SFLTopicCellMargin;
    frame.origin.y += SFLTopicCellMargin;
    frame.size.width  -= SFLTopicCellMargin * 2;
    frame.size.height = self.topic.cellHeight - SFLTopicCellMargin;
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

- (SFLTopicVoiceView *)voiceView{
    if (_voiceView == nil) {
        SFLTopicVoiceView *cv = [SFLTopicVoiceView voiceView];
        [self.contentView addSubview:cv];
        _voiceView = cv;
    }
    return _voiceView;
}

- (SFLTopicVideoView *)videoView{
    if (_videoView == nil) {
        SFLTopicVideoView *v = [SFLTopicVideoView videoView];
        [self.contentView addSubview:v];
        _videoView = v;
    }
    return _videoView;
}



- (void)setTopic:(SFLTopic *)topic{
    _topic = topic;
    
    // 新浪加V
    self.sinaVView.hidden = !topic.isSina_v;
    
    // 设置头像
    [self.profileImageView setCircleHeaderWithURLString:topic.profile_image];
    
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
    
    self.pictureView.hidden = YES;
    self.voiceView.hidden = YES;
    self.videoView.hidden = YES;

    // 根据模型类型(帖子类型)添加对应的内容到 cell 的中间
    if (topic.type == SFLTopicTypePicture) { // 图片帖子
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureFrame;
    } else if (topic.type == SFLTopicTypeVoice) { // 声音帖子
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceFrame;
    } else if (topic.type == SFLTopicTypeVideo){
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoFrame;
    }
    
    // 处理最热评论
    if (topic.top_cmt) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", topic.top_cmt.user.username, topic.top_cmt.content];
    } else {
        self.topCmtView.hidden = YES;
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
- (IBAction)more:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"举报"style:UIAlertActionStyleDestructive handler:nil];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"收藏"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SFLoginTool getUID];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self.tableVC presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 低栏四按钮设置
- (void)dingBtnClick{
    self.caiButton.enabled = NO;
}

- (void)caiBtnClick{
    self.dingButton.enabled = NO;
}

- (void)shareBtnClick{
    
}

- (void)commentBtnClick{
    SFLCommentVC *commentVC = [[SFLCommentVC alloc] init];
    commentVC.topic = self.topic;
    [self.tableVC.navigationController pushViewController:commentVC animated:YES];
}

@end
