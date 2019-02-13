//
//  CTBaseTabVC.h
//  JXBFramework
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/3/22.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTBaseVC.h"

@interface CTBaseTabItem : NSObject
@property(nonatomic,copy)NSString                       *title;
@property(nonatomic,copy)NSString                       *selectedImage;
@property(nonatomic,copy)NSString                       *unselectedImage;
@property(nonatomic,strong)UIViewController             *rootVC;
@end

@interface CTBaseTabVC : UITabBarController
- (CTBaseTabVC*)initWithItems:(NSArray*)items;
@end
