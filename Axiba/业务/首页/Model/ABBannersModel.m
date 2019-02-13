//
//  ABHomeIndexModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABBannersModel.h"

@implementation ABBannerResult
@end

@implementation ABBannersModel

+ (void)requestBannerList:(NSDictionary *)par blcok:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    [[CTHttpApi sharedInstance] requestWithURL:urlBannerList paras:par success:success failure:failure];
}

@end
