//
//  ABLikeListModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABContentsModel.h"

@protocol ABLikeListResult <NSObject>
@end

@interface ABLikeListResult : CTBaseModel
@property (nonatomic, strong) NSArray<ABLikeUserModel>  *praise;
@property (nonatomic, strong) ABCommonPageModel         *page;

@end

@interface ABLikeListModel : CTBaseModel
@property (nonatomic, strong) ABLikeListResult  *rspObject;

+ (void)requestLikeList:(NSString *)_pageNumber contentids:(NSString *)_contentids block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
