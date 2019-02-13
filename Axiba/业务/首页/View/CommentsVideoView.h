//
//  CommentsVideoView.h
//  Axiba
//
//  Created by bianKerMacBook on 2017/5/3.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsVideoView : UIView
@property (nonatomic, strong) UIImageView *closeImg_comm;
@property (nonatomic, strong) UIButton *send_btn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *line_view;
@property (nonatomic, strong) UITextView *textView_comm;
@property (nonatomic, strong) UIVisualEffectView *effectView;        //模糊

@end
