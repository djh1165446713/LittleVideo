//
//  ABHttpStubs.m
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABHttpStubs.h"
#import "OHHTTPStubs.h"
#import "OHHTTPStubsResponse.h"
#import "OHPathHelpers.h"

@implementation ABHttpStubs

+ (void)startStubs {
    return;
    [self stubRequest:@"http://api.cuitrip.com/baseservice/getVersionCtrl" jsonFile:@"test.json"];
    
    //axiba
    [self stubRequest:urlLogin jsonFile:@"login.json"];
    [self stubRequest:urlReg jsonFile:@"reg.json"];
    [self stubRequest:urlFindPass jsonFile:@"getcaptcha.json"];
    [self stubRequest:urlGetCaptcha jsonFile:@"getcaptcha.json"];
    [self stubRequest:urlProfile jsonFile:@"getcaptcha.json"];
    [self stubRequest:urlEditPass jsonFile:@"getcaptcha.json"];
    [self stubRequest:urlFeedback jsonFile:@"getcaptcha.json"];
    [self stubRequest:urlUpdateData jsonFile:@"getcaptcha.json"];
    [self stubRequest:urlMeOrOther jsonFile:@"profile.json"];
    [self stubRequest:urlComments jsonFile:@"commtents.json"];;
}


+ (void)stubRequest:(NSString*)url jsonFile:(NSString*)jsonFile {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString containsString:url];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString* fixture = OHPathForFileInBundle(jsonFile,[NSBundle mainBundle]);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
}

@end
