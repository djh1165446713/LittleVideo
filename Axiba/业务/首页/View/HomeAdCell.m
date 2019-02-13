
//
//  HomeAdCell.m
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/11.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import "HomeAdCell.h"

@implementation HomeAdCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        ______WS();
        _imageAd = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageAd];
        [_imageAd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView).offset(0);
            make.right.equalTo(wSelf.contentView).offset(0);
            make.top.equalTo(wSelf.contentView).offset(0);
            make.bottom.equalTo(wSelf.contentView).offset(0);
        }];
        
        
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont systemFontOfSize:16];
        _title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf.contentView);
            make.centerY.equalTo(wSelf.contentView);
            make.width.offset(150);
            make.height.offset(20);
        }];
        
        
        _lab = [[UILabel alloc] init]; 
        _lab.textColor = [UIColor whiteColor];
        _lab.backgroundColor = [UIColor blackColor];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.alpha = 0.8;
        _lab.text = @"广告";
        _lab.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_lab];
        [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.contentView.mas_right).offset(-12);
            make.top.equalTo(wSelf.contentView.mas_top).offset(12);
            make.width.offset(34);
            make.height.offset(20);
        }];
        
    }
    return self;
}

- (void)setModel:(GuanggaoMoreModel *)model{
    _title.text = model.summary;
    [_imageAd sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
}

@end
