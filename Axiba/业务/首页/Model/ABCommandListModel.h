//
//  ABHomeIndexModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABContentsModel.h"

@protocol ABCommandListResult <NSObject>
@end
@interface ABCommandListResult : CTBaseModel
@property (nonatomic, strong) NSArray<ABCommentModel>   *comment;
@property (nonatomic, strong) ABCommonPageModel         *page;
@end

@interface ABCommandListModel : CTBaseModel
@property (nonatomic, strong) ABCommandListResult  *rspObject;

+ (void)requestCommandList:(NSString *)_pageNumber contentids:(NSString *)_contentids block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
