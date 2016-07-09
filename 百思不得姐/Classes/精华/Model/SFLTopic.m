//
//  SFLTopic.m
//  百思不得姐
//
//  Created by Light on 5-5.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTopic.h"

@implementation SFLTopic
{   // @implementation 中的默认私有
    CGFloat _cellHeight;
    CGRect _pictureFrame;
}

+ (instancetype)topicWithDic:(NSDictionary *)dic{
    SFLTopic *topic = [[SFLTopic alloc] init];
    topic.name = dic[@"name"];
    topic.profile_image = dic[@"profile_image"];
    topic.create_time = dic[@"create_time"];
    topic.ding = [dic[@"love"] integerValue];
    topic.cai = [dic[@"cai"] integerValue];
    topic.repost = [dic[@"repost"] integerValue];
    topic.comment = [dic[@"comment"] integerValue];
    topic.sina_v = [dic[@"sina_v"] boolValue];
    
    topic.type = (SFLTopicType)[dic[@"type"] integerValue];
    topic.text = dic[@"text"];
    topic.width = [dic[@"width"] integerValue];
    topic.height = [dic[@"height"] integerValue];
    topic.small_image = dic[@"image0"];
    topic.middle_image = dic[@"image2"];
    topic.large_image = dic[@"image1"];


    return topic;
}

- (NSString *)create_time {
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }
}

- (CGFloat)cellHeight{
    // 防止重复计算
    if (!_cellHeight) {
        // 文字的最大尺寸
        CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4 * SFLTopicCellMargin, MAXFLOAT);
        
        CGFloat textH = [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // cell的高度
        _cellHeight = SFLTopicCellTextY + textH + SFLTopicCellMargin;
        
        // 设置默认值
        self.isBigPicture = NO;
        
        // 根据 内容类型 计算 cell 高度
        if (self.type == SFLTopicTypePicture) {
            // 图片尺寸自适应
            CGFloat pictureW = textMaxSize.width;
            CGFloat pictureH = pictureW * self.height / self.width;
            
            // 图片高度过长
            if (pictureH >= SFLTopicCellPictureMaxH) {
                pictureH = SFLTopicCellPictureBreakH;
                self.isBigPicture = YES; // 大图
            }
            
            // 计算图片控件的frame
            CGFloat pictureX = SFLTopicCellMargin;
            CGFloat pictureY = _cellHeight;
            _pictureFrame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            // 计算 cell 的高度
            _cellHeight = pictureY + pictureH + SFLTopicCellMargin;
        } else if (self.type == SFLTopicTypeVoice) {
            // 声音帖子
            
        }
        
        _cellHeight += SFLTopicCellMargin + SFLTopicCellBottomBarH;
    }
    return _cellHeight;
}
@end
