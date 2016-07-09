//
//  SFLCircleProgressView.m
//  百思不得姐
//
//  Created by Light on 5-7.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLCircleProgressView.h"

@implementation SFLCircleProgressView

- (UIColor *)progressColor{
    if (_progressColor == nil) {
        _progressColor = [UIColor colorWithWhite:1 alpha:0.7];
    }
    return _progressColor;
}

- (CGFloat)progressLineWidth{
    if (!_progressLineWidth) {
        _progressLineWidth = 5;
    }
    return _progressLineWidth;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    // 注意：drawRect不能手动调用,因为图形上下文自己创建不了,只能由系统创建,并传递给我们
    
    // 重新绘制圆弧
    // 系统会先创建 与 view相关联的上下文,然后调用drawRect方法
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //    获取圆形半径大小
    CGFloat radius = rect.size.width * 0.5;
    
    //    创建贝瑟尔路径
    CGPoint center = CGPointMake(radius, radius);
    CGFloat endAngle = -M_PI_2 + _progress * M_PI * 2;
    
    // clockwise : 是否 是顺时针
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius-25 startAngle:-M_PI_2 endAngle:endAngle clockwise:YES];
    
    path.lineWidth = self.progressLineWidth;
    path.lineCapStyle = kCGLineCapRound; // 线端点有弧度
    //    设置上下文状态: 所有路径都会保持一致，要像修改上下文，在设置一次就好
    //    上下文：内存缓存区
    [self.progressColor setStroke]; // 设置线颜色
    //    描边
    [path stroke]; // 正式描边
}

@end
