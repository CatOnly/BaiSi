//
//  SFLRecommendType.m
//  百思不得姐
//
//  Created by Light on 5-1.
//  Copyright © 2016年 Light. All rights reserved.
//  推荐关注 左边的数据模型

#import "SFLRecommendType.h"
#import "SFLRecommendDisplay.h"
@implementation SFLRecommendType

- (void)setDisplayCards:(NSArray *)array{
    NSMutableArray *displayCards = nil;
    if (array.count){
        displayCards = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            [displayCards addObject:[SFLRecommendDisplay cardWithDic:dic]];
        }
    }
    if (_displayCards != nil) {
        [_displayCards removeAllObjects];
    }

    _displayCards = displayCards;
}

- (void)addDisplayCards:(NSArray *)array{
    for (NSDictionary *dic in array) {
        [_displayCards addObject:[SFLRecommendDisplay cardWithDic:dic]];
    }
}

- (NSMutableArray *)displayCards{
    if (_displayCards == nil) {
        _displayCards = [NSMutableArray array];
    }
    return _displayCards;
}

+ (instancetype)typeWithDic:(NSDictionary *)dic{
    SFLRecommendType *type = [[SFLRecommendType alloc] init];
    [type setValuesForKeysWithDictionary:dic];
    return type;
}

@end
