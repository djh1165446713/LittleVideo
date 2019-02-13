//
//  UITableView+PullRefresh.m
//  Axiba
//
//  Created by Peter on 16/6/25.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "UITableView+PullRefresh.h"
#import "ABCommonDataManager.h"
#import "MJRefresh.h"

@implementation UITableView (PullRefresh)

- (void)addPullRefreshHandle:(void(^)(void))block {
//    MJRefreshGifHeader *header          = [MJRefreshGifHeader headerWithRefreshingBlock:block];
//    header.lastUpdatedTimeLabel.hidden  = YES;
//    [header setImages:[ABCommonDataManager getRefreshPullingImages] forState:MJRefreshStateIdle];
//    [header setImages:[ABCommonDataManager getRefreshRefreshingImages] forState:MJRefreshStateRefreshing];
//    header.gifView.contentMode          = UIViewContentModeScaleAspectFit;
//    header.stateLabel.hidden            = YES;
//    header.backgroundColor              = HEXCOLOR(0xe9e9e9);
//    self.mj_header                      = header;
    
    MJRefreshNormalHeader *header          = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    header.lastUpdatedTimeLabel.hidden  = YES;
    header.stateLabel.hidden            = YES;
    header.backgroundColor              = HEXCOLOR(0xe9e9e9);
    self.mj_header                      = header;
}

- (void)addPullNextHandle:(void (^)(void))block {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
//    [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
//    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"到底啦^0^" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    footer.refreshingTitleHidden    = YES;
    footer.stateLabel.font          = [UIFont systemFontOfSize:17];
    footer.stateLabel.textColor     = colorNormalText;
    self.mj_footer = footer;
}
@end
