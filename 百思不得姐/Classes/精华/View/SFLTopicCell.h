//
//  SFLTopicCell.h
//  百思不得姐
//
//  Created by Light on 5-5.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFLTopic;
@interface SFLTopicCell : UITableViewCell

/** 帖子数据 */
@property (nonatomic,strong) SFLTopic *topic;

+ (instancetype)cell;
@end
