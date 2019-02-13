//
//  ABUpdatePannel.m
//  Axiba
//
//  Created by Peter on 16/6/14.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABUpdatePannel.h"

@interface ABUpdatePannel()
@property (nonatomic, strong) UIView     *vMain;
@property (nonatomic, strong) UILabel    *vTitle;
@property (nonatomic, strong) UIView     *vLine;
@property (nonatomic, strong) UIButton   *btnCancel;
@property (nonatomic, strong) UIButton   *btnAgree;
@end

@implementation ABUpdatePannel

- (id)init {
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ______WS();
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.vMain = [[UIView alloc] init];
        self.vMain.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        self.vMain.layer.cornerRadius = 5;
        self.vMain.layer.masksToBounds = YES;
        [self addSubview:self.vMain];
        [self.vMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(wSelf.mas_centerX);
            make.centerY.mas_equalTo(wSelf.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(233, 150));
        }];
        
        self.vTitle = [UILabel new];
        self.vTitle.font = Font_Chinease_Blod(30);
        self.vTitle.text = @"爸爸有更新";
        self.vTitle.textColor = [UIColor whiteColor];
        self.vTitle.textAlignment = NSTextAlignmentCenter;
        [self.vMain addSubview:self.vTitle];
        [self.vTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.vMain);
            make.right.equalTo(wSelf.vMain);
            make.top.equalTo(wSelf.vMain).offset(37);
            make.height.mas_equalTo(35);
        }];
        
        self.vLine = [UIView new];
        self.vLine.backgroundColor = [UIColor whiteColor];
        [self.vMain addSubview:self.vLine];
        [self.vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.vMain.mas_left).offset(30);
            make.right.equalTo(wSelf.vMain.mas_right).offset(-30);
            make.bottom.equalTo(wSelf.vMain.mas_bottom).offset(-60);
            make.height.mas_equalTo(1);
        }];
        
        self.btnCancel = [UIButton new];
        [self.btnCancel setTitle:@"下次再说" forState:UIControlStateNormal];
        self.btnCancel.titleLabel.font = Font_Chinease_Normal(14);
        self.btnCancel.backgroundColor = [UIColor clearColor];
        self.btnCancel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.btnCancel.layer.borderWidth = 1;
        self.btnCancel.layer.cornerRadius = 15;
        [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.vMain addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.vMain.mas_centerX).offset(-10);
            make.bottom.equalTo(wSelf.vMain.mas_bottom).offset(-15);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        [[self.btnCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [wSelf hide];
        }];
        
        self.btnAgree = [UIButton new];
        [self.btnAgree setTitle:@"确定升级" forState:UIControlStateNormal];
        self.btnAgree.titleLabel.font = Font_Chinease_Normal(14);
        self.btnAgree.backgroundColor = [UIColor whiteColor];
        self.btnAgree.layer.borderColor = [UIColor whiteColor].CGColor;
        self.btnAgree.layer.borderWidth = 1;
        self.btnAgree.layer.cornerRadius = 15;
        [self.btnAgree setTitleColor:colorMainText forState:UIControlStateNormal];
        [self.vMain addSubview:self.btnAgree];
        [self.btnAgree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.vMain.mas_centerX).offset(10);
            make.bottom.equalTo(wSelf.vMain.mas_bottom).offset(-15);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        [[self.btnAgree rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [wSelf hide];
        }];
    }
    return self;
}

- (void)show {
    [[[CTTools currentRootController] view] addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}
@end
