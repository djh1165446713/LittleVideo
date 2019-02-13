//
//  CTLoadingView.m
//  TP
//
//  Created by Peter on 15/9/13.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "CTLoadingView.h"
#import "UIImageView+PlayGIF.h"
#import "ABCommonDataManager.h"

@interface CTLoadingView()
//@property (nonatomic , strong) UIImageView *ui_imvLoading;
@property (nonatomic , strong) UIActivityIndicatorView *ui_activity;
@end

@implementation CTLoadingView
@synthesize ui_activity;

- (void)dealloc {
    NSLog(@"CTLoadingView dealloc");
}

- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
    
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    { 
//        ui_imvLoading                   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120*kTPScreenScale, 260*kTPScreenScale)];
//        ui_imvLoading.center            = CGPointMake(CGRectGetWidth(self.frame)/2, (CGRectGetHeight(self.frame)-64)/2);
//        ui_imvLoading.animationImages   = [ABCommonDataManager getLoadingImages];
//        [self addSubview:ui_imvLoading];
//        [ui_imvLoading startAnimating];
        
        ui_activity                     = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        ui_activity.center              = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        ui_activity.hidesWhenStopped    = YES;
        [self addSubview:ui_activity];
        [ui_activity startAnimating];
        
    }
    return self;
}

- (void)removeFromSuperview
{
    [ui_activity stopAnimating];
    [super removeFromSuperview];
}

@end
