//
//  ABLoginVC.m
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABLoginVC.h"
#import "ABLoginTextCell.h"
#import "ABLoginModel.h"
#import "ABRegOrFindVC.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"
#import "ABPerfectInfoVC.h"
#import "LoginView.h"
#import "SetControViewController.h"
@interface ABLoginVC ()<setStringDelegat>
@property (nonatomic, strong) ABLoginTextCell   *userBack;
@property (nonatomic, strong) ABLoginTextCell   *passBack;
@property (nonatomic, strong) LoginView   *contureBack;

@property (nonatomic, strong) UIImageView         *backgroud_img;
@property (nonatomic, strong) UIButton      *popbtn;
@property (nonatomic, strong) UILabel       *login_lab;

@property (nonatomic, strong) UIButton      *btnRegistered;

@property (nonatomic, strong) UIButton      *btnLogin;
@property (nonatomic, strong) UIButton      *findpassbtn;

@property (nonatomic, strong) UIButton      *btnLoginWeibo;
@property (nonatomic, strong) UIButton      *btnLoginWechat;
@property (nonatomic, strong) UIButton      *btnLoginQQ;

@property (nonatomic, strong) UILabel       *lblThird;
@property (nonatomic, strong) UIView        *vLine1;
@property (nonatomic, strong) UIView        *vLine2;
@end

@implementation ABLoginVC

- (ABLoginTextCell*)userBack {
    if (!_userBack) {
        _userBack = [[ABLoginTextCell alloc] initWithFrame:CGRectMake(20, 170, kTPScreenWidth - 40, 38)];
        _userBack.icon2.image = [UIImage imageNamed:@"icon_phone"];
        _userBack.txt.placeholder = @"请输入手机号";
        _userBack.txt.keyboardType = UIKeyboardTypePhonePad;
        _userBack.txt.textColor = [UIColor whiteColor];
        _userBack.type = ABLoginTextPhone;
    }
    return _userBack;
}




- (ABLoginTextCell*)passBack {
    if (!_passBack) {
        _passBack = [[ABLoginTextCell alloc] initWithFrame:CGRectMake(20, 230, kTPScreenWidth-40, 38)];
        _passBack.icon2.image = [UIImage imageNamed:@"icon_pass"];
        _passBack.txt.placeholder = @"请输入密码";
        _passBack.txt.keyboardType = UIKeyboardTypeEmailAddress;
        _passBack.txt.textColor = [UIColor whiteColor];
        _passBack.txt.secureTextEntry = YES;
        _passBack.type = ABLoginTextPass;
    }
    return _passBack;
}




- (UIButton*)btnLogin {
    if (!_btnLogin) {
//        ______WS();
        _btnLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _btnLogin.frame = CGRectMake(20, 305, kTPScreenWidth-40, 44);
        [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        [_btnLogin setTitle:@"登录" forState:UIControlStateDisabled];
        _btnLogin.titleLabel.font = Font_Chinease_Blod(18);
        [_btnLogin setTitleColor:HEXCOLOR(0xfdfbf1) forState:UIControlStateNormal];
        [_btnLogin setTitleColor:HEXCOLOR(0xfdfbf1) forState:UIControlStateDisabled];
        [_btnLogin addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
        
   }
    return _btnLogin;
}

- (void) buttonAction {
        [self.userBack.txt resignFirstResponder];
        [self.passBack.txt resignFirstResponder];
        if ((self.userBack.txt.text.length != 11) && ( [self.contureBack.txt.text isEqualToString:@"国家/地区     中国"])) {
            TOAST_FAILURE(@"请输入正确的手机号");
            return ;
        }
           
        [self.btnLogin start];

        [ABLoginModel login:@"86" phone:self.userBack.txt.text pass:self.passBack.txt.text success:^(NSDictionary *resultObject) {
            [self.btnLogin end];
            ABLoginModel* model = [[ABLoginModel alloc] initWithDictionary:resultObject error:nil];
            if (model.rspCode.integerValue == 200) {
                [ABLoginModel loginSuccess:model.rspObject fromThird:@"axiba"];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                TOAST_FAILURE(model.rspMsg);
            }
        } failure:^(NSError *requestErr) {
            [self.btnLogin end];
            TOAST_ERROR(wSelf, requestErr);
        }];
    
    
}



- (UIButton*)btnLoginWeibo {
    if (!_btnLoginWeibo) {
        ______WS();
        _btnLoginWeibo = [[UIButton alloc] init];
        [_btnLoginWeibo setImage:[UIImage imageNamed:@"icon_login_weibo"] forState:UIControlStateNormal];
        [[_btnLoginWeibo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [wSelf doThird:UMShareToSina];
        }];
    }
    return _btnLoginWeibo;
}

- (UIButton*)btnLoginWechat {
    if (!_btnLoginWechat) {
        ______WS();
        _btnLoginWechat = [[UIButton alloc] init];
        [_btnLoginWechat setImage:[UIImage imageNamed:@"icon_login_wechat"] forState:UIControlStateNormal];
        [[_btnLoginWechat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [wSelf doThird:UMShareToWechatSession];
        }];
    }
    return _btnLoginWechat;
}

- (UIButton*)btnLoginQQ {
    if (!_btnLoginQQ) {
        ______WS();
        _btnLoginQQ = [[UIButton alloc] init];
        [_btnLoginQQ setImage:[UIImage imageNamed:@"icon_login_qq"] forState:UIControlStateNormal];
        [[_btnLoginQQ rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [wSelf doThird:UMShareToQQ];
        }];
    }
    return _btnLoginQQ;
}

- (UILabel*)lblThird {
    if (!_lblThird) {
        _lblThird = [UILabel new];
        _lblThird.text = @"第三方登录";
        _lblThird.font = Font_Chinease_Normal(15);
        _lblThird.textColor = [UIColor whiteColor];
        _lblThird.textAlignment = NSTextAlignmentCenter;
    }
    return _lblThird;
}

- (UIView*)vLine1 {
    if (!_vLine1) {
        _vLine1 = [[UIView alloc] init];
        _vLine1.backgroundColor = HEXCOLOR(0xaeb0af);
    }
    return _vLine1;
}

- (UIView*)vLine2 {
    if (!_vLine2) {
        _vLine2 = [[UIView alloc] init];
        _vLine2.backgroundColor = HEXCOLOR(0xaeb0af);
    }
    return _vLine2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ______WS();
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeAction) name:@"dissmiss_Notification" object:nil];
    
    
    _backgroud_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight)];
    _backgroud_img.image = [UIImage imageNamed:@"login_vc_img"];
    [self.view addSubview:_backgroud_img];
    
    
    _popbtn = [[UIButton alloc] init];
    [_popbtn setImage:[UIImage imageNamed:@"icon_close"] forState:(UIControlStateNormal)];
    [self.view addSubview:_popbtn];

    [[_popbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [wSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [_popbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view.mas_left).offset(15);
        make.top.equalTo(wSelf.view.mas_top).offset(32);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    
    _findpassbtn = [[UIButton alloc] init];
    [_findpassbtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [_findpassbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _findpassbtn.titleLabel.font = Font_Chinease_Normal(14);
    [[_findpassbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ABRegOrFindVC* vc = [[ABRegOrFindVC alloc] init];
        vc.isFindPass = YES;
        [wSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:_findpassbtn];
    [_findpassbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wSelf.view.mas_right).offset(-15);
        make.top.equalTo(wSelf.view.mas_top).offset(35);
        make.size.mas_equalTo(CGSizeMake(65, 20));
    }];
    
    
//    [self actionCustomLeftBtnWithNrlImage:@"icon_close" htlImage:@"icon_close" title:nil action:^{}];
//    [self actionCustomRightBtnWithNrlImage:nil htlImage:nil title:@"找回密码" action:^{}];
    
    _login_lab = [[UILabel alloc] init];
    _login_lab.textColor = [UIColor whiteColor];
    _login_lab.text = @"登录";
    _login_lab.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:_login_lab];
    [_login_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view.mas_left).offset(15);
        make.top.equalTo(wSelf.view.mas_top).offset(109);
        make.width.offset(60);
        make.height.offset(33);
    }];
    

    [self.view addSubview:self.userBack];
    [self.view addSubview:self.passBack];
    [self.view addSubview:self.btnLogin];
    
    
    _btnRegistered = [[UIButton alloc] init];
    [_btnRegistered setTitle:@"新用户注册" forState:UIControlStateNormal];
    [_btnRegistered setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnRegistered.titleLabel.font = Font_Chinease_Normal(14);
    
    [[_btnRegistered rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //            ABRegOrFindVC* vc = [[ABRegOrFindVC alloc] init];
        //            vc.isFindPass = YES;
        //            vc.isFindPass = NO;
        //            [wSelf.navigationController pushViewController:vc animated:YES];
        
        ABRegOrFindVC* vc = [[ABRegOrFindVC alloc] init];
        vc.view.frame = CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight);
//        [wSelf.navigationController pushViewController:vc animated:YES];
        [self.view addSubview:vc.view];
        
    }];
    [self.view addSubview:_btnRegistered];
    [_btnRegistered mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.btnLogin);
        make.top.equalTo(wSelf.btnLogin.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(155, 16));
    }];
    
    
    [self.view addSubview:self.btnLoginWeibo];
    [self.btnLoginWeibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.view.mas_centerX);
        make.bottom.equalTo(wSelf.view.mas_bottom).offset(-30);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.btnLoginWechat];
    [self.btnLoginWechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wSelf.btnLoginWeibo.mas_left).offset(-38);
        make.bottom.equalTo(wSelf.view.mas_bottom).offset(-30);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.btnLoginQQ];
    [self.btnLoginQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.btnLoginWeibo.mas_right).offset(38);
        make.bottom.equalTo(wSelf.view.mas_bottom).offset(-30);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.btnLoginWeibo];
    [self.btnLoginWeibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.view.mas_centerX);
        make.bottom.equalTo(wSelf.view.mas_bottom).offset(-30);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.view addSubview:self.lblThird];
    [self.lblThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.view.mas_centerX);
        make.bottom.equalTo(wSelf.btnLoginQQ.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [self.view addSubview:self.vLine1];
    [self.view addSubview:self.vLine2];
    
    [self.vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view).offset(20);
        make.right.equalTo(wSelf.lblThird.mas_left);
        make.centerY.equalTo(wSelf.lblThird);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.vLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wSelf.view).offset(-20);
        make.left.equalTo(wSelf.lblThird.mas_right);
        make.centerY.equalTo(wSelf.lblThird);
        make.height.mas_equalTo(0.5);
    }];
    

    
    [RACObserve(self.btnLogin, enabled) subscribeNext:^(NSNumber* x) {
        if (x.boolValue || wSelf.btnLogin.isOperationing.boolValue) {
            [wSelf.btnLogin setBackgroundColor:colorMain];
        }
        else {
            [wSelf.btnLogin setBackgroundColor:colorMainDisable];
        }
    }];
    self.btnLogin.enabled = false;
    
    RACSignal* signal = [self.userBack.txt.rac_textSignal combineLatestWith:self.passBack.txt.rac_textSignal];
    [signal subscribeNext:^(RACTuple* x) {
        NSString* user = x.first;
        NSString* pass = x.second;
        wSelf.btnLogin.enabled = user.length != 0 && pass.length > 0;
    }];
}


- (void)doThird:(NSString*)type {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:type];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"三方登录:%@",response)
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSString* actionKey = nil;
            NSString* channel = nil;
            if ([type isEqualToString:UMShareToSina]) {
                actionKey = snsAccount.usid;
                channel = @"WB";
            }
            else if ([type isEqualToString:UMShareToQQ]) {
                actionKey = snsAccount.openId;
                channel = @"QQ";
            }
            else if ([type isEqualToString:UMShareToWechatSession]) {
                actionKey = snsAccount.unionId;
                channel = @"WX";
            }
            NSString* nick = snsAccount.userName;
            NSString* avator = snsAccount.iconURL;

            ______WS();
            [ABLoginModel thirdlogin:actionKey channel:channel city:nil sex:@"3" avator:avator nickname:nick success:^(NSDictionary *resultObject) {
                ABLoginModel* model = [[ABLoginModel alloc] initWithDictionary:resultObject error:nil];
                if (model.rspCode.integerValue == 200) {
                    [ABLoginModel loginSuccess:model.rspObject fromThird:type];
                    [wSelf.navigationController dismissViewControllerAnimated:NO  completion:nil];
                }
                else {
                    TOAST_FAILURE(model.rspMsg);
                }
            } failure:^(NSError *requestErr) {
                TOAST_ERROR(wSelf, requestErr);
            }];
        }});
}


- (void)noticeAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
