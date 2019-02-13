//
//  ABChannelCell.m
//  Axiba
//
//  Created by Nemofish on 16/06/9.
//  Copyright (c) 2016年 Nemofish. All rights reserved.
//

#import "ABChannelCell.h"

@interface ABChannelCell()
{
    ABChannelInfoResult *m_model;
}

@end

@implementation ABChannelCell

+ (NSString*)identifier
{
    return @"ABChannelCellIdentifier";
}

#pragma mark - Layout Initialization

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle     = UITableViewCellSelectionStyleNone;
        self.backgroundColor    = [UIColor clearColor];
        self.contentView.frame  = CGRectMake(0, 0, kTPScreenWidth, [ABChannelCell heightForCell]);
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        float fHeightHead       = [ABChannelCell heightForCell];
        float fMarginX          = 8;
        
        UIImageView *imvChannelHead        = [[UIImageView alloc] initWithFrame:CGRectMake(14, fMarginX, fHeightHead-fMarginX*2,fHeightHead-fMarginX*2)];
        imvChannelHead.contentMode         = UIViewContentModeScaleAspectFill;
        imvChannelHead.backgroundColor     = [UIColor darkGrayColor];
        imvChannelHead.layer.masksToBounds = YES;
        imvChannelHead.layer.cornerRadius  = CGRectGetHeight(imvChannelHead.frame)/2;
        imvChannelHead.stringTag           = @"tag_imv_channel_head";
        [self.contentView addSubview:imvChannelHead];
        
        UILabel *labelUserName      = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imvChannelHead.frame)+fMarginX, 0, CGRectGetWidth(self.contentView.frame)-fHeightHead-fMarginX*3, fHeightHead)];
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
    return 55;
}


#pragma mark - public mehtod
- (void)updateData:(ABChannelInfoResult *)_model
{
    m_model = _model;
    
    UILabel *labelUserName      = (UILabel *)[self.contentView viewWithStringTag:@"tag_label_channel_name"];
    labelUserName.text          = m_model.name;
    
    UIImageView *imvChannelHead = (UIImageView *)[self.contentView viewWithStringTag:@"tag_imv_channel_head"];
    [imvChannelHead sd_setImageWithURL:[NSURL URLWithString:m_model.photo] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
}


@end
