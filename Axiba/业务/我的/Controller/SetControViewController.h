//
//  SetControViewController.h
//  Axiba
//
//  Created by bianKerMacBook on 16/10/12.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setStringDelegat<NSObject>

- (void)sendStr:(NSString *)str1 str2:(NSString *)str2;

@end

@interface SetControViewController : CTBaseVC

@property (nonatomic, strong) id<setStringDelegat> abDelegate;

@end
