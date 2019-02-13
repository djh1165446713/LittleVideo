//
//  ABProfileModel.m
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABProfileModel.h"

@implementation ABProfileItem
@end

@implementation ABProfileModel

+ (void)getProfile:(NSString*)userId profileType:(ProfileType)profileType success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSDictionary* dicParam = @{@"userId":userId?:@"",@"userType":[NSString stringWithFormat:@"%zd",profileType]};
    [[CTHttpApi sharedInstance] requestWithURL:urlMeOrOther paras:dicParam success:success failure:failure];
}

+ (void)updateProfile:(NSString*)type value:(NSString*)value success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    [[CTHttpApi sharedInstance] requestWithURL:urlProfile paras:@{@"type":type,type:value} success:success failure:failure];
}

@end

@implementation ABAvatorItem
@end

@implementation ABAvatorModel
@end