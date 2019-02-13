//
//  ABChannelCell.h
//  Axiba
//
//  Created by Nemofish on 16/06/9.
//  Copyright (c) 2016年 Nemofish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABSearchModel.h"


@interface ABChannelCell : UITableViewCell

@property (nonatomic) BOOL  isSelected;

+ (NSString*)identifier;
+ (CGFloat)  heightForCell;

- (void)updateData:(ABChannelInfoResult *)_model;

@end
