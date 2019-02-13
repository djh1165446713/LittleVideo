//
//  UITableView+PullRefresh.h
//  Axiba
//
//  Created by Peter on 16/6/25.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (PullRefresh)

- (void)addPullRefreshHandle:(void(^)(void))block;
- (void)addPullNextHandle:(void(^)(void))block;
@end
