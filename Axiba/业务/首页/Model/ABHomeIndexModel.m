//
//  ABHomeIndexModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABHomeIndexModel.h"

@implementation ABHomeIndexRsult
@end

@implementation ABHomeIndexModel

+ (void)requestIndex:(NSString*)_pageNumber success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{@"pageNumber":_pageNumber};
    [[CTHttpApi sharedInstance] requestWithURL:urlDataIndex paras:dicParam success:success failure:failure];
}

@end
