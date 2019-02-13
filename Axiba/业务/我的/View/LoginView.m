//
//  LoginView.m
//  Axiba
//
//  Created by bianKerMacBook on 16/10/12.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "LoginView.h"

@interface LoginView()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton   *btnSee;
@end


@implementation LoginView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xd0d2d1);
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.masksToBounds = YES;
        [self addSubview:self.icon];
        [self addSubview:self.txt];
    }
    return self;
}

- (UIImageView*)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 16, self.height / 2 - 4, 8,8)];
    }
    return _icon;
}




- (UILabel*)txt {
    if (!_txt) {
        _txt = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.width - 40, self.height)];
        _txt.font = Font_Chinease_Normal(15);
    }
    return _txt;
}



@end
