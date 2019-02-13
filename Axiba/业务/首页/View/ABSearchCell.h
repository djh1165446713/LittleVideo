//
//  ABSearchCell.h
//  Axiba
//
//  Created by Nemofish on 16/06/9.
//  Copyright (c) 2016年 Nemofish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABSearchCellDelegate <NSObject>

- (void)deRemoveSearchKey:(NSString *)_strKey;

@optional
@end


@interface ABSearchCell : UITableViewCell

@property (nonatomic) BOOL  isSelected;
@property (nonatomic, weak) id<ABSearchCellDelegate> delegate;

+ (NSString*)identifier;
+ (CGFloat)  heightForCell;

- (void)updateData:(NSString *)_strKey;

@end
