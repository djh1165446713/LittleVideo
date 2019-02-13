//
//  CTLikeContentModel.m
//  Axiba
//
//  Created by Peter on 16/6/21.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTLikeContentModel.h"

@implementation CTLikeConnectObj

@end

@implementation CTLikeContentModel

+ (void)getContent:(NSString*)userids page:(NSInteger)page success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSDictionary* dicParam = @{@"userids":userids,@"pageNumber":[NSString stringWithFormat:@"%zd",page]};
    [[CTHttpApi sharedInstance] requestWithURL:urlCollectList paras:dicParam success:success failure:failure];
}
@end
