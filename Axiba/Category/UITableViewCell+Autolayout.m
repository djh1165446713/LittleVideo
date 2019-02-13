//
//  UITableViewCell+Autolayout.m
//  TP
//
//  Created by Peter on 15/11/18.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "UITableViewCell+Autolayout.h"

@implementation UITableViewCell (Autolayout)

- (void)setSelfAutolayout:(UIView *)view bottom:(CGFloat)bottom {
    [view setNeedsLayout];
    [view layoutIfNeeded];
    self.height = view.y+view.height + bottom;
}
@end
