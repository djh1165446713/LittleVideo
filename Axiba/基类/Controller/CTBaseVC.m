//
//  CTBaseVC.m
//  TP
//
//  Created by Peter on 15/9/11.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "CTBaseVC.h"
#import "CTLoadingView.h"
#import "CTEmptyView.h"
#import <objc/runtime.h>
#import "CTBaseErrorView.h"


static char *btnClickAction;

@interface CTBaseVC()<CTBaseErrorDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) CTLoadingView   *vLoad;
@property (nonatomic, strong) CTEmptyView     *vEmpty;
@property (nonatomic, strong) CTBaseErrorView *vError;

@end

@implementation CTBaseVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString* className = NSStringFromClass([self class]);
    NSLog(@"%@ dealloc", className);
    [self p_dealloc];
}

- (void)p_dealloc {
    
}

- (id)init {
    if (self = [super init]) {
        if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)])
        {
            self.extendedLayoutIncludesOpaqueBars = NO;
        }
        if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        if([self respondsToSelector:@selector(setModalPresentationCapturesStatusBarAppearance:)])
        {
            self.modalPresentationCapturesStatusBarAppearance = YES;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(22, 21, 16);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isShowing = YES;
    
    NSInteger count = self.navigationController.viewControllers.count;
    self.navigationController.interactivePopGestureRecognizer.enabled = count > 1;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isShowing = NO;
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.navigationController.viewControllers.count > 1;
}

- (void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearMemory];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

#pragma mark -actionCustomLeftBtnWithNrlImage

- (void)actionBack:(void(^)())btnClickBlock {
    [self actionCustomLeftBtnWithNrlImage:@"icon_left" htlImage:@"icon_left" title:nil action:btnClickBlock];
}

- (void)actionCustomLeftBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                  title:(NSString *)title
                                 action:(void(^)())btnClickBlock {
    self.navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftBtn setBackgroundColor:[UIColor clearColor]];
    id block = ^{
        if (btnClickBlock!=NULL)
            btnClickBlock();
    };
    objc_setAssociatedObject(self.navLeftBtn, &btnClickAction, block, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navLeftBtn nrlImage:nrlImage htlImage:hltImage title:title];
    
    //把button放到view上，点击区域就不会那么的大
    UIView *backBtnView = [[UIView alloc] initWithFrame:self.navLeftBtn.bounds];
    
    
    backBtnView.bounds = CGRectOffset(backBtnView.bounds, 0, 0);
    [backBtnView addSubview:self.navLeftBtn];
    self.navLeftBtn.x = 10;
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    self.navigationItem.leftBarButtonItem = backBarBtn;
}

#pragma mark -actionCustomRightBtnWithNrlImage
- (void)actionCustomRightBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                   title:(NSString *)title
                                  action:(void(^)())btnClickBlock {
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    objc_setAssociatedObject(self.navRightBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navRightBtn nrlImage:nrlImage htlImage:hltImage title:title];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
}

#pragma mark -actionCustomNavBtn
#pragma mark -actionCustomNavBtn
- (void)actionCustomNavBtn:(UIButton *)btn nrlImage:(NSString *)nrlImage
                  htlImage:(NSString *)hltImage
                     title:(NSString *)title {
    [btn setImage:[UIImage imageNamed:nrlImage] forState:UIControlStateNormal];
    if (hltImage) {
        [btn setImage:[UIImage imageNamed:hltImage] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[UIImage imageNamed:nrlImage] forState:UIControlStateNormal];
    }
    if (title) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    
    [btn sizeToFit];
    [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -actionBtnClick
- (void)actionBtnClick:(UIButton *)btn {
    void (^btnClickBlock) (void) = objc_getAssociatedObject(btn, &btnClickAction);
    if (btnClickBlock!=NULL)
        btnClickBlock();
}

#pragma mark -getter or setter
- (void)setItemTitle:(NSString *)title {
    _itemTitle = title;
    [self.navigationItem setTitle:_itemTitle];
}

- (void)setShowBackBtn:(BOOL)showBack {
    __weak typeof(self) wSelf = self;
    if (showBack) {
        [self actionCustomLeftBtnWithNrlImage:@"icon_left" htlImage:@"icon_left" title:nil action:^{
            [wSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    else {
        [self actionCustomLeftBtnWithNrlImage:nil htlImage:nil title:nil action:nil];
    }
}

#pragma mark - Loading View
- (void)showLoading {
    if (!self.vLoad) {
        self.vLoad = [[CTLoadingView alloc] initWithFrame:self.view.bounds];
    }
    [self.view addSubview:self.vLoad];
}

- (void)showLoading:(CGFloat)y {
    if (!self.vLoad) {
        self.vLoad = [[CTLoadingView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    [self.view addSubview:self.vLoad];
}

- (void)hideLoading:(BOOL)bAnimated {
    if (!bAnimated) {
        if (self.vLoad)
            [self.vLoad removeFromSuperview];
        self.vLoad = nil;
    }
    else {
        ______WS();
        [UIView animateWithDuration:0.35 animations:^{
            wSelf.vLoad.alpha = 0;
        } completion:^(BOOL finished) {
            [wSelf.vLoad removeFromSuperview];
            wSelf.vLoad = nil;
        }];
    }
}

#pragma mark - Empty View
- (void)showEmpty:(NSString*)text {
    if (!self.vEmpty) {
        self.vEmpty = [[CTEmptyView alloc] initWithFrame:self.view.bounds];
    }
    if ([text isValid])
        [self.vEmpty setEmptyText:text];
    [self.view addSubview:self.vEmpty];
}

- (void)showEmpty:(NSString*)text y:(CGFloat)y {
    if (!self.vEmpty) {
        self.vEmpty = [[CTEmptyView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    [self.vEmpty setEmptyText:text];
    [self.view addSubview:self.vEmpty];
}

- (void)hideEmpty {
    if (self.vEmpty)
        [self.vEmpty removeFromSuperview];
}

#pragma mark - ErrorView
- (void)showError {
    if (!self.vError) {
        self.vError = [[CTBaseErrorView alloc] initWithFrame:self.view.bounds];
        self.vError.delegate = self;
    }
    [self.view addSubview:self.vError];
}

- (void)hideError {
    if (self.vError)
        [self.vError removeFromSuperview];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end
