//
//  LoginView.h
//  Axiba
//
//  Created by bianKerMacBook on 16/10/12.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ABLoginViewType) {
    ABLoginViewPhone,
    ABLoginViewPass,
    ABLoginViewPassSee,
    ABLoginViewtCaptcha,
    ABLoginViewNick
};
@interface LoginView : UIView


@property (nonatomic, assign) ABLoginViewType   type;
@property (nonatomic, strong) UILabel       *txt;
@property (nonatomic, strong) UIImageView       *icon;

@end
