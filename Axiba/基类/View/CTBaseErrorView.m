//
//  CTBaseErrorView.m
//  Tripinsiders
//
//  Created by Peter on 16/4/18.
//  Copyright © 2016年 Tripinsiders. All rights reserved.
//

#import "CTBaseErrorView.h"

@interface CTBaseErrorView()
@property (nonatomic, strong) UIImageView   *img;
@property (nonatomic, strong) UIButton  *btnReload;
@end

@implementation CTBaseErrorView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ______WS();
        self.backgroundColor = colorMainBG;
        
        self.img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_neterror"]];
        [self addSubview:self.img];
        [self.img mas_makeConstraints:^(MASConstraintMaker* maker) {
            maker.centerY.mas_equalTo(wSelf).with.offset(-100);
            maker.centerX.mas_equalTo(wSelf);
            maker.size.mas_equalTo(CGSizeMake(135, 148));
        }];
        
        self.btnReload = [CTTools getButton:@"重试" frame:CGRectZero];
        [self addSubview:self.btnReload];
        [self.btnReload mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.mas_left).with.offset(16);
            make.right.equalTo(wSelf.mas_right).with.offset(-16);
            make.top.equalTo(wSelf.img.mas_bottom).with.offset(30);
            make.height.mas_equalTo(44);
        }];
        
        [[self.btnReload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(reloadView)]) {
                [wSelf removeFromSuperview];
                [wSelf.delegate reloadView];
            }
        }];
        
    }
    return self;
}

- (void)setDelegate:(id<CTBaseErrorDelegate>)delegate {
    _delegate = delegate;
    if ([self.delegate respondsToSelector:@selector(reloadView)]) {
        self.btnReload.hidden = NO;
    }
    else {
        self.btnReload.hidden = YES;
    }
}

@end
