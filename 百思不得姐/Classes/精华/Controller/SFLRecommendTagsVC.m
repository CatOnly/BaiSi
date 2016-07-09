//
//  SFLRecommendTagsVC.m
//  百思不得姐
//
//  Created by Light on 5-3.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLRecommendTagsVC.h"
#import "SFLRecommendTag.h"
#import "SFLRecommendTagCell.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface SFLRecommendTagsVC ()

/** 标签数据 */
@property (nonatomic,strong) NSArray *tags;

@end

static NSString * const SFLTagsID = @"tag";

@implementation SFLRecommendTagsVC

- (void)setTags:(NSArray *)tags{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in tags) {
        [arr addObject:[SFLRecommendTag recmdTagWithDic:dic]];
    }
    _tags = arr;
}

- (void)setupTableView{
    self.title = @"推荐标签";
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SFLGlobalBG;
}

- (void)loadTags{
    // 遮罩
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 注册可用的 Cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SFLRecommendTagCell class]) bundle:nil]  forCellReuseIdentifier:SFLTagsID];
    
    // 发送请求给服务器
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 去遮罩
        [SVProgressHUD dismiss];
        self.tags = responseObject;
        // 刷新表格
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载数据失败!"];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadTags];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFLRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:SFLTagsID forIndexPath:indexPath];
    cell.recmdTag = self.tags[indexPath.row];
    
    return cell;
}

@end
