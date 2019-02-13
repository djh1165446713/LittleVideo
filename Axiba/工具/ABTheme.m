//
//  ABTheme.m
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABTheme.h"

@implementation ABTheme

+ (void)initConfig {
    [[UITextField appearance] setTintColor:colorMain];
    [[UITextView appearance] setTintColor:colorMain];
    [[UISearchBar appearance] setTintColor:colorMain];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //    CGRect rect = CGRectMake(0, 0, kTPScreenWidth, 0.5);
    //    UIGraphicsBeginImageContext(rect.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(context,CTColorOther.CGColor);
    //    CGContextFillRect(context, rect);
    //    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    [[UINavigationBar appearance] setShadowImage:img];
    
    // customise NavigationBar UI Effect
    [[UINavigationBar appearance] setBackgroundImage:[CTTools createImageWithColor:RGB(22, 21, 16)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];//
}

@end
