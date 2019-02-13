//
//  ABChangePassModel.m
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABChangePassModel.h"

@implementation ABChangePassModel

+ (void)changePass:(NSString*)originPassword newPassword:(NSString*)newPassword success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSDictionary* dicParam = @{@"pwd":originPassword?:@"",@"npwd":newPassword?:@""};
    [[CTHttpApi sharedInstance] requestWithURL:urlEditPass paras:dicParam success:success failure:failure];
}

@end
