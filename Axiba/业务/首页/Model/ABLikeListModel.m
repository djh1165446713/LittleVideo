//
//  ABLikeListModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABLikeListModel.h"

@implementation ABLikeListResult
@end

@implementation ABLikeListModel


+ (void)requestLikeList:(NSString *)_pageNumber contentids:(NSString *)_contentids block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{
                               @"pageNumber"    : _pageNumber  ? _pageNumber  : @"0",
                               @"contentids"    : _contentids  ? _contentids  : @""
                               };
    [[CTHttpApi sharedInstance] requestWithURL:urlLikeList paras:dicParam success:success failure:failure];
}

@end
