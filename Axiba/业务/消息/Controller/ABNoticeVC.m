//
//  ABNoticeVC.m
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABNoticeVC.h"

@interface ABNoticeVC ()

@end

@implementation ABNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知";
    self.showBackBtn = YES;
    [self showEmpty:nil];
}

@end
