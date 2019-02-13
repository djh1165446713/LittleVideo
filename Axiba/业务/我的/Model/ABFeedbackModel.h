//
//  ABFeedbackModel.h
//  Axiba
//
//  Created by Peter on 16/6/11.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseModel.h"

@interface ABFeedbackModel : CTBaseModel

+ (void)feedback:(NSString*)feedback success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;
@end
