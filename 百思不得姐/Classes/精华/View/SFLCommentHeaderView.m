//
//  SFLCommentHeaderView.m
//  百思不得姐
//
//  Created by Light on 7-10.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLCommentHeaderView.h"
@interface SFLCommentHeaderView()
/** 文字标签 */
@property (nonatomic, weak) UILabel *label;

@end

static NSString * const SFLCommentHeaderViewID = @"header";

@implementation SFLCommentHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    SFLCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SFLCommentHeaderViewID];
    if (header == nil) { // 缓存池中没有, 自己创建
        header = [[SFLCommentHeaderView alloc] initWithReuseIdentifier:SFLCommentHeaderViewID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = SFLGlobalBG;
        
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = SFLRGBColor(67, 67, 67);
        label.font = [UIFont systemFontOfSize:14];
        label.width = 200;
        label.textAlignment = NSTextAlignmentJustified;
        label.x = SFLTopicCellMargin * 1.5;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.label.text = title;
}

@end
