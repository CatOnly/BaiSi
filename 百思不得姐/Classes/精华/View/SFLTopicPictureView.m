//
//  SFLTopicPictureView.m
//  百思不得姐
//
//  Created by Light on 5-6.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTopicPictureView.h"
#import "SFLTopic.h"
#import "SFLShowPictureVC.h"
#import "SFLCircleProgressView.h"

#import <UIImageView+WebCache.h>

@interface SFLTopicPictureView()

/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifImgView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigImgBtn;

/** 图片下载具体进度数据 */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
/** 图片下载进度指示器 */
@property (weak, nonatomic) IBOutlet SFLCircleProgressView *progressView;


@end

@implementation SFLTopicPictureView

+ (instancetype)pictureView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 给图片添加监听
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture{
    SFLShowPictureVC *showPicture = [[SFLShowPictureVC alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

- (void)setTopic:(SFLTopic *)topic{
    _topic = topic;
    
    // 立刻显示最新的进度值(防止因为网速慢显示其他的 Cell)
    self.progressView.progress = topic.pictureProgress;
    
    // 下载图片
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        // 更新进度值
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        self.progressView.progress = topic.pictureProgress;
        self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(topic.pictureProgress * 100)];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        // 如果不是大图，以后的操作不执行
        if (!self.topic.isBigPicture) return;
        // 开启图形上下文
        UIGraphicsBeginImageContext(self.topic.pictureFrame.size);
        
        // 将下载完的 img 图像绘制到上下文中
        CGFloat rectW = self.topic.pictureFrame.size.width;
        CGFloat rectH = rectW * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, rectW, rectH)];
        // 获得图片
        self.imgView
        .image =  UIGraphicsGetImageFromCurrentImageContext();
        // 结束图形上下文
        UIGraphicsEndImageContext();
    }];
    
    // 判断图片类型
    NSString *imgExtertion = topic.large_image.pathExtension;
    // 如果不知道图片类型，需要取出图片的第一个字节，才可以判断图片的类型
    self.gifImgView.hidden = ![imgExtertion.lowercaseString isEqualToString:@"gif"];
    
    // 是否显示查看全图
    if (topic.isBigPicture) {
        self.seeBigImgBtn.hidden = NO;
        self.imgView.contentMode = UIViewContentModeScaleToFill;
    } else {
        self.seeBigImgBtn.hidden = YES;
        self.imgView.contentMode = UIViewContentModeScaleToFill;
    }
    
}

@end
