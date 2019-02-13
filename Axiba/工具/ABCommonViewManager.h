//
//  ABCommonView.h
//  Axiba
//
//  Created by Hu Zejiang on 16/6/13.
//  Copyright © 2016年 Nemofish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "WMPlayer.h"

typedef void(^BlockResultState)(NSString *strPlatName , BOOL success , NSError *error);


@interface ABCommonViewManager : NSObject

+ (ABCommonViewManager *)shareInstance;

@property (nonatomic, copy) BlockResultState blockShareResult;



/*!
 @method 弹出用户分享
 @param content:@"分享内容"
 @param defaultContent:@"测试一下"
 @param image:[ShareSDK imageWithPath:imagePath]
 @param title:@"ShareSDK"
 @param url:@"http://www.mob.com"
 @param description:@"这是一条测试信息"
 @param mediaType:SSPublishContentMediaTypeNews
 
 @return block 相关参数和结果的回调
 */
- (void)showShareView:(NSString *)_content
       defaultContent:(NSString *)_defaultContent
                image:(UIImage *)_image
                title:(NSString *)_title
                  url:(NSString *)_url
          description:(NSString *)_description
           contentids:(NSString *)_contentids
          isCollected:(BOOL)_isCollected
                block:(BlockResultState)_block;

- (WMPlayer *)getPlayer:(CGRect)_frame videoURLStr:(NSString *)_url;

-(void)releaseWMPlayer;

@end

