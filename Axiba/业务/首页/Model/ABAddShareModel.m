//
//  ABAddShareModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABAddShareModel.h"

@implementation ABAddShareModel

+ (void)requestAddShare:(NSString *)_contentIds block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{
                               @"contentids"  : _contentIds     ? _contentIds     : @"0"
                               };
    [[CTHttpApi sharedInstance] requestWithURL:urlAddShare paras:dicParam success:success failure:failure];
}



@end
