//
//  ABHomeIndexModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABCollectionStateModel.h"

@implementation ABCollectionStateResult
@end

@implementation ABCollectionStateModel

/*!
 @abstract
 @param op 添加或取消收藏	1-添加收藏，2-取消收藏
 @param collectedids 内容或者频道的ids
 @param sessionid 会话唯一标识
 @param type 操作类型		string	1-收藏视频，2-收藏频道
 */
+ (void)requestCollectionState:(NSString *)_op collectedIds:(NSString *)_ids type:(NSString *)_type block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{
                               @"op":_op,
                               @"collectedids" : _ids,
                               @"type"         : _type
                               };
    [[CTHttpApi sharedInstance] requestWithURL:urlCollectionState paras:dicParam success:success failure:failure];
}

@end
