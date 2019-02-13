//
//  ABHomeIndexModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABChannelInfoModel.h"

@protocol ABCommonPageModel <NSObject>
@end
@interface ABCommonPageModel : CTBaseModel
@property (nonatomic, strong) NSString<Optional>        *currentPageCount;
@property (nonatomic, strong) NSString<Optional>        *pageNumber;
@property (nonatomic, strong) NSString<Optional>        *start;
@property (nonatomic, strong) NSString<Optional>        *totalPage;
@property (nonatomic, strong) NSString<Optional>        *totalRow;
@end


@protocol ABUserInfoModel <NSObject>
@end
@interface ABUserInfoModel : CTBaseModel
@property (nonatomic, strong) NSString<Optional>  *summary;
@property (nonatomic, strong) NSString<Optional>  *nickname;
@property (nonatomic, strong) NSString<Optional>  *ids;
@property (nonatomic, strong) NSString<Optional>  *avator;
@end


@protocol ABCommentModel <NSObject>
@end
@interface ABCommentModel : CTBaseModel
@property (nonatomic, strong) NSString<Optional>        *content_photo;
@property (nonatomic, strong) NSString<Optional>        *contentids;
@property (nonatomic, strong) NSString<Optional>        *create_time;
@property (nonatomic, strong) NSNumber<Optional>        *idv;
@property (nonatomic, strong) NSString<Optional>        *del_flag;
@property (nonatomic, strong) NSString<Optional>        *message;
@property (nonatomic, strong) NSString<Optional>        *other;
@property (nonatomic, strong) NSString<Optional>        *update_by;
@property (nonatomic, strong) NSString<Optional>        *update_time;
@property (nonatomic, strong) NSNumber<Optional>        *praiseCount;
@property (nonatomic, strong) NSNumber<Optional>        *flag;

@property (nonatomic, strong) NSString<Optional>        *my_info;
@property (nonatomic, strong) ABUserInfoModel<Optional> *my_infoObj;
@property (nonatomic, strong) NSString<Optional>        *other_info;
@property (nonatomic, strong) ABUserInfoModel<Optional> *other_infoObj;
@end


@protocol ABCommentInfoResult <NSObject>
@end
@interface ABCommentInfoResult : CTBaseModel
@property (nonatomic, strong) NSNumber<Optional>        *total;
@property (nonatomic, strong) NSArray<ABCommentModel>   *comment;
@end


@protocol ABLikeUserModel <NSObject>
@end
@interface ABLikeUserModel : CTBaseModel
@property (nonatomic, strong) NSString<Optional>        *avator;
@property (nonatomic, strong) NSString<Optional>        *birthday;
@property (nonatomic, strong) NSString<Optional>        *channel;
@property (nonatomic, strong) NSString<Optional>        *city;
@property (nonatomic, strong) NSString<Optional>        *collected;
@property (nonatomic, strong) NSString<Optional>        *deviceids;
@property (nonatomic, strong) NSString<Optional>        *ids;
@property (nonatomic, strong) NSString<Optional>        *imei;
@property (nonatomic, strong) NSString<Optional>        *login;
@property (nonatomic, strong) NSString<Optional>        *mobile;
@property (nonatomic, strong) NSString<Optional>        *nickname;
@property (nonatomic, strong) NSString<Optional>        *pKValue;
@property (nonatomic, strong) NSString<Optional>        *praised;
@property (nonatomic, strong) NSString<Optional>        *sessionid;
@property (nonatomic, strong) NSString<Optional>        *sex;
@property (nonatomic, strong) NSString<Optional>        *status;
@property (nonatomic, strong) NSString<Optional>        *summary;
@end


@protocol ABPraiseInfoResult <NSObject>
@end
@interface ABPraiseInfoResult : CTBaseModel
@property (nonatomic, strong) NSNumber<Optional>        *praiseTotal;
@property (nonatomic, strong) NSArray<ABLikeUserModel>  *praise;
@end


@protocol ABContentInfoResult <NSObject>
@end

@interface ABContentInfoResult : CTBaseModel
@property (nonatomic, strong) NSString<Optional>  *added_views;
@property (nonatomic, strong) NSString<Optional>  *attention;
@property (nonatomic, strong) NSString<Optional>  *channel_ids;
@property (nonatomic, strong) NSString<Optional>  *classify_ids;
@property (nonatomic, strong) NSString<Optional>  *collected;
@property (nonatomic, strong) NSString<Optional>  *comment_num;
@property (nonatomic, strong) NSString<Optional>  *create_by;
@property (nonatomic, strong) NSString<Optional>  *create_time;
@property (nonatomic, strong) NSString<Optional>  *del_flag;
@property (nonatomic, strong) NSString<Optional>  *ids;
@property (nonatomic, strong) NSString<Optional>  *like;
@property (nonatomic, strong) NSString<Optional>  *link;
@property (nonatomic, strong) NSString<Optional>  *photo;
@property (nonatomic, strong) NSString<Optional>  *publish_time;
@property (nonatomic, strong) NSString<Optional>  *share;
@property (nonatomic, strong) NSString<Optional>  *praised;
@property (nonatomic, strong) NSString<Optional>  *sort;
@property (nonatomic, strong) NSString<Optional>  *source;
@property (nonatomic, strong) NSString<Optional>  *status;
@property (nonatomic, strong) NSString<Optional>  *summary;
@property (nonatomic, strong) NSString<Optional>  *title;
@property (nonatomic, strong) NSString<Optional>  *update_by;
@property (nonatomic, strong) NSString<Optional>  *update_time;
@property (nonatomic, strong) NSString<Optional>  *views;
@property (nonatomic, strong) NSNumber<Optional>  *linkType;

@end


@protocol ABContentResult <NSObject>
@end

@interface ABContentResult : CTBaseModel
@property (nonatomic, strong) ABContentInfoResult   *contentInfo;
@property (nonatomic, strong) ABChannelInfoResult   *channelInfo;
@property (nonatomic, strong) ABPraiseInfoResult    *praiseInfo;
@property (nonatomic, strong) ABCommentInfoResult   *commentInfo;
@end


@interface ABContentsResult : CTBaseModel
@property (nonatomic, strong) NSArray<ABContentResult>  *content;
@property (nonatomic, strong) ABCommonPageModel         *page;
@end

@interface ABContentsModel : CTBaseModel
@property (nonatomic, strong) ABContentsResult  *rspObject;

+ (void)requestContents:(NSString *)_pageNumber classifyids:(NSString *)_classifyids channelId:(NSString *)_channelId block:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
