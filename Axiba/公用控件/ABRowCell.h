//
//  ABRowCell.h
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABRowCell : UITableViewCell
@property (nonatomic, strong) UIView        *vLine;
@property (nonatomic, strong) UILabel       *lblTitle;
@property (nonatomic, strong) UILabel       *lblValue;

- (void)setRedDot:(BOOL)bHidden;
- (void)setTitle:(NSString*)title bNext:(BOOL)bNext;
- (void)setTitle:(NSString*)icon title:(NSString*)title bNext:(BOOL)bNext;
- (void)setTitle:(NSString*)title bNext:(BOOL)bNext value:(NSString*)value;
- (void)setTitle:(NSString*)title bNext:(BOOL)bNext buttonCell:(BOOL)buttonCell;
- (void)setTitle:(NSString*)title bNext:(BOOL)bNext value:(NSString*)value buttonCell:(BOOL)buttonCell;
- (void)setTitle:(NSString*)icon title:(NSString*)title bNext:(BOOL)bNext value:(NSString*)value buttonCell:(BOOL)buttonCell;
@end
