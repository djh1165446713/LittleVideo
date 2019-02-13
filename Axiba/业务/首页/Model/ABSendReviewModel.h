//
//  ABHomeIndexModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABSendReviewModel : CTBaseModel

+ (void)sendReview:(NSString *)_message forids:(NSString *)_forids contentids:(NSString *)_contentids block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
