//
//  ABPerfectInfoVC
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABPerfectInfoVC.h"
#import "ABLoginTextCell.h"
#import "ABProfileModel.h"

@interface ABPerfectInfoVC ()
@property (nonatomic, strong) UIImageView   *imgHead;
@property (nonatomic, strong) UILabel       *lblTitle;
@property (nonatomic, strong) ABLoginTextCell   *nickCell;
@property (nonatomic, strong) UIButton      *btnSubmit;
@end

@implementation ABPerfectInfoVC

- (UIImageView*)imgHead {
    if (!_imgHead) {
        _imgHead = [UIImageView new];
        _imgHead.image = [UIImage imageNamed:@"icon_need_head"];
        _imgHead.layer.cornerRadius = 37.5;
        _imgHead.layer.masksToBounds = YES;
        _imgHead.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
        [_imgHead addGestureRecognizer:tap];
    }
    return _imgHead;
}

- (UILabel*)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [UILabel new];
        _lblTitle.text = @"设置头像";
        _lblTitle.font = Font_Chinease_Normal(15);
        _lblTitle.textColor = colorNormalText;
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
        [_lblTitle addGestureRecognizer:tap];
    }
    return _lblTitle;
}

- (ABLoginTextCell*)nickCell {
    if (!_nickCell) {
        _nickCell = [[ABLoginTextCell alloc] initWithFrame:CGRectMake(20, 130, kTPScreenWidth - 40, 44)];
        _nickCell.icon2.image = [UIImage imageNamed:@"icon_user"];
        _nickCell.txt.placeholder = @"请输入用户名(支持英文、数字、“_”或-)";
        _nickCell.txt.keyboardType = UIKeyboardTypeDefault;
        _nickCell.type = ABLoginTextNick;
    }
    return _nickCell;
}

- (UIButton*)btnSubmit {
    if (!_btnSubmit) {
        ______WS();
        _btnSubmit = [[UIButton alloc] init];
        _btnSubmit.backgroundColor = colorMain;
        _btnSubmit.layer.cornerRadius = 22;
        [_btnSubmit setTitle:@"确定" forState:UIControlStateNormal];
        [[_btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [wSelf.btnSubmit start];
            [ABProfileModel updateProfile:@"nickName" value:wSelf.nickCell.txt.text success:^(NSDictionary *resultObject) {
                [wSelf.btnSubmit end];
                ABProfileModel* model = [[ABProfileModel alloc] initWithDictionary:resultObject error:nil];
                if (model.rspCode.integerValue == 200) {
                    [[[[ABUser sharedInstance] abuser] user] setNickname:wSelf.nickCell.txt.text];
                    [[ABUser sharedInstance] syncUser];
                    [wSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    self.showBackBtn = NO;
    self.title = @"完善用户信息";
    
    [self.view addSubview:self.imgHead];
    [self.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.view.mas_centerX);
        make.top.equalTo(wSelf.view.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    [self.view addSubview:self.lblTitle];
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.imgHead.mas_bottom).offset(8);
        make.height.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.nickCell];
    [self.view addSubview:self.btnSubmit];
    [self.btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view.mas_left).offset(20);
        make.right.equalTo(wSelf.view.mas_right).offset(-20);
        make.top.equalTo(wSelf.nickCell.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    [RACObserve(self.btnSubmit, enabled) subscribeNext:^(NSNumber* x) {
        if (x.boolValue || wSelf.btnSubmit.isOperationing.boolValue) {
            [wSelf.btnSubmit setBackgroundColor:colorMain];
        }
        else {
            [wSelf.btnSubmit setBackgroundColor:colorMainDisable];
        }
    }];
    self.btnSubmit.enabled = false;
    
    [self.nickCell.txt.rac_textSignal subscribeNext:^(NSString* x) {
        wSelf.btnSubmit.enabled = x.length > 0;
    }];
}

- (void)choosePhoto {
    ______WS();
    [[CTTakePhotoTool sharedInstance] takePhoto:self placeholder:@"请上传头像" autoUpload:YES chooseBlock:^(NSString * _Nonnull picName, UIImage * _Nonnull image) {
        wSelf.imgHead.image = image;
    } errorBlock:nil completeUploadBlock:^(NSString * _Nonnull picUrl, UIImage * _Nonnull image) {
        [[[[ABUser sharedInstance] abuser] user] setAvator:picUrl];
        [[ABUser sharedInstance] syncUser];
    }];
}

@end
