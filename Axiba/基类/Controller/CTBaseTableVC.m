//
//  CTBaseTableVC.m
//  TP
//
//  Created by Peter on 15/9/14.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "CTBaseTableVC.h"

@interface CTBaseTableVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CTBaseTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.showsHorizontalScrollIndicator   = NO;
    self.tableView.showsVerticalScrollIndicator     = NO;
    self.tableView.estimatedSectionHeaderHeight = 10;
    self.tableView.estimatedSectionFooterHeight = 10;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ABTableHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"CTBASETABLECELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    return cell;
}
@end
