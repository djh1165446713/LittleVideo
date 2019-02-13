//
//  ABRegModel.m
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABRegModel.h"
#import "OpenUDID.h"

@implementation ABRegModel

+ (void)getCaptcha:(NSString *)contron phone:(NSString*)phone type:(NSString*)type success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSDictionary* dicParam = @{@"zone":contron?:@"",@"mobile":phone?:@"",@"type":type?:@"register"};
    [[CTHttpApi sharedInstance] requestWithURL:urlGetCaptcha paras:dicParam success:success failure:failure];
}



+ (void)regOrFindPass:(BOOL)isReg contron:(NSString *)contron phone:(NSString*)phone pass:(NSString*)pass captcha:(NSString*)captcha success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSDictionary* dicParam = @{@"zone":contron?:@"",@"mobile":phone?:@"",@"pwd":pass?:@"",@"authcode":captcha?:@"",@"imei":[OpenUDID value]?:@""};
    [[CTHttpApi sharedInstance] requestWithURL:(isReg ? urlReg : urlFindPass) paras:dicParam success:success failure:failure];
}

@end
