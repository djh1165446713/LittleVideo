//
//  CTBaseView.m
//  Tripinsiders
//
//  Created by Peter on 16/4/25.
//  Copyright © 2016年 Tripinsiders. All rights reserved.
//

#import "CTBaseView.h"
#import "CTBaseErrorView.h"

@interface CTBaseView()<CTBaseErrorDelegate>
@property (nonatomic, strong) CTBaseErrorView *vError;
@end

@implementation CTBaseView

- (void)dealloc {
    NSLog(@"%@ dealloc success", NSStringFromClass([self class]));
}

#pragma mark - ErrorView
- (CTBaseErrorView*)vError {
    if (!_vError) {
        _vError = [[CTBaseErrorView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _vError.delegate = self;
    }
    return _vError;
}

- (void)showError:(NSError*)error {
//    [self.vError setErrorMsg:error];
    [self addSubview:self.vError];
}

- (void)hideError {
    if (self.vError) {
        [self.vError removeFromSuperview];
        self.vError = nil;
    }
}

- (void)reloadView {
    NSLog(@"%@ reloadview is not implementation",NSStringFromClass([self class]));
}
@end
