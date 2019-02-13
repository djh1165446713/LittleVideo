//
//  AppDelegate.h
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary* userInfo;

- (void)loadRedDot;
@end

