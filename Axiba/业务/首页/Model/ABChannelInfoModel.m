//
//  ABHomeIndexModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABChannelInfoModel.h"

@implementation ABChannelInfoResult
@end

@implementation ABChannelInfoModel

+ (void)requestChannelInfo:(NSString *)_channelids block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{
                               @"ids" : _channelids  ? _channelids  : @""
                               };
    [[CTHttpApi sharedInstance] requestWithURL:urlChannelInfo paras:dicParam hasSessoin:YES success:success failure:failure];
}

@end
