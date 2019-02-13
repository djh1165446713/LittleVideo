//
//  RelatedRemmCell.h
//  Axiba
//
//  Created by bianKerMacBook on 2017/4/21.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemmendModel.h"
@interface RelatedRemmCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic,strong) RemmendModel *model;

@end
