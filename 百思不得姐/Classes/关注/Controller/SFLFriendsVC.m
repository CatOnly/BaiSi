//
//  SFLFriendsVC.m
//  百思不得姐
//
//  Created by Light on 4-20.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLFriendsVC.h"
#import "SFLRecommendVC.h"
#import "SFLLoginRegisterVC.h"

@interface SFLFriendsVC ()

@end

@implementation SFLFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的关注";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(addFriends)];
    self.view.backgroundColor = SFLGlobalBG;
}

- (void)addFriends{
    [self.navigationController pushViewController:[[SFLRecommendVC alloc] init] animated:YES];
}

- (IBAction)loginRegister:(id)sender {
    [SFLoginTool getUID];
}

@end
