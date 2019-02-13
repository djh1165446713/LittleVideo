//
//  SearchCollectHeaderView.m
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/19.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import "SearchCollectHeaderView.h"

@implementation SearchCollectHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        ______WS();
        // 搜索历史
        _search_history = [[UILabel alloc] init];
        _search_history.text = @"搜索历史";
        _search_history.textColor = RGB(179, 179, 179);
        _search_history.font = Font_Chinease_Blod(12);
        [self addSubview:_search_history];
        [_search_history mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wSelf.mas_bottom).offset(-18);
            make.left.equalTo(wSelf.mas_left).offset(0);
            make.width.offset(60);
            make.height.offset(17);
            
        }];
        
        _clear_lab = [[UILabel alloc] init];
        _clear_lab.text = @"清除";
        _clear_lab.textColor = RGB(179, 179, 179);
        _clear_lab.userInteractionEnabled = YES;
        _clear_lab.font = Font_Chinease_Blod(12);
        [self addSubview:_clear_lab];
        [_clear_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf.search_history);
            make.right.equalTo(wSelf.mas_right).offset(-18);
            make.width.offset(30);
            make.height.offset(17);
            
        }];
        
        _clear_img = [[UIImageView alloc] init];
        _clear_img.image = [UIImage imageNamed:@"clear_search"];
        _clear_img.userInteractionEnabled = YES;
        [self addSubview:_clear_img];
        [_clear_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf.search_history);
            make.left.equalTo(wSelf.clear_lab.mas_right).offset(6);
            make.width.offset(12);
            make.height.offset(12);
            
        }];
        
  
    }
    return self;
}


@end
