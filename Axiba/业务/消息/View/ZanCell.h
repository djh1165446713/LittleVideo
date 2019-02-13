//
//  ZanCell.h
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/8.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABZanListModel.h"

@interface ZanCell : UITableViewCell
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *lab_tit;
@property (nonatomic, strong) UILabel *time_lab;
@property (nonatomic, strong) UILabel *descri_lab;
@property (nonatomic, strong) ABZanListModel *model;

- (CGFloat)heightCellGetModel:(ABZanListModel *)model;              // 计算cell行高

@end
