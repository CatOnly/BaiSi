//
//  SFLFooterView.m
//  百思不得姐
//
//  Created by Light on 7-11.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLMeFooterView.h"
#import "SFLMeSquare.h"
#import "SFLMeSquareBtn.h"
#import "SFLWebVC.h"

#import <AFNetworking.h>
#import <MJExtension.h>

@implementation SFLMeFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *sqaures = [SFLMeSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            // 创建方块
            [self createSquares:sqaures];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

- (void)createSquares:(NSArray *)squares{
    // 一行最多4列
    int maxCols = 4;
    
    // 宽度和高度
    CGFloat buttonW = SFLScreenW / maxCols;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i<squares.count; i++) {
        // 创建按钮
        SFLMeSquareBtn *btn = [SFLMeSquareBtn buttonWithType:UIButtonTypeCustom];
        // 监听点击
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        btn.square = squares[i];
        [self addSubview:btn];
        
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        btn.x = col * buttonW;
        btn.y = row * buttonH;
        btn.width = buttonW;
        btn.height = buttonH;
    }
    // 总页数 == (总个数 + 每页的最大数 - 1) / 每页最大数
    NSUInteger rows = (squares.count/2 + maxCols - 1) / maxCols;
    // 计算footer的高度
    self.height = rows * buttonH;
    // 重绘
    [self setNeedsDisplay];
}

- (void)buttonClick:(SFLMeSquareBtn *)btn{
    if (![btn.square.url hasPrefix:@"http"]) return;
    
    SFLWebVC *web = [[SFLWebVC alloc] init];
    web.url = btn.square.url;
    web.title = btn.square.name;
    
    // 取出当前的导航控制器
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVc.selectedViewController;
    [nav pushViewController:web animated:YES];
}

@end
