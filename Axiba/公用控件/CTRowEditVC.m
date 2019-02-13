//
//  CTRowEditVC.m
//  TP
//
//  Created by Peter on 15/10/8.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "CTRowEditVC.h"
#import "ABProfileModel.h"
@interface CTRowEditVC ()<UITextFieldDelegate>

@property (nonatomic, strong)ABTextField    *txt;
@property (nonatomic, strong)UILabel        *lblMsg;
@end

@implementation CTRowEditVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUIS];
}

- (void)initUIS {
    ______WS();
    self.bDisableGesture = self.bHideBackBtn;
    [self setShowBackBtn:!self.bHideBackBtn];
    
    UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kTPScreenWidth, 44)];
    vvv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vvv];
    
    self.txt = [[ABTextField alloc] initWithFrame:CGRectMake(20, 0, vvv.width - 40, vvv.height)];
    self.txt.placeholder = self.placeholder;
    self.txt.delegate = self;
    self.txt.text = self.text;
    [vvv addSubview:self.txt];

    self.lblMsg = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, kTPScreenWidth - 40, 20)];
    self.lblMsg.textColor = colorNormalText;
    self.lblMsg.font = Font_Chinease_Normal(13);
    self.lblMsg.textAlignment = NSTextAlignmentCenter;
    self.lblMsg.text = self.tipMsg;
    [self.view addSubview:self.lblMsg];;
    
    [self actionCustomRightBtnWithNrlImage:nil htlImage:nil title:@"保存" action:^{
        [wSelf submitAction];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length + string.length > self.maxLength) {
        if (string.length > 0)
            return NO;
    }
    return YES;
}

- (void)submitAction {
    ______WS();
    if (![self.txt.text isValid]) {
        return ;
    };
    if (self.txt.text.length > self.maxLength) {
        NSString* msg = [NSString stringWithFormat:@"长度不能超过%zd位",self.maxLength];
        TOAST_FAILURE(msg);
        return;
    }
    [self.txt resignFirstResponder];
    if ([self.txt.text isEqualToString:self.text]) {
        TOAST_SUCCESS(@"保存成功");
        if (wSelf.completeBlock!=NULL) {
            wSelf.completeBlock(wSelf.keyName,wSelf.txt.text);
        }
        [wSelf.navigationController popViewControllerAnimated:YES];
        return;
    }
    TOAST_Process;
    [ABProfileModel updateProfile:self.keyName value:self.txt.text success:^(NSDictionary *resultObject) {
        ABProfileModel* model = [[ABProfileModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200) {
            TOAST_SUCCESS(@"保存成功");
            if (wSelf.completeBlock!=NULL) {
                wSelf.completeBlock(wSelf.keyName,wSelf.txt.text);
            }
            [wSelf.navigationController popViewControllerAnimated:YES];
        }
        else {
            TOAST_FAILURE(model.rspMsg);
        }
    } failure:^(NSError *requestErr) {
        TOAST_ERROR(wSelf, requestErr);
    }];
}

@end
