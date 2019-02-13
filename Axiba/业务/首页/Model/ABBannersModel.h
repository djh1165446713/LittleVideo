//
//  ABHomeIndexModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABBannerResult <NSObject>
@end

@interface ABBannerResult : CTBaseModel
//@property (nonatomic, strong) NSString<Optional>  *ids;
//@property (nonatomic, strong) NSString<Optional>  *create_time;
//@property (nonatomic, strong) NSString<Optional>  *del_flag;

@property (nonatomic, strong) NSMutableArray<Optional>  *impr;
@property (nonatomic, strong) NSMutableArray<Optional>  *click;


@property (nonatomic, strong) NSNumber<Optional>  *isApi;

@property (nonatomic, strong) NSString<Optional>  *link;
@property (nonatomic, strong) NSString<Optional>  *name;
//@property (nonatomic, strong) NSString<Optional>  *pKValue;
@property (nonatomic, strong) NSString<Optional>  *photo;
//@property (nonatomic, strong) NSString<Optional>  *status;
@property (nonatomic, strong) NSString<Optional>  *type;

@property (nonatomic, strong) NSNumber<Optional>  *linkType;


@end

@interface ABBannersModel : CTBaseModel
@property (nonatomic, strong) NSArray<ABBannerResult>  *rspObject;

+ (void)requestBannerList:(NSDictionary *)par blcok:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
