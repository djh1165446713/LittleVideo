//
//  ABUserLikeCell.m
//  Axiba
//
//  Created by Nemofish on 16/06/9.
//  Copyright (c) 2016年 Nemofish. All rights reserved.
//

#import "ABUserLikeCell.h"

@interface ABUserLikeCell()
{
    ABLikeUserModel *m_model;
}

@end

@implementation ABUserLikeCell

+ (NSString*)identifier
{
    return @"ABUserLikeCellIdentifier";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle     = UITableViewCellSelectionStyleNone;
        self.backgroundColor    = [UIColor clearColor];
        self.contentView.frame  = CGRectMake(0, 0, kTPScreenWidth, [ABUserLikeCell heightForCell]);
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        float fHeightHead       = [ABUserLikeCell heightForCell];
        float fMarginX          = 8;
        
        UIImageView *imvUserHead        = [[UIImageView alloc] initWithFrame:CGRectMake(16, fMarginX, fHeightHead-fMarginX*2,fHeightHead-fMarginX*2)];
        imvUserHead.contentMode         = UIViewContentModeScaleAspectFill;
        imvUserHead.backgroundColor     = [UIColor darkGrayColor];
        imvUserHead.layer.masksToBounds = YES;
        imvUserHead.layer.cornerRadius  = CGRectGetHeight(imvUserHead.frame)/2;
        imvUserHead.stringTag           = @"tag_imv_user_head";
        [self.contentView addSubview:imvUserHead];
        
        UILabel *labelUserName      = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imvUserHead.frame)+10, 12, CGRectGetWidth(self.contentView.frame)-fHeightHead-fMarginX*6, 20)];
        labelUserName.textColor     = [UIColor blackColor];
        labelUserName.font          = Font_Chinease_Normal(14);
        labelUserName.stringTag     = @"tag_label_channel_name";
        [self.contentView addSubview:labelUserName];
        
        UIImageView *imvRightArrow  = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"icon_right"] imageWithTintColor:[UIColor colorWithWhite:0.0 alpha:0.4]]];
        imvRightArrow.frame         = CGRectMake(CGRectGetWidth(self.contentView.frame)-30, 4, 12, CGRectGetHeight(self.contentView.frame)-8);
        imvRightArrow.contentMode   = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imvRightArrow];
        
        UIView *viewLine            = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame)-0.5,  CGRectGetWidth(self.contentView.frame), 0.5)];
        viewLine.backgroundColor    = [UIColor colorWithWhite:0.0 alpha:0.1];
        [self.contentView addSubview:viewLine];
    }
    return self;
}

+ (CGFloat)heightForCell
{
    return 60;
}


#pragma mark - public mehtod
- (void)updateData:(ABLikeUserModel *)_model
{
    m_model = _model;
    
    UILabel *labelUserName      = (UILabel *)[self.contentView viewWithStringTag:@"tag_label_channel_name"];
    labelUserName.text          = m_model.nickname;
    
    UIImageView *imvUserHead    = (UIImageView *)[self.contentView viewWithStringTag:@"tag_imv_user_head"];
    [imvUserHead sd_setImageWithURL:[NSURL URLWithString:_model.avator] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
}


@end
