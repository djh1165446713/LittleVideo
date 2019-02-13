//
//  ABUserLikeCell.h
//  Axiba
//
//  Created by Nemofish on 16/06/9.
//  Copyright (c) 2016年 Nemofish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABLikeListModel.h"


@interface ABUserLikeCell : UITableViewCell

@property (nonatomic) BOOL  isSelected;

+ (NSString*)identifier;
+ (CGFloat)  heightForCell;

- (void)updateData:(ABLikeUserModel *)_model;

@end
