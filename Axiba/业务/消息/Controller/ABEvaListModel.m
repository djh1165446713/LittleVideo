//
//  ABEvaListModel.m
//  Axiba
//
//  Created by Peter on 16/6/11.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABEvaListModel.h"
#import "ABCommandListModel.h"

@implementation ABEvaItem

- (ABUserInfoModel *)my_infoObj
{
    if(!_my_infoObj)
    {
        NSString *strUserInfo   = [_my_info isValid] ? [_my_info stringByReplacingOccurrencesOfString:@"\\" withString:@""] : @"";
        _my_infoObj = [[ABUserInfoModel alloc] initWithString:strUserInfo error:nil];
    }
    return _my_infoObj;
}

- (ABUserInfoModel *)other_infoObj
{
    if(!_other_infoObj)
    {
        NSString *strUserInfo   = [_other_info isValid] ? [_other_info stringByReplacingOccurrencesOfString:@"\\" withString:@""] : @"";
        _other_infoObj = [[ABUserInfoModel alloc] initWithString:strUserInfo error:nil];
    }
    return _other_infoObj;
}

@end

@implementation ABEvaResult
@end

@implementation ABEvaListModel

+ (void)getList:(NSString*)contentids page:(NSInteger)page success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"pageNumber"];
    if ([contentids isValid]) {
        [dicParam setObject:contentids forKey:@"contentids"];
    }
    [[CTHttpApi sharedInstance] requestWithURL:urlComments paras:dicParam success:success failure:failure];
}

+ (void)setReddot:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    [[CTHttpApi sharedInstance] requestWithURL:urlSetRedDot paras:@{} success:success failure:failure];
}

+ (void)getReddot:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    [[CTHttpApi sharedInstance] requestWithURL:urlGetRedDot paras:@{} success:success failure:failure];
}
@end
