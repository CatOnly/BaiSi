//
//  SFLUser.h
//  百思不得姐
//
//  Created by Light on 7-9.
//  Copyright © 2016年 Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFLUser : NSObject
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 用户 */
@property (nonatomic, strong) SFLUser *user;

@end
