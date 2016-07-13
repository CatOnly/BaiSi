//
//  SFLVoiceView.m
//  百思不得姐
//
//  Created by Light on 7-9.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTopicVoiceView.h"
#import "SFLTopic.h"
#import "SFLShowPictureVC.h"

#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>

@interface SFLTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

// 音乐播放工具条
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playBtnHorizonCaonstraint;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *progressTimeLabel;
/* 播放器 */
@property (nonatomic, strong) AVPlayer *player;
/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

@end

static SFLTopicVoiceView *lastTopicVoiceView;

@implementation SFLTopicVoiceView

- (void)setTopic:(SFLTopic *)topic{
    _topic = topic;
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd次播放",topic.playcount];
    self.voicetimeLabel.text = timeFormatWithSec(topic.voicetime);
//    [self pauseMusic];
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithURL:[NSURL URLWithString:self.topic.voiceuri]];
    }
    return _player;
}

+ (instancetype)voiceView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听
    self.bgImgView.userInteractionEnabled = YES;
    [self.bgImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
    
    // 播放音乐工具条
    [self.playBtn addTarget:self action:@selector(playOrPauseMusic) forControlEvents:UIControlEventTouchUpInside];
    self.toolView.hidden = YES;
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    [self removeProgressTimer];
    [self addProgressTimer];
}

- (void)showPicture{
    SFLShowPictureVC *showPicture = [[SFLShowPictureVC alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

#pragma mark - 播放音乐

// 播放或暂停音乐
- (void)playOrPauseMusic {
    
//    if (isPlaying && self.playBtnHorizonCaonstraint.constant == 0) return;
//    if (self.playBtnHorizonCaonstraint.constant == 0){
//        [self playMusic];
//    } else {
//        [self pauseMusic];
//    }
    
    if (!self.playBtn.selected) {
        if (lastTopicVoiceView != self && lastTopicVoiceView != nil) {
            [lastTopicVoiceView pauseMusic];
        }
        [self playMusic];
        lastTopicVoiceView = self;
    } else {
        [self pauseMusic];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)playMusic{
    self.voicetimeLabel.hidden = YES;
    self.playcountLabel.hidden = YES;
    self.playBtn.selected = YES;
    self.toolView.hidden = NO;

    self.playBtnHorizonCaonstraint.constant = self.playBtn.width - SFLScreenW * 0.5 - 10;
    [self.player play];
    [self addProgressTimer];
}

- (void)pauseMusic{
    self.voicetimeLabel.hidden = NO;
    self.playcountLabel.hidden = NO;
    self.playBtn.selected = NO;
    self.toolView.hidden = YES;
    
    self.playBtnHorizonCaonstraint.constant = 0;
    [self.player pause];
    _player = nil;
    [self removeProgressTimer];
}

- (IBAction)slider {
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
}

- (IBAction)startSlider {
    [self removeProgressTimer];
}

- (IBAction)sliderValueChange {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.progressTimeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}


- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

#pragma mark - 定时器制作
- (void)addProgressTimer {
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo {
    // 1.更新时间
    self.progressTimeLabel.text = [self timeString];
    
    // 2.设置进度条的value
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
}

- (NSString *)timeString {
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}

@end
