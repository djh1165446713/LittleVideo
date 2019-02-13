//
//  ABMineVC.m
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABMineVC.h"
#import "ABRowCell.h"
#import "ABLoginVC.h"
#import "ABSettingVC.h"
#import "ABProfileModel.h"
#import "ABEditProfileVC.h"
#import "ABFeedbackVC.h"
#import "CTLikeChannelVC.h"
#import "CTLikeContentVC.h"
#import "AppDelegate.h"

@interface ABMineVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView        *headBack;
@property (nonatomic, strong) UILabel       *lblTitle;
@property (nonatomic, strong) UIButton      *btnNavRight;
@property (nonatomic, strong) UIButton      *btnNavLeft;
@property (nonatomic, strong) UIImageView   *imgHead;
@property (nonatomic, strong) UILabel       *lblNick;
@property (nonatomic, strong) UILabel       *lblSign;

@end

@implementation ABMineVC

- (UIView*)headBack {
    if (!_headBack) {
        _headBack = [[UIView alloc] init];
        _headBack.backgroundColor = HEXCOLOR(0xffdd2a);
    }
    return _headBack;
}

- (UILabel*)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textColor = [UIColor whiteColor];
        _lblTitle.font = [UIFont boldSystemFontOfSize:18];
        _lblTitle.text = @"我";
        _lblTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _lblTitle;
}

- (UIButton*)btnNavRight {
    if (!_btnNavRight) {
        _btnNavRight = [UIButton new];
        [_btnNavRight setImage:[[UIImage imageNamed:@"icon_nav_dot"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_btnNavRight addTarget:self action:@selector(rightAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnNavRight;
}


- (void)rightAction{

    if ([ABUser isLoginedAndPresent]) {
        NSString* url = urlMineShare(self.userId?:[[[[ABUser sharedInstance] abuser] user] ids]);
        NSString* nick = self.nickname?:[[[[ABUser sharedInstance] abuser] user] nickname];
        NSString* summary = self.summary?:[[[[ABUser sharedInstance] abuser] user] summary];
        [[ABCommonViewManager shareInstance] showShareView:@"分享个人主页"
                                            defaultContent:summary
                                                     image:[UIImage imageNamed:@"about"]
                                                     title:nick
                                                       url:url
                                               description:summary
                                                contentids:@""
                                               isCollected:NO
                                                     block:^(NSString *strPlatName ,BOOL success, NSError *error) {
                                                         if(success) {
                                                             NSLog(@"分享成功");
                                                         }
                                                     }];
    }
}


- (UIButton*)btnNavLeft {
    if (!_btnNavLeft) {
        _btnNavLeft = [UIButton new];
        [_btnNavLeft setImage:[[UIImage imageNamed:@"icon_left"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        ______WS();
        [[_btnNavLeft rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [wSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _btnNavLeft;
}

- (UIImageView*)imgHead {
    if (!_imgHead) {
        ______WS();
        _imgHead = [UIImageView new];
        _imgHead.image = [UIImage imageNamed:@"icon_default_head"];
        _imgHead.layer.cornerRadius = 37.5;
        _imgHead.layer.borderColor = [UIColor whiteColor].CGColor;
        _imgHead.layer.borderWidth = 2;
        _imgHead.layer.masksToBounds = YES;
        _imgHead.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [UITapGestureRecognizer new];
        [_imgHead addGestureRecognizer:tap];
        if (![self.userId isValid]) {
            [[tap rac_gestureSignal] subscribeNext:^(id x) {
                if ([ABUser isLoginedAndPresent]) {
                    ABEditProfileVC* vc = [[ABEditProfileVC alloc] init];
                    [wSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }
    return _imgHead;
}

- (UILabel*)lblNick {
    if (!_lblNick) {
        _lblNick = [[UILabel alloc] init];
        _lblNick.textColor = [UIColor whiteColor];
        _lblNick.font = [UIFont boldSystemFontOfSize:17];
        _lblNick.text = @"未登录";
        _lblNick.textAlignment = NSTextAlignmentCenter;
    }
    return _lblNick;
}

- (UILabel*)lblSign {
    if (!_lblSign) {
        _lblSign = [[UILabel alloc] init];
        _lblSign.textColor = [UIColor whiteColor];
        _lblSign.font = Font_Chinease_Blod(12);
        _lblSign.textAlignment = NSTextAlignmentCenter;
        _lblSign.lineBreakMode = NSLineBreakByWordWrapping;
        _lblSign.numberOfLines = 0;
    }
    return _lblSign;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.btnNavRight.hidden = NO;
    if ([self.userId isValid]) {
        self.lblTitle.text = @"他的主页";
    }
    else {
        if ([ABUser isLogined]) {
            [(AppDelegate*)[UIApplication sharedApplication].delegate loadRedDot];
        }
        else {
            self.btnNavRight.hidden = YES;
            self.lblNick.text = @"未登录";
            self.lblSign.text = @"";
            self.imgHead.image = [UIImage imageNamed:@"icon_default_head"];
        }
    }
    
    [self loadProfile];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    ______WS();
    [self.view addSubview:self.headBack];

    [self.headBack addSubview:self.lblTitle];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.headBack.mas_left).offset(40);
        make.right.equalTo(wSelf.headBack.mas_right).offset(-40);
        make.top.equalTo(wSelf.headBack.mas_top).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    if (![self.userId isValid]) {
        [self.headBack addSubview:self.btnNavRight];
        [self.btnNavRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.headBack.mas_right).with.offset(2);
            make.centerY.equalTo(wSelf.lblTitle.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(70, 44));
        }];
    }
    
    [self.headBack addSubview:self.btnNavLeft];
    self.btnNavLeft.hidden = ![self.userId isValid];
    [self.btnNavLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.headBack.mas_left).with.offset(0);
        make.centerY.equalTo(wSelf.lblTitle.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    
    [self.headBack addSubview:self.imgHead];
    [self.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.headBack.mas_centerX);
        make.top.equalTo(wSelf.lblTitle.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    [self.headBack addSubview:self.lblNick];
    [self.lblNick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.imgHead.mas_bottom).offset(10);
        make.left.equalTo(wSelf.headBack);
        make.right.equalTo(wSelf.headBack);
        make.height.mas_equalTo(17);
    }];
    
    [self.headBack addSubview:self.lblSign];
    
    self.tableView.bounces = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.headBack.mas_bottom);
        make.bottom.equalTo(wSelf.view);
    }];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:KCTNotityLogout object:nil] subscribeNext:^(id x) {
        wSelf.imgHead.image = [UIImage imageNamed:@"icon_default_head"];
    }];
}

- (void)loadProfile {
    if ([self.userId isValid]) {
        self.lblSign.text = self.summary;
        self.lblNick.text = self.nickname;
        [self.imgHead sd_setImageWithURL:[NSURL URLWithString:self.avator] placeholderImage:self.imgHead.image];
    }
    else {
        self.lblSign.text = [[[[ABUser sharedInstance] abuser] user] summary];
        self.lblNick.text = [[[[ABUser sharedInstance] abuser] user] nickname];
        NSLog(@"%@",[[[[ABUser sharedInstance] abuser] user] avator]);
        [self.imgHead sd_setImageWithURL:[NSURL URLWithString:[[[[ABUser sharedInstance] abuser] user] avator]] placeholderImage:self.imgHead.image];
    }
    if (![self.lblNick.text isValid]) {
        self.lblNick.text = @"未登录";
    }
    
    ______WS();
    if ([self.lblSign.text isValid]) {
        self.lblSign.hidden = NO;
        CGSize s = [self.lblSign.text textSizeWithFont:self.lblSign.font constrainedToSize:CGSizeMake(250, 999) lineBreakMode:NSLineBreakByWordWrapping];
        [self.lblSign mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(wSelf.lblNick.mas_bottom).offset(10);
            make.centerX.mas_equalTo(wSelf.headBack);
            make.size.mas_equalTo(CGSizeMake(250, s.height));
        }];
        [self.headBack mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.view);
            make.right.equalTo(wSelf.view);
            make.top.equalTo(wSelf.view);
            make.bottom.equalTo(wSelf.lblSign.mas_bottom).offset(10);
        }];
    }
    else {
        self.lblSign.hidden = YES;
        [self.headBack mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.view);
            make.right.equalTo(wSelf.view);
            make.top.equalTo(wSelf.view);
            make.bottom.equalTo(wSelf.lblNick.mas_bottom).offset(10);
        }];
    }


    
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.userId isValid]) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ABTableHeight;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell setTitle:@"收藏的内容" bNext:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [cell setTitle:@"收藏的频道" bNext:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell setTitle:@"意见反馈" bNext:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        [cell setTitle:@"功能设置" bNext:YES];
    }
    cell.vLine.hidden = indexPath.row > 0;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
        ABSettingVC* vc = [ABSettingVC new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (![ABUser isLoginedAndPresent]) {
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        CTLikeContentVC* vc = [[CTLikeContentVC alloc] init];
        vc.userId = self.userId;
        if (![vc.userId isValid]) {
            vc.userId = [[[[ABUser sharedInstance] abuser] user] ids];
        }
        [self.navigationController pushViewController:vc animated:YES];
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"www.baidu.com"]];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        CTLikeChannelVC* vc = [[CTLikeChannelVC alloc] init];
        vc.userId = self.userId;
        if (![vc.userId isValid]) {
            vc.userId = [[[[ABUser sharedInstance] abuser] user] ids];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        ABFeedbackVC* vc = [ABFeedbackVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
