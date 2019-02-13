//
//  ABAddViewModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABAddViewModel.h"

@implementation ABAddViewModel

+ (void)requestAddView:(NSString *)_contentIds block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{
                               @"contentids"  : _contentIds     ? _contentIds     : @"0"
                               };
    [[CTHttpApi sharedInstance] requestWithURL:urlAddView paras:dicParam success:success failure:failure];
}

@end
