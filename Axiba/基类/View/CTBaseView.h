//
//  CTBaseView.h
//  Tripinsiders
//
//  Created by Peter on 16/4/25.
//  Copyright © 2016年 Tripinsiders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTBaseView : UIView

- (void)reloadView;
- (void)showError:(NSError*)error;
- (void)hideError;
@end
