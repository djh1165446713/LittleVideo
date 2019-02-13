//
//  ABChangePassVC.m
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABChangePassVC.h"
#import "ABLoginTextCell.h"
#import "ABChangePassModel.h"

@interface ABChangePassVC ()
@property (nonatomic, strong) ABLoginTextCell   *cellOld;
@property (nonatomic, strong) ABLoginTextCell   *cellNew1;
@property (nonatomic, strong) ABLoginTextCell   *cellNew2;
@property (nonatomic, strong) UIButton          *btnSubmit;
@end

@implementation ABChangePassVC

- (ABLoginTextCell*)cellOld {
    if (!_cellOld) {
        _cellOld = [[ABLoginTextCell alloc] initWithFrame:CGRectMake(20, 30, kTPScreenWidth - 40, 45)];
        _cellOld.backgroundColor = RGB(179, 179, 179);
        _cellOld.icon2.image = [UIImage imageNamed:@"icon_pass_a1"];
        _cellOld.txt.placeholder = @"请输入旧密码";
        _cellOld.txt.keyboardType = UIKeyboardTypeEmailAddress;
        _cellOld.txt.secureTextEntry = YES;
        _cellOld.txt.textColor = [UIColor whiteColor];
        _cellOld.type = ABLoginTextPass;
    }
    return _cellOld;
}

- (ABLoginTextCell*)cellNew1 {
    if (!_cellNew1) {
        _cellNew1 = [[ABLoginTextCell alloc] initWithFrame:CGRectMake(20, 95, kTPScreenWidth - 40, 45)];
        _cellNew1.backgroundColor = RGB(247, 247, 247);
        _cellNew1.icon2.image = [UIImage imageNamed:@"icon_pass_a1"];
        _cellNew1.txt.placeholder = @"请输入新密码";
        _cellNew1.txt.keyboardType = UIKeyboardTypeEmailAddress;
        _cellNew1.txt.secureTextEntry = YES;
        _cellNew1.txt.textColor = [UIColor whiteColor];
        _cellNew1.type = ABLoginTextPass;
    }
    return _cellNew1;
}

- (ABLoginTextCell*)cellNew2 {
    if (!_cellNew2) {
        _cellNew2 = [[ABLoginTextCell alloc] initWithFrame:CGRectMake(20, 155, kTPScreenWidth - 40, 45)];
        _cellNew2.backgroundColor = RGB(247, 247, 247);
        _cellNew2.icon2.image = [UIImage imageNamed:@"icon_pass_a1"];
        _cellNew2.txt.placeholder = @"请再次输入新密码";
        _cellNew2.txt.keyboardType = UIKeyboardTypeEmailAddress;
        _cellNew2.txt.secureTextEntry = YES;
        _cellNew2.txt.textColor = [UIColor whiteColor];
        _cellNew2.type = ABLoginTextPass;
    }
    return _cellNew2;
}

- (UIButton*)btnSubmit {
    if (!_btnSubmit) {
        ______WS();
        _btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(20, 245, kTPScreenWidth - 40, 44)];
        _btnSubmit.backgroundColor = colorMain;
        _btnSubmit.layer.cornerRadius = 22;
        [_btnSubmit setTitle:@"确定" forState:UIControlStateNormal];
        _btnSubmit.titleLabel.font = Font_Chinease_Blod(18);
        
        [[_btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [wSelf.cellOld.txt resignFirstResponder];
            [wSelf.cellNew1.txt resignFirstResponder];
            [wSelf.cellNew2.txt resignFirstResponder];
            if (![wSelf.cellNew1.txt.text isEqualToString:wSelf.cellNew2.txt.text]) {
                TOAST_FAILURE(@"两次新密码不一致");
                return ;
            }
            if (wSelf.cellNew1.txt.text.length < 6 || wSelf.cellNew1.txt.text.length > 16) {
                TOAST_FAILURE(@"请输入支持6-16密码，密码不支持特殊字符");
                return ;
            }
            [wSelf.btnSubmit start];
            [ABChangePassModel changePass:wSelf.cellOld.txt.text newPassword:wSelf.cellNew1.txt.text success:^(NSDictionary *resultObject) {
                [wSelf.btnSubmit end];
                ABChangePassModel* model = [[ABChangePassModel alloc] initWithDictionary:resultObject error:nil];
                if (model.rspCode.integerValue == 200) {
                    TOAST_SUCCESS(@"密码修改成功");
                    [wSelf.navigationController popViewControllerAnimated:YES];
                }
                else {
                    TOAST_FAILURE(model.rspMsg);
                }
            } failure:^(NSError *requestErr) {
                [wSelf.btnSubmit end];
                TOAST_ERROR(wSelf, requestErr);
            }];
        }];
    }
    return _btnSubmit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ______WS();
    self.title = @"修改密码";
    self.showBackBtn = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cellOld];
    [self.view addSubview:self.cellNew1];
    [self.view addSubview:self.cellNew2];
    [self.view addSubview:self.btnSubmit];
    
    [RACObserve(self.btnSubmit, enabled) subscribeNext:^(NSNumber* x) {
        if (x.boolValue || wSelf.btnSubmit.isOperationing.boolValue) {
            [wSelf.btnSubmit setBackgroundColor:colorMain];
        }
        else {
            [wSelf.btnSubmit setBackgroundColor:colorMainDisable];
        }
    }];
    
    RACSignal* s = [RACSignal combineLatest:@[self.cellOld.txt.rac_textSignal,self.cellNew1.txt.rac_textSignal,self.cellNew2.txt.rac_textSignal]];
    [s subscribeNext:^(RACTuple* x) {
        NSString* o = x.first;
        NSString* n1 = x.second;
        NSString* n2 = x.third;
        wSelf.btnSubmit.enabled = o.length > 0 && n1.length > 0 && n2.length > 0;
    }];
    
    self.btnSubmit.enabled = false;
}


@end
