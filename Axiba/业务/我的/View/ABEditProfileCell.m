//
//  ABEditProfileCell.m
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABEditProfileCell.h"

@interface ABEditProfileCell()
@property (nonatomic, strong) UIImageView   *imgHead;
@end

@implementation ABEditProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ______WS();
        
        self.imgHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_default_head"]];
        self.imgHead.layer.cornerRadius = 24;
        self.imgHead.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imgHead];
        [self.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(wSelf.contentView.mas_centerY);
            make.right.equalTo(wSelf.contentView).offset(-37);
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
        
    }
    return self;
}

- (void)setHead:(NSString*)url {
    self.imgHead.hidden = ![url isValid];
    if ([url isValid]) {
        [self.imgHead sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:self.imgHead.image];
        self.lblValue.hidden = YES;
    }
}
@end
