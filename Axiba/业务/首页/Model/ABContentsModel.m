//
//  ABHomeIndexModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABContentsModel.h"

@implementation ABContentInfoResult
@end

@implementation ABContentResult
@end

@implementation ABContentsResult
@end

@implementation ABUserInfoModel
@end

@implementation ABCommentModel
- (ABUserInfoModel *)my_infoObj
{
    if(!_my_infoObj)
    {
        NSString *strUserInfo   = [_my_info isValid] ? [[_my_info stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@""] : @"";
        _my_infoObj = [[ABUserInfoModel alloc] initWithString:strUserInfo error:nil];
    }
    return _my_infoObj;
}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"idv"}];
}

- (ABUserInfoModel *)other_infoObj
{
    if(!_other_infoObj)
    {
        NSString *strUserInfo   = [_other_info isValid] ? [[_other_info stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@""] : @"";
        _other_infoObj = [[ABUserInfoModel alloc] initWithString:strUserInfo error:nil];
    }
    return _other_infoObj;
}
@end

@implementation ABCommentInfoResult
@end

@implementation ABLikeUserModel
@end

@implementation ABPraiseInfoResult
@end

@implementation ABCommonPageModel
@end

@implementation ABContentsModel


+ (void)requestContents:(NSString *)_pageNumber classifyids:(NSString *)_classifyids channelId:(NSString *)_channelId block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSDictionary* dicParam = @{
                               @"pageNumber"    : _pageNumber   ? _pageNumber   : @"0",
                               @"classifyids"   : _classifyids  ? _classifyids  : @"",
                               @"channelids"    : _channelId    ? _channelId    : @""
                               };
    [[CTHttpApi sharedInstance] requestWithURL:urlContentList paras:dicParam success:success failure:failure];
}

@end
