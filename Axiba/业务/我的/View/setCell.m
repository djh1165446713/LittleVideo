//
//  setCell.m
//  Axiba
//
//  Created by bianKerMacBook on 16/10/12.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "setCell.h"

@implementation setCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cityLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 60)];
        self.cityLab.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_cityLab];
        self.phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.width - 30, 0, 100, 60)];
        self.cityLab.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_phoneLab];
    }
    return self;
}

@end
