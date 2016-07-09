//
//  SFLEssenceVC.m
//  百思不得姐
//
//  Created by Light on 4-20.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLEssenceVC.h"
#import "SFLRecommendTagsVC.h"
#import "SFLTopicTableVC.h"

@interface SFLEssenceVC ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *currentSelectedBtn;
/** 标签栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 总内容视图 */
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation SFLEssenceVC

// 底部红色指示器
- (UIView *)indicatorView{
    if (_indicatorView == nil) {
        UIView *indicatorView = [[UIView alloc] init];
        indicatorView.backgroundColor = [UIColor redColor];
        indicatorView.tag = -1;
        indicatorView.height = 2;
        indicatorView.y = self.titlesView.height - indicatorView.height;
        [self.titlesView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

// 标题栏
- (UIView *)titlesView{
    if (_titlesView == nil) {
        // 标签栏整体
        UIView *titlesView = [[UIView alloc] init];
        titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        titlesView.width = self.view.width;
        titlesView.height = SFLTitlesViewH;
        titlesView.y = SFLTitlesViewY;
        titlesView.tag = -1;
        [self.view addSubview:titlesView];
        _titlesView = titlesView;
    }
    return _titlesView;
}

// 底部多个 TableView 的总容器
- (UIScrollView *)contentView{
    if (_contentView == nil) {
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.frame = self.view.bounds;
        contentView.pagingEnabled = YES;
        contentView.delegate = self;
        contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
        [self.view insertSubview:contentView atIndex:0];
        _contentView = contentView;
    }
    return _contentView;
}

- (void)setCurrentSelectedBtn:(UIButton *)btn{
    if (btn != self.currentSelectedBtn) {
        btn.enabled = NO;
        self.currentSelectedBtn.enabled = YES;
        
        // 移动动画
        [UIView animateWithDuration:0.2 animations:^{
            self.indicatorView.width = btn.titleLabel.width;
            self.indicatorView.centerX = btn.centerX;
        }];
        
        _currentSelectedBtn = btn;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置导航栏内容
    [self setupNavi];
    
    // 2. 创建底部的子控制器
    [self setupChildVC];

    // 3. 初始化标题界面
    [self setupTitlesView];

    [self scrollViewDidEndScrollingAnimation:self.contentView];
}

- (void)setupNavi{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    self.view.backgroundColor = SFLGlobalBG;
}

- (void)setupTitlesView{
    // 内部子标签
    NSArray *childVC = self.childViewControllers;
    CGFloat w = self.titlesView.width / childVC.count;
    CGFloat h = self.titlesView.height;
    
    for (NSInteger i=0; i < childVC.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.width = w;
        btn.height = h;
        btn.x = i * w;
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitle:[childVC[i] title] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [btn.titleLabel sizeToFit];
            [self titleClick:btn];
        }
        
        [self.titlesView addSubview:btn];
    }
}

- (void)tagClick{
    SFLRecommendTagsVC *recmdTags = [[SFLRecommendTagsVC alloc] init];
    [self.navigationController pushViewController:recmdTags animated:YES];
}

- (void)titleClick:(UIButton *)btn{
    // 修改按钮状态
    self.currentSelectedBtn = btn;
    
    // 滚动底部内容
    CGPoint offset = self.contentView.contentOffset;
    offset.x = btn.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

- (void)setupChildVC{

    SFLTopicTableVC *all = [SFLTopicTableVC topicWithType:SFLTopicTypeAll];
    all.title = @"全部";
    [self addChildViewController:all];
    
    SFLTopicTableVC *word = [SFLTopicTableVC topicWithType:SFLTopicTypeWord];
    word.title = @"段子";
    [self addChildViewController:word];

    SFLTopicTableVC *picture = [SFLTopicTableVC topicWithType:SFLTopicTypePicture];
    picture.title = @"图片";
    [self addChildViewController:picture];

    SFLTopicTableVC *voice = [SFLTopicTableVC topicWithType:SFLTopicTypeVoice];
    voice.title = @"音频";
    [self addChildViewController:voice];

    SFLTopicTableVC *video = [SFLTopicTableVC topicWithType:SFLTopicTypeVideo];
    video.title = @"视频";
    [self addChildViewController:video];

    // 设置 contentView 的内容大小
    self.contentView.contentSize = CGSizeMake(self.contentView.width * self.childViewControllers.count, 0);
}

#pragma mark - contentView, <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 根据当前索引，取出子控制器
    NSInteger idx = scrollView.contentOffset.x / scrollView.width;
    UITableViewController *vc = self.childViewControllers[idx];
    vc.tableView.x = scrollView.contentOffset.x;    
    [scrollView addSubview:vc.tableView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    [self titleClick:[self.titlesView viewWithTag:(scrollView.contentOffset.x / scrollView.width)]];
}

@end
