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

/** 正在显示的下标 */
@property (nonatomic, assign) int showingImgIdx;
/** 音频播放 */
@property (nonatomic, strong) AVPlayer *player;
@end

static SFLCommentCell *currentPlayingVoiceCell;

@implementation SFLCommentCell

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
    if (comment.voiceuri.length) {
        self.voiceBtn.hidden = NO;
        self.voiceBtn.selected = NO;
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
        [self.voiceBtn addTarget:self action:@selector(voiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.voiceBtn.hidden = YES;
    }
}

- (void)voiceBtnClick {
    if (currentPlayingVoiceCell == nil) {
        SFLLOG(@"播放 - 无 正在播放的");
        [self playVoice];
    } else if (currentPlayingVoiceCell == self) {
        SFLLOG(@"停止 - 自己 是 正在播放的");
        [self pauseVoice];
    } else {
        SFLLOG(@"停止 - 自己 不是 正在播放的");
        [currentPlayingVoiceCell pauseVoice];
        SFLLOG(@"播放 - 有 正在播放，关了 播新的");
        [self playVoice];
    }

}

- (void)playVoice {
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.comment.voiceuri]];
    [self.player play];
    self.voiceBtn.selected = YES;
    currentPlayingVoiceCell = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.comment.voicetime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 同一个 player 说明完整的播放完了，关掉显示
        if (currentPlayingVoiceCell.player == self.player){
            self.voiceBtn.selected = NO;
            currentPlayingVoiceCell = nil;
            SFLLOG(@"停止 - 时间到");
        }
    });
}

- (void)pauseVoice{
    [self.player pause];
    _player = nil;
    self.voiceBtn.selected = NO;
    currentPlayingVoiceCell = nil;
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
