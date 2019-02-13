//
//  ABChangePassModel.h
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseModel.h"

@interface ABChangePassModel : CTBaseModel
+ (void)changePass:(NSString*)originPassword newPassword:(NSString*)newPassword success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;
@end
