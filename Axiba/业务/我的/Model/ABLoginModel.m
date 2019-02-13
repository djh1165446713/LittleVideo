//
//  ABLoginModel.m
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABLoginModel.h"
#import "OpenUDID.h"

@implementation ABLoginUser

- (NSString*)sexFormat {
    NSString* sex = @"无性生物";
    switch (self.sex.integerValue) {
        case ABSexMale:
            sex = @"男";
            break;
        case ABSexFemale:
            sex = @"女";
            break;
        case ABSexShit:
            sex = @"无性生物";
            break;
        default:
            break;
    }
    return sex;
}

@end

@implementation ABLoginResult


@end

@implementation ABLoginModel

+ (void)login:(NSString*)contro phone:(NSString *)phone pass:(NSString*)pass success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSDictionary* dicParam = @{@"zone":contro?:@"",@"mobile":phone?:@"",@"pwd":pass?:@""};
    [[CTHttpApi sharedInstance] requestWithURL:urlLogin paras:dicParam success:success failure:failure];
}

+ (void)thirdlogin:(NSString*)actionKey channel:(NSString*)channel city:(NSString*)city sex:(NSString*)sex avator:(NSString*)avator nickname:(NSString*)nickname success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSDictionary* dicParam = @{@"actionKey":actionKey?:@"",@"channel":channel?:@"",@"channel":channel?:@"",@"sex":sex?:@"",@"avator":avator?:@"",@"nickname":nickname?:@"",@"imei":[OpenUDID value]?:@""};
    [[CTHttpApi sharedInstance] requestWithURL:urlThird paras:dicParam success:success failure:failure];
}

+ (void)logout {
    [[CTHttpApi sharedInstance] requestWithURL:urlLogout paras:@{} success:nil failure:nil];
}

+ (void)loginSuccess:(ABLoginResult*)result fromThird:(NSString*)fromThird {
    //UMShareToSina
    [[NSUserDefaults standardUserDefaults] setObject:fromThird forKey:@"kuserthird"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary* dicUser = [result toDictionary];
    [[ABUser sharedInstance] saveUser:dicUser];
    
    [UMessage setAlias:[[[[ABUser sharedInstance] abuser] user] ids] type:@"UseID" response:nil];
}



@end
