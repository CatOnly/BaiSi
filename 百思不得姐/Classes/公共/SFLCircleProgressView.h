//
//  SFLCircleProgressView.h
//  百思不得姐
//
//  Created by Light on 5-7.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFLCircleProgressView : UIView

/** 进度，范围 0 ~ 1 */
@property (nonatomic, assign) CGFloat progress;
/** 进度条颜色 */
@property (nonatomic, strong) UIColor *progressColor;
/** 进度条宽度 */
@property (nonatomic, assign) CGFloat progressLineWidth;

@end
