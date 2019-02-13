//
//  LVHomeleftController.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/12/21.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "LVHomeleftController.h"
#import "LVHomeleftCell.h"
#import "CTLikeChannelVC.h"
#import "CTLikeContentVC.h"
#import "UIViewController+MMDrawerController.h"
#import "ABSettingVC.h"
#import "ABFeedbackVC.h"
#import "ABEditProfileVC.h"
#import "ABMessageVC.h"

@interface LVHomeleftController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *arraynoLogin;
@property (nonatomic, strong) UIButton *noLoginBtn;

@end

@implementation LVHomeleftController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (![ABUser isLogined]) {
        _imgHeader_user.image = [UIImage imageNamed:@"icon_default_head"];
        _lab_notic.text = @"点击登录后可评论";
        _noLoginBtn.hidden = YES;
    }else{
        [_imgHeader_user sd_setImageWithURL:[NSURL URLWithString:[[[[ABUser sharedInstance] abuser] user] avator]]  placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
        _lab_notic.text = [[[[ABUser sharedInstance] abuser] user] nickname];

        _noLoginBtn.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ______WS();
    _backImg_user = [[UIImageView alloc] init];
    _backImg_user.backgroundColor = [UIColor redColor];
    _backImg_user.image = [UIImage imageNamed:@"backgroud_user"];
    [self.view addSubview:_backImg_user];
    [_backImg_user mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.view.mas_top).offset(0);
        make.left.equalTo(wSelf.view.mas_left).offset(0);
        make.height.offset(185);
        make.width.offset(kTPScreenWidth / 3 * 2);
    }];
    
    
    _imgHeader_user = [[UIImageView alloc] init];
    _imgHeader_user.layer.masksToBounds = YES;
    _imgHeader_user.layer.cornerRadius = 25;
    _imgHeader_user.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap_head = [UITapGestureRecognizer new];
    [_imgHeader_user addGestureRecognizer:tap_head];
    [self.view addSubview:_imgHeader_user];
    [_imgHeader_user mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(wSelf.backImg_user);
        make.width.height.offset(50);
    }];
    
    [[tap_head rac_gestureSignal] subscribeNext:^(id x) {
        if ([ABUser isLoginedAndPresent]) {
            ABEditProfileVC* vc = [[ABEditProfileVC alloc] init];
            UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
            [nav pushViewController:vc animated:YES];
            [wSelf.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
                [wSelf.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
            }];
        }
    }];
    
    
    
    _lab_notic = [[UILabel alloc] init];
    _lab_notic.textColor = [UIColor whiteColor];
    _lab_notic.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLoginAction)];
    [_lab_notic addGestureRecognizer:tap];
    _lab_notic.textAlignment = NSTextAlignmentCenter;
//    _lab_notic.backgroundColor = RGB(45, 44, 41);
    _lab_notic.font = Font_Chinease_Blod(16);
    [self.view addSubview:_lab_notic];
    [_lab_notic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.imgHeader_user.mas_bottom).offset(15);
        make.left.equalTo(wSelf.view.mas_left).offset(0);
        make.height.offset(22);
        make.width.offset(kTPScreenWidth / 3 * 2);
    }];
    
    
   
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 185, kTPScreenWidth / 3 * 2, kTPScreenHeight - 280) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;

    [self.view addSubview:_tableView];
    [self.tableView registerClass:[LVHomeleftCell class] forCellReuseIdentifier:@"leftcell_idf"];
    
    [self creatLoginoutButton];

}

- (void)creatLoginoutButton{
    ______WS();
    _noLoginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_noLoginBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
    [_noLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_noLoginBtn addTarget:self action:@selector(loginoutAction) forControlEvents:(UIControlEventTouchUpInside)];
    _noLoginBtn.backgroundColor = RGB(53, 49, 50);
    _noLoginBtn.titleLabel.font = Font_Chinease_Blod(14);
    [self.view addSubview:_noLoginBtn];
    [_noLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wSelf.view.mas_bottom).offset(-16);
        make.left.equalTo(wSelf.view.mas_left).offset(0);
        make.right.equalTo(wSelf.view.mas_right).offset(0);
        make.height.offset(48);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (![ABUser isLoginedAndPresent]) {
            return;
        }
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        CTLikeChannelVC* vc = [[CTLikeChannelVC alloc] init];
        vc.userId = self.userId;
        if (![vc.userId isValid]) {
            vc.userId = [[[[ABUser sharedInstance] abuser] user] ids];
        }
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:vc animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        CTLikeContentVC* vc = [[CTLikeContentVC alloc] init];
        vc.userId = self.userId;
        if (![vc.userId isValid]) {
            vc.userId = [[[[ABUser sharedInstance] abuser] user] ids];
        }
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:vc animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        ABMessageVC* vc = [[ABMessageVC alloc] init];
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        ABSettingVC* vc = [ABSettingVC new];
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (![ABUser isLoginedAndPresent]) {
            return;
        }
        ABFeedbackVC* vc = [ABFeedbackVC new];
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:vc animated:YES];
    }
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    else {
        return 2;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    }
    else {
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LVHomeleftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftcell_idf" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.icon_cell.image = [UIImage imageNamed:@"user_gz"];
        cell.title_cell.text = @"我的关注";
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.icon_cell.image = [UIImage imageNamed:@"user_sc"];
        cell.title_cell.text = @"我的收藏";
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.icon_cell.image = [UIImage imageNamed:@"user_notice"];
        cell.title_cell.text = @"消息通知";
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.icon_cell.image = [UIImage imageNamed:@"user_gz"];
        cell.title_cell.text = @"更多设置";
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.icon_cell.image = [UIImage imageNamed:@"user_fk"];
        cell.title_cell.text = @"意见反馈";
    }
   
    return cell;
}

- (void)loginoutAction{
        if (![ABUser isLoginedAndPresent]) {
            return;
        }
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要退出当前登录账号吗?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil];
        [alert show];
        ______WS();
        [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber* x) {
            if (x.integerValue == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KCTNotityLogout object:nil];
                [UMessage removeAlias:[ABUser sharedInstance].abuser.user.ids type:@"ALIAS_TYPE.DIPAI" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                    
                }];
                [ABLoginModel logout];
                [[ABUser sharedInstance] logout];
                [ABUser isLoginedAndPresent];
            }
        }];
}

- (void)tapLoginAction{
    if (![ABUser isLoginedAndPresent]) {
        return;
    }
}

@end
