//
//  SetControViewController.m
//  Axiba
//
//  Created by bianKerMacBook on 16/10/12.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "SetControViewController.h"
#import "setCell.h"
@interface SetControViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SetControViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ______WS();
    [self actionCustomLeftBtnWithNrlImage:@"icon_left" htlImage:@"icon_close" title:nil action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, 600) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 10;
    _tableView.estimatedSectionHeaderHeight = 10;
    _tableView.estimatedSectionFooterHeight = 10;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[setCell class] forCellReuseIdentifier:@"conCell"];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    setCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conCell" forIndexPath:indexPath];

        if (indexPath.row == 0) {
            cell.phoneLab.text = @"+62";
            cell.cityLab.text = @"印度尼西亚";
        }
        if (indexPath.row == 1) {
            cell.phoneLab.text = @"+853";
            cell.cityLab.text = @"澳门(中国)";
        }
        if (indexPath.row == 2) {
            cell.phoneLab.text = @"+60";
            cell.cityLab.text = @"马来西亚";
        }
        if (indexPath.row == 3) {
            cell.phoneLab.text = @"+65";
            cell.cityLab.text = @"新加坡";
        }
        if (indexPath.row == 4) {
            cell.phoneLab.text = @"+852";
            cell.cityLab.text = @"香港(中国)";
        }
    if (indexPath.row == 5) {
        cell.phoneLab.text = @"+886";
        cell.cityLab.text = @"台湾(中国)";
    }
    
    if (indexPath.row == 6) {
            cell.phoneLab.text = @"+86";
            cell.cityLab.text = @"中国";
        }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if ([self.abDelegate respondsToSelector:@selector(sendStr: str2:)]) {
            [self.abDelegate sendStr:@"印度尼西亚" str2:@"+62"];

        }
    }
    if (indexPath.row == 1) {
        if ([self.abDelegate respondsToSelector:@selector(sendStr: str2:)]) {
            [self.abDelegate sendStr:@"澳门(中国)" str2:@"+853"];
            
        }
    }
    if (indexPath.row == 2) {
        if ([self.abDelegate respondsToSelector:@selector(sendStr: str2:)]) {
            [self.abDelegate sendStr:@"马来西亚" str2:@"+60"];
            
        }
    }
    if (indexPath.row == 3) {
        if ([self.abDelegate respondsToSelector:@selector(sendStr: str2:)]) {
            [self.abDelegate sendStr:@"新加坡" str2:@"+65"];
        }
    }
    if (indexPath.row == 4) {
        if ([self.abDelegate respondsToSelector:@selector(sendStr: str2:)]) {
            [self.abDelegate sendStr:@"香港(中国)" str2:@"+852"];
        }
    }
    if (indexPath.row == 5) {
        if ([self.abDelegate respondsToSelector:@selector(sendStr: str2:)]) {
            [self.abDelegate sendStr:@"台湾(中国)" str2:@"+886"];
        }
    }
    
    if (indexPath.row == 6) {
        if ([self.abDelegate respondsToSelector:@selector(sendStr: str2:)]) {
            [self.abDelegate sendStr:@"中国" str2:@"+86"];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}

@end
