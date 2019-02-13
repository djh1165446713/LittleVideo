//
//  CTLikeChannelVC.m
//  Axiba
//
//  Created by Peter on 16/6/21.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTLikeChannelVC.h"
#import "CTLikeChannelModel.h"
#import "ABLikeChannelCell.h"
#import "ABChannelDetailVC.h"

@interface CTLikeChannelVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger        page;
@property (nonatomic, strong) NSMutableArray   *list;
@end

@implementation CTLikeChannelVC

- (NSMutableArray*)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadData:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    ______WS();
    self.title = @"我的关注";
    self.view.backgroundColor = [UIColor whiteColor];
    self.showBackBtn = YES;
    
    
    [self.tableView addPullRefreshHandle:^{
        wSelf.page = 1;
        [wSelf loadData:^{
            [wSelf.list removeAllObjects];
        }];
    }];
    
    [self.tableView addPullNextHandle:^{
        wSelf.page++;
        [wSelf loadData:nil];
    }];
    
    self.page = 1;
    [self showLoading];
    
    ABChannelDetailVC *vc = [[ABChannelDetailVC alloc] init];
    vc.blockChannle = ^(void) {
        NSLog(@"成功");
    };
}

- (void)loadData:(void(^)(void))block {
    ______WS();
    [CTLikeChannelModel getChannels:self.userId page:self.page success:^(NSDictionary *resultObject) {
        [wSelf.tableView.mj_header endRefreshing];
        [wSelf.tableView.mj_footer endRefreshing];
        [wSelf.list removeAllObjects];
        if (block != NULL) {
            block();
        }
        CTLikeChannelModel* model = [[CTLikeChannelModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200) {
            wSelf.page = model.rspObject.page.pageNumber.integerValue;
            [wSelf hideLoading:YES];
            if (model.rspObject.channels.count > 0) {
                [wSelf.list addObjectsFromArray:model.rspObject.channels];
            }
            if (wSelf.list.count == 0) {
                [wSelf showEmpty:nil];
            }
            if (model.rspObject.page.totalPage.integerValue <= wSelf.page) {
                [wSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [wSelf.tableView reloadData];
        }
        else {
            TOAST_FAILURE(model.rspMsg);
        }
    } failure:^(NSError *requestErr) {
        TOAST_ERROR(wSelf, requestErr);
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"CTLIKECHANNELCELL";
    ABLikeChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[ABLikeChannelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    CTListChannelItem* item = self.list[indexPath.row];
    [cell setPhoto:item.photo title:item.name summy:item.summary];
    [cell setTitle:nil bNext:YES];
    cell.vLine.hidden = NO;
    cell.lblValue.hidden = YES;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CTListChannelItem* item = self.list[indexPath.row];
    ABChannelDetailVC* vc   = [[ABChannelDetailVC alloc] initWithChannel:item.ids];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setChannelName:item.name];
}


@end
