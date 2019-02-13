//
//  ABLoginModel.h
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseModel.h"

@interface ABLoginUser : CTBaseModel
@property (nonatomic, strong) NSString<Optional>  *sessionid;
@property (nonatomic, strong) NSString<Optional>  *avator;
@property (nonatomic, strong) NSString<Optional>  *birthday;
@property (nonatomic, strong, readonly) NSString  *sexFormat;
@property (nonatomic, strong) NSString<Optional>  *sex;
@property (nonatomic, strong) NSString<Optional>  *login;
@property (nonatomic, strong) NSString<Optional>  *nickname;
@property (nonatomic, strong) NSString<Optional>  *city;
@property (nonatomic, strong) NSString<Optional>  *mobile;
@property (nonatomic, strong) NSString<Optional>  *ids;
@property (nonatomic, strong) NSString<Optional>  *summary;
@end

@interface ABLoginResult : CTBaseModel
@property (nonatomic, strong) ABLoginUser<Optional>  *user;
@property (nonatomic, strong) NSNumber<Optional>     *redDot;
@end

@interface ABLoginModel : CTBaseModel
@property (nonatomic, strong) ABLoginResult<Optional>  *rspObject;

+ (void)login:(NSString*)contro phone:(NSString*)phone pass:(NSString*)pass success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;
+ (void)thirdlogin:(NSString*)actionKey channel:(NSString*)channel city:(NSString*)city sex:(NSString*)sex avator:(NSString*)avator nickname:(NSString*)nickname success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

+ (void)logout;

+ (void)loginSuccess:(ABLoginResult*)result fromThird:(NSString*)fromThird;
@end
