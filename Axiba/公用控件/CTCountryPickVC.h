//
//  CTCountryPickVC.h
//  TP
//
//  Created by Peter on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "CTBaseVC.h"

typedef void(^CTCountryBlock)(NSString* city);

@interface CTCountryPickVC : CTBaseVC
@property (nonatomic, strong) CTCountryBlock    block;
@end
