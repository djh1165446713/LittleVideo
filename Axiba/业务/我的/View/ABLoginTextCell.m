//
//  ABLoginTextCell.m
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABLoginTextCell.h"

@interface ABLoginTextCell()
@property (nonatomic, strong) UIButton   *btnSee;
@end

@implementation ABLoginTextCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(22, 21, 16);
        self.alpha = 0.8;
        [self addSubview:self.icon2];
        [self addSubview:self.txt];
    }
    return self;
}


- (UIImageView*)icon2 {
    if (!_icon2) {
        _icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.height / 2 - 9, 18,18)];
    }
    return _icon2;
}


- (UIButton*)btnSee {
    if (!_btnSee) {
        ______WS();
        _btnSee = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 31, 13, 20, 12)];
        _btnSee.hidden = YES;
        [_btnSee setImage:[UIImage imageNamed:@"icon_see"] forState:UIControlStateNormal];
        [[_btnSee rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            wSelf.txt.secureTextEntry = !wSelf.txt.isSecureTextEntry;
            [wSelf.btnSee setImage:[UIImage imageNamed:(!wSelf.txt.isSecureTextEntry ? @"icon_see":@"icon_unsee")] forState:UIControlStateNormal];
        }];
    }
    return _btnSee;
}

- (ABTextField*)txt {
    if (!_txt) {
        _txt = [[ABTextField alloc] initWithFrame:CGRectMake(40, 0, self.width - 40, self.height)];
        _txt.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txt.font = Font_Chinease_Normal(15);
    }
    return _txt;
}

- (void)setType:(ABLoginTextType)type {
    _type = type;
    if (_type == ABLoginTextPassSee) {
        self.btnSee.hidden = NO;
        [self addSubview:self.btnSee];
        self.txt.width = self.width - 110;
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (self.type == ABLoginTextPhone && textField.text.length + string.length > 11)
//        return NO;
//    if (self.type == ABLoginTextCaptcha && textField.text.length + string.length > 6)
//        return NO;
//    if ((self.type == ABLoginTextPass || self.type == ABLoginTextPassSee) && string.length > 0) {
//        int c = [string characterAtIndex:0];
//        if ((c>=48&& c<=57) || (c>=97&&c<=122) || (c>=65&&c<=90)) {
//            if (textField.text.length + string.length > 16) {
//                return NO;
//            }
//        }
//        else {
//            return NO;
//        }
//    }
//    return YES;
//}

@end
