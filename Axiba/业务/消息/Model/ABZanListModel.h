//
//  ABZanListModel.h
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseModel.h"

@interface ABZanListModel : CTBaseModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *other;
@property (nonatomic, strong) NSNumber *tag;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *contentids;

@end
