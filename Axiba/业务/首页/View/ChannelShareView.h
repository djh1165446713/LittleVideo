//
//  ChannelShareView.h
//  Axiba
//
//  Created by bianKerMacBook on 2017/12/22.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelShareView : UIView
@property (nonatomic, strong) UIView *back_view;        // 小背景
@property (nonatomic, strong) UIView *back_bigview;     // 大背景

@property (nonatomic, strong) UIView *line_Top;
@property (nonatomic, strong) UIView *line_bottom;
@property (nonatomic, strong) UILabel *share_titlt;
@property (nonatomic, strong) UIButton *share_WX;
@property (nonatomic, strong) UIButton *share_PYQ;
@property (nonatomic, strong) UIButton *share_QQ;
@property (nonatomic, strong) UIButton *share_QQozoe;
@property (nonatomic, strong) UIButton *share_WB;
@property (nonatomic, strong) UIVisualEffectView *effectView;        //模糊
@property (nonatomic, strong) UIButton *cancel_btn;
@property (nonatomic, strong)UILabel *summy_lab;
@property (nonatomic, strong) NSString *typeShare;
@property (nonatomic, strong) NSString *from;

@property (nonatomic, strong) UIButton *exit_btn;       // 全屏退出按钮

@end
