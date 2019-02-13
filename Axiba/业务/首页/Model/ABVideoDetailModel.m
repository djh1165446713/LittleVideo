//
//  ABHomeIndexModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABVideoDetailModel.h"

@implementation ABVideoDetailResult
@end

@implementation ABVideoDetailModel


+ (void)requestVideoDetail:(NSString *)_videoIds block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{
                               @"ids" : _videoIds  ? _videoIds  : @""
                               };
    [[CTHttpApi sharedInstance] requestWithURL:urlVideoDetail paras:dicParam success:success failure:failure];
}

@end
