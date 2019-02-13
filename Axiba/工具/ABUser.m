//
//  ABUser.m
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABUser.h"
#import "ABLoginVC.h"


@interface ABUser()

@end

@implementation ABUser

+ (BOOL)isLogined {
    return [[[[[ABUser sharedInstance] abuser] user] sessionid] isValid];
}

+ (BOOL)isLoginedAndPresent {
    if (![self isLogined]) {
        ABLoginVC *vc = [ABLoginVC new];
        CTBaseNavVC* nav = [[CTBaseNavVC alloc] initWithRootViewController:vc];
        [[CTTools rootViewController] presentViewController:nav animated:YES completion:nil];
        return false;
    }
    return true;
}




+ (void)presentLogined {
    ABLoginVC *vc = [ABLoginVC new];
    CTBaseNavVC* nav = [[CTBaseNavVC alloc] initWithRootViewController:vc];
    [[CTTools rootViewController] presentViewController:nav animated:YES completion:nil];
}

+ (instancetype)sharedInstance {
    static ABUser* user = nil;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        user = [[ABUser alloc] init];
    });
    return user;
}

- (void)saveUser:(NSDictionary*)dicUser {
    [[NSUserDefaults standardUserDefaults] setObject:dicUser forKey:kLoginUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.abuser = [[ABLoginResult alloc] initWithDictionary:dicUser error:nil];
}

- (void)syncUser {
    [self p_saveUser];
}

- (void)p_saveUser {
    NSDictionary* dic = [self.abuser toDictionary];
    [self saveUser:dic];
}

- (id)init {
    self = [super init];
    if (self) {
        [self getlogin];
    }
    return self;
}

- (void)getlogin {
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUser];
    self.abuser = [[ABLoginResult alloc] initWithDictionary:dic error:nil];
}

- (void)logout {
    self.abuser = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
