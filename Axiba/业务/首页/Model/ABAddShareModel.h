//
//  ABAddShareModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABAddShareModel : CTBaseModel

+ (void)requestAddShare:(NSString *)_contentIds block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
