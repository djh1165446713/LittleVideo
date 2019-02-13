//
//  MylikeVideoCell.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/12/27.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "MylikeVideoCell.h"

@implementation MylikeVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ______WS();
        _headImg = [[UIImageView alloc] init];
        //        _headImg.layer.masksToBounds = YES;
        //        _headImg.layer.cornerRadius = 20;
        
        //        self.backgroundColor    =  RGB(53, 49, 50);

        _headImg.backgroundColor = RGB(179, 179, 179);
        [self.contentView addSubview:_headImg];
        [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView).offset(10);
            make.centerY.equalTo(wSelf.contentView);
            make.width.offset(145);
            make.height.offset(80);
        }];
        
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.numberOfLines    = 0;
        _titleLab.lineBreakMode    = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLab];
        
        _videotype_lab = [[UILabel alloc] init];
        _videotype_lab.textColor = RGB(179, 179, 179);
        _videotype_lab.font = [UIFont systemFontOfSize:10];
        _videotype_lab.numberOfLines    = 0;
        _videotype_lab.lineBreakMode    = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_videotype_lab];
        
    }
    return self;
}

- (void)setCelllabandimg:(ABContentResult *)model{
    ______WS();
    CGSize maximumLabelSize = CGSizeMake(kTPScreenWidth - 165, 9999);//labelsize的最大值
    _titleLab.text = model.contentInfo.summary;
    CGSize expectSize1 = [self.titleLab sizeThatFits:maximumLabelSize];
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.contentInfo.photo] placeholderImage:nil];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.headImg.mas_right).offset(15);
        make.centerY.equalTo(wSelf.headImg);
        make.right.equalTo(wSelf.contentView.mas_right).offset(-15);
        make.height.offset(expectSize1.height);
    }];
    
    [_videotype_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.headImg.mas_right).offset(15);
        make.top.equalTo(wSelf.titleLab.mas_bottom).offset(5);
        make.right.equalTo(wSelf.contentView.mas_right).offset(-15);
        make.height.offset(12);
    }];
}


//  自定义选中image 需要实现这两个方法
-(void)layoutSubviews
{
    [super layoutSubviews];

    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (self.selected) {
                        image.image=[UIImage imageNamed:@"edit_select_yes"];
                    }
                    else
                    {
                        image.image=[UIImage imageNamed:@"edit_select_nor"];
                    }
                }
            }
        }
    }

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (!self.selected) {
                        image.image=[UIImage imageNamed:@"edit_select_yes"];
                    }else{
                        image.image=[UIImage imageNamed:@"edit_select_nor"];
                    }
                }
            }
        }
    }
    [super setEditing:editing animated:animated];

}

@end
