//
//  AppDelegate.m
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "AppDelegate.h"
#import "JxbDebugTool.h"
#import "ABHomeVC.h"
#import "ABMineVC.h"
#import "ABMessageVC.h"
#import "ABHttpStubs.h"
#import "ABTheme.h"
#import "ABUpdatePannel.h"
#import "ABUpdateUserDataModel.h"
#import "TPLocationManager.h"
#import "ABHomeIndexModel.h"
#import "ABCollectionStateModel.h"
#import "ABCommonDataManager.h"
#import "CTCirclePageControl.h"
#import "ABEvaListModel.h"
#import "UMSocialTwitterHandler.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import <MPShareSDK/MPShareSDK.h>
#import "IQKeyboardManager.h"
#import "UIView+Toast.h"
#import "XHLaunchAd.h"
#import "Reachability.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import<CoreTelephony/CTCarrier.h>
#import "OpenUDID.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "JWLaunchAd.h"
#import "sys/utsname.h"
#import "LVHomeleftController.h"
#import <UserNotifications/UserNotifications.h>
#import "UMessage_Sdk_1.5.0a/UMessage.h"
#import "CTWebViewVC.h"

@interface AppDelegate ()<UIScrollViewDelegate , MPSDKProtocol,UNUserNotificationCenterDelegate>
{
    CTTelephonyNetworkInfo *phoneInfo;

}
@property (nonatomic, strong) UIPageControl* page;
@property (nonatomic, strong) NSString *ppiModel;
//@property (nonatomic, strong) NSMutableDictionary *listDIc;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[ABUser sharedInstance] getlogin];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
#if DEBUG
    [[JxbDebugTool shareInstance] enableDebugMode];
    [ABHttpStubs startStubs];
#endif
    
    CSToastStyle* style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    style.titleColor = HEXCOLOR(0x646464);
    style.messageColor = [UIColor whiteColor];
    style.titleFont = Font_Chinease_Normal(15);
    style.messageFont = Font_Chinease_Normal(15);
    [CSToastManager setSharedStyle:style];
    
    
    UMAnalyticsConfig* umconfig = [[UMAnalyticsConfig alloc] init];
    umconfig.appKey = keyUMeng;
    umconfig.secret = secretUMeng;
    [MobClick startWithConfigure:umconfig];
    [UMessage registerForRemoteNotifications];
    [UMessage startWithAppkey:keyUMeng launchOptions:launchOptions];
    
    [UMessage setAutoAlert:YES];
    
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [ABTheme initConfig];
    
    [self configUMSocial];
    
    [self getMoibelList:1 appkey:@"womoios"];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    [UMessage setLogEnabled:YES];
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){
        
        self.userInfo = userInfo;
    }

    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert)categories:nil];
    [application registerUserNotificationSettings:settings];
    
    [MobClick event:@"active_day_number"];
    [MobClick beginLogPageView:@"online_time"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    CTBaseNavVC *baseNavVC = [[CTBaseNavVC alloc] initWithRootViewController:[[ABHomeVC alloc] init]];
    LVHomeleftController  *leftCro = [[LVHomeleftController alloc] init];
    CTBaseNavVC *leftNav = [[CTBaseNavVC alloc] initWithRootViewController:leftCro];
    leftNav.navigationBar.hidden = YES;
    MMDrawerController *mmdVC = [[MMDrawerController alloc] initWithCenterViewController:baseNavVC leftDrawerViewController:leftNav];
    
    [mmdVC setShowsShadow:NO];//设置是否有阴影
    [mmdVC setShouldStretchDrawer:NO];//设置是否回弹效果
    [mmdVC setMaximumLeftDrawerWidth:kTPScreenWidth / 3 * 2];//最大距离
    [mmdVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmdVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [mmdVC setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        
    }];
    
    [self testInterface];
    [self.window makeKeyAndVisible];

    ______WS();
    [XHLaunchAd showWithAdFrame:CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight * 0.8) setAdImage:^(XHLaunchAd *launchAd) {
//        未检测到广告数据,启动页停留时间,默认3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
        launchAd.noDataDuration = 4;
;
        
        NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
        [[DJHttpApi shareInstance] POST:urlAdSever dict:par  succeed:^(id data) {
                //1.->显示启动广告(初始化方法)
            GuanggaoMoreModel *moreModel = [[GuanggaoMoreModel alloc] init];

            if ([data[@"rspObject"] isKindOfClass:[NSDictionary class]]) {
                [moreModel setValuesForKeysWithDictionary:data[@"rspObject"]];
                [[NSUserDefaults standardUserDefaults] setObject:data[@"rspObject"] forKey:@"admodel"];
                UIView *view = [UIView new];
                view.backgroundColor = [UIColor whiteColor];
                view.frame = CGRectMake(0, kTPScreenHeight * 0.8, kTPScreenWidth, kTPScreenHeight * 0.2);
                [launchAd.view addSubview:view];
                
                UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_icon_s"]];
                [view addSubview:imgv];
                [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view);
                    make.centerY.equalTo(view);
                    make.width.offset(102);
                    make.height.offset(40);
                }];
            }
                if ([moreModel.image isValid]) {
                    NSString *aisd = moreModel.ids;
                    NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
                    [repDic setValue:aisd forKey:@"aids"];
                    [repDic setValue:@"1" forKey:@"type"];
                    [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
                        NSLog(@"广告展示: %@",data);
                        [MobClick event:@"Start_ads_show_num"];
                    } failure:^(NSError *error) {
                        
                    }];
                    //2.->设置广告数据(数据源方法)
                    [launchAd setImageUrl:moreModel.image
                         duration:5 skipType:SkipTypeTimeText options:XHWebImageRefreshCached completed:^(UIImage *image, NSURL *url) {
                    
                         } click:^{
                             [repDic setObject:@"2" forKey:@"type"];
                             [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
                                 NSLog(@"广告点击: %@",data);
                                 [MobClick event:@"Start_ads_click_num"];
                                
                             } failure:^(NSError *error) {
                             }];
                             
                             CTWebViewVC* vc = [[CTWebViewVC alloc] init];
                             vc.url          = [NSURL URLWithString:moreModel.url];
                             vc.title        = moreModel.title;
                             vc.isPop        =   YES;
                             wSelf.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
                             
                         }];
                }else{}
        } failure:^(NSError *error) {
        }];
    } showFinish:^{
        //广告展示完成回调,设置window根控制器
        wSelf.window.rootViewController = mmdVC;

    }];
    
//
//    NSString* showpage = [[NSUserDefaults standardUserDefaults] objectForKey:@"showpage"];
//    if (![showpage isValid]) {
//        [self showPage];
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"showpage"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
   
    if ([ABUser isLogined]) {
        NSLog(@"%@",[[[[ABUser sharedInstance] abuser] user] ids]);
        //        NSString* type = [[NSUserDefaults standardUserDefaults] objectForKey:@"kuserthird"];
        [UMessage setAlias:[[[[ABUser sharedInstance] abuser] user] ids] type:@"UseID" response:nil];
        [self loadRedDot];
    }
    return YES;
}


- (void)loadRedDot {
    [ABEvaListModel getReddot:^(NSDictionary *resultObject) {
        if (!resultObject[@"rspObject"]) {
            NSInteger count = [resultObject[@"rspObject"][@"redDot"] integerValue];
            [[[ABUser sharedInstance] abuser] setRedDot:@(count)];
            [[NSNotificationCenter defaultCenter] postNotificationName:KCTNotityUnreadCount object:@(count)];
        }
    } failure:nil];
}


- (void)configUMSocial
{
    [UMSocialData setAppKey:keyUMeng]; 
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx95a204e5ad7f73b8" appSecret:@"20a4ab3ddeacbe6276c451f9d710c479" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1106582549" appKey:@"izjLFxGkfGW5Pdcz" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3670082856"
                                              secret:@"f7b3327e5dc1b4dc24bac25b6f848629"
                                         RedirectURL:@"http://www.bianker.cn"];
}



/*!
 @abstract 接口测试
 */
- (void)testInterface
{
    //收藏的测试数据 如果是视频则  ids NR201606220036  type 1   如果是频道  ids PD0052  type 2
    [ABCollectionStateModel requestCollectionState:@"1" collectedIds:@"NR201606220018" type:@"1" block:^(NSDictionary *resultObject)
    {
        
    } failure:^(NSError *requestErr) {
        
    }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MobClick endLogPageView:@"online_time"];

}

//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //震动
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [TPLocationManager startLocation];
    NSLog(@"enter applicationDidBecomeActive");
    
    [ABUpdateUserDataModel update:nil block:^(NSDictionary *resultObject)
     {
         ABUpdateUserDataModel* model = [[ABUpdateUserDataModel alloc] initWithDictionary:resultObject error:nil];
         if (model.rspCode.integerValue == 200)
         {
             [ABCommonDataManager updateClaissify:model];
         }
         
     } failure:^(NSError *requestErr) {
         
     }];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    NSLog(@"接收到了通知远程");
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [self loadRedDot];
    NSString* body = userInfo[@"body"];
    if ([body isValid]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"通知" message:body delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [UMessage registerDeviceToken:deviceToken];
    
    [ABUpdateUserDataModel update:token block:^(NSDictionary *resultObject)
    {
        ABUpdateUserDataModel* model = [[ABUpdateUserDataModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200)
        {
            [ABCommonDataManager updateClaissify:model];
        }
    } failure:^(NSError *requestErr)
    {
        TOAST_ERROR([CTTools rootViewController], requestErr);
    }];
} 

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [ABUpdateUserDataModel update:nil block:^(NSDictionary *resultObject)
    {
        ABUpdateUserDataModel* model = [[ABUpdateUserDataModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200)
        {
            [ABCommonDataManager updateClaissify:model];
        }
        
    } failure:^(NSError *requestErr) {
        TOAST_ERROR([CTTools rootViewController], requestErr);
    }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    [MPShareSDK handleOpenURL:url delegate:self];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options {
    return [UMSocialSnsService handleOpenURL:url];
}

/**
 *  分享到美拍是否成功
 *
 *  @param success 是否成功
 */
- (void)shareToMeipaiDidSucceed:(BOOL)success
{
    NSNumber *isSuccess = [NSNumber numberWithBool:success];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notifycation_Share_Meipai object:nil userInfo:@{@"key_success":isSuccess}];
}

- (void)showPage {
    UIScrollView* sc = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sc.contentSize = CGSizeMake(kTPScreenWidth*4, kTPScreenHeight);
    sc.backgroundColor = [UIColor clearColor];
    sc.showsVerticalScrollIndicator = false;
    sc.showsHorizontalScrollIndicator = false;
    sc.pagingEnabled = YES;
    sc.bounces = false;
    sc.delegate = self;
    [[[CTTools rootViewController] view] addSubview:sc];
    
    UIImageView* img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight)];
    img1.image = [UIImage imageNamed:@"page1"];
    [sc addSubview:img1];
    
    UIImageView* img2 = [[UIImageView alloc] initWithFrame:CGRectMake(kTPScreenWidth, 0, kTPScreenWidth, kTPScreenHeight)];
    img2.image = [UIImage imageNamed:@"page2"];
    [sc addSubview:img2];
    
    UIImageView* img3 = [[UIImageView alloc] initWithFrame:CGRectMake(kTPScreenWidth+kTPScreenWidth, 0, kTPScreenWidth, kTPScreenHeight)];
    img3.userInteractionEnabled = true;
    img3.image = [UIImage imageNamed:@"page3"];
    [sc addSubview:img3];

    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kTPScreenHeight - 36, kTPScreenWidth, 12)];
    self.page.currentPage = 0;
    self.page.numberOfPages = 3;
    self.page.currentPageIndicatorTintColor = HEXCOLOR(0xd69700);
    self.page.pageIndicatorTintColor = HEXCOLOR(0xe2c32e);
    [[[CTTools rootViewController] view] addSubview:self.page];
   
    
    ______WS();
    UIButton* btnOK = [[UIButton alloc] initWithFrame:CGRectMake(kTPScreenWidth / 2 - 67, kTPScreenHeight - 122, 134, 44)];
    btnOK.userInteractionEnabled = true;
    [btnOK setTitle:@"进入APP" forState:UIControlStateNormal];
    [btnOK setTitleColor:HEXCOLOR(0x807126) forState:UIControlStateNormal];
    btnOK.titleLabel.font = Font_Chinease_Blod(18.5);
    btnOK.layer.borderColor = HEXCOLOR(0x807126).CGColor;
    btnOK.layer.borderWidth = 1;
    btnOK.layer.cornerRadius = 22;
    [img3 addSubview:btnOK];
    [[btnOK rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [UIView animateWithDuration:0.35 animations:^{
            sc.x = -kTPScreenWidth;
        } completion:^(BOOL finished) {
            [sc removeFromSuperview];
            [wSelf.page removeFromSuperview];
        }];
    }];

    [RACObserve(sc, contentOffset) subscribeNext:^(NSValue *x) {
        CGPoint p = x.CGPointValue;
        if (p.x < kTPScreenWidth) {
            wSelf.page.currentPage = 0;
        }
        else if (p.x < kTPScreenWidth*2) {
            wSelf.page.currentPage = 1;
        }
        else {
            wSelf.page.currentPage = 2;
        }
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    if (x >  2.5*kTPScreenWidth) {
        [scrollView removeFromSuperview];
        [self.page removeFromSuperview];
    }
}

#pragma mark - 获取网络状态
- (NSString *)internetStatus {
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [NSArray array];
    
    if ([[app valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        
        children = [[[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        
    } else {
        
        children = [[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
        
    }
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wf";
                    break;
                default:
                    break;
                }
            }
        }
    }
    return state;

}

#pragma mark - 获取ip地址

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}




- (void)getMoibelList:(NSInteger)adType appkey:(NSString *)appkey{
    //     获取用户SIM卡信息
    phoneInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *carrier = @"";
    if ([phoneInfo.subscriberCellularProvider.carrierName isEqualToString:@"中国移动"]) {
        carrier = @"0";
        
    }else if ([phoneInfo.subscriberCellularProvider.carrierName isEqualToString:@"中国联通"]){
        carrier = @"1";
        
    }else if ([phoneInfo.subscriberCellularProvider.carrierName isEqualToString:@"中国电信"]){
        carrier = @"2";
        
    }else{
        carrier = @"0";
    }
    
    
    phoneInfo.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier * carrier)
    {
        // 当用户更换 SIM 卡时会调用这个回调
    };
    
    // IMSI拼接获取
    NSString *imsiStr = [NSString stringWithFormat:@"%@%@",phoneInfo.subscriberCellularProvider.mobileCountryCode,phoneInfo.subscriberCellularProvider.mobileNetworkCode];
    // 获取唯一标识,苹果私有API获取IMEI号,可能会改变
    NSString *identifierForAd = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // 系统版本
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    // 获取应用的版本
    //    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    // 获取数据连接状态/网络类型
    NSString *interNet = [self internetStatus];
//    NSString *ua = [self getUA];
    NSString *udid = [OpenUDID value];
    NSString *mdIphone = [self deviceVersion];
    NSNumber *type =[NSNumber numberWithInteger:adType];
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleIdentifier"];
//    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // 屏幕宽,高
//    NSString *dvw = [NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].bounds.size.width];
//    NSString *dvh = [NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].bounds.size.height];
    
    NSLog(@"%@",self.ppiModel);
    
    if (!self.ppiModel) {
        self.ppiModel= @"401";
    }
    NSDictionary *par = @{@"brd":@"Apple",
                            @"carrier":carrier,
                            @"density":self.ppiModel,
                            @"imei":identifierForAd,
                           @"imsi":imsiStr,
                           @"mc":@"02:00:00:00:00:00",
                           @"nt":interNet,
                           @"openudid":udid ,
                           @"os":@"iOS",
                           @"md":mdIphone,
                           @"ovs":phoneVersion,
                           @"position":type,};
    
    [[NSUserDefaults standardUserDefaults] setObject:par forKey:@"adDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


// 获取手机型号
- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone5,1"]){
        self.ppiModel = @"326";
        return @"iPhone 5";
    }
    if ([deviceString isEqualToString:@"iPhone5,2"])
    {
        self.ppiModel = @"326";
        return @"iPhone 5";
    }
    
    if ([deviceString isEqualToString:@"iPhone5,3"]){
        self.ppiModel = @"326";
        
        return @"iPhone 5C";
        
    }
    if ([deviceString isEqualToString:@"iPhone5,4"])
    {
        self.ppiModel = @"326";
        
        return @"iPhone 5C";
        
    }
    if ([deviceString isEqualToString:@"iPhone6,1"]){
        self.ppiModel = @"326";
        return @"iPhone 5S";
        
    }
    
    if ([deviceString isEqualToString:@"iPhone6,2"]){
        self.ppiModel = @"326";
        return @"iPhone 5S";
    }
    
    if ([deviceString isEqualToString:@"iPhone7,1"]){
        self.ppiModel = @"326";
        return @"iPhone 6";
    }
    
    if ([deviceString isEqualToString:@"iPhone7,2"]){
        self.ppiModel = @"401";
        return @"iPhone 6";
        
    }
    
    if ([deviceString isEqualToString:@"iPhone8,1"]){
        self.ppiModel = @"326";
        return @"iPhone 6s";
        
    }
    if ([deviceString isEqualToString:@"iPhone8,2"]){
        self.ppiModel = @"401";
        return @"iPhone 6s Plus";
        
    }
    if ([deviceString isEqualToString:@"iPhone8,4"]){
        self.ppiModel = @"326";
        return @"iPhone SE";
        
    }
    
    if ([deviceString isEqualToString:@"iPhone8,5"]){
        self.ppiModel = @"326";
        return @"iPhone SE";
        
    }
    
    if ([deviceString isEqualToString:@"iPhone8,3"]){
        self.ppiModel = @"326";
        return @"iPhone SE";
        
    }
    
    if ([deviceString isEqualToString:@"iPhone9,1"]){
        self.ppiModel = @"326";
        return @"iPhone 7";
        
    }
    if ([deviceString isEqualToString:@"iPhone9,1"]){
        self.ppiModel = @"401";
        return @"iPhone 7s Plus";
    }
    
    if ([deviceString isEqualToString:@"iPhone9,2"]){
        self.ppiModel = @"401";
        return @"iPhone 7s Plus";
    }
    
    if ([deviceString isEqualToString:@"iPhone9,2"]){
        self.ppiModel = @"458";
        return @"iPhone X";
    }
    
    return deviceString;
}


@end
