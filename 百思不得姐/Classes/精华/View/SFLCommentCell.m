//
//  SFLCommentCell.m
//  百思不得姐
//
//  Created by Light on 7-10.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLCommentCell.h"
#import "SFLComment.h"
#import "SFLUser.h"

#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>

@interface SFLCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

/** 播放器 */
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation SFLCommentCell

static BOOL isPlayingCommentVoice;

- (void)setComment:(SFLComment *)comment{
    _comment = comment;
    [self.profileImgView setCircleHeaderWithURLString:comment.user.profile_image];

    // 外观初始化
    NSString *imgName = [comment.user.sex isEqualToString:SFLUserSexMale] ? @"Profile_manIcon" : @"Profile_womanIcon";
    self.sexImgView.image = [UIImage imageNamed:imgName];
    self.contentLabel.text = comment.content;
    self.nameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    
    // 音频播放
    isPlayingCommentVoice = NO;
    if (comment.voiceuri.length) {
        self.voiceBtn.hidden = NO;
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
        [self.voiceBtn addTarget:self action:@selector(voiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.voiceBtn.hidden = YES;
    }
}

- (void)voiceBtnClick {
    if(isPlayingCommentVoice){
        
        NSLog(@"pause");
    }else {
        
        NSLog(@"play");
    }
    isPlayingCommentVoice = !isPlayingCommentVoice;
}

- (void)playingImg {
    
}


#pragma mark - MenuController 处理

- (void)setFrame:(CGRect)frame{
    frame.origin.x = SFLTopicCellMargin;
    frame.size.width -= 2 * SFLTopicCellMargin;
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}

@end
