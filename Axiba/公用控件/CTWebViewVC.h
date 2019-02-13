//
//  CTWebViewVC.h
//  TP
//
//  Created by Peter on 15/9/25.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "CTBaseVC.h"

@interface CTWebViewVC : CTBaseVC
@property(nonatomic,assign)BOOL  bLocal;
@property(nonatomic,strong)NSURL *url;
@property(nonatomic,assign)BOOL isPop;

@end
