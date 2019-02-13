//
//  CTBaseVC.h
//  TP
//
//  Created by Peter on 15/9/11.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CTBaseVC : UIViewController

#pragma mark UI related properties & functions
@property(nonatomic,  assign) BOOL isShowing;
@property (nonatomic, assign) BOOL showBackBtn;
@property (nonatomic, assign) BOOL shareFriend;
@property (nonatomic,   copy) NSString *itemTitle;
@property (nonatomic,   copy) NSString *requestURL;
@property (nonatomic, strong) UIButton *navLeftBtn;
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, assign) BOOL bDisableGesture;//是否禁用右滑回退
@property (nonatomic, assign) BOOL bSupportDelete;//默认NO，tableview左滑删除需要设置yes

//screnn name
@property (nonatomic, strong) NSString  *screenName;

/**
 *  控制器即将释放处理
 */
- (void)p_dealloc;

/**y7
 *  NavBar上面的左右按钮
 *
 *  @param 正常图片
 *  @param 点击图片
 *  @param 标题
 *  @param 点击事件
 */
- (void)actionBack:(void(^)())btnClickBlock;
- (void)actionCustomLeftBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                  title:(NSString *)title
                                 action:(void(^)())btnClickBlock;
- (void)actionCustomRightBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                   title:(NSString *)title
                                  action:(void(^)())btnClickBlock;


/**
 *  加载中视图
 */
- (void)showLoading;
- (void)showLoading:(CGFloat)y;
- (void)hideLoading:(BOOL)bAnimated;

/**
 *  空视图
 */
- (void)showEmpty:(NSString*)text;
- (void)showEmpty:(NSString*)text y:(CGFloat)y;
- (void)hideEmpty;

/**
 *  错误视图
 *
 */
- (void)reloadView;
- (void)showError;
- (void)hideError;

@end
