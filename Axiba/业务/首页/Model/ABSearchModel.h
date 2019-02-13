//
//  ABHomeIndexModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABContentsModel.h"

typedef NS_ENUM(NSInteger ,Type_Search)
{
    Type_Search_All     = 0 ,
    Type_Search_Content = 1 ,
    Type_Search_Channel = 2
};

@interface ABSearchResult : CTBaseModel
@property (nonatomic, strong) NSArray<ABContentResult>      *content;
@property (nonatomic, strong) NSArray<ABChannelInfoResult>  *channel;

@end

@interface ABSearchModel : CTBaseModel
@property (nonatomic, strong) ABSearchResult  *rspObject;

+ (void)requestSearch:(NSString *)_keyword type:(Type_Search)_type pageNumber:(NSString*)_strPage block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
