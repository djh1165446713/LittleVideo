//
//  CTCirclePageControl.h
//  Tripinsiders
//
//  Created by ZhouQian on 16/4/27.
//  Copyright © 2016年 Tripinsiders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCirclePageControl : UIPageControl
@property(nonatomic, retain) UIImage* activeImage;
@property(nonatomic, retain) UIImage* inactiveImage;


@property (nonatomic) CGFloat dotRadius;
- (instancetype)initWithFrame:(CGRect)frame dotRadius:(CGFloat)dotRadius;
@end
