//
//  ABCommonData.m
//  Axiba
//
//  Created by Hu Zejiang on 16/6/13.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABCommonDataManager.h"
#import "UIImage+Resize.h"

@implementation ABCommonDataManager

//下拉刷新图片集合
+ (NSMutableArray *)getRefreshPullingImages
{
    NSMutableArray *arrayPulling = [[NSMutableArray alloc] init];
    for(int i = 0 ; i <= 20 ; i++)
    {
        NSString *strImageName  = [NSString stringWithFormat:@"working__000%02d" , i];
        UIImage *image          = [[UIImage imageNamed:strImageName] resizedImageToFitInSize:CGSizeMake(74, 74) scaleIfSmaller:YES];
        
        
        [arrayPulling addObject:image];
    }
    return arrayPulling;
}

+ (NSMutableArray *)getRefreshRefreshingImages
{
    NSMutableArray *arrayRefreshing = [NSMutableArray array];
    for (NSUInteger i = 15; i<=20; i++)
    {
        UIImage *image = [[UIImage imageNamed:[NSString stringWithFormat:@"working__000%02ld", i]] resizedImageToFitInSize:CGSizeMake(74, 74) scaleIfSmaller:YES];
        [arrayRefreshing addObject:image];
    }
    return arrayRefreshing;
}

//获取loading的动图
+ (NSMutableArray *)getLoadingImages
{
    NSMutableArray *arrayLoading = [NSMutableArray array];
    for (NSUInteger i = 0; i<=32; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"跳动_000%02ld", i]];
        [arrayLoading addObject:image];
    }
    return arrayLoading;
}


/*!
 @abstract 历史记录管理
 */
#define UD_KEY_SEARCH_KEYS @"ud_key_search_keys"
+ (NSMutableArray *)getSearchKeyHistory
{
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrayKeys       = [[NSMutableArray alloc] initWithArray:[userDefaults stringArrayForKey:UD_KEY_SEARCH_KEYS]];
    arrayKeys                       = (NSMutableArray *)[[arrayKeys reverseObjectEnumerator] allObjects];
    return arrayKeys;
}

+ (void)addSearchKey:(NSString *)_strKey
{
    if(![_strKey isValid]) return;
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrayKeys       = [[NSMutableArray alloc] initWithArray:[userDefaults stringArrayForKey:UD_KEY_SEARCH_KEYS]];
    if(!arrayKeys)
    {
        arrayKeys = [[NSMutableArray alloc] init];
    }
    
    if([arrayKeys containsObject:_strKey])
    {
        [arrayKeys removeObject:_strKey];
    }
    [arrayKeys addObject:_strKey];
    
    [userDefaults setObject:arrayKeys forKey:UD_KEY_SEARCH_KEYS];
    [userDefaults synchronize];
}

+ (void)removeSearchKey:(NSString *)_strKey
{
    if(![_strKey isValid]) return;
    
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    
    NSArray *arrayKeysOld           = [userDefaults stringArrayForKey:UD_KEY_SEARCH_KEYS];
    
    NSMutableArray *arrayKeysNew    = [[NSMutableArray alloc] initWithArray:arrayKeysOld];
    
    for(NSString *strTemp in arrayKeysOld)
    {
        if([strTemp isEqualToString:_strKey])
        {
            [arrayKeysNew removeObject:strTemp];
        }
    }
    
    [userDefaults setObject:arrayKeysNew forKey:UD_KEY_SEARCH_KEYS];
    
    [userDefaults synchronize];
}

/*!
 @abstract 判断是否存在，如果存在则返回YES，同时将该记录调整到末尾即最新搜索
 */
+ (BOOL)isContainSearchKey:(NSString *)_strKey
{
    if(![_strKey isValid]) return YES;
    
    BOOL isContain  = NO;
    NSUserDefaults *userDefaults    = [NSUserDefaults standardUserDefaults];
    NSArray *arrayKeysOld           = [userDefaults stringArrayForKey:UD_KEY_SEARCH_KEYS];
    NSMutableArray *arrayKeysNew    = [[NSMutableArray alloc] initWithArray:arrayKeysOld];
    
    for(NSString *strTemp in arrayKeysOld)
    {
        if([strTemp isEqualToString:_strKey])
        {
            isContain = YES;
            [arrayKeysNew removeObject:strTemp];
            [arrayKeysNew addObject:strTemp];
        }
    }
    
    [userDefaults setObject:arrayKeysNew forKey:UD_KEY_SEARCH_KEYS];
    [userDefaults synchronize];
    
    return isContain;
}

+ (void)removeAllSearchKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:UD_KEY_SEARCH_KEYS];
    [userDefaults synchronize];
}


#define UD_KEY_CLASSIFY @"ud_key_classify"
+ (void)updateClaissify:(ABUpdateUserDataModel *)_model
{
    if(!_model || ![_model.toJSONString isValid]) return;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_model.toJSONString forKey:UD_KEY_CLASSIFY];
    [userDefaults synchronize];
    
    NSNotification *notice = [NSNotification notificationWithName:Notifycation_Main_Fun object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

+ (ABUpdateUserDataModel *)getClassifyModel
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strModel  = [userDefaults objectForKey:UD_KEY_CLASSIFY];
    if(![strModel isValid])
    {
        ABUpdateUserDataModel *model = [[ABUpdateUserDataModel alloc] init];
        ABUpdateUserDataResult *modelResult     = [[ABUpdateUserDataResult alloc] init];
        
        ABClassifyDetailResult *modelClassify_A = [[ABClassifyDetailResult alloc] init];
        modelClassify_A.ids     = @"FL0002";
        modelClassify_A.name    = @"最新";
        
        ABClassifyDetailResult *modelClassify_B = [[ABClassifyDetailResult alloc] init];
        modelClassify_B.ids     = @"FL0001";
        modelClassify_B.name    = @"推荐";
        
        NSArray *arrayResult    = @[modelClassify_A , modelClassify_B];
        modelResult.classify    = arrayResult;
        model.rspObject = modelResult;
        return model;
    }
    
    JSONModelError* initError       = nil;
    ABUpdateUserDataModel *model    = [[ABUpdateUserDataModel alloc] initWithString:strModel error:&initError];
    return model;
}

@end
