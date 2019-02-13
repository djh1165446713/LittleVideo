//
//  ABHomeIndexModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABSendReviewModel.h"

@implementation ABSendReviewModel

+ (void)sendReview:(NSString *)_message forids:(NSString *)_forids contentids:(NSString *)_contentids block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{
                               @"message"       : _message      ? _message      : @"0",
                               @"forids"        : _forids       ? _forids       : @"",
                               @"contentids"    : _contentids   ? _contentids   : @""
                               };
    [[CTHttpApi sharedInstance] requestWithURL:urlSendReview paras:dicParam success:success failure:failure];
}

@end
