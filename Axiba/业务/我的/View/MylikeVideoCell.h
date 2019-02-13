//
//  MylikeVideoCell.h
//  Axiba
//
//  Created by bianKerMacBook on 2017/12/27.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABSearchModel.h"

@interface MylikeVideoCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *videotype_lab;

- (void)setCelllabandimg:(ABContentResult *)model;

@end
