//
//  SFLRecommendType.h
//  百思不得姐
//
//  Created by Light on 5-1.
//  Copyright © 2016年 Light. All rights reserved.
//  推荐关注 左边的数据模型

#import <Foundation/Foundation.h>

@interface SFLRecommendType : NSObject
{
    /** 当前对象对应的要展示的数据内容 */
    NSMutableArray *_displayCards;
}
/** id */
@property (nonatomic, assign) NSInteger id;
/** 总数 */
@property (nonatomic, assign) NSInteger count;
/** 名字 */
@property (nonatomic, copy) NSString *name;

/** 总个数 */
@property (nonatomic,assign) NSInteger total;
/** 当前页码 */
@property (nonatomic,assign) NSInteger currentPage;


+ (instancetype)typeWithDic:(NSDictionary *)dic;
- (void)setDisplayCards:(NSArray *)array;
- (void)addDisplayCards:(NSArray *)array;

- (NSMutableArray *)displayCards;
@end
