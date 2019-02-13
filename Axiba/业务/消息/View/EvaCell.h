//
//  EvaCell.h
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/9.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaModel.h"
@interface EvaCell : UITableViewCell
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *otherName;

@property (nonatomic, strong) UILabel *lab_tit;
@property (nonatomic, strong) UILabel *time_lab;
@property (nonatomic, strong) UILabel *descri_lab;
@property (nonatomic, strong) EvaModel *model;
- (CGFloat)heightCellGetModel:(EvaModel *)model;              // 计算cell行高

@end
