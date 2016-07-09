//
//  SFLVoiceView.m
//  百思不得姐
//
//  Created by Light on 7-9.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTopicVoiceView.h"
#import "SFLTopic.h"

#import "UIImageView+WebCache.h"

@interface SFLTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@end

@implementation SFLTopicVoiceView

+ (instancetype)voiceView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(SFLTopic *)topic{
    _topic = topic;
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    self.voicetimeLabel.text = timeFormatWithSec(topic.voicetime);
}

@end
