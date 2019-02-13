//
//  ABZanVC.m
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABZanVC.h"
#import "ZanCell.h"
#import "ABZanListModel.h"
#import "ABVideoDetailVC.h"
@interface ABZanVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *zanList;
@end

@implementation ABZanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点赞";
    self.showBackBtn = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.zanList = [NSMutableArray array];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tableView registerClass:[ZanCell class] forCellReuseIdentifier:@"zanCell"];
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleSingleLine;

//    [self showEmpty:@"没有相关信息哦~"];
    [self rqquestPariseList];
    [self showEmpty:nil];
}


// 请求数据
- (void)rqquestPariseList{
    ______WS();
    NSLog(@"%@",[ABUser sharedInstance].abuser.user.sessionid);
    [[DJHttpApi shareInstance] POST:urlPraiseList dict:@{@"sessionid":[ABUser sharedInstance].abuser.user.sessionid} succeed:^(id data) {
        for (NSDictionary *dic in data[@"rspObject"]) {
            ABZanListModel *model = [[ABZanListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [wSelf.zanList addObject:model];
            [wSelf.tableView reloadData];
        }
        if (wSelf.zanList.count >= 1) {
            [wSelf hideEmpty];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _zanList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZanCell *cell = [[ZanCell alloc] init];
    CGFloat height = [cell heightCellGetModel:self.zanList[indexPath.row]];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zanCell" forIndexPath:indexPath];
    cell.model = self.zanList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ABZanListModel *model = self.zanList[indexPath.row];
    ABVideoDetailVC* vc = [[ABVideoDetailVC alloc] initWithContentids:model.contentids needShowKeyboard:false];
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}
@end
