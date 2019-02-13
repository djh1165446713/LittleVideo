//
//  ABHomeIndexModel.h
//  Axiba
//
//  Created by Michael on 16/6/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABHomeIndexRsult : CTBaseModel
//@property (nonatomic, strong) NSArray<ABBannerModel> *banner;

@end

@interface ABHomeIndexModel : CTBaseModel
@property (nonatomic, strong) ABHomeIndexRsult<Optional>  *rspObject;

+ (void)requestIndex:(NSString*)_pageNumber success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure;

@end
