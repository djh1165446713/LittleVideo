//
//  ZanCell.m
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/8.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import "ZanCell.h"

@implementation ZanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        ______WS();
        _photo = [[UIImageView alloc] init];
        _photo.backgroundColor = RGB(179, 179, 179);
        [self.contentView addSubview:_photo];
        [_photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.contentView.mas_right).offset(-15);
            make.centerY.equalTo(wSelf.contentView);
            make.width.offset(125);
            make.height.offset(70);
        }];
        
        
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = RGB(74, 144, 226);
        _nickName.font = [UIFont systemFontOfSize:14];
//        _nickName.text = @"Taya Krajcik";
        [self.contentView addSubview:_nickName];
        
        
        
        _lab_tit = [[UILabel alloc] init];
        _lab_tit.textColor = [UIColor blackColor];
        _lab_tit.font = [UIFont systemFontOfSize:14];
//        _lab_tit.text = @"赞了你的评论";
        [self.contentView addSubview:_lab_tit];
        
        _descri_lab = [[UILabel alloc] init];
        _descri_lab.textColor = RGB(136, 136, 136);
        _descri_lab.numberOfLines    = 0;
        _descri_lab.lineBreakMode    = NSLineBreakByWordWrapping;
        _descri_lab.font = [UIFont systemFontOfSize:12];
//        _descri_lab.text = @"奥斯卡的数据都是废话收到就好看闪电发货";
        [self.contentView addSubview:_descri_lab];
        
        _time_lab = [[UILabel alloc] init];
        _time_lab.textColor = RGB(136, 136, 136);
        _time_lab.font = [UIFont systemFontOfSize:11];
//        _time_lab.text = @"刚刚";
        [self.contentView addSubview:_time_lab];
        
    }
    return self;
}

- (void)setModel:(ABZanListModel *)model{
    ______WS();
    
    [_photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
    
    CGFloat width = ([model.tag integerValue] == 1)? 30 : 120;
    _nickName.text = ([model.tag integerValue] == 1)? @"我" : model.other;
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.contentView.mas_left).offset(15);
        make.top.equalTo(wSelf.contentView.mas_top).offset(22);
        make.width.offset(width);
        make.height.offset(20);
    }];
    
    if ([model.tag integerValue] == 1) {
        _lab_tit.text = @"赞了视频";
    }else{
        _lab_tit.text = @"赞了你的评论";
    }
    [_lab_tit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.nickName.mas_right).offset(10);
        make.top.equalTo(wSelf.contentView.mas_top).offset(22);
        make.width.offset(90);
        make.height.offset(20);
    }];
    
    
    CGFloat widthD = ([model.photo isValid])? 216 : (kTPScreenWidth - 30);
    _descri_lab.text = model.content;
    CGFloat height = [self getStringLabHeight:model.content font:12 width:widthD];
    [_descri_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.contentView).offset(10);
        make.top.equalTo(wSelf.nickName.mas_bottom).offset(10);
        make.width.offset(widthD);
        make.height.offset(height + 5);
    }];
    
    
    _time_lab.text = model.create_time;
    [_time_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.contentView).offset(10);
        make.top.equalTo(wSelf.descri_lab.mas_bottom).offset(10);
        make.width.offset(150);
        make.height.offset(16);
    }];
    
}


- (CGFloat)heightCellGetModel:(ABZanListModel *)model{
    CGFloat widthD = ([model.photo isValid])? 216 : (kTPScreenWidth - 30);
    CGFloat height1 = [self getStringLabHeight:model.content font:12 width:widthD];
    return height1 + 90;
}


- (CGFloat)getStringLabHeight:(NSString *)str font:(NSInteger)font width:(CGFloat)width{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attributes context:nil].size;
    return textSize.height;
}

@end
