
//
//  LVHomeleftCell.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/12/21.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "LVHomeleftCell.h"

@implementation LVHomeleftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        ______WS();
        self.contentView.backgroundColor = RGB(53, 49, 50);
        _icon_cell = [[UIImageView alloc] init];
        [self.contentView addSubview:_icon_cell];
        [_icon_cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView.mas_left).offset(15);
            make.width.height.offset(24);
            make.centerY.equalTo(wSelf.contentView);
        }];
        
        _title_cell = [[UILabel alloc] init];
        _title_cell.font = [UIFont systemFontOfSize:16];
        _title_cell.textColor = RGB(255, 255, 255);
        [self.contentView addSubview:_title_cell];
        [_title_cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.icon_cell.mas_right).offset(10);
            make.centerY.equalTo(wSelf.icon_cell);
            make.width.offset(100);
            make.height.offset(22);
        }];
        
        
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
