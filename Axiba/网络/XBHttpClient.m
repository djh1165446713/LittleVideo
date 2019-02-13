//
//  XBHttpClient.m
//  XBHttpClient
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/1/30.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "XBHttpClient.h"
#import "HYBNetworking.h"

@interface XBHttpClient()

@end

@implementation XBHttpClient

#pragma mark - request
- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
               success:(void(^)(NSDictionary *resultObject))success
               failure:(void(^)(NSError *requestErr))failure {
    [self requestWithURL:url paras:parasDict type:type hasSession:YES success:success failure:failure];
}

- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
            hasSession:(BOOL)hasSession
               success:(void(^)(NSDictionary *resultObject))success
               failure:(void(^)(NSError *requestErr))failure
{
    // 检查是否是xml解析
    // 已指定何种格式解析，无需重复相同实例化，否则http多线程会引起内存问题
    if (type == XBHttpResponseType_XML) {
        if (![self.responseSerializer isMemberOfClass:[AFXMLParserResponseSerializer class]])
        {
            if(_myRespnse)
                self.responseSerializer = _myRespnse;
            else
            {
                AFXMLParserResponseSerializer *xmlParserSerializer = [[AFXMLParserResponseSerializer alloc] init];
                self.responseSerializer = xmlParserSerializer;
            }
        }
    }
    else if (type == XBHttpResponseType_Json) {
        if(![self.responseSerializer isMemberOfClass:[AFJSONResponseSerializer class]])
        {
            if(_myRespnse)
                self.responseSerializer = _myRespnse;
            else
            {
                AFJSONResponseSerializer *jsonParserSerializer = [[AFJSONResponseSerializer alloc] init];
                self.responseSerializer = jsonParserSerializer;
            }
        }
    }
    else {
        if (![self.responseSerializer isMemberOfClass:[AFHTTPResponseSerializer class]])
        {
            if(_myRespnse)
                self.responseSerializer = _myRespnse;
            else
            {
                AFHTTPResponseSerializer *httpParserSerializer = [[AFHTTPResponseSerializer alloc] init];
                self.responseSerializer = httpParserSerializer;
            }
        }
    }
   
    // 检查BaseURL
    NSString *requestURL = @"";
    if (![url containsString:@"http"])
        requestURL = [_API_ stringByAppendingString:url];
    else
        requestURL = url;
    
    NSMutableDictionary *transferParas = [NSMutableDictionary dictionaryWithDictionary:parasDict];
    if (parasDict == nil) {
        
    }
    else {
        // 添加共同的请求参数
        NSString* localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary* dic = @{@"appver":localVersion,@"client":@"iOS",@"devicever":[UIDevice currentDevice].systemVersion,@"device":[CTTools getDeviceCategroy]};
        NSMutableDictionary* baseParas = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSString* session = [[[[ABUser sharedInstance] abuser] user] sessionid];
        if (hasSession && [session isValid]) {
            [baseParas setObject:session forKey:@"sessionid"];
        }
        if (baseParas && baseParas.allKeys.count > 0) {
            [transferParas setValuesForKeysWithDictionary:baseParas];
        }
        
//        NSLog(@"request url:%@",requestURL);
//        NSString* json = [transferParas toString];
//        NSLog(@"request body:%@",json);
    }
    // 开始请求
    __weak typeof(self) wSelf = self;
    id successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        if (!wSelf) {
            return ;
        }
        if(type == XBHttpResponseType_Common)
        {
            NSString* string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            success(@{@"result":string});
            return;
        }
        
        NSDictionary* dic = (NSDictionary*)responseObject;
        if ([dic[@"rspCode"] integerValue] == 431) {
            if ([ABUser isLogined]) {
                [[ABUser sharedInstance] logout];
                [ABUser presentLogined];
            }
        }
        
        
        if (success != NULL) {
            success(dic);
        }
    };
    
    id failureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure != NULL)
            failure(error);
        
    };

    if (parasDict) {
        [self POST:requestURL parameters:transferParas progress:nil success:successBlock failure:failureBlock];
    }
    else {
        [self GET:requestURL parameters:nil progress:nil success:successBlock failure:failureBlock];
    }
}


- (NSURLSessionUploadTask*)uploadFile:(NSString*)url image:(UIImage*)image progressBlock:(void (^)(NSProgress* uploadProgress))progressBlock success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSError* error))failure {
    NSString *requestURL = @"";
    if (![url containsString:@"http"])
        requestURL = [_API_ stringByAppendingString:url];
    else
        requestURL = url;
    [HYBNetworking configRequestType:kHYBRequestTypePlainText responseType:kHYBResponseTypeJSON shouldAutoEncodeUrl:NO callbackOnCancelRequest:YES];
    [HYBNetworking uploadWithImage:image url:requestURL filename:nil name:@"avator" mimeType:@"image/jpeg" parameters:@{@"sessionid":[[[[ABUser sharedInstance] abuser] user] sessionid]} progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
        if (progressBlock != NULL) {
            NSProgress* process = [[NSProgress alloc] init];
            process.completedUnitCount = bytesWritten;
            process.totalUnitCount = totalBytesWritten;
            progressBlock(process);
        }
    } success:^(id response) {
        success((NSDictionary*)response);
    } fail:^(NSError *error) {
        if (failure != NULL) {
            failure(error);
        }
    }];
    
    return nil;
    
    
//    NSError* error = NULL;
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
//        [formData appendPartWithFileData:imageData name:@"uploadFile" fileName:@"userhead.jpg" mimeType:@"multipart/form-data"];
////        NSString* session = [[[ABUser sharedInstance] user] sessionId];
////        [formData appendPartWithFormData:[session dataUsingEncoding:NSUTF8StringEncoding] name:@"sessionId"];
//    } error:&error];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
//        if (progressBlock != NULL) {
//            progressBlock(uploadProgress);
//        }
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (error) {
//            if (failure != NULL) {
//                failure(error);
//            }
//        }
//        else if (success != NULL) {
//            success((NSDictionary*)responseObject);
//        }
//    }];
//    
//    return uploadTask;
}

@end
