//
//  SFLCommentVC.m
//  百思不得姐
//
//  Created by Light on 7-9.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLCommentVC.h"
#import "SFLComment.h"
#import "SFLTopicCell.h"
#import "SFLTopic.h"
#import "SFLCommentHeaderView.h"
#import "SFLCommentCell.h"
#import "SFLUser.h"

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>


@interface SFLCommentVC ()<UITableViewDelegate,UITableViewDataSource>
/** 用户对话框 */
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 底部工具条间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;
/** 保存帖子的 top_cmt */
@property (nonatomic, strong) SFLComment *saved_top_cmt;
/** 保存当前的页码 */
@property (nonatomic, assign) NSInteger page;
/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

static NSString * const SFLCommentCellID = @"comment";

@implementation SFLCommentVC

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBasic];
    [self setupHeader];
    [self setupRefresh];
}

- (void)setupBasic {
    self.title = @"评论";
    self.tableView.backgroundColor = SFLGlobalBG;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon"highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    // 去分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // cell 高度自适应设置 iOS 8.0「两个缺一不可」
//    self.tableView.estimatedRowHeight = 70;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // cell 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SFLCommentCell class]) bundle:nil] forCellReuseIdentifier:SFLCommentCellID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupHeader {
    if (self.topic.top_cmt) {
        // 清空 top_cmt
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    // 创建header「因为重写了 frame，必须包装个 View 才能改变大小」
    UIView *header = [[UIView alloc] init];
    
    // 添加cell
    SFLTopicCell *cell = [SFLTopicCell cell];
    cell.topic = self.topic;
    // 绕过重写的 frame
    cell.size = CGSizeMake(SFLScreenW, self.topic.cellHeight);
    [header addSubview:cell];
    // header的高度
    header.height = self.topic.cellHeight + SFLTopicCellMargin;
    
    // 设置header
    self.tableView.tableHeaderView = header;
}

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer.hidden = YES;
}

// 只要键盘位置、大小改变就会调用这个方法
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 其值随着键盘位置的改变而改变
    self.bottomSpace.constant = SFLScreenH - frame.origin.y;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)loadNewComments {
    // 结束之前的所有请求
    //  一个任务取消了，会调用 failure block
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params  progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 如果没有数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return;
        }

        // 最热评论
        self.hotComments = [SFLComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        // 最新评论
        self.latestComments = [SFLComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.page = 1;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        // 设置 footer 状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (total <= self.latestComments.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreComments {
    // 结束之前的所有请求，任务并没有销毁，任务还可以开启
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSInteger page = self.page + 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"lastcid"] = [[self.latestComments lastObject] ID];
    params[@"page"] = @(page);
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params  progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 如果没有数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        NSArray *newComments = [SFLComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        // 页码
        self.page = page;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        // 设置 footer 状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if (total <= self.latestComments.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.saved_top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    // 取消所有任务, session 死了不能从新开始任务，要重新创建 session
    [self.manager invalidateSessionCancelingTasks:YES];
}

// 返回第 section 组的所有评论数组
- (NSArray *)commentsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

- (SFLComment *)commentInIndexPath:(NSIndexPath *)indexPath {
    return [self commentsInSection:indexPath.section][indexPath.row];
}

#pragma mark - MenuItem 处理
- (void)ding:(UIMenuController *)menu{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SFLComment *comment = [self commentInIndexPath:indexPath];
    comment.like_count ++;
    // 向服务器发送数据
}

- (void)replay:(UIMenuController *)menu{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SFLComment *comment = [self commentInIndexPath:indexPath];
    self.commentTextField.text = [NSString stringWithFormat:@"@%@ ",comment.user.username];
    [self.commentTextField becomeFirstResponder];
    // 向服务器发送数据
}

- (void)report:(UIMenuController *)menu{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SFLLOG(@"举报内容：%@",[self commentInIndexPath:indexPath].content);
    // 向服务器发送数据
}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    } else {
        // 被点击的 Cell
        SFLCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding, replay, report];
        CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, 0);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.hotComments.count) return 2; // 有"最热评论" + "最新评论" 2组
    if (self.latestComments.count) return 1; // 有"最新评论" 1 组
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    // 隐藏上拉指示器
    tableView.mj_footer.hidden = (latestCount == 0);
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    // 非第0组
    return latestCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:SFLCommentCellID];
    cell.comment = [self commentInIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取出帖子模型
    return [[self commentInIndexPath:indexPath] cellHeight];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 先从缓存池中找header
    SFLCommentHeaderView *header = [SFLCommentHeaderView headerViewWithTableView:tableView];
    
    // 设置label的数据
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        header.title = hotCount ? @"最热评论" : @"最新评论";
    } else {
        header.title = @"最新评论";
    }
    return header;
}

@end
