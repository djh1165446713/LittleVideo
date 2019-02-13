//
//  ABCommonData.h
//  Axiba
//
//  Created by Hu Zejiang on 16/6/13.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABUpdateUserDataModel.h"

@interface ABCommonDataManager : NSObject

//下拉刷新图片集合
+ (NSMutableArray *)getRefreshPullingImages;
+ (NSMutableArray *)getRefreshRefreshingImages;
//获取loading的动图
+ (NSMutableArray *)getLoadingImages;


/*!
 @abstract 历史记录管理
 */
+ (NSMutableArray *)getSearchKeyHistory;
+ (void)addSearchKey:(NSString *)_strKey;
+ (void)removeSearchKey:(NSString *)_strKey;
+ (void)removeAllSearchKey;

+ (void)updateClaissify:(ABUpdateUserDataModel *)_model;
+ (ABUpdateUserDataModel *)getClassifyModel;

@end
