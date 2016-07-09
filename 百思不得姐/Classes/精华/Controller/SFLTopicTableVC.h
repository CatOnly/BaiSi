//
//  SFLTopicTableVC.h
//  百思不得姐
//
//  Created by Light on 5-4.
//  Copyright © 2016年 Light. All rights reserved.
//  最基本的帖子的父类

#import <UIKit/UIKit.h>

@interface SFLTopicTableVC : UITableViewController

+ (instancetype)topicWithType:(SFLTopicType)type;
@end
