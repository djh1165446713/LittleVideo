//
//  CTBriefVC.m
//  Axiba
//
//  Created by Peter on 16/6/11.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBriefVC.h"

@interface CTBriefVC ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView    *txt;
@property (nonatomic, strong) UILabel       *lbl;
@end

@implementation CTBriefVC

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
        _lbl.text = @"简介不能超过34个字";
        _lbl.font = Font_Chinease_Normal(12);
        _lbl.textAlignment = NSTextAlignmentCenter;
    }
    return _lbl;
}

- (void)viewDidLoad {
    ______WS();
    [super viewDidLoad];
    self.title = @"简介";
    self.view.backgroundColor = [UIColor whiteColor];
    self.showBackBtn = YES;
    [self actionCustomRightBtnWithNrlImage:nil htlImage:nil title:@"保存" action:^{
        [wSelf.txt resignFirstResponder];
        if (wSelf.block != NULL) {
            wSelf.block(wSelf.txt.text);
        }
    }];
    
    [self.view addSubview:self.txt];
    self.txt.text = self.summary;
    [self.txt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.view).offset(20);
        make.height.mas_equalTo(127);
    }];
    
    [self.view addSubview:self.lbl];
    [self.lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view);
        make.right.equalTo(wSelf.view);
        make.top.equalTo(wSelf.txt.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length > 0 && textView.text.length + text.length > 34)
        return NO;
    return YES;
}

@end
