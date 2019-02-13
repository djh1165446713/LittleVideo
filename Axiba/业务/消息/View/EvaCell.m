//
//  EvaCell.m
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/9.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import "EvaCell.h"

@implementation EvaCell
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
        
        _otherName = [[UILabel alloc] init];
        _otherName.textColor = RGB(74, 144, 226);
        _otherName.font = [UIFont systemFontOfSize:14];
        //        _nickName.text = @"Taya Krajcik";
        [self.contentView addSubview:_otherName];
        
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

- (void)setModel:(EvaModel *)model{
    ______WS();
    
    if ([model.type integerValue] == 1) {
        [_photo sd_setImageWithURL:[NSURL URLWithString:model.contentPhoto] placeholderImage:nil];
    }else{
        _photo.hidden = YES;
    }
    
    CGFloat width = 0;
    CGFloat width2 = 0;

    _nickName.text = ([model.type integerValue] == 3)? model.othername : @"我";
    if ([model.type integerValue] == 3) {
        width = 120;
    }else{
        width = 30;
    }
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.contentView.mas_left).offset(15);
        make.top.equalTo(wSelf.contentView.mas_top).offset(22);
        make.width.offset(width);
        make.height.offset(20);
    }];
    
    if ([model.type integerValue] == 1) {
        _lab_tit.text = @"评论了视频";
        width2 = 80;
    }else if([model.type integerValue] == 2){
        _lab_tit.text = @"回复了";
        width2 = 50;
    }else{
        _lab_tit.text = @"回复";
        width2 = 40;
    }
    
    [_lab_tit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.nickName.mas_right).offset(10);
        make.top.equalTo(wSelf.contentView.mas_top).offset(22);
        make.width.offset(width2);
        make.height.offset(20);
    }];
    
    if ([model.type integerValue] == 1) {
        _otherName.text = @"";
    }else if([model.type integerValue] == 2){
        _otherName.text = model.othername;
    }else{
        _otherName.text = @"我";
    }
    
    CGFloat width1 = 0;
    if ([model.type integerValue] == 2) {
        width1 = 200;
    }else{
        width1 = 30;
    }
    
    [_otherName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.lab_tit.mas_right).offset(10);
        make.top.equalTo(wSelf.contentView.mas_top).offset(22);
        make.width.offset(width1);
        make.height.offset(20);
    }];
    
    
    CGFloat widthD = ([model.contentPhoto isValid] && [model.type integerValue] == 1)? 216 : (kTPScreenWidth - 30);
    _descri_lab.text = model.message;
    CGFloat height = [self getStringLabHeight:model.contentTitle font:12 width:widthD];
    [_descri_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.contentView).offset(10);
        make.top.equalTo(wSelf.nickName.mas_bottom).offset(10);
        make.width.offset(widthD);
        make.height.offset(height + 5);
    }];
    
    
    _time_lab.text = model.createTime;
    [_time_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.contentView).offset(10);
        make.top.equalTo(wSelf.descri_lab.mas_bottom).offset(10);
        make.width.offset(150);
        make.height.offset(16);
    }];
    
}


- (CGFloat)heightCellGetModel:(EvaModel *)model{
    CGFloat widthD = ([model.contentPhoto isValid])? 216 : (kTPScreenWidth - 30);
    CGFloat height1 = [self getStringLabHeight:model.contentTitle font:12 width:widthD];
    return height1 + 90;
}


- (CGFloat)getStringLabHeight:(NSString *)str font:(NSInteger)font width:(CGFloat)width{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize textSize = [str boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attributes context:nil].size;
    return textSize.height;
}

@end
