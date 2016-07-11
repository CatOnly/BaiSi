//
//  UIImageView+SFLExtension.m
//  百思不得姐
//
//  Created by Light on 7-11.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "UIImageView+SFLExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (SFLExtension)

- (void)setCircleHeaderWithURLString:(NSString *)url{
    UIImage *placeholderImage = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholderImage;
    }];
}

@end
