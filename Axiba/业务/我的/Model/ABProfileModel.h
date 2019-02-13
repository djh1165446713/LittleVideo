//
//  ABProfileModel.h
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseModel.h"

@interface ABProfileItem : CTBaseModel
@property (nonatomic, strong) NSString<Optional>  *video_count;
@property (nonatomic, strong) NSString<Optional>  *popularity;
@property (nonatomic, strong) NSString<Optional>  *brief;
@property (nonatomic, strong) NSString<Optional>  *nickName;
@property (nonatomic, strong) NSString<Optional>  *avatar_url;
@property (nonatomic, strong) NSString<Optional>  *theme_color;
@end

@interface ABProfileModel : CTBaseModel
@property (nonatomic, strong) ABProfileItem<Optional> *rspObject;


+ (void)getProfile:(NSString*)userId profileType:(ProfileType)profileType success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

+ (void)updateProfile:(NSString*)type value:(NSString*)value success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end


@interface ABAvatorItem : CTBaseModel
@property (nonatomic, strong) NSString<Optional>  *avator;
@end

@interface ABAvatorModel : CTBaseModel
@property (nonatomic, strong) ABAvatorItem<Optional> *rspObject;
@end