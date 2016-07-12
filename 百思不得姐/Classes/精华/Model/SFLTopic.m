//
//  SFLTopic.m
//  百思不得姐
//
//  Created by Light on 5-5.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTopic.h"
#import "SFLUser.h"
#import "SFLComment.h"

#import <MJExtension.h>

@implementation SFLTopic
{   // @implementation 中的默认私有
    CGFloat _cellHeight;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    //    return @{@"top_cmt" : [XMGComment class]};
    return @{@"top_cmt" : [SFLComment class]};
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
        CGSize textMaxSize = CGSizeMake(SFLScreenW - 4 * SFLTopicCellMargin, MAXFLOAT);
        
        CGFloat textH = [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // cell的高度
        _cellHeight = SFLTopicCellTextY + textH + SFLTopicCellMargin;
        
        // 设置默认值
        self.isBigPicture = NO;
        
        CGFloat width = textMaxSize.width;
        // 根据 内容类型 计算 cell 高度
        if (self.type == SFLTopicTypePicture) {
            // 图片尺寸自适应
            CGFloat pictureH = width * self.height / self.width;
            // 图片高度过长
            if (pictureH >= SFLTopicCellPictureMaxH) {
                pictureH = SFLTopicCellPictureBreakH;
                self.isBigPicture = YES; // 大图
            }
            // 计算图片控件的frame
            _pictureFrame = CGRectMake(SFLTopicCellMargin, _cellHeight, width, pictureH);
            // 计算 cell 的高度
            _cellHeight += pictureH + SFLTopicCellMargin;
        } else if (self.type == SFLTopicTypeVoice) {
            CGFloat voiceH = width * self.height / self.width;
            _voiceFrame = CGRectMake(SFLTopicCellMargin, _cellHeight, width, voiceH);
            _cellHeight += voiceH + SFLTopicCellMargin;
        } else if (self.type == SFLTopicTypeVideo){
            CGFloat videoH = width * self.height / self.width;
            _videoFrame = CGRectMake(SFLTopicCellMargin, _cellHeight, width, videoH);
            _cellHeight += videoH + SFLTopicCellMargin;
        }
        
        // 如果有最热评论
        if (self.top_cmt) {
            NSString *content = [NSString stringWithFormat:@"%@: %@", self.top_cmt.user.username, self.top_cmt.content];
            CGFloat contentH = [content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
            _cellHeight += SFLTopicCellTopCmtTitleH + contentH + SFLTopicCellMargin;
        }
        
        _cellHeight += SFLTopicCellMargin + SFLTopicCellBottomBarH;
    }
    return _cellHeight;
}
@end
