//
//  SFLRecommedTag.m
//  百思不得姐
//
//  Created by Light on 5-3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLRecommendTag.h"

@implementation SFLRecommendTag

+ (instancetype)recmdTagWithDic:(NSDictionary *)dic {
    SFLRecommendTag *r = [[SFLRecommendTag alloc] init];
    r.theme_name = dic[@"theme_name"];
    r.image_list = dic[@"image_list"];
    r.sub_number = [dic[@"sub_number"] integerValue];
    return r;
}
@end
