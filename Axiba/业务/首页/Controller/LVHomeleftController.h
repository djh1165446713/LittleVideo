//
//  LVHomeleftController.h
//  Axiba
//
//  Created by bianKerMacBook on 2017/12/21.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LVHomeleftController : UIViewController
@property (nonatomic, strong) UIImageView *imgHeader_user;
@property (nonatomic, strong) UILabel *lab_notic;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *backImg_user;


@property (nonatomic, strong) NSString  *userId;
@property (nonatomic, strong) NSString  *avator;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *summary;
@end
