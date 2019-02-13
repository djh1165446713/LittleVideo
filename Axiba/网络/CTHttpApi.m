//
//  CTHttpApi.m
//  
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/1/30.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "CTHttpApi.h"

#define allowCache  0

static CTHttpApi* xb = nil;
static dispatch_once_t once;

@implementation CTHttpApi

+ (instancetype)sharedInstance:(AFHTTPRequestSerializer*)request respone:(AFHTTPResponseSerializer*)respone {
    dispatch_once(&once, ^{
        xb = [[CTHttpApi alloc] initWithRespone:request response:respone];
    });
    return xb;
}

+ (instancetype)sharedInstance {
    dispatch_once(&once, ^{
        xb = [[CTHttpApi alloc] init];
    });
    return xb;
}

- (instancetype)initWithRespone:(AFHTTPRequestSerializer*)request response:(AFHTTPResponseSerializer*)response {
    self = [super init];
    if (self) {
        [self initialHttp:request respone:response];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self)
    {
        [self initialHttp:nil respone:nil];
    }
    return self;
}

- (void)initialHttp:(AFHTTPRequestSerializer*)request respone:(AFHTTPResponseSerializer*)respone {
    _http_json = [[XBHttpClient alloc] init];
    
    AFHTTPRequestSerializer* request_form = request ? (AFHTTPRequestSerializer*)request : [[AFHTTPRequestSerializer alloc] init];
    request_form.timeoutInterval = 30;
    [_http_json setRequestSerializer:request_form];
    
    AFJSONResponseSerializer* response_json = respone ? (AFJSONResponseSerializer*)respone : [[AFJSONResponseSerializer alloc] init];
    [_http_json setResponseSerializer:response_json];
}

- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
               success:(void(^)(NSDictionary *resultObject))success
               failure:(void(^)(NSError  *requestErr))failure
{
    [_http_json requestWithURL:url paras:parasDict type:XBHttpResponseType_Json success:success failure:failure];
}


- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
            hasSessoin:(BOOL)hasSession
               success:(void(^)(NSDictionary *resultObject))success
               failure:(void(^)(NSError  *requestErr))failure
{
    [_http_json requestWithURL:url paras:parasDict type:XBHttpResponseType_Json hasSession:hasSession success:success failure:failure];
}



- (void)uploadFile:(NSString *)url
             image:(UIImage *)image
     progressBlock:(void (^)(NSProgress* uploadProgress))progressBlock
           success:(void (^)(NSDictionary* responseObject))success
           failure:(void (^)(NSError* error))failure
{

    [_http_json uploadFile:url image:image progressBlock:progressBlock success:success failure:failure];
}
@end
