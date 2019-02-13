//
//  ABLikeChannelCell.m
//  Axiba
//
//  Created by Peter on 16/6/23.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABLikeChannelCell.h"

@interface ABLikeChannelCell()
@property (nonatomic, strong) UIImageView   *imgLogo;
@property (nonatomic, strong) UILabel       *lblChannelTitle;
@property (nonatomic, strong) UILabel       *summyLab;

@end

@implementation ABLikeChannelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ______WS();
       
        self.imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_default_head"]];
        self.imgLogo.layer.cornerRadius = 24;
        self.imgLogo.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imgLogo];
        [self.imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView).offset(20);
            make.centerY.mas_equalTo(wSelf.contentView);
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
        
        self.lblChannelTitle = [UILabel new];
        self.lblChannelTitle.font = Font_Chinease_Blod(14);
        self.lblChannelTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.lblChannelTitle];
        [self.lblChannelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.imgLogo.mas_right).offset(10);
            make.right.equalTo(wSelf.contentView.mas_right).offset(-40);
            make.centerY.mas_equalTo(wSelf.contentView.mas_centerY).offset(-12);
            make.height.mas_equalTo(18);
        }];
        
        
        self.summyLab = [UILabel new];
        self.summyLab.font = Font_Chinease_Blod(12);
        self.summyLab.textColor = RGB(102, 102, 102);
        [self.contentView addSubview:self.summyLab];
        [self.summyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.imgLogo.mas_right).offset(10);
            make.right.equalTo(wSelf.contentView.mas_right).offset(-40);
            make.centerY.mas_equalTo(wSelf.contentView.mas_centerY).offset(10);
            make.height.mas_equalTo(18);
        }];
    }
    return self;
}

- (void)setPhoto:(NSString*)url title:(NSString*)title summy:(NSString *)summy{
    [self.imgLogo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:self.imgLogo.image];
    self.lblChannelTitle.text = title;
    self.summyLab.text = summy;
}

@end
