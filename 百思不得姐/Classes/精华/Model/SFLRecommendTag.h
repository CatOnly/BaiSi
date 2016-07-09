//
//  SFLRecommedTag.h
//  百思不得姐
//
//  Created by Light on 5-3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFLRecommendTag : NSObject

/** 图片 */
@property (nonatomic, copy) NSString *image_list;
/** 名字 */
@property (nonatomic, copy) NSString *theme_name;
/** 订阅数 */
@property (nonatomic, assign) NSInteger sub_number;

+ (instancetype)recmdTagWithDic:(NSDictionary *)dic;
@end
