//
//  ChatTableView.h
//  Axiba
//
//  Created by bianKerMacBook on 2017/4/20.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABContentsModel.h"
@interface ChatTableView : UIView

@property (nonatomic, strong)UITableView *chatTableView;

@property (nonatomic, strong)NSMutableArray *dataChat;
@property (strong,nonatomic) UIView         *ui_viewReview;
@property (strong,nonatomic) UITextField    *ui_tfReview;

@property (nonatomic, strong) UIView *headViewTab_Chat;
@property (nonatomic, strong) UIImageView *headIcon_Img;
@property (nonatomic, strong) UILabel *speakTextFile;
@property (nonatomic, strong) UIImageView *closeChaCha_btn;
@property (nonatomic, strong) UIView *lineView_ie;
@property (nonatomic, strong) ABContentResult *m_modelContent;

@property (assign,nonatomic) NSInteger      m_iPage;
@property (nonatomic, strong) UIView *clickView;

@property (nonatomic, strong)UIVisualEffectView *effectView;        //模糊


@end
