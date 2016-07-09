//
//  SFLMeVC.m
//  百思不得姐
//
//  Created by Light on 4-20.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLMeVC.h"

@interface SFLMeVC ()

@end

@implementation SFLMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.navigationItem.rightBarButtonItems =@[
                                              [UIBarButtonItem itemWithImage:@"mine-setting-icon"
                                                                   highImage:@"mine-setting-icon-click"
                                                                      target:self
                                                                      action:@selector(settingClick)],
                                              [UIBarButtonItem itemWithImage:@"mine-moon-icon"
                                                                   highImage:@"mine-moon-icon-click"
                                                                      target:self
                                                                      action:@selector(moonClick)]
                                              
                                              ];
    self.view.backgroundColor = SFLGlobalBG;

}

- (void)settingClick{
    
}

- (void)moonClick{
    
}
@end
