//
//  CommentsVideoView.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/5/3.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "CommentsVideoView.h"

@implementation CommentsVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self initUI];
        
    }
    return self;
}


- (void)initUI{
    ______WS();
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self addSubview:_effectView];
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.mas_top).offset(0);
        make.bottom.equalTo(wSelf.mas_bottom).offset(0);
        make.right.equalTo(wSelf.mas_right).offset(0);
        make.left.equalTo(wSelf.mas_left).offset(0);
    }];
    
    
    self.closeImg_comm = [[UIImageView alloc] init];
    self.closeImg_comm.image = [UIImage imageNamed:@"omo_new_chacha"];
    self.closeImg_comm.userInteractionEnabled = YES;
    [self addSubview:self.closeImg_comm];
    [self.closeImg_comm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf).offset(10);
        make.top.equalTo(wSelf).offset(17);
        make.width.offset(15);
        make.height.offset(15);
    }];
    
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.text = @"评论";
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf);
        make.top.equalTo(wSelf).offset(17);
        make.width.offset(100);
        make.height.offset(16);
    }];
    
    
    self.send_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.send_btn setImage:[UIImage imageNamed:@"sure_send"] forState:(UIControlStateNormal)];
    self.send_btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.send_btn];
    [self.send_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wSelf.titleLab);
        make.right.equalTo(wSelf.mas_right).offset(-15);
        make.width.offset(20);
        make.height.offset(15);
    }];
    
    
    self.line_view = [[UIView alloc] init];
    self.line_view.backgroundColor = RGB(102, 102, 102);
    [self addSubview:self.line_view];
    [self.line_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.equalTo(wSelf).offset(15);
        make.right.equalTo(wSelf).offset(-15);
        make.top.equalTo(wSelf.mas_top).offset(49);
    }];
    
    
    self.textView_comm = [[UITextView alloc] init];
    [self addSubview:self.textView_comm];
    self.textView_comm.backgroundColor = [UIColor clearColor];
    [self.textView_comm  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.line_view.mas_bottom).offset(20);
        make.left.equalTo(wSelf).offset(10);
        make.right.equalTo(wSelf).offset(-10);
//        make.bottom.equalTo(wSelf.mas_bottom).offset(-10);
        make.height.offset(100);

    }];
}

@end
