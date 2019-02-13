//
//  ABHomeIndexModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABCommandListModel.h"


@implementation ABCommandListResult
@end

@implementation ABCommandListModel

+ (void)requestCommandList:(NSString *)_pageNumber contentids:(NSString *)_contentids block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{
                               @"pageNumber"    : _pageNumber  ? _pageNumber  : @"0",
                               @"contentids"    : _contentids  ? _contentids  : @""
                               };
    
    [[CTHttpApi sharedInstance] requestWithURL:urlReviewList paras:dicParam hasSessoin:NO success:success failure:failure];
}

@end
