//
//  ABEvaVC.m
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABEvaVC.h"
#import "ABEvaListModel.h"
#import "ABMineVC.h"
#import "ABCommandListModel.h"
#import "ABVideoDetailVC.h"
#import "EvaModel.h"
#import "EvaCell.h"


@interface ABEvaVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray   *listData;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ABEvaVC

- (NSMutableArray*)listData {
    if (!_listData) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:YES];
}

- (void)viewDidLoad {
    ______WS();
    [super viewDidLoad];
    [[[ABUser sharedInstance] abuser] setRedDot:@(0)];
    [[NSNotificationCenter defaultCenter] postNotificationName:KCTNotityUnreadCount object:[[[ABUser sharedInstance] abuser] redDot]];
    
    UIView* vvv1 = [[UIView alloc] init];
    vvv1.backgroundColor = HEXCOLOR(0xe9e9e9);
    [self.view addSubview:vvv1];
    [vvv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.view);
        make.height.mas_equalTo(100);
    }];
    
    UIView* vvv2 = [[UIView alloc] init];
    vvv2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vvv2];
    [vvv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.view).offset(100);
        make.bottom.equalTo(wSelf.view);
    }];
    
    self.title = @"评论";
    self.showBackBtn = YES;
    self.view.backgroundColor       = HEXCOLOR(0xe9e9e9);
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.showsHorizontalScrollIndicator   = NO;
    self.tableView.showsVerticalScrollIndicator     = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];

    
    [self.tableView registerClass:[EvaCell class] forCellReuseIdentifier:@"evaCell"];
    
    [self.tableView addPullRefreshHandle:^{
        wSelf.page = 1;
        [wSelf.listData removeAllObjects];
        [wSelf requestCommentList];
    }];
    
    [self.tableView addPullNextHandle:^{
        wSelf.page++;
        [wSelf requestCommentList];
    }];
    
    self.page = 1;
    [self showLoading];
    [self requestCommentList];

    if ([ABUser isLogined]) {
        [ABEvaListModel setReddot:nil failure:nil];
    }
    
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(NSValue* x) {
        CGPoint p = x.CGPointValue;
        if (p.y < 0) {
            [vvv1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(100 - p.y);
            }];
            [vvv2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(wSelf.view).offset(100-p.y);
            }];
        }
        else {
            CGFloat y = 100 - p.y;
            if (y <0) {
                y = 0;
            }
            [vvv2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(wSelf.view).offset(y);
            }];
        }
    }];
    [self showEmpty:nil];

}


- (void)requestCommentList{
    ______WS();
  
    [[DJHttpApi shareInstance] POST:urlCommentList dict:@{@"pageNumber":[NSNumber numberWithInteger:self.page],@"sessionid":[ABUser sharedInstance].abuser.user.sessionid} succeed:^(id data) {
        [wSelf hideLoading:YES];
        [wSelf.tableView.mj_header endRefreshing];
        [wSelf.tableView.mj_footer endRefreshing];
        for (NSDictionary *dic in data[@"rspObject"][@"comment"]) {
            EvaModel *model = [[EvaModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [wSelf.listData addObject:model];
      
        }
        if ([data[@"rspObject"][@"page"][@"totalPage"] integerValue] <= wSelf.page) {
            [wSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (wSelf.listData.count > 0) {
            [wSelf hideEmpty];
        }
        [wSelf.tableView reloadData];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listData.count <= 0) {
        return 0;
    }
    EvaCell *cell = [[EvaCell alloc] init];
    CGFloat height = [cell heightCellGetModel:self.listData[indexPath.row]];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EvaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaCell" forIndexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EvaModel *model = self.listData[indexPath.row];
    ABVideoDetailVC* vc = [[ABVideoDetailVC alloc] initWithContentids:model.contentids needShowKeyboard:false];
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}


- (void)tapUser:(ABUserInfoModel *)user {
//    ABMineVC* vc = [[ABMineVC alloc] init];
//    vc.userId = user.ids;
//    vc.avator = user.avator;
//    vc.nickname = user.nickname;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapContent:(NSString *)contentId {
//    ABVideoDetailVC* vc = [[ABVideoDetailVC alloc] initWithContentids:contentId needShowKeyboard:false];
//    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
//
//    [self presentViewController:navi animated:YES completion:nil];
}
@end
