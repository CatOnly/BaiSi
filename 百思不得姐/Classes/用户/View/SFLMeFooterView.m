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

@interface SFLMeFooterView() <UIScrollViewDelegate>
/** 分页控制器 */
@property (nonatomic, weak) UIPageControl *pageCotrol;

@end

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
            [self addScrollViewWithSquares:sqaures];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}


- (void)addScrollViewWithSquares:(NSArray *)squares{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.pagingEnabled = YES;
    contentView.showsHorizontalScrollIndicator = NO;
    
    int col = 4;     // 一行 col 列占满屏幕宽度
    int maxRow = 4;  // 一列一共有 maxRow 行
    NSInteger totalNumber = squares.count;
    int maxCol = 1.0 * totalNumber / maxRow;
    // 宽度和高度
    CGFloat buttonW = SFLScreenW / col;
    CGFloat buttonH = buttonW;
    CGFloat footerHeight = maxRow * buttonH;
    contentView.frame = CGRectMake(0, 0, SFLScreenW, footerHeight);
    contentView.contentSize = CGSizeMake(maxCol * buttonW, 0);
    contentView.delegate = self;
    
    // 分页控制器
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.centerX = self.centerX;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.numberOfPages = totalNumber / (col * maxRow);
    pageControl.y = footerHeight + 15;
    self.pageCotrol = pageControl;
    
    // 计算footer的高度
    self.height = footerHeight + 20;
    
    for (int i = 0; i < totalNumber; i++) {
        // 创建按钮
        SFLMeSquareBtn *btn = [SFLMeSquareBtn buttonWithType:UIButtonTypeCustom];
        
        // 计算frame
        int col = i % maxCol;
        int row = i / maxCol;
        
        btn.x = col * buttonW;
        btn.y = row * buttonH;
        btn.width = buttonW;
        btn.height = buttonH;
        
        // 监听点击
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        btn.square = squares[i];
        [contentView addSubview:btn];
    }
    // 总页数 == (总个数 + 每页的最大数 - 1) / 每页最大数
    [self addSubview:pageControl];
    [self addSubview:contentView];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageCotrol.currentPage = scrollView.contentOffset.x / SFLScreenW;
}
@end
