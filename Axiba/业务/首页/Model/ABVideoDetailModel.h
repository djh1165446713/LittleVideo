//
//  ABHomeIndexModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABContentsModel.h"

@interface ABVideoDetailResult : CTBaseModel
@property (nonatomic, strong) ABContentInfoResult  *contentInfo;
@property (nonatomic, strong) ABChannelInfoResult  *channelInfo;
@property (nonatomic, strong) ABPraiseInfoResult   *praiseInfo;
@property (nonatomic, strong) ABCommentInfoResult   *commentInfo;
//@property (nonatomic, strong) ABRecommendInfoResult   *recommendInfo;
@end

@interface ABVideoDetailModel : CTBaseModel
@property (nonatomic, strong) ABVideoDetailResult  *rspObject;

+ (void)requestVideoDetail:(NSString *)_videoIds block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
