//
//  ABHomeIndexModel.m
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABSearchModel.h"

@implementation ABSearchResult
@end

@implementation ABSearchModel

+ (void)requestSearch:(NSString *)_keyword type:(Type_Search)_type pageNumber:(NSString*)_strPage block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure
{
    NSString *strType;
    switch (_type) {
        case Type_Search_All:
           strType = @"all";
            break;
            
        case Type_Search_Channel:
           strType = @"channel";
            break;
            
        case Type_Search_Content:
           strType = @"content";
            break;
    }
    NSDictionary* dicParam = @{@"word":_keyword?_keyword:@"", @"pageNumber":_strPage?_strPage:@"0" , @"type":strType};
    [[CTHttpApi sharedInstance] requestWithURL:urlSearchResult paras:dicParam success:success failure:failure];
}

@end
