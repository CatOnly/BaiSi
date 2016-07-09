//
//  NSDate+SFLExtension.h
//  百思不得姐
//
//  Created by Light on 4-5.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SFLExtension)

/** 比较from和self的时间差值 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;
/** 是否为今年 */
- (BOOL)isThisYear;
/** 是否为今天 */
- (BOOL)isToday;
/** 是否为昨天 */
- (BOOL)isYesterday;

@end
