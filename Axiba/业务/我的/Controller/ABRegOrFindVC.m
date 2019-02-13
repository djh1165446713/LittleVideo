//
//  ABRegOrFindVC.m
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABRegOrFindVC.h"
#import "ABLoginTextCell.h"
#import "ABRegModel.h"
#import "ABLoginModel.h"
#import "ABPerfectInfoVC.h"
#import "CTWebViewVC.h"
#import "LoginView.h"
#import "SetControViewController.h"

@interface ABRegOrFindVC ()<setStringDelegat>
@property (nonatomic, strong) ABLoginTextCell   *userBack;
@property (nonatomic, strong) ABLoginTextCell   *captchatBack;
@property (nonatomic, strong) ABLoginTextCell   *phoneBack;
@property (nonatomic, strong) ABLoginTextCell   *passBack;
@property (nonatomic, strong) UIButton          *btnGet;
@property (nonatomic, strong) UIButton          *btnSubmit;
@property (nonatomic, strong) UILabel           *lblFuwu;
@property (nonatomic, strong) UIButton          *goLoginViewbtn;

@property (nonatomic, strong) NSTimer           *codeTimer;
@property (nonatomic, assign) NSInteger         codeLeftTime;

@property (nonatomic, strong) UIImageView         *backgroud_img;
@property (nonatomic, strong) UIButton      *popbtn;
@property (nonatomic, strong) UILabel       *login_lab;

@end

@implementation ABRegOrFindVC

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_codeTimer invalidate];
    _codeTimer = nil;
}


- (UILabel*)lblFuwu {
    if (!_lblFuwu) {
        ______WS();
        _lblFuwu = [[UILabel alloc] init];
        _lblFuwu.textColor = colorNormalText;
        _lblFuwu.font = Font_Chinease_Normal(10);
        _lblFuwu.textAlignment = NSTextAlignmentCenter;
        NSString* text = @"点击确定后，表示你已经阅读并同意《一点视频服务条款》";
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:text];
        [string addAttribute:NSForegroundColorAttributeName value:colorMainText range:NSMakeRange(text.length - 9, 8)];
        _lblFuwu.attributedText = string;
        _lblFuwu.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [UITapGestureRecognizer new];
        [_lblFuwu addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            CTWebViewVC* vc = [CTWebViewVC new];
            vc.url = [NSURL URLWithString:urlAppService];
            vc.title = @"服务条款";
            [wSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _lblFuwu;
}



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


- (void)timerAction {
    _codeLeftTime--;
    if (_codeLeftTime == 0) {
        [_codeTimer invalidate];
        _codeTimer = nil;
        [self.btnGet setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.btnGet.enabled = self.userBack.txt.text.length == 11;
    }
    else {
        [self.btnGet setTitle:[NSString stringWithFormat:@"重新获取(%zd)",_codeLeftTime] forState:UIControlStateNormal];
        [self.btnGet setTitle:[NSString stringWithFormat:@"重新获取(%zd)",_codeLeftTime] forState:UIControlStateDisabled];
    }
}


- (NSTimer*)codeTimer {
    if (!_codeTimer) {
        _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        _codeLeftTime = 60;
        self.btnGet.enabled = false;
    }
    return _codeTimer;
}

- (UIButton*)btnSubmit {
    if (!_btnSubmit) {
        ______WS();
        _btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(20, 352, kTPScreenWidth - 40, 44)];
        _btnSubmit.backgroundColor = colorMain;
        [_btnSubmit setTitle:@"确定" forState:UIControlStateNormal];
        [_btnSubmit setTitleColor:HEXCOLOR(0xfdfbf1) forState:UIControlStateNormal];
        _btnSubmit.titleLabel.font = Font_Chinease_Blod(18);
        [[_btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [wSelf.userBack.txt resignFirstResponder];
            [wSelf.captchatBack.txt resignFirstResponder];
            [wSelf.passBack.txt resignFirstResponder];
//            if (![wSelf.userBack.txt.text isVAlidPhoneNumber]) {
//                TOAST_FAILURE(@"请输入正确的手机号");
//                return ;
//            }
//            
            
            if ((wSelf.userBack.txt.text.length != 11)) {
                TOAST_FAILURE(@"请输入正确的手机号");
                return ;
            }
            
            NSString *str = @"86";
            [wSelf.btnSubmit start];
            [ABRegModel regOrFindPass:!wSelf.isFindPass contron:str phone:self.userBack.txt.text pass:wSelf.passBack.txt.text captcha:wSelf.captchatBack.txt.text success:^(NSDictionary *resultObject) {
                [wSelf.btnSubmit end];
                if (wSelf.isFindPass) {
                    ABRegModel* model = [[ABRegModel alloc] initWithDictionary:resultObject error:nil];
                    if (model.rspCode.integerValue == 200) {
                        TOAST_SUCCESS(@"找回密码成功，请登录");
                        [wSelf.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else {
                        TOAST_FAILURE(model.rspMsg);
                    }
                }
                else {
                    ABLoginModel* model = [[ABLoginModel alloc] initWithDictionary:resultObject error:nil];
                    if (model.rspCode.integerValue == 200) {
                        TOAST_FAILURE(@"注册成功");
                        [MobClick event:@"day_registered_num"];
//                        [ABLoginModel loginSuccess:model.rspObject fromThird:@"littlevideo"];
//                        ABPerfectInfoVC* vc = [ABPerfectInfoVC new];
//                        [wSelf.navigationController pushViewController:vc animated:YES];
                        
                        [wSelf.view removeFromSuperview];
                        
                    }
                    else {
                        TOAST_FAILURE(model.rspMsg);
                    }
                }
            } failure:^(NSError *requestErr) {
                [wSelf.btnSubmit end];
                TOAST_ERROR(wSelf, requestErr);
            }];
        }];
    }
    return _btnSubmit;
}

- (UIButton*)btnGet {
    if (!_btnGet) {
        ______WS();
        _btnGet = [[UIButton alloc] initWithFrame:CGRectMake(kTPScreenWidth / 2 + 50, 232, kTPScreenWidth / 2 - 70, 38)];
        _btnGet.backgroundColor = colorMain;
        _btnGet.titleLabel.font = Font_Chinease_Normal(15);
        [_btnGet setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_btnGet setTitleColor:HEXCOLOR(0xfdfbf1) forState:UIControlStateNormal];
        
        [[_btnGet rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (wSelf.codeLeftTime > 0)
                return ;
                [wSelf.userBack.txt resignFirstResponder];
                [wSelf.captchatBack.txt resignFirstResponder];
                [wSelf.passBack.txt resignFirstResponder];
           
            
            if (wSelf.userBack.txt.text.length != 11) {
                TOAST_FAILURE(@"请输入正确的手机号");
                return ;
            }
            
            [wSelf.btnGet start];
            [ABRegModel getCaptcha:@"86" phone:self.userBack.txt.text type:wSelf.isFindPass?@"resetpwd":@"register" success:^(NSDictionary *resultObject) {
                [wSelf.btnGet end];
                ABRegModel* model = [[ABRegModel alloc] initWithDictionary:resultObject error:nil];
                if (model.rspCode.integerValue == 200) {
                    [wSelf.captchatBack.txt becomeFirstResponder];
                    [wSelf.codeTimer fire];
                    wSelf.btnGet.enabled = NO;
                }
                else {
                    TOAST_FAILURE(model.rspMsg);
                }
            } failure:^(NSError *requestErr) {
                [wSelf.btnGet end];
                TOAST_ERROR(wSelf, requestErr);
            }];
        }];
    }
    return _btnGet;
}



- (ABLoginTextCell*)captchatBack {
    if (!_captchatBack) {
        _captchatBack = [[ABLoginTextCell alloc] initWithFrame:CGRectMake(20, 232, kTPScreenWidth / 2 + 10, 38)];
        _captchatBack.icon2.image = [UIImage imageNamed:@"rigest_yzm"];
        _captchatBack.txt.placeholder = @"请输入验证码";
        _captchatBack.txt.keyboardType = UIKeyboardTypePhonePad;
        _captchatBack.txt.textColor = [UIColor whiteColor];
        _captchatBack.type = ABLoginTextCaptcha;
    }
    return _captchatBack;
}

- (ABLoginTextCell*)passBack {
    if (!_passBack) {
        _passBack = [[ABLoginTextCell alloc] initWithFrame:CGRectMake(20, 292, kTPScreenWidth-40, 38)];
        _passBack.icon2.image = [UIImage imageNamed:@"icon_pass"];
        _passBack.txt.placeholder = @"请设置6到16位的密码";
        _passBack.txt.keyboardType = UIKeyboardTypeEmailAddress;
        _passBack.txt.textColor = [UIColor whiteColor];
        _passBack.txt.clearButtonMode = UITextFieldViewModeNever;
        _passBack.type = ABLoginTextPassSee;
    }
    return _passBack;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    ______WS();
//    self.title = self.isFindPass ? @"找回密码" : @"注册";
    self.showBackBtn = YES;
    self.userBack.txt.text = @"";
    
    
    _backgroud_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight)];
    _backgroud_img.image = [UIImage imageNamed:@"login_vc_img"];
    [self.view addSubview:_backgroud_img];
    
    
    _popbtn = [[UIButton alloc] init];
    if (self.isFindPass) {
        [_popbtn setImage:[UIImage imageNamed:@"omo_back_left"] forState:(UIControlStateNormal)];
    }else{
        [_popbtn setImage:[UIImage imageNamed:@"icon_close"] forState:(UIControlStateNormal)];
    }
    
    [self.view addSubview:_popbtn];
    
    [[_popbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (wSelf.isFindPass) {
            [wSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dissmiss_Notification" object:self];
        }
    }];
    
    [_popbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view.mas_left).offset(15);
        make.top.equalTo(wSelf.view.mas_top).offset(32);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _login_lab = [[UILabel alloc] init];
    _login_lab.textColor = [UIColor whiteColor];
    _login_lab.text = self.isFindPass ? @"找回密码" : @"注册";
    _login_lab.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:_login_lab];
    [_login_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view.mas_left).offset(15);
        make.top.equalTo(wSelf.view.mas_top).offset(109);
        make.width.offset(120);
        make.height.offset(33);
    }];
    
    
    [self.view addSubview:self.userBack];
    [self.view addSubview:self.captchatBack];
    [self.view addSubview:self.btnGet];
    [self.view addSubview:self.passBack];
    [self.view addSubview:self.btnSubmit];
    [self.view addSubview:self.lblFuwu];

    [self.lblFuwu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.btnSubmit.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    
    if (!self.isFindPass) {
        _goLoginViewbtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _goLoginViewbtn.titleLabel.font = Font_Chinease_Normal(14);
        [_goLoginViewbtn setTitle:@"已有账号登录 >" forState:UIControlStateNormal];
        [_goLoginViewbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_goLoginViewbtn];
        [[_goLoginViewbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            wSelf.view.hidden = YES;
        }];
        
        [_goLoginViewbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf.view);
            make.top.equalTo(wSelf.view.mas_top).offset(475);
            make.height.offset(16);
            make.width.offset(155);
        }];
    }

    
    [RACObserve(self.btnGet, enabled) subscribeNext:^(NSNumber* x) {
        if (x.boolValue || wSelf.btnGet.isOperationing.boolValue) {
            [wSelf.btnGet setBackgroundColor:colorMain];
        }
        else {
            [wSelf.btnGet setBackgroundColor:colorMainDisable];
        }
    }];
    
    [RACObserve(self.btnSubmit, enabled) subscribeNext:^(NSNumber* x) {
        if (x.boolValue || wSelf.btnSubmit.isOperationing.boolValue) {
            [wSelf.btnSubmit setBackgroundColor:colorMain];
        }
        else {
            [wSelf.btnSubmit setBackgroundColor:colorMainDisable];
        }
    }];
    
    RACSignal* s = [RACSignal combineLatest:@[self.userBack.txt.rac_textSignal,self.captchatBack.txt.rac_textSignal,self.passBack.txt.rac_textSignal]];
    [s subscribeNext:^(RACTuple* x) {
        NSString* u = x.first;
        NSString* c = x.second;
        NSString* p = x.third;
        NSString* p1 = [wSelf removeChinese:x.third];
        if (![p1 isEqualToString:p]) {
            wSelf.passBack.txt.text = p1;
            return ;
        }
        wSelf.btnGet.enabled = u.length > 0 && wSelf.codeLeftTime == 0;
        wSelf.btnSubmit.enabled = u.length > 0 && c.length == 6 && p.length >=6&& p.length<=16;
    }];
    
    self.btnGet.enabled = false;
    self.btnSubmit.enabled = false;
}

- (NSString*)removeChinese:(NSString *)str {
    NSMutableString* string = [NSMutableString string];
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            //中文字符
        }
        else {
            [string appendString:[str substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return string;
}



@end
