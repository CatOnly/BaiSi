//
//  SFLoginTool.m
//  百思不得姐
//
//  Created by Light on 7-12.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLoginTool.h"
#import "SFLLoginRegisterVC.h"

@implementation SFLoginTool

+ (NSString *)getUID{
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    SFLLoginRegisterVC *loginVC = [[SFLLoginRegisterVC alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVC animated:YES completion:nil];
    return uid;
}

+ (void)setUID:(NSString *)uid{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
