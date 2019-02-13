//
//  CTLikeChannelModel.m
//  Axiba
//
//  Created by Peter on 16/6/21.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTLikeChannelModel.h"

@implementation CTListChannelItem

@end

@implementation CTListChannelObj

@end

@implementation CTLikeChannelModel

+ (void)getChannels:(NSString*)userids page:(NSInteger)page success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSDictionary* dicParam = @{@"userids":userids,@"pageNumber":[NSString stringWithFormat:@"%zd",page]};
    [[CTHttpApi sharedInstance] requestWithURL:urlChannelList paras:dicParam success:success failure:failure];
}
@end
