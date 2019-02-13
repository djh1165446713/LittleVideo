//
//  ABHomeIndexModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABChannelInfoResult <NSObject>
@end

@interface ABChannelInfoResult : CTBaseModel

@property (nonatomic, strong) NSString<Optional>  *attention;
@property (nonatomic, strong) NSString<Optional>  *classify_ids;
@property (nonatomic, strong) NSString<Optional>  *classify_name;
@property (nonatomic, strong) NSString<Optional>  *collected;
@property (nonatomic, strong) NSString<Optional>  *create_by;
@property (nonatomic, strong) NSString<Optional>  *create_time;
@property (nonatomic, strong) NSString<Optional>  *del_flat;
@property (nonatomic, strong) NSString<Optional>  *ids;
@property (nonatomic, strong) NSString<Optional>  *name;
@property (nonatomic, strong) NSString<Optional>  *pkValue;
@property (nonatomic, strong) NSString<Optional>  *photo;
@property (nonatomic, strong) NSString<Optional>  *remarks;
@property (nonatomic, strong) NSString<Optional>  *status;
@property (nonatomic, strong) NSString<Optional>  *summary;
@property (nonatomic, strong) NSString<Optional>  *theme;
@property (nonatomic, strong) NSString<Optional>  *total_content;
@property (nonatomic, strong) NSString<Optional>  *type;
@property (nonatomic, strong) NSString<Optional>  *update_by;
@property (nonatomic, strong) NSString<Optional>  *update_time;

@end

@interface ABChannelInfoModel : CTBaseModel
@property (nonatomic, strong) ABChannelInfoResult  *rspObject;

+ (void)requestChannelInfo:(NSString *)_channelids block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;


@end
