//
//  ABCommonView.m
//  Axiba
//
//  Created by Hu Zejiang on 16/6/13.
//  Copyright © 2016年 Nemofish. All rights reserved.
//

#import "ABCommonViewManager.h"
#import "UMSocial.h"
#import "ABAddShareModel.h"
#import <MPShareSDK/MPShareSDK.h>


@interface ABCommonViewManager()<UMSocialUIDelegate>
{
    WMPlayer *ui_player;
    NSString *m_contentids;
}

@end

@implementation ABCommonViewManager
@synthesize blockShareResult;


+ (ABCommonViewManager *)shareInstance
{
    static ABCommonViewManager * commonViewManager = nil;
    if(commonViewManager == nil)
    {
        commonViewManager = [[ABCommonViewManager alloc]init];
    }
    return commonViewManager;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMeiPaiShare:) name:Notifycation_Share_Meipai object:nil];
}


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
                block:(BlockResultState)_block
{
    blockShareResult    = _block;
    m_contentids        = _contentids;
    
    //1、创建分享参数
    NSArray* imageArray;
    if(_image)
        imageArray = @[_image];
    
//    UMSocialSnsPlatform *sinaMeipaiPlatform  = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSms];
//    sinaMeipaiPlatform.bigImageName          = @"ico_share_meipai";
//    sinaMeipaiPlatform.displayName           = @"美拍";
//    sinaMeipaiPlatform.snsClickHandler       = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController)
//    {
//        NSLog(@"点击美拍");
//        [MPShareSDK shareVideoAtPathToMeiPai:[NSURL URLWithString:_url]];
//    };
    
    
//    if([_contentids isValid])
//    {
//        UMSocialSnsPlatform *sinaPlatform   = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToEmail];
//        sinaPlatform.bigImageName           = _isCollected ? @"ico_share_collection_cancel" : @"ico_share_collection";
//        sinaPlatform.displayName            = _isCollected ? @"取消收藏" : @"收藏";
//        sinaPlatform.snsClickHandler        = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController)
//        {
//            NSLog(@"点击收藏");
//            blockShareResult(UMShareToEmail , YES , nil);
//        };
//    }
    
    NSArray *arraySns =@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone];
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:_url];
    [UMSocialData defaultData].extConfig.title                    = _title;
    [UMSocialData defaultData].extConfig.qqData.title             = _title;
    [UMSocialData defaultData].extConfig.qzoneData.title          = _title;
    [UMSocialData defaultData].extConfig.wechatSessionData.title  = _title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = _title;

    [UMSocialData defaultData].extConfig.qqData.url               = _url;
    [UMSocialData defaultData].extConfig.qzoneData.url            = _url;
    [UMSocialData defaultData].extConfig.wechatSessionData.url    = _url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url   = _url;
    
    [UMSocialData defaultData].extConfig.sinaData.shareText       = [NSString stringWithFormat:@"%@  %@" , _title , _url];
    [UMSocialData defaultData].extConfig.sinaData.urlResource     = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_url];
    [UMSocialData defaultData].extConfig.sinaData.shareImage      = _image;
    [UMSocialSnsService presentSnsIconSheetView:[self getPresentedViewController]
                                         appKey:keyUMeng
                                      shareText:_content
                                     shareImage:_image
                                shareToSnsNames:arraySns
                                       delegate:self];
}

- (void)notifyMeiPaiShare:(NSNotification *)_notification
{
    NSNumber *isSuccess = [_notification.userInfo objectForKey:@"key_success"];
    blockShareResult(UMShareToSms , isSuccess.boolValue , nil);
}

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC     = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

//分享成功的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        if([m_contentids isValid])
        {
            [ABAddShareModel requestAddShare:m_contentids block:^(NSDictionary *resultObject) {
            } failure:^(NSError *requestErr) {
            }];
        }
        
        blockShareResult([[response.data allKeys] objectAtIndex:0] , YES , nil);
    }
    else
    {
        blockShareResult(nil , NO , response.error);
    }
}

- (WMPlayer *)getPlayer:(CGRect)_frame videoURLStr:(NSString *)_url
{
    if(ui_player)
    {
        [self releaseWMPlayer];
    }
    
    if(!ui_player)
    {
        ui_player = [[WMPlayer alloc]initWithFrame:_frame videoURLStr:_url videoTitleStr:nil];
    }
    return ui_player;
}

-(void)releaseWMPlayer
{
    if(!ui_player) return;
    
    [ui_player.player.currentItem cancelPendingSeeks];
    [ui_player.player.currentItem.asset cancelLoading];
    [ui_player.player pause];
    [ui_player removeFromSuperview];
    [ui_player.playerLayer removeFromSuperlayer];
    [ui_player.player replaceCurrentItemWithPlayerItem:nil];
    ui_player               = nil;
    ui_player.player        = nil;
    ui_player.currentItem   = nil;
    ui_player.playOrPauseBtn= nil;
    ui_player.playerLayer   = nil;
}

-(void)pauseWMPlayer:(NSNotification *)_notification
{
    if(!ui_player) return;
    
    [ui_player.player.currentItem cancelPendingSeeks];
    [ui_player.player.currentItem.asset cancelLoading];
    [ui_player.player pause];
}


@end
