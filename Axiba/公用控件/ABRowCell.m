//
//  ABRowCell.m
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABRowCell.h"

@interface ABRowCell()
@property (nonatomic, strong) UIImageView   *imgIcon;
@property (nonatomic, strong) UIImageView   *imgRight;
@property (nonatomic, strong) UIView        *vRedDot;
@end

@implementation ABRowCell

- (UIImageView*)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.hidden = YES;
    }
    return _imgIcon;
}

- (UIView*)vLine {
    if (!_vLine) {
        _vLine = [[UIView alloc] init];
        _vLine.backgroundColor = HEXCOLOR(0xe1e1e1);
        _vLine.hidden = YES;
    }
    return _vLine;
}

- (UIView*)vRedDot {
    if (!_vRedDot) {
        _vRedDot = [[UIView alloc] init];
        _vRedDot.backgroundColor = [UIColor redColor];
        _vRedDot.layer.cornerRadius = 4;
        _vRedDot.hidden = YES;
    }
    return _vRedDot;
}

- (UIImageView*)imgRight {
    if (!_imgRight) {
        _imgRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right"]];
        _imgRight.hidden = YES;
    }
    return _imgRight;
}

- (UILabel*)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [UILabel new];
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = Font_Chinease_Blod(14);
    }
    return _lblTitle;
}

- (UILabel*)lblValue {
    if (!_lblValue) {
        _lblValue = [UILabel new];
        _lblValue.textColor = colorNormalText;
        _lblValue.font = Font_Chinease_Normal(14);
        _lblValue.textAlignment = NSTextAlignmentRight;
    }
    return _lblValue;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ______WS();
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self addSubview:self.imgIcon];
        [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf.mas_centerY);
            make.left.equalTo(wSelf.mas_left).offset(20);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        [self addSubview:self.imgRight];
        [self.imgRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf.mas_centerY);
            make.right.equalTo(wSelf.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(12, 13));
        }];
        
        [self addSubview:self.lblTitle];
        [self addSubview:self.lblValue];
        
        [self addSubview:self.vLine];
        [self.vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf);
            make.right.equalTo(wSelf);
            make.bottom.equalTo(wSelf);
            make.height.mas_equalTo(0.5);
        }];
        
        [self addSubview:self.vRedDot];
        [self.vRedDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.imgIcon.mas_right).offset(-6);
            make.top.equalTo(wSelf.imgIcon.mas_top);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
    }
    return self;
}

- (void)setRedDot:(BOOL)bHidden {
    [self.vRedDot setHidden:bHidden];
}

- (void)setTitle:(NSString*)title bNext:(BOOL)bNext {
    [self setTitle:title bNext:bNext value:nil];
}

- (void)setTitle:(NSString*)title bNext:(BOOL)bNext value:(NSString*)value {
    [self setTitle:title bNext:bNext value:value buttonCell:NO];
}

- (void)setTitle:(NSString*)title bNext:(BOOL)bNext buttonCell:(BOOL)buttonCell {
    [self setTitle:title bNext:bNext value:nil buttonCell:buttonCell];
}

- (void)setTitle:(NSString*)title bNext:(BOOL)bNext value:(NSString*)value buttonCell:(BOOL)buttonCell {
    [self setTitle:nil title:title bNext:bNext value:value buttonCell:buttonCell];
}

- (void)setTitle:(NSString*)icon title:(NSString*)title bNext:(BOOL)bNext {
    [self setTitle:icon title:title bNext:bNext value:nil buttonCell:NO];
}

- (void)setTitle:(NSString*)icon title:(NSString*)title bNext:(BOOL)bNext value:(NSString*)value buttonCell:(BOOL)buttonCell {
         ______WS();
    self.lblTitle.text = title;
    if (![value isValid]) {
        value = @"未设置";
    }
    self.lblValue.text = value;
    self.imgRight.hidden = !bNext;

    if (bNext) {
        [self.lblValue mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView).offset(20);
            make.right.equalTo(wSelf.imgRight.mas_left).offset(-10);
            make.centerY.equalTo(wSelf.contentView);
            make.height.mas_equalTo(21);
        }];
    }
    else {
        [self.lblValue mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView).offset(20);
            make.right.equalTo(wSelf.contentView).offset(-15);
            make.centerY.equalTo(wSelf.contentView);
            make.height.mas_equalTo(21);
        }];
    }
    
    if ([icon isValid]) {
        self.imgIcon.hidden = NO;
        self.imgIcon.image = [UIImage imageNamed:icon];
        [self.lblTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.imgIcon.mas_right).offset(15);
            make.right.equalTo(wSelf.imgRight.mas_left).offset(-20);
            make.centerY.equalTo(wSelf.contentView);
            make.height.mas_equalTo(21);
        }];
    }
    else {
        self.imgIcon.hidden = YES;
        [self.lblTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView).offset(16);
            make.right.equalTo(wSelf.imgRight.mas_left).offset(-20);
            make.centerY.equalTo(wSelf.contentView);
            make.height.mas_equalTo(21);
        }];
    }
    
    if (buttonCell) {
        self.lblValue.hidden = YES;
        self.lblTitle.textColor = colorMainText;
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
    }
    else {
        self.lblValue.hidden = ![value isValid];
        self.lblTitle.textColor = [UIColor blackColor];
        self.lblTitle.textAlignment = NSTextAlignmentLeft;
    }
    
    if ([self.lblTitle.text containsString:@"登录"]) {
        _lblTitle.font = Font_Chinease_Blod(17);
        [self.lblTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf).offset(16);
            make.right.equalTo(wSelf).offset(-16);
            make.centerY.equalTo(wSelf.contentView);
            make.height.mas_equalTo(21);
        }];
    }
    else {
        _lblTitle.font = Font_Chinease_Blod(14);
    }
}

@end
