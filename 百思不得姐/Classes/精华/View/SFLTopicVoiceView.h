//
//  SFLVoiceView.h
//  百思不得姐
//
//  Created by Light on 7-9.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFLTopic;
@interface SFLTopicVoiceView : UIView

/** 帖子数据 */
@property (nonatomic,strong) SFLTopic *topic;

+ (instancetype)voiceView;

@end
