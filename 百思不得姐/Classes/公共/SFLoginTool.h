//
//  SFLoginTool.h
//  百思不得姐
//
//  Created by Light on 7-12.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFLoginTool : NSObject

/** 检测是否登入，是：返回UID字符串，否：返回 nil */
+ (NSString *)getUID;
+ (void)setUID:(NSString *)uid;

@end
