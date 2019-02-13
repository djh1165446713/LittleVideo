//
//  ABUpdateUserDataModel.h
//  Axiba
//
//  Created by Peter on 16/6/17.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseModel.h"

@protocol ABClassifyDetailResult <NSObject>
@end

@protocol ABUpdateUserDataResult <NSObject>
@end

@interface ABClassifyDetailResult : CTBaseModel

@property (nonatomic, strong) NSString<Optional>  *create_by;
@property (nonatomic, strong) NSString<Optional>  *create_time;
@property (nonatomic, strong) NSString<Optional>  *del_flag;
@property (nonatomic, strong) NSString<Optional>  *name;
@property (nonatomic, strong) NSString<Optional>  *ids;
@property (nonatomic, strong) NSString<Optional>  *pkValue;
@property (nonatomic, strong) NSString<Optional>  *place;
@property (nonatomic, strong) NSString<Optional>  *remarks;
@property (nonatomic, strong) NSString<Optional>  *sort;
@property (nonatomic, strong) NSString<Optional>  *statue;
@property (nonatomic, strong) NSString<Optional>  *update_by;
@property (nonatomic, strong) NSString<Optional>  *update_time;

@end

@interface ABUpdateUserDataResult : CTBaseModel
@property (nonatomic, strong) NSArray<ABClassifyDetailResult>  *classify;

@end

@interface ABUpdateUserDataModel : CTBaseModel

@property (nonatomic, strong) ABUpdateUserDataResult  *rspObject;

+ (void)update:(NSString*)token block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;
@end
