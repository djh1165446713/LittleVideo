//
//  ABEvaListModel.h
//  Axiba
//
//  Created by Peter on 16/6/11.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseModel.h"

@class ABUserInfoModel;

@protocol ABEvaItem
@end

@interface ABEvaItem : CTBaseModel
@property (nonatomic, strong) NSString<Optional>  *message;
@property (nonatomic, strong) NSNumber<Optional>  *id;
@property (nonatomic, strong) NSNumber<Optional>  *create_time;
@property (nonatomic, strong) NSString<Optional>  *contentids;
@property (nonatomic, strong) NSString<Optional>  *content_photo;
@property (nonatomic, strong) NSString<Optional>  *other;
@property (nonatomic, strong) NSString<Optional>  *my_info;
@property (nonatomic, strong) ABUserInfoModel<Optional> *my_infoObj;
@property (nonatomic, strong) NSString<Optional>  *other_info;
@property (nonatomic, strong) ABUserInfoModel<Optional> *other_infoObj;
@end

@interface ABEvaResult : CTBaseModel
@property (nonatomic, strong) NSArray<ABEvaItem>        *comment;
@property (nonatomic, strong) ABPageModel<Optional>     *page;
@end

@interface ABEvaListModel : CTBaseModel
@property (nonatomic, strong) ABEvaResult<Optional>     *rspObject;

+ (void)getList:(NSString*)contentids page:(NSInteger)page success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;
+ (void)setReddot:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;
+ (void)getReddot:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;
@end
