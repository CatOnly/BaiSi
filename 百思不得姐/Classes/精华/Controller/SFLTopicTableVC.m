//
//  SFLTopicTableVC.m
//  百思不得姐
//
//  Created by Light on 5-4.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLTopicTableVC.h"
#import "SFLTopic.h"
#import "SFLTopicCell.h"
#import "SFLCommentVC.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>


@interface SFLTopicTableVC ()<UITableViewDataSource,UITableViewDelegate>

/** UITaleView 类型 */
@property (nonatomic, assign) SFLTopicType type;
/** 帖子数据 */
@property (nonatomic,strong) NSMutableArray *topics;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;

@end

static NSString * const SFLTopicTableVCID = @"topic";

@implementation SFLTopicTableVC

+ (instancetype)topicWithType:(SFLTopicType)type {
    SFLTopicTableVC *t = [[SFLTopicTableVC alloc] init];
    t.type = type;
    return t;
}

- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];

    [self setupRefresh];
    
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SFLTopicCell class]) bundle:nil] forCellReuseIdentifier:SFLTopicTableVCID];
    self.tableView.y = 0; // 设置控制器view的y值为0(默认是20)
    
    // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    self.tableView.height = [UIApplication sharedApplication].keyWindow.height;
    
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(SFLTitlesViewY+SFLTitlesViewH, 0, bottom, 0);
    
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];

}

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma mark - 服务器接收数据处理
// 加载新帖数据
- (void)loadNewTopics{
    // 结束上拉
    [self.tableView.mj_footer endRefreshingWithNoMoreData];

    // 发送请求给服务器
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);

    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求过期，params已经有了新值，禁止显示，先存储下来
        if (self.params != params) return;
        
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];

        // 字典转模型
        self.topics = [SFLTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];

        // 刷新表格
        [self.tableView reloadData];
        
        // 重新刷新，页码也变成新的页码
        self.page = 0;
        
        // 结束下拉
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        // 结束下拉
        [self.tableView.mj_header endRefreshing];
    }];
}

// 添加帖子数据
- (void)loadMoreTopics{
    // 发送请求给服务器
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"maxtime"] = self.maxtime;

    NSInteger page = self.page + 1;
    params[@"page"] = @(page);
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求过期，params已经有了新值，禁止显示，先存储下来
        if (self.params != params) return;

        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];

        // 字典转模型
        self.topics = [SFLTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 数据加载成功后，更改页码
        self.page = page;
        
        // 结束上拉
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        // 结束上拉
        [self.tableView.mj_footer endRefreshing];
    }];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SFLTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:SFLTopicTableVCID forIndexPath:indexPath];
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取出帖子模型
    return [self.topics[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SFLCommentVC *commentVC = [[SFLCommentVC alloc] init];
    commentVC.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
}

@end
