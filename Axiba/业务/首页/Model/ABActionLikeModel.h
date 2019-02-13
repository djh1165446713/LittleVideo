//
//  ABActionLikeModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABActionLikeModel : CTBaseModel

/*!
 @method
 内容ids	collectedids	string
 添加或取消点赞	op	string	1-添加点赞，2-取消点赞
 */
+ (void)requestActionLike:(NSString *)_collectedids op:(NSString *)_op block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
