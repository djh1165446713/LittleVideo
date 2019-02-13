//
//  ABHomeIndexModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABActionLikeModel.h"

@implementation ABActionLikeModel

+ (void)requestActionLike:(NSString *)_collectedids op:(NSString *)_op block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{
                               @"collectedids"  : _collectedids     ? _collectedids     : @"0",
                               @"op"            : _op               ? _op               : @"",
                               };
    [[CTHttpApi sharedInstance] requestWithURL:urlActionLike paras:dicParam success:success failure:failure];
}



@end
