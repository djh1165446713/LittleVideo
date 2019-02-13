//
//  ABFeedbackVC.m
//  Axiba
//
//  Created by Peter on 16/6/11.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABFeedbackVC.h"
#import "ABFeedbackModel.h"
#import "ABEditProfileVC.h"

@interface ABFeedbackVC ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView    *txt;
@property (nonatomic, strong) UILabel       *lbl;
@property (nonatomic, strong) UIButton      *btnSubmit;
@end

@implementation ABFeedbackVC

- (UITextView*)txt {
    if (!_txt) {
        _txt = [UITextView new];
        _txt.font = Font_Chinease_Normal(14);
        _txt.textColor = RGB(22, 21, 16);
        _txt.delegate = self;
        _txt.backgroundColor = RGB(235, 235, 235);
        _txt.tintColor = RGB(22, 21, 16);
        _txt.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
    }
    return _txt;
}

- (UILabel*)lbl {
    if (!_lbl) {
        _lbl = [UILabel new];
        _lbl.textColor = colorNormalText;
        _lbl.text = @"内容不能超过200个字";
        _lbl.font = Font_Chinease_Normal(12);
        _lbl.textAlignment = NSTextAlignmentCenter;
    }
    return _lbl;
}

- (UIButton*)btnSubmit {
    if (!_btnSubmit) {
        ______WS();
        _btnSubmit = [[UIButton alloc] init];
        _btnSubmit.backgroundColor = HEXCOLOR(0xffdd2a);
        _btnSubmit.titleLabel.font = Font_Chinease_Blod(17);
        [_btnSubmit setTitle:@"提交意见" forState:UIControlStateNormal];
        
        [[_btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (![wSelf.txt.text isValid]) {
                TOAST_FAILURE(@"请输入反馈意见");
                return ;
            }
            if (wSelf.txt.text.length > 200) {
                NSString* msg = [NSString stringWithFormat:@"长度不能超过200位"];
                TOAST_FAILURE(msg);
                return;
            }
            if (![[[[[ABUser sharedInstance] abuser] user] city] isValid] || ![[[[ABUser sharedInstance] abuser] user] birthday]) {

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"baba需要完善个人资料哦(城市/生日)" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"完善信息", nil];
                [alert show];
                [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber* x) {
                    if (x.integerValue == 1) {
                        [wSelf.navigationController pushViewController:[ABEditProfileVC new] animated:NO];
                    }
                }];
                return ;
            }
            [wSelf.btnSubmit start];
            [ABFeedbackModel feedback:wSelf.txt.text success:^(NSDictionary *resultObject) {
                ABFeedbackModel* model = [[ABFeedbackModel alloc] initWithDictionary:resultObject error:nil];
                if (model.rspCode.integerValue == 200) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wSelf.btnSubmit end];
                        NSString* msg = @"隆重欢迎baba给我们提意见，我们积（bu）极（hui）地改善问题";
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"爸爸我知道了" otherButtonTitles: nil];
                        [alert show];
                        [[alert rac_buttonClickedSignal] subscribeNext:^(id x) {
                            [wSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    });
                }
                else {
                    [wSelf.btnSubmit end];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    ______WS();
    self.title = @"意见反馈";
    self.showBackBtn = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.txt];
    [self.txt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.view).offset(20);
        make.height.mas_equalTo(203);
    }];
    
    [self.view addSubview:self.lbl];
    [self.lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.txt.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.btnSubmit];
    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view).offset(40);
        make.right.equalTo(wSelf.view).offset(-40);
        make.top.equalTo(wSelf.lbl.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length > 0 && textView.text.length + text.length > 200)
        return NO;
    return YES;
}



@end
