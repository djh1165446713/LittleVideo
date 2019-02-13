//
//  CTRowEditVC.h
//  TP
//
//  Created by Peter on 15/10/8.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "CTBaseVC.h"

@interface CTRowEditVC : CTBaseVC
@property(nonatomic,assign)BOOL         bHideBackBtn;
@property(nonatomic,copy)NSString       *keyName;
@property(nonatomic,copy)NSString       *placeholder;
@property(nonatomic,copy)NSString       *tipMsg;
@property(nonatomic,copy)NSString       *text;
@property(nonatomic,assign)NSInteger    maxLength;
@property(nonatomic,copy)void (^completeBlock)(NSString* keyname,NSString* value);
@end
