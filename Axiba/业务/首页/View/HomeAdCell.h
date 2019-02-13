//
//  HomeAdCell.h
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/11.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuanggaoMoreModel.h"

@interface HomeAdCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imageAd;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *lab;

@property (nonatomic, strong) GuanggaoMoreModel *model;

@end
