//
//  SFLRecommendDisplay.m
//  百思不得姐
//
//  Created by Light on 5-2.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLRecommendDisplay.h"

@implementation SFLRecommendDisplay
+ (instancetype)cardWithDic:(NSDictionary *)dic{
    SFLRecommendDisplay *card = [[SFLRecommendDisplay alloc] init];
    card.header = dic[@"header"];
    card.fans_count = [dic[@"fans_count"] integerValue];
    card.screen_name = dic[@"screen_name"];

    return card;
}
@end
