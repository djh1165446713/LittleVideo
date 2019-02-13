//
//  ABDemoModel.h
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 *  若字段的值可以为空，则使用NSString<Optional>，否则此字段是not null
 */

@interface ABDemoResult : CTBaseModel
@property (nonatomic, strong) NSString  *needUpdate;
@property (nonatomic, strong) NSString  *forceUpdate;
@property (nonatomic, strong) NSString  *url;
@end

@interface ABDemoModel : CTBaseModel

@property (nonatomic, strong) ABDemoResult  *result;

+ (void)doDemoGet:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;
@end
