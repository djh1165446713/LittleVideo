//
//  CTHttpApi.h
//  
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/1/30.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBHttpClient.h"

#define CTHttpSuccessBlock      (void(^)(NSDictionary *resultObject))success
#define CTHttpFailureBlock      (void(^)(NSError  *requestErr))failure

@interface CTHttpApi : NSObject
@property (nonatomic, strong, readonly) XBHttpClient *http_json;

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstance:(AFHTTPRequestSerializer*)request respone:(AFHTTPResponseSerializer*)respone;

- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
               success:(void(^)(NSDictionary *resultObject))success
               failure:(void(^)(NSError  *requestErr))failure;


- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
               success:(void(^)(NSDictionary *resultObject))success
               failure:(void(^)(NSError  *requestErr))failure;

- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
            hasSessoin:(BOOL)hasSession
               success:(void(^)(NSDictionary *resultObject))success
               failure:(void(^)(NSError  *requestErr))failure;

- (void)uploadFile:(NSString *)url
             image:(UIImage *)image
     progressBlock:(void (^)(NSProgress* uploadProgress))progressBlock
           success:(void (^)(NSDictionary* responseObject))success
           failure:(void (^)(NSError* error))failure;

@end
