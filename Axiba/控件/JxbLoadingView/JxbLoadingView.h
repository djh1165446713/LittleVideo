//
//  JxbLoadingView.h
//  TP
//
//  Created by Peter on 15/11/27.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JxbLoadingView : UIView

typedef void (^JxbLoadingCompleteBlock) ();

@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CGFloat        lineWidth;
@property (nonatomic, copy  ) UIColor        *strokeColor;

- (void)startLoading;
- (void)endLoading;
- (void)finishSuccess:(JxbLoadingCompleteBlock)block;
- (void)finishFailure:(JxbLoadingCompleteBlock)block;
@end
