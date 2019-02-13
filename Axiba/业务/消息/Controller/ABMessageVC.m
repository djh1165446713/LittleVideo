//
//  ABMessageVC.m
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABMessageVC.h"
#import "ABRowCell.h"
#import "ABLoginVC.h"
#import "ABZanVC.h"
#import "ABEvaVC.h"
#import "ABNoticeVC.h"

@interface ABMessageVC ()

@end

@implementation ABMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ______WS();
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.showBackBtn = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:KCTNotityUnreadCount object:nil] subscribeNext:^(id x) {
        [wSelf.tableView reloadData];
    }];
}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"MINECELL";
    ABRowCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[ABRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    [cell setRedDot:YES];
    cell.vLine.hidden = false;
    if (indexPath.row == 0) {
        [cell setTitle:@"icon_zan" title:@"点赞" bNext:YES];
        cell.lblValue.hidden = YES;

    }
    if (indexPath.row == 1) {
        [cell setTitle:@"icon_pl" title:@"评论" bNext:YES];
        cell.lblValue.hidden = YES;

        if ([ABUser isLogined]) {
            NSInteger num = [[[[ABUser sharedInstance] abuser] redDot] integerValue];
            [cell setRedDot:num == 0];
        }
    }
    if (indexPath.row == 2) {
        [cell setTitle:@"icon_tongzhi" title:@"通知" bNext:YES];
        cell.lblValue.hidden = YES;

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (![ABUser isLoginedAndPresent]) {
        return;
    }
    
    if (indexPath.row == 0) {
        ABZanVC* vc = [ABZanVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        ABEvaVC* vc = [ABEvaVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        ABNoticeVC* vc = [ABNoticeVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
