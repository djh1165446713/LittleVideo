//
//  ABDemoModel.m
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABDemoModel.h"

@implementation ABDemoResult
@end

@implementation ABDemoModel

+ (void)doDemoGet:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSString* url = @"http://api.cuitrip.com/baseservice/getVersionCtrl";
    NSDictionary* dicParam = @{@"platform":@"iOS"};
    [[CTHttpApi sharedInstance] requestWithURL:url paras:dicParam success:success failure:failure];
}

@end
