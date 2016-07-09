//
//  SFLRecommendVC.m
//  百思不得姐
//
//  Created by Light on 4-30.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLRecommendVC.h"
#import "SFLRecommendType.h"
#import "SFLRecommendTypeCell.h"
#import "SFLRecommendDisplay.h"
#import "SFLRecommendDisplayCell.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>

#define SFLselectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]
@interface SFLRecommendVC ()<UITableViewDelegate,UITableViewDataSource>

/** 左边的类别数据 */
@property (nonatomic,strong) NSArray *categories;
/** 左边的类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边的展示表格 */
@property (weak, nonatomic) IBOutlet UITableView *showTableView;

/** 请求参数 */
@property (nonatomic,strong) NSMutableDictionary *params;
/** AFN的请求管理者，统一管理所有的请求，防止本类对象消除，请求还在的现象 */
@property (nonatomic,strong) AFHTTPSessionManager *manger;
@end

@implementation SFLRecommendVC
static NSString * const categoryCellID = @"category";
static NSString * const displayCellID = @"display";

- (void)setCategories:(NSArray *)categories{
    NSMutableArray *array = nil;
    
    if (categories.count){
        array = [NSMutableArray array];
        for (NSDictionary *dic in categories) {
            [array addObject:[SFLRecommendType typeWithDic:dic]];
        }
    }
    _categories = array;
}

- (AFHTTPSessionManager *)manger{
    if (!_manger) {
        _manger = [AFHTTPSessionManager manager];
    }
    return _manger;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 控件的初始化
    [self setupTableView];
    
    // 显示加载暂停指示器
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 添加 刷新控件
    [self setupRefresh];
    // 添加 左侧的视图
    [self loadCategories];
}

// 初始化本类的对象
- (void)setupTableView{
    self.title = @"推荐关注";
    self.view.backgroundColor = SFLGlobalBG;
    
    // 注册 Cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SFLRecommendTypeCell class]) bundle:nil] forCellReuseIdentifier:categoryCellID];
    [self.showTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SFLRecommendDisplayCell class]) bundle:nil] forCellReuseIdentifier:displayCellID];
    
    // 去表格分隔线
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 去竖直滚动指示器
    self.categoryTableView.showsVerticalScrollIndicator = NO;
    self.showTableView.showsVerticalScrollIndicator = NO;
    
    // 设置 insert
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.showTableView.contentInset = self.categoryTableView.contentInset;
    self.showTableView.rowHeight = 60;
}

// 初始化 刷新控件
- (void)setupRefresh{
    self.showTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCards)];
    
    self.showTableView.mj_header.automaticallyChangeAlpha = YES;

    self.showTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCards)];
}

// 获得左侧视图资源「发送请求」
- (void)loadCategories{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    [self.manger GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 去遮罩
        [SVProgressHUD dismiss];
        
        if ((self.categories = responseObject[@"list"])) {
            // 刷新表格
            [self.categoryTableView reloadData];
            // 设置默认选中首行
            [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        // 让显示表格进入下拉状态
        [self.showTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败，请重新加载！"];
    }];
}

// 每当刷新信息时调用
- (void)loadNewCards{
    SFLRecommendType *type = SFLselectedCategory;
    
    // 发送请求给服务器，加载右侧数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(type.id);
    params[@"page"] = @(type.currentPage);
    
    // 存储当前的值
    self.params = params;
    
    [self.manger GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 获取全部 数据的数量
        type.total = [responseObject[@"total"] integerValue];
        // 已经加载完毕
        if (type.total == type.displayCards.count) {
            [self.showTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        // 添加新数据
        type.displayCards = responseObject[@"list"];
        
        // 请求过期，params已经有了新值，禁止显示，先存储下来
        if (self.params != params) return;
        
        // 刷新数据
        [self.showTableView reloadData];

        // 让底部控件结束刷新
        [self checkFootState];
        // 结束头部刷新
        [self.showTableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求过期，params已经有了新值
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载数据失败!"];
        // 结束刷新
        [self.showTableView.mj_header endRefreshing];
    }];
}

// 加载更多信息时调用
- (void)loadMoreCards{
    SFLRecommendType *type = SFLselectedCategory;
    
    // 发送请求给服务器，加载右侧数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(type.id);
    params[@"page"] = @(++type.currentPage);
    self.params = params;
    [self.manger GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 添加当前数据到数组中
        [type addDisplayCards:responseObject[@"list"]];
        
        // 请求过期，params已经有了新值，禁止显示，先存储下来
        if (self.params != params) return;

        // 刷新右边的表格
        [self.showTableView reloadData];
        
//        SFLLOG(@"%@",responseObject);
//        SFLLOG(@"count = %zd, total = %zd",type.displayCards.count,type.total);
        // 让底部控件结束刷新
        [self checkFootState];
        // 结束刷新
        [self.showTableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求过期，params已经有了新值
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载数据失败!"];
        // 结束刷新
        [self.showTableView.mj_header endRefreshing];
    }];
}

// 时刻检测 footer 状态
- (void)checkFootState{
    SFLRecommendType *type = SFLselectedCategory;
    NSInteger count = type.displayCards.count;
    
    self.showTableView.mj_footer.hidden = (count == 0);

    if (type.total == count) {
        [self.showTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.showTableView.mj_footer endRefreshing];
    }
}

#pragma mark - Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 首先结束其他选中位置的 刷新效果
    [self.showTableView.mj_header endRefreshing];
    [self.showTableView.mj_footer endRefreshing];
    
    SFLRecommendType *type = self.categories[indexPath.row];
    type.currentPage = 1;
    
    // 不管成功与失败，先更新界面
    [self.showTableView reloadData];

    if (!type.displayCards.count) {
        // 进入下拉刷新状态
        [self.showTableView.mj_header beginRefreshing];
    }
}


#pragma mark - Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.categoryTableView) return self.categories.count;
    // 让底部控件结束刷新
    [self checkFootState];
        
    return [SFLselectedCategory displayCards].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        SFLRecommendTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCellID];
        cell.category = self.categories[indexPath.row];
        
        return cell;
    }else{
        SFLRecommendDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:displayCellID];
        cell.displayCard = [SFLselectedCategory displayCards][indexPath.row];
        
        return cell;
    }
}

#pragma mark - Dealloc
- (void)dealloc{
    // 本类的实例对象销毁时，停止所有操作
    [self.manger.operationQueue cancelAllOperations];
}
@end
