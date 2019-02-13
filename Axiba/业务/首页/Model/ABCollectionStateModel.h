//
//  ABHomeIndexModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABCollectionStateResult <NSObject>
@end

@interface ABCollectionStateResult : CTBaseModel

@end

@interface ABCollectionStateModel : CTBaseModel
@property (nonatomic, strong) ABCollectionStateResult  *rspObject;

/*!
 @abstract
 @param op 添加或取消收藏	1-添加收藏，2-取消收藏
 @param collectedids 内容或者频道的ids
 @param sessionid 会话唯一标识
 @param type 操作类型		string	1-收藏视频，2-收藏频道
 */
+ (void)requestCollectionState:(NSString *)_op collectedIds:(NSString *)_ids type:( NSString *)_type block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
