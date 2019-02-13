//
//  ABAboutVC.m
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABAboutVC.h"
#import "ABRowCell.h"
#import "CTWebViewVC.h"

@interface ABAboutVC ()
@property (nonatomic, strong) UIImageView   *imgLogo;
@property (nonatomic, strong) UILabel       *lblVersion;
@property (nonatomic, strong) UILabel       *lblB1;
@property (nonatomic, strong) UILabel       *lblB2;
@end

@implementation ABAboutVC

- (UIImageView*)imgLogo {
    if (!_imgLogo) {
        _imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about"]];
    }
    return _imgLogo;
}

- (UILabel*)lblVersion {
    if (!_lblVersion) {
        _lblVersion = [[UILabel alloc] init];
        _lblVersion.text = [NSString stringWithFormat:@"v %@",clientVersion];
        _lblVersion.textColor = colorNormalText;
        _lblVersion.font = Font_Chinease_Blod(10);
        _lblVersion.textAlignment = NSTextAlignmentCenter;
    }
    return _lblVersion;
}

- (UILabel*)lblB1 {
    if (!_lblB1) {
        _lblB1 = [[UILabel alloc] init];
        _lblB1.text = [NSString stringWithFormat:@"官方QQ群：%@",appQQGroup];
        _lblB1.textColor = colorMainText;
        _lblB1.font = Font_Chinease_Normal(12);
        _lblB1.textAlignment = NSTextAlignmentCenter;
        _lblB1.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [UITapGestureRecognizer new];
        [_lblB1 addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = appQQGroup;
            TOAST_SUCCESS(@"成功复制QQ群");
        }];
    }
    return _lblB1;
}

- (UILabel*)lblB2 {
    if (!_lblB2) {
        _lblB2 = [[UILabel alloc] init];
        _lblB2.text = @"社区 ● 微博";
        _lblB2.textColor = colorMainText;
        _lblB2.font = Font_Chinease_Blod(13);
        _lblB2.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer* tap = [UITapGestureRecognizer new];
        [_lblB2 addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = appQQGroup;
            TOAST_SUCCESS(@"成功复制QQ群");
        }];
    }
    return _lblB2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ______WS();
    self.showBackBtn = YES;
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imgLogo];
    [self.imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.view.mas_centerX);
        make.top.equalTo(wSelf.view).offset(45);
        make.size.mas_equalTo(CGSizeMake(105,160));
    }];
    
    [self.view addSubview:self.lblVersion];
    [self.lblVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.imgLogo.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    
    self.tableView.bounces = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.lblVersion.mas_bottom).offset(37.5);
        make.bottom.equalTo(wSelf.view);
    }];
    
    
    [self.view addSubview:self.lblB2];
    [self.lblB2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.bottom.equalTo(wSelf.view.mas_bottom).offset(-22);
        make.height.mas_equalTo(15);
    }];
    
    [self.view addSubview:self.lblB1];
    [self.lblB1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.bottom.equalTo(wSelf.lblB2.mas_top).offset(-10);
        make.height.mas_equalTo(13.5);
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"MINECELL";
    ABRowCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.backgroundColor = RGB(245, 245, 245);
    if (!cell) {
        cell = [[ABRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.vLine.hidden = NO;
    if (indexPath.row == 0) {
        [cell setTitle:@"服务条款" bNext:YES];
        cell.lblValue.hidden = YES;

    }
    if (indexPath.row == 1) {
        [cell setTitle:@"给我评分" bNext:YES];
        cell.lblValue.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        CTWebViewVC* vc = [CTWebViewVC new];
        vc.url = [NSURL URLWithString:urlAppService];
        vc.title = @"服务条款";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        //TODO:替换id
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAppRate]];
    }
}
@end
