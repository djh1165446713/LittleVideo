//
//  CTLikeChannelModel.h
//  Axiba
//
//  Created by Peter on 16/6/21.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseModel.h"

@protocol CTListChannelItem <NSObject>
@end

@interface CTListChannelItem : CTBaseModel
@property (nonatomic, strong) NSString<Optional>  *summary;
@property (nonatomic, strong) NSString<Optional>  *ids;
@property (nonatomic, strong) NSString<Optional>  *type;
@property (nonatomic, strong) NSString<Optional>  *name;
@property (nonatomic, strong) NSString<Optional>  *theme;
@property (nonatomic, strong) NSString<Optional>  *photo;
@end

@interface CTListChannelObj : CTBaseModel
@property (nonatomic, strong) NSArray<CTListChannelItem>    *channels;
@property (nonatomic, strong) ABPageModel<Optional>         *page;
@end

@interface CTLikeChannelModel : CTBaseModel
@property (nonatomic, strong) CTListChannelObj<Optional>    *rspObject;


+ (void)getChannels:(NSString*)userids page:(NSInteger)page success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
