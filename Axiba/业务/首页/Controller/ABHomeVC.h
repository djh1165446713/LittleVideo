//
//  ABHomeVC.h
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseVC.h"
#import "HomeSelectModel.h"
@interface ABHomeVC : CTBaseVC

@property (strong, nonatomic) NSString *pop_AdImageUrl;

@property (strong, nonatomic) NSString *insert_adImageUrl;

@property (strong, nonatomic) UILabel *lab;
@property (strong, nonatomic) NSMutableArray *arrayUrls;
@end
