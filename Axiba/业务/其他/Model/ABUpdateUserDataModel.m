//
//  ABUpdateUserDataModel.m
//  Axiba
//
//  Created by Peter on 16/6/17.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABUpdateUserDataModel.h"

@implementation ABClassifyDetailResult
@end

@implementation ABUpdateUserDataResult
@end

@implementation ABUpdateUserDataModel

+ (void)update:(NSString*)token block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSString* wh = [NSString stringWithFormat:@"%.0f*%.0f",kTPScreenWidth,kTPScreenHeight];
    
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    NSString* net = @"无";
    switch (status) {
        case AFNetworkReachabilityStatusUnknown: {
            break;
        }
        case AFNetworkReachabilityStatusNotReachable: {
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            net = @"2G/3G/4G";
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            net = @"wifi";
            break;
        }
        default: {
            break;
        }
    }
    NSString* ccc   = nil;
    NSString* city  = [TPLocationManager locationCity];
    NSString* p     = [TPLocationManager locationProvince];
    if ([city isValid] && [p isValid]) {
        ccc = [NSString stringWithFormat:@"%@-%@",p,city];
    }
    NSDictionary* dicParam = @{@"city":ccc?:@"",@"down_channel":@"AppleStore",@"resolution":wh,@"imsi":@"123456",@"os":@"iOS",@"imei":@"123456",@"model":[CTTools getDeviceCategroy],@"networking":net};
    [[CTHttpApi sharedInstance] requestWithURL:urlUpdateData paras:dicParam success:success failure:failure];
}
@end
