//
//  ABSearchCell.m
//  Axiba
//
//  Created by Nemofish on 16/06/9.
//  Copyright (c) 2016年 Nemofish. All rights reserved.
//

#import "ABSearchCell.h"

@interface ABSearchCell()
{
    NSString *m_strKey;
}

@end

@implementation ABSearchCell
@synthesize delegate;

+ (NSString*)identifier
{
    return @"ABSearchCellIdentifier";
}

#pragma mark - Layout Initialization

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle     = UITableViewCellSelectionStyleGray;
        self.backgroundColor    = [UIColor whiteColor];
        self.contentView.frame  = CGRectMake(0, 0, kTPScreenWidth, [ABSearchCell heightForCell]);
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imvIcon    = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, CGRectGetHeight(self.contentView.frame)-22,CGRectGetHeight(self.contentView.frame)-22)];
        imvIcon.image           = [UIImage imageNamed:@"ico_search_time"];
        imvIcon.contentMode     = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imvIcon];
        
        
        //content
        UILabel *labelContent       = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imvIcon.frame)+8, 0,
                                                                                CGRectGetWidth(self.contentView.frame)-90,
                                                                                CGRectGetHeight(self.contentView.frame))];
        labelContent.textColor      = [UIColor lightGrayColor];
        labelContent.font           = Font_Chinease_Normal(13);
        labelContent.stringTag      = @"tag_label_content";
        [self.contentView addSubview:labelContent];
        
        UIButton *btnClose           = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.frame               = CGRectMake(CGRectGetWidth(self.contentView.frame)-50, 0, 50, CGRectGetHeight(self.contentView.frame));
        [btnClose setImage:[UIImage imageNamed:@"ico_search_close"] forState:UIControlStateNormal];
        btnClose.imageEdgeInsets     = UIEdgeInsetsMake(5, 10, 5, 0);
        [btnClose addTarget:self action:@selector(onActionCloseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnClose];
        
        UIView *viewLine            = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(self.contentView.frame)-0.5,  CGRectGetWidth(self.contentView.frame)-15, 0.5)];
        viewLine.backgroundColor    = [UIColor colorWithWhite:0.0 alpha:0.1];
        [self.contentView addSubview:viewLine];
    }
    return self;
}

+ (CGFloat)heightForCell
{
    return 36;
}


#pragma mark - public mehtod
- (void)updateData:(NSString *)_strKey
{
    m_strKey    = _strKey;
    UILabel *labelContent   = (UILabel *)[self.contentView viewWithStringTag:@"tag_label_content"];
    labelContent.text       = _strKey;
}



#pragma mark - onAction
- (void)onActionCloseBtnClicked:(UIButton *)_button
{
    if(delegate && [delegate respondsToSelector:@selector(deRemoveSearchKey:)])
    {
        [delegate deRemoveSearchKey:m_strKey];
    }
}


@end
