//
//  HotseachcollCell.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/12/25.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "HotseachcollCell.h"

@implementation HotseachcollCell
- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
//        ______WS();
        _hot_lab = [[UILabel alloc] init];
        _hot_lab.textColor = [UIColor whiteColor];
        _hot_lab.textAlignment = NSTextAlignmentCenter;
        _hot_lab.backgroundColor = RGB(45, 44, 41);
        _hot_lab.font = Font_Chinease_Blod(14);
        [self.contentView addSubview:_hot_lab];

    }
    return self;
}


- (void)setModel:(NSString *)model{
    ______WS();

    _hot_lab.text = model;
    [_hot_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.contentView.mas_top).offset(0);
        make.right.equalTo(wSelf.contentView.mas_right).offset(0);
        make.bottom.equalTo(wSelf.contentView.mas_bottom).offset(0);
        make.left.equalTo(wSelf.contentView.mas_left).offset(0);

    }];
}
@end
