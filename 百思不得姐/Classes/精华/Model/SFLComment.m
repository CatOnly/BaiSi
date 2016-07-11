//
//  SFLComment.m
//  百思不得姐
//
//  Created by Light on 7-9.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLComment.h"
#import "SFLUser.h"

#import <MJExtension.h>

@implementation SFLComment
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end
