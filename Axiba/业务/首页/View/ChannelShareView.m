//
//  ChannelShareView.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/12/22.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "ChannelShareView.h"

@implementation ChannelShareView
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        ______WS();
        
        _back_bigview = [[UIView alloc] init];
        _back_bigview.backgroundColor = RGB(22, 21, 16);
        _back_bigview.userInteractionEnabled = YES;
        _back_bigview.alpha = 0.8;
        _back_bigview.hidden = YES;
        [self addSubview:_back_bigview];
        [_back_bigview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wSelf.mas_top).offset(0);
            make.width.offset(kTPScreenWidth);
            make.height.offset(kTPScreenHeight);
            make.left.equalTo(wSelf).offset(0);
        }];

        _back_view = [[UIView alloc] init];
        _back_view.backgroundColor = RGB(255, 255, 255);
        [self addSubview:_back_view];
        [_back_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wSelf.mas_bottom).offset(0);
            make.width.offset(kTPScreenWidth);
            make.height.offset(250);
        }];
        
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.hidden = YES;
        [_back_view addSubview:_effectView];
        [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wSelf.back_view.mas_top).offset(0);
            make.width.offset(kTPScreenWidth);
            make.height.offset(kTPScreenHeight);
            make.left.equalTo(wSelf.back_view.mas_left).offset(0);
        }];

        _share_titlt = [[UILabel alloc] init];
        _share_titlt.text = @"分享";
        _share_titlt.textColor = [UIColor blackColor];
        _share_titlt.font = [UIFont systemFontOfSize:18];
        [_back_view addSubview:_share_titlt];
        [_share_titlt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf);
            make.top.equalTo(wSelf.back_view.mas_top).offset(28);
            make.width.offset(37);
            make.height.offset(25);
        }];
        
        _summy_lab = [[UILabel alloc] init];
        _summy_lab.textColor = [UIColor whiteColor];
        _summy_lab.font = [UIFont systemFontOfSize:10];
        _summy_lab.textAlignment = NSTextAlignmentCenter;
        _summy_lab.hidden = YES;
        [_back_view addSubview:_summy_lab];
        [_summy_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.mas_right).offset(0);
            make.top.equalTo(wSelf.share_titlt.mas_bottom).offset(18);
            make.width.offset(kTPScreenWidth);
            make.height.offset(12);
        }];
        
        
        _line_Top = [[UIView alloc] init];
        _line_Top.backgroundColor =RGB(232, 232, 232);
        [_back_view addSubview:_line_Top];
        [_line_Top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.mas_left).offset(30);
            make.right.equalTo(wSelf.mas_right).offset(-30);
            make.top.equalTo(wSelf.back_view.mas_top).offset(88);
            make.height.offset(1);
        }];

        self.share_QQ = [[UIButton alloc] init];
        [self.share_QQ setImage:[UIImage imageNamed:@"channle_qq"] forState:UIControlStateNormal];
        [self.share_QQ addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.share_QQ setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.share_QQ.tag = 10003;
        [_back_view addSubview:self.share_QQ];
        [self.share_QQ mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf);
            make.width.offset(29);
            make.height.offset(49);
            make.top.equalTo(wSelf.back_view.mas_top).offset(110);
        }];

        self.share_PYQ = [[UIButton alloc] init];
        [self.share_PYQ setImage:[UIImage imageNamed:@"channle_wxg"] forState:UIControlStateNormal];
        [self.share_PYQ addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.share_PYQ setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.share_PYQ.tag = 10005;
        [_back_view addSubview:self.share_PYQ];
        [self.share_PYQ mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.share_QQ.mas_left).offset(-33);
            make.width.offset(29);
            make.height.offset(49);
            make.top.equalTo(wSelf.back_view.mas_top).offset(110);
        }];


        self.share_WX = [[UIButton alloc] init];
        [self.share_WX setImage:[UIImage imageNamed:@"channle_wx"] forState:UIControlStateNormal];
        [self.share_WX addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.share_WX setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.share_WX.tag = 10004;
        [_back_view addSubview:self.share_WX];
        [self.share_WX mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.share_PYQ.mas_left).offset(-33);
            make.width.offset(29);
            make.height.offset(49);
            make.top.equalTo(wSelf.back_view.mas_top).offset(110);
        }];


        self.share_QQozoe = [[UIButton alloc] init];
        [self.share_QQozoe setImage:[UIImage imageNamed:@"channle_qqozne"] forState:UIControlStateNormal];
        [self.share_QQozoe addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.share_QQozoe setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.share_QQozoe.tag = 10002;
        [_back_view addSubview:self.share_QQozoe];
        [self.share_QQozoe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.share_QQ.mas_right).offset(33);
            make.width.offset(29);
            make.height.offset(49);
            make.top.equalTo(wSelf.back_view.mas_top).offset(110);
        }];

        self.share_WB = [[UIButton alloc] init];
        [self.share_WB setImage:[UIImage imageNamed:@"channle_wb"] forState:UIControlStateNormal];
        [self.share_WB addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.share_WB setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.share_WB.tag = 10006;
        [_back_view addSubview:self.share_WB];
        [self.share_WB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.share_QQozoe.mas_right).offset(33);
            make.width.offset(29);
            make.height.offset(49);
            make.top.equalTo(wSelf.back_view.mas_top).offset(110);
        }];

        _line_bottom = [[UIView alloc] init];
        _line_bottom.backgroundColor =RGB(232, 232, 232);
        [_back_view addSubview:_line_bottom];
        [_line_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.mas_left).offset(30);
            make.right.equalTo(wSelf.mas_right).offset(-30);
            make.top.equalTo(wSelf.back_view.mas_top).offset(180);
            make.height.offset(1);
        }];

        self.cancel_btn = [[UIButton alloc] init];
        [self.cancel_btn setTitle:@"取消" forState:UIControlStateNormal];
        self.cancel_btn.titleLabel.font = Font_Chinease_Blod(14);
        [self.cancel_btn setTitleColor:RGB(58, 58, 58) forState:UIControlStateNormal];
        [_back_view addSubview:self.cancel_btn];
        [self.cancel_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf);
            make.width.offset(40);
            make.height.offset(20);
            make.top.equalTo(wSelf.line_bottom.mas_bottom).offset(20);
        }];
        
    }
    return self;
}

- (void)shareAction:(UIButton *)btn{
    if (btn.tag == 10002) {
        self.typeShare = @"5";
    }
    if (btn.tag == 10003) {
        self.typeShare = @"4";
    }
    if (btn.tag == 10004) {
        self.typeShare = @"1";
    }
    if (btn.tag == 10005) {
        self.typeShare = @"2";
    }
    
    if (btn.tag == 10006) {
        self.typeShare = @"3";
    }
    [MobClick event:@"share_day_num"];

    if ([self.from isEqualToString:@"channel"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChannelShare_TapShare" object:self userInfo:@{@"type":self.typeShare}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"videoeEndPlay_TapShare" object:self userInfo:@{@"type":self.typeShare}];
    }
    
}


@end
