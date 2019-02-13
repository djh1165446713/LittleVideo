//
//  FullShareView.h
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/2.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullShareView : UIView
@property (nonatomic, strong) UIImageView *back_bigview;     // 大背景
@property (nonatomic, strong) UIView *line_Top;
@property (nonatomic, strong) UIView *line_bottom;
@property (nonatomic, strong) UILabel *share_titlt;
@property (nonatomic, strong) UIButton *share_WX;
@property (nonatomic, strong) UIButton *share_PYQ;
@property (nonatomic, strong) UIButton *share_QQ;
@property (nonatomic, strong) UIButton *share_QQozoe;
@property (nonatomic, strong) UIButton *share_WB;
@property (nonatomic, strong) UIButton *cancel_btn;
@property (nonatomic, strong)UILabel *summy_lab;
@property (nonatomic, strong) NSString *typeShare;
@property (nonatomic, strong) NSString *from;

@property (nonatomic, strong) UIButton *exit_btn;       // 全屏退出按钮
@end
