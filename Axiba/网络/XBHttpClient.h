//
//  XBHttpClient.h
//  XBHttpClient
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/1/30.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class NSURLSessionDataTask;

#define xbAllowCache    @"xbAllowCache"

typedef enum
{
    XBHttpResponseType_Json,
    XBHttpResponseType_JqueryJson,
    XBHttpResponseType_XML,
    XBHttpResponseType_Common
}XBHttpResponseType;

@interface XBHttpClient : AFHTTPSessionManager

@property(nonatomic,copy)AFHTTPResponseSerializer* myRespnse;

- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
               success:(void(^)(NSDictionary *resultObject))success
               failure:(void(^)(NSError *requestErr))failure;

- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
            hasSession:(BOOL)hasSession
               success:(void(^)(NSDictionary *resultObject))success
               failure:(void(^)(NSError *requestErr))failure;


- (NSURLSessionUploadTask*)uploadFile:(NSString*)url image:(UIImage*)image progressBlock:(void (^)(NSProgress* uploadProgress))progressBlock success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSError* error))failure;

@end
