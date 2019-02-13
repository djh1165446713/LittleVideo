//
//  HeaderADView.m
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/3.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import "HeaderADView.h"

@implementation HeaderADView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        ______WS();
        self.backgroundColor = RGB(22, 21, 16);
        _adicon = [[UIImageView alloc] init];
        _adicon.image = [UIImage imageNamed:@"notic"];
        [self addSubview:_adicon];
        [_adicon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf);
            make.width.height.offset(15);
            make.left.equalTo(wSelf).offset(15);
        }];
        
        _adtitle = [[UILabel alloc] init];
        _adtitle.text = @"趣编一点视频上线";
        _adtitle.textColor = [UIColor whiteColor];
        _adtitle.font = [UIFont systemFontOfSize:12];
        [self addSubview:_adtitle];
        [_adtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf);
            make.left.equalTo(wSelf.adicon.mas_right).offset(10);
            make.height.offset(17);
            make.right.equalTo(wSelf.mas_right).offset(-80);

        }];
        
        _adbutton= [[UIButton alloc] init];
        [self.adbutton setTitle:@"查看详情" forState:(UIControlStateNormal)];
//        [self.adbutton addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.adbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.adbutton.backgroundColor = RGB(255, 186, 0);
        _adbutton.titleLabel.font = [UIFont systemFontOfSize:10];

        [self addSubview:self.adbutton];
        [self.adbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf);
            make.height.offset(19);
            make.right.equalTo(wSelf.mas_right).offset(-10);
            make.width.offset(59);
        }];
        
    }
    return self;
}

@end
