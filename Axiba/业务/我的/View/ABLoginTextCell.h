//
//  ABLoginTextCell.h
//  Axiba
//
//  Created by Peter on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ABLoginTextType) {
    ABLoginTextPhone,
    ABLoginTextPass,
    ABLoginTextPassSee,
    ABLoginTextCaptcha,
    ABLoginTextNick
};

@interface ABLoginTextCell : UIView
@property (nonatomic, assign) ABLoginTextType   type;
@property (nonatomic, strong) ABTextField       *txt;
@property (nonatomic, strong) UIImageView       *icon2;

@end
