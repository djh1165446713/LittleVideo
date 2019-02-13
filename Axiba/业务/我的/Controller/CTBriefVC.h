//
//  CTBriefVC.h
//  Axiba
//
//  Created by Peter on 16/6/11.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseVC.h"

typedef void(^CTBriefBlock)(NSString* city);

@interface CTBriefVC : CTBaseVC
@property (nonatomic, copy  ) CTBriefBlock  block;
@property (nonatomic, strong) NSString  *summary;
@end
