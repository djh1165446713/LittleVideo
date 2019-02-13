//
//  ABRegModel.h
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseModel.h"

@interface ABRegModel : CTBaseModel

+ (void)getCaptcha:(NSString *)contron phone:(NSString*)phone type:(NSString*)type success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

+ (void)regOrFindPass:(BOOL)isReg contron:(NSString *)contron phone:(NSString*)phone pass:(NSString*)pass captcha:(NSString*)captcha success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;
@end
