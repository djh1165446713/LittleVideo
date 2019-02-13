//
//  RelatedRemmCell.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/4/21.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "RelatedRemmCell.h"

@implementation RelatedRemmCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ______WS();
        _headImg = [[UIImageView alloc] init];
//        _headImg.layer.masksToBounds = YES;
//        _headImg.layer.cornerRadius = 20;
        
//        self.backgroundColor    =  RGB(53, 49, 50);
        self.contentView.backgroundColor =  RGB(53, 49, 50);
        self.alpha = 0.75;
        
        _headImg.backgroundColor = RGB(179, 179, 179);
        [self.contentView addSubview:_headImg];
        [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView).offset(10);
            make.centerY.equalTo(wSelf.contentView);
            make.width.offset(145);
            make.height.offset(80);
        }];
        
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.numberOfLines    = 0;
        _titleLab.lineBreakMode    = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLab];
 
    }
    return self;
}


- (void)setModel:(RemmendModel *)model{
    ______WS();
    
    
    CGSize maximumLabelSize = CGSizeMake(kTPScreenWidth - 165, 9999);//labelsize的最大值
    _titleLab.text = model.title;
    CGSize expectSize1 = [self.titleLab sizeThatFits:maximumLabelSize];
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.headImg.mas_right).offset(15);
        make.centerY.equalTo(wSelf.headImg);
        make.right.equalTo(wSelf.contentView.mas_right).offset(-15);
        make.height.offset(expectSize1.height);
    }];

}

@end
