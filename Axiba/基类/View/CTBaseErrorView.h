//
//  CTBaseErrorView.h
//  Tripinsiders
//
//  Created by Peter on 16/4/18.
//  Copyright © 2016年 Tripinsiders. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTBaseErrorDelegate <NSObject>
@optional
- (void)reloadView;
@end

@interface CTBaseErrorView : UIView
@property (nonatomic, weak) id<CTBaseErrorDelegate> delegate;
@end
