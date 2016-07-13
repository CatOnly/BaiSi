//
//  VideoPlayView.h
//  02-远程视频播放(AVPlayer)
//
//  Created by apple on 7-12.
//  Copyright (c) 2016年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoPlayViewDelegate <NSObject>

@optional

- (void)videoplayViewSwitchOrientation:(BOOL)isFull;

@end


@interface VideoPlayView : UIView

+ (instancetype)videoPlayView;

@property (weak, nonatomic) id<VideoPlayViewDelegate> delegate;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@end
