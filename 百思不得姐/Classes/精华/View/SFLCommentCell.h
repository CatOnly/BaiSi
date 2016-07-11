//
//  SFLCommentCell.h
//  百思不得姐
//
//  Created by Light on 7-10.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFLComment;
@interface SFLCommentCell : UITableViewCell

/** 评论模型 */
@property (nonatomic,strong) SFLComment *comment;

@end
