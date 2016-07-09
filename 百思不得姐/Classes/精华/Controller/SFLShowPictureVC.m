//
//  SFLShowPictureVC.m
//  百思不得姐
//
//  Created by Light on 5-7.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLShowPictureVC.h"
#import "SFLTopic.h"
#import "SFLCircleProgressView.h"

#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface SFLShowPictureVC ()
/** 使大图滚动的视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *scorllView;

/** 进度条视图 */
@property (weak, nonatomic) IBOutlet SFLCircleProgressView *progressView;
/** 进度指示数字 */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

/** 显示的图片 */
@property (nonatomic,strong) UIImageView *imgView;
@end

@implementation SFLShowPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加图片视图，来显示图片
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.scorllView addSubview:imgView];
    self.imgView = imgView;
    
    // 设置图片点按
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    
    // 设置图片大小
    CGFloat picW = SFLScreenW;
    CGFloat picH = picW * self.topic.height / self.topic.width;
    
    if (picH > SFLScreenH) {
        imgView.frame = CGRectMake(0, 0, picW, picH);
        self.scorllView.contentSize = CGSizeMake(0, picH); //宽为 0 ，左右不能滚动
    } else {
        imgView.size = CGSizeMake(picW, picH);
        imgView.centerY = SFLScreenH * 0.5;
    }
    
    // 立刻显示下载进度
    self.progressView.progress = self.topic.pictureProgress;

    // 下载图片 和 下载进度
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        self.progressLabel.hidden = NO;
        
        self.topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        self.progressView.progress = self.topic.pictureProgress;
        self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(self.topic.pictureProgress * 100)];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        self.progressLabel.hidden = YES;
    }];
}

- (IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save{
    if (self.imgView.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"图片未下载完成！"];
        return;
    }
    // 将图片写入相册
    UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
    }
}
@end
