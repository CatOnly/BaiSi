//
//  SFLComment.m
//  百思不得姐
//
//  Created by Light on 7-9.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLComment.h"
#import "SFLUser.h"

#import <MJExtension.h>

@implementation SFLComment
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

- (CGFloat)cellHeight{
    if (!_cellHeight) {
        _cellHeight = SFLCommentCellTextY;
        if (self.voiceuri.length) {
            _cellHeight += SFLCommentCellVoiceH;
        } else {
            // 文字的最大尺寸
            CGSize textMaxSize = CGSizeMake(SFLScreenW - SFLCommentCellMarginW, MAXFLOAT);
            CGFloat textH = [self.content boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
            // cell的高度
            _cellHeight += textH;
        }
        _cellHeight += SFLTopicCellMargin;
    }
    return _cellHeight;
}
@end
