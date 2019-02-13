//
//  ABConstant.h
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#define ABTableHeight   44

#define clientVersion   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define HEXCOLORA(rgbValue, a)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:a]
#define HEXCOLOR(rgbValue)      HEXCOLORA(rgbValue, 1.0)
#define RGB(r,g,b)          [   UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.]

#define  ______WS()         __weak __typeof(&*self) wSelf = self
#define  ______SS()         __strong __typeof(&*wSelf) sSelf = wSelf

#define kTPScreenWidth              [UIScreen mainScreen].bounds.size.width
#define kTPScreenHeight             [UIScreen mainScreen].bounds.size.height
#define kTPScreenScale              [[UIScreen mainScreen] bounds].size.width / 320.0f
#define kTPNavBarHeight             self.navigationController.navigationBar.frame.size.height

#define kLoginUser                  @"kLoginUser"

#define KCTNotityUnreadCount        @"KCTNotityUnreadCount"
#define KCTNotityLogout             @"KCTNotityLogout"

#define TOAST_Process               [[[CTTools currentRootController] view] makeToastActivity:CSToastPositionCenter]
#define TOAST_Hide                  [[[CTTools currentRootController] view] hideToastActivity]
#define TOAST_SUCCESS(x)            TOAST_Hide;[[[CTTools currentRootController] view] makeToast:x duration:2 position:CSToastPositionCenter]
#define TOAST_FAILURE(x)            TOAST_Hide;[[[CTTools currentRootController] view] makeToast:x duration:2 position:CSToastPositionCenter]
#define TOAST_ERROR(this,x)         TOAST_Hide;[[[CTTools currentRootController] view] makeToast:[NSString stringWithFormat:@"%@",x.userInfo[NSLocalizedDescriptionKey]] duration:2 position:CSToastPositionCenter]


#define CTLineSpace     5

#define colorMainText       RGB(255,214,0)
#define colorNormalText     HEXCOLOR(0xa2a2a2)
#define colorMain           HEXCOLOR(0xffd600)
#define colorMainDisable    HEXCOLORA(0xffd600,0.5)
#define colorMainBG         HEXCOLOR(0xe9e9e9)

#define Font_Chinease_Normal(_size)         [UIFont systemFontOfSize:_size]
#define Font_Chinease_Blod(_size)           [UIFont boldSystemFontOfSize:_size]

#define appQQGroup      @"541328474"

#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)



#define keyUMeng        @"5a4c3d41f43e4833f6000104"
#define secretUMeng        @"84iotskotbwqertaipexrubrlopbfw5t"

//通知部分
#define Notifycation_Main_Fun       @"notify_main_fun"
#define Notifycation_Share_Meipai   @"notify_share_meipai"
#define Notifycation_Close_Video    @"notify_close_video"
#define Notifycation_Pause_Video    @"notify_pause_video"

