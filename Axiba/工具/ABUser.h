//
//  ABUser.h
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABLoginModel.h"

@interface ABUser : NSObject
@property (nonatomic, strong) ABLoginResult  *abuser;

+ (BOOL)isLogined;
+ (BOOL)isLoginedAndPresent;



+ (void)presentLogined;

+ (instancetype)sharedInstance;

- (void)saveUser:(NSDictionary*)dicUser;
- (void)syncUser;
- (void)getlogin;
- (void)logout;
@end
