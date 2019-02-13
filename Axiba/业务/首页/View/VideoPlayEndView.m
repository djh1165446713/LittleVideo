//
//  VideoPlayEndView.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/4/17.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "VideoPlayEndView.h"

@implementation VideoPlayEndView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        ______WS();
        self.backImg = [[UIImageView alloc] init];
        self.backImg.backgroundColor = [UIColor blackColor];
        self.backImg.alpha = 0.5;
        self.backImg.frame = frame;
        [self addSubview:self.backImg];
        
        
        self.seeAgainImg = [[UIImageView alloc] init];
        self.seeAgainImg.userInteractionEnabled = YES;
        self.seeAgainImg.image = [UIImage imageNamed:@"again_see"];
        [self addSubview:self.seeAgainImg];
        [self.seeAgainImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf.mas_centerX).offset(-55);
            make.width.height.offset(30);
            make.centerY.equalTo(wSelf.mas_centerY).offset(-30);
        }];
        
        
        self.againLab = [[UILabel alloc] init];
        self.againLab.text = @"再看一遍";
        self.againLab.userInteractionEnabled = YES;
        self.againLab.font = [UIFont systemFontOfSize:18];
        self.againLab.textColor = [UIColor whiteColor];
        [self addSubview:self.againLab];
        [self.againLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.seeAgainImg.mas_right).offset(10);
            make.height.offset(18);
            make.width.offset(100);
            make.centerY.equalTo(wSelf.seeAgainImg);

        }];
        
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.text = @"觉得不错, 就动动手分享一下吧";
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(15);
            make.width.offset(kTPScreenWidth);
            make.centerX.equalTo(wSelf);
            make.top.equalTo(wSelf.seeAgainImg.mas_bottom).offset(15);
        }];
        
        
        self.wbBtn = [[UIButton alloc] init];
        [self.wbBtn setImage:[UIImage imageNamed:@"wbImg_share"] forState:UIControlStateNormal];
        [self.wbBtn addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        self.wbBtn.tag = 1006;
        [self.wbBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:self.wbBtn];
        [self.wbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf.mas_centerX).offset(-15);
            make.width.offset(30);
            make.height.offset(40);
            make.top.equalTo(wSelf.titleLab.mas_bottom).offset(18);
        }];
        
        
        self.wxfBtn = [[UIButton alloc] init];
        self.wxfBtn.tag = 1005;
        [self.wxfBtn setImage:[UIImage imageNamed:@"wxf_share"] forState:UIControlStateNormal];
        [self.wxfBtn addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.wxfBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:self.wxfBtn];
        [self.wxfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.wbBtn.mas_left).offset(-20);
            make.width.offset(30);
            make.height.offset(40);
            make.centerY.equalTo(wSelf.wbBtn);
        }];
        
        self.wxBtn = [[UIButton alloc] init];
        self.wxBtn.tag = 1004;
        [self.wxBtn setImage:[UIImage imageNamed:@"wx_share"] forState:UIControlStateNormal];
        [self.wxBtn addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.wxBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:self.wxBtn];
        [self.wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.wxfBtn.mas_left).offset(-20);
            make.width.offset(30);
            make.height.offset(40);
            make.centerY.equalTo(wSelf.wbBtn);
        }];
        
        
        
        self.qqBtn = [[UIButton alloc] init];
        self.qqBtn.tag = 1003;
        [self.qqBtn setImage:[UIImage imageNamed:@"qq_share"] forState:UIControlStateNormal];
        [self.qqBtn addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.qqBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:self.qqBtn];
        [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.wbBtn.mas_right).offset(20);
            make.width.offset(30);
            make.height.offset(40);
            make.centerY.equalTo(wSelf.wbBtn);
        }];
        
        
        self.qqkjBtn = [[UIButton alloc] init];
        self.qqkjBtn.tag = 1002;
        [self.qqkjBtn setImage:[UIImage imageNamed:@"qqkj_share"] forState:UIControlStateNormal];
        [self.qqkjBtn addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.qqkjBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:self.qqkjBtn];
        [self.qqkjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.qqBtn.mas_right).offset(20);
            make.width.offset(30);
            make.height.offset(40);
            make.centerY.equalTo(wSelf.wbBtn);
        }];
        
        
        self.scBtn = [[UIButton alloc] init];
        [self.scBtn setImage:[UIImage imageNamed:@"sc_share"] forState:UIControlStateNormal];
        [self.scBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.scBtn addTarget:self action:@selector(scbtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.scBtn];
        [self.scBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.qqkjBtn.mas_right).offset(20);
            make.width.offset(30);
            make.height.offset(40);
            make.centerY.equalTo(wSelf.wbBtn);
        }];
        
    }
    return self;
}

- (void)scbtnAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoeEndPlay_TapBtn" object:nil userInfo:nil];
}



- (void)shareAction:(UIButton *)btn{
    if (btn.tag == 1002) {
        self.typeShare = @"5";
    }
    if (btn.tag == 1003) {
        self.typeShare = @"4";
    }
    if (btn.tag == 1004) {
        self.typeShare = @"1";
    }
    if (btn.tag == 1005) {
        self.typeShare = @"2";
    }
    
    if (btn.tag == 1006) {
        self.typeShare = @"3";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoeEndPlay_TapShare" object:nil userInfo:@{@"type":self.typeShare}];

}


@end
