//
//  SFLTopicVideo.m
//  百思不得姐
//
//  Created by Light on 7-9.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTopicVideoView.h"
#import "SFLTopic.h"
#import "SFLShowPictureVC.h"

#import "VideoPlayView.h"
#import "FullViewController.h"

#import <UIImageView+WebCache.h>

@interface SFLTopicVideoView()<VideoPlayViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) VideoPlayView *playView;
/** 视频全屏控制器 */
@property (strong, nonatomic) FullViewController *fullVc;

@end

static SFLTopicVideoView *lastTopicVideoView;

@implementation SFLTopicVideoView

+ (instancetype)videoView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听
    self.bgImgView.userInteractionEnabled = YES;
    [self.bgImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
    // 给视频添加监听
    [self.playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTopic:(SFLTopic *)topic{
    _topic = topic;
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd次播放",topic.playcount];
    self.videotimeLabel.text = timeFormatWithSec(topic.videotime);
    
    // 清除数据，防止循环利用带来的问题
    [self clearLastTopicVideoView];
}

#pragma - 图片展示
- (void)showPicture{
    SFLShowPictureVC *showPicture = [[SFLShowPictureVC alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}


#pragma mark - 视频播放
- (void)playVideo {
    if (lastTopicVideoView != self && lastTopicVideoView != nil){
        [self clearLastTopicVideoView];
    }
    [self setupVideoPlayView];
    lastTopicVideoView = self;
}

- (void)clearLastTopicVideoView{
    UIView *superview = lastTopicVideoView.superview;
    lastTopicVideoView.playView.playerItem = nil;
    [lastTopicVideoView.playView removeFromSuperview];
    [superview layoutIfNeeded];
}

- (void)setupVideoPlayView {
    VideoPlayView *playView = [VideoPlayView videoPlayView];
    // self.width * 9 / 16
    playView.frame = CGRectMake(0, 0, self.width, self.height);
    [self addSubview:playView];
    self.playView = playView;
    self.playView.delegate = self;
    self.playView.playerItem= [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.videouri]];
}

// 全屏
- (FullViewController *)fullVc {
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    
    return _fullVc;
}

- (void)videoplayViewSwitchOrientation:(BOOL)isFull {
    if (isFull) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.fullVc animated:YES completion:^{
            self.playView.frame = self.fullVc.view.bounds;
            [self.fullVc.view addSubview:self.playView];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:YES completion:^{
            // self.width * 9 / 16
            self.playView.frame = CGRectMake(0, 0, self.width, self.height);
            [self addSubview:self.playView];
        }];
    }
}

@end
