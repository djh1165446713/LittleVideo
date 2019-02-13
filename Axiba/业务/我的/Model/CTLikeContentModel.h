//
//  CTLikeContentModel.h
//  Axiba
//
//  Created by Peter on 16/6/21.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseModel.h"
#import "ABContentsModel.h"

@protocol CTListChannelItem <NSObject>
@end

@interface CTLikeConnectObj : CTBaseModel
@property (nonatomic, strong) NSArray<ABContentResult>  *contents;
@property (nonatomic, strong) ABPageModel<Optional>     *page;
@end

@interface CTLikeContentModel : CTBaseModel
@property (nonatomic, strong) CTLikeConnectObj<Optional>    *rspObject;

+ (void)getContent:(NSString*)userids page:(NSInteger)page success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;
@end
