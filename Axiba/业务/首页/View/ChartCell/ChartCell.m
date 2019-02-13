//
//  ChartCell.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartCell.h"
#import "ChartContentView.h"
//#import "UIImage+TintColor.h"

@interface ChartCell()<ChartContentViewDelegate>
@property (nonatomic,strong) UIImageView    *icon;
@property (nonatomic,strong) UILabel        *labelName;
@property (nonatomic,strong) UILabel        *labelTime;
@property (nonatomic,strong) UIButton        *reply_btn;


@property (nonatomic,strong) ChartContentView *chartView;
@property (nonatomic,strong) ChartContentView *currentChartView;
@property (nonatomic,strong) NSString *contentStr;
@end

@implementation ChartCell

+ (NSString *)identifier
{
    return @"identifier_char_cell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ______WS();
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self.contentView addSubview:_effectView];
        [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wSelf.contentView.mas_top).offset(0);
            make.bottom.equalTo(wSelf.contentView.mas_bottom).offset(0);
            make.right.equalTo(wSelf.contentView.mas_right).offset(0);
            make.left.equalTo(wSelf.contentView.mas_left).offset(0);
        }];
        self.selectionStyle              = UITableViewCellSelectionStyleNone;
        self.backgroundColor             = [UIColor clearColor];
        self.contentView.backgroundColor             = [UIColor clearColor];
         self.icon                        = [[UIImageView alloc]init];
        self.icon.userInteractionEnabled = YES;
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 20;
        [self.contentView addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView).offset(10);
            make.top.equalTo(wSelf.contentView.mas_top).offset(20);
            make.width.height.offset(40);
        }];
        
        
        self.labelName                   = [[UILabel alloc]init];
        self.labelName.textColor         = [UIColor whiteColor];
        self.labelName.font              = Font_Chinease_Normal(13);
        [self.contentView addSubview:self.labelName];
        [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.icon.mas_right).offset(7);
            make.top.equalTo(wSelf.icon.mas_top).offset(0);
            make.right.equalTo(wSelf.contentView.mas_right).offset(0);
            make.height.offset(16);
        }];
        
        
        self.like_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.like_btn addTarget:self action:@selector(likeCommtentAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.like_btn];
        [self.like_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf.labelName);
            make.right.equalTo(wSelf.contentView.mas_right).offset(-15);
            make.width.height.offset(14);
        }];
        
        
        self.like_lab                   = [[UILabel alloc]init];
        self.like_lab.font              = Font_Chinease_Normal(10);
        self.like_lab.textAlignment     = NSTextAlignmentRight;
        self.like_lab.textColor         = [UIColor whiteColor];

//        self.like_lab.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.like_lab];
        [self.like_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf.labelName);
            make.right.equalTo(wSelf.like_btn.mas_left).offset(-2);
            make.height.offset(14);
            make.width.offset(60);
        }];
        
        
        self.chartView                   = [[ChartContentView alloc]initWithFrame:CGRectZero];
        self.chartView.delegate          = self;
        [self.contentView addSubview:self.chartView];
//        [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(wSelf.labelName.mas_bottom).offset(10);
//            make.left.equalTo(wSelf.labelName.mas_left).offset(0);
//            make.height.offset(13);
//            make.right.equalTo(wSelf.contentView.mas_right).offset(0);
//        }];
//        
        
        self.reply_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.reply_btn setTitle:@"回复" forState:(UIControlStateNormal)];
        [self.reply_btn setTitleColor:RGB(179, 179, 179) forState:(UIControlStateNormal)];
        [self.reply_btn addTarget:self action:@selector(replyAction) forControlEvents:(UIControlEventTouchUpInside)];
        self.reply_btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.reply_btn];

        
        self.labelTime                   = [[UILabel alloc]init];
        self.labelTime.textColor         = [UIColor grayColor];
        self.labelTime.font              = Font_Chinease_Normal(11);
        self.labelTime.textAlignment     = NSTextAlignmentLeft;
//        self.labelTime.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.labelTime];

        
        //为icon 添加点击事件,同时注销在其上面的其他点击事件
        UITapGestureRecognizer *gesUser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPressIcon:)];
        [self.icon addGestureRecognizer:gesUser];
        for(UIGestureRecognizer *gestureTemp in self.gestureRecognizers)
        {
            [gesUser requireGestureRecognizerToFail:gestureTemp];
        }
    }
    return self;
}



-(void)setCellFrame:(ChartCellFrame *)cellFrame
{
    ______WS();
    _cellFrame  = cellFrame;
    ChartMessage *chartMessage    = cellFrame.chartMessage;
    self.chartMessageN = chartMessage;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:chartMessage.icon] placeholderImage:[UIImage imageNamed:@"icon_need_head"]];
    self.labelName.text           = chartMessage.name;
    self.labelTime.text           = chartMessage.time;
    if (chartMessage.commentModel.praiseCount) {
        self.like_lab.text = [NSString stringWithFormat:@"%@",chartMessage.commentModel.praiseCount];
    }else{
        self.like_lab.text = @"0";
    }
    [self.like_btn setImage:[UIImage imageNamed:([cellFrame.chartMessage.commentModel.flag integerValue] != 0)? @"omo_dianzan_finsh":@"omo_dianzan_new"] forState:(UIControlStateNormal)];
    
    self.chartView.chartMessage   = chartMessage;
    [self setBackGroundImageViewImage:self.chartView from:@"ico_chatfrom_bg_normal.png" to:@"ico_chatto_bg_normal.png"];
//    self.chartView.frame          = cellFrame.chartViewRect;
    
    NSString *message = [chartMessage.otherInfo isValid] ? [NSString stringWithFormat:@"%@%@" , chartMessage.otherInfo , chartMessage.content] : chartMessage.content;
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:message];
    [attrText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,message.length)];
    if([chartMessage.otherInfo isValid])
    {
        [attrText addAttribute:NSForegroundColorAttributeName value:RGB(25, 209, 74) range:NSMakeRange(0,chartMessage.otherInfo.length)];
    }
    self.chartView.contentLabel.attributedText  = attrText;
    CGSize maximumLabelSize = CGSizeMake(kTPScreenWidth - 60, 9999);//labelsize的最大值
    CGSize expectSize = [self.chartView.contentLabel sizeThatFits:maximumLabelSize];
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.labelName.mas_bottom).offset(10);
        make.left.equalTo(wSelf.labelName.mas_left).offset(0);
        make.height.offset(expectSize.height);
        make.right.equalTo(wSelf.contentView.mas_right).offset(0);
    }];
    

    [self.chartView.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.chartView.mas_left).offset(0);
        make.bottom.equalTo(wSelf.chartView.mas_bottom).offset(0);
        make.right.equalTo(wSelf.chartView.mas_right).offset(0);
        make.top.equalTo(wSelf.chartView.mas_top).offset(0);
    }];
    
    [self.reply_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.chartView.mas_bottom).offset(10);
        make.left.equalTo(wSelf.labelName.mas_left).offset(0);
        make.height.offset(14);
        make.width.offset(25);
    }];
    
    [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.chartView.mas_bottom).offset(10);
        make.right.equalTo(wSelf.contentView.mas_right).offset(-15);
        make.height.offset(14);
        make.left.equalTo(wSelf.reply_btn.mas_right).offset(28);
    }];
    
}

-(void)setBackGroundImageViewImage:(ChartContentView *)chartView from:(NSString *)from to:(NSString *)to
{
    UIImage *normal = nil ;
    if(chartView.chartMessage.messageType == kMessageFrom){
        
//        normal = [[UIImage imageNamed:from] imageWithTintColor:Color_Red];
        normal = [UIImage imageNamed:from];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.5];
        
    }else if(chartView.chartMessage.messageType == kMessageTo){
        
        normal = [UIImage imageNamed:to];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.5];
    }
//    chartView.backImageView.image = normal;
}

-(void)chartContentViewLongPress:(ChartContentView *)chartView content:(NSString *)content
{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
    self.contentStr         = content;
    self.currentChartView   = chartView;
}

-(void)chartContentViewTapPress:(ChartContentView *)chartView content:(NSString *)content
{
    if([self.delegate respondsToSelector:@selector(chartCell:tapContent:)]){
    
        [self.delegate chartCell:self tapContent:content];
    }
}

-(void)menuShow:(UIMenuController *)menu
{
    [self setBackGroundImageViewImage:self.currentChartView from:@"ico_chatfrom_bg_focused.png" to:@"ico_chatto_bg_focused.png"];
}

-(void)menuHide:(UIMenuController *)menu
{
    [self setBackGroundImageViewImage:self.currentChartView from:@"ico_chatfrom_bg_normal.png" to:@"ico_chatto_bg_normal.png"];
    self.currentChartView = nil;
    [self resignFirstResponder];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(copy:)){

        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard]setString:self.contentStr];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)tapPressIcon:(UILongPressGestureRecognizer *)tapPress
{
    if([self.delegate respondsToSelector:@selector(chartCell:tapUser:)])
    {
        [self.delegate chartCell:self tapUser:self.chartView.chartMessage.commentModel];
    }
}


- (void)replyAction{
    if([self.delegate respondsToSelector:@selector(chartCell:tapContent:)]){
        
        [self.delegate chartCell:self tapContent:self.contentStr];
    }}

- (void)likeCommtentAction{
    
    NSDictionary *parDic = @{@"commentids":self.chartMessageN.commentModel.idv,
                             @"op":[NSNumber numberWithInteger:([self.chartMessageN.commentModel.flag integerValue] != 0) ? 2:1],
                             @"sessionid":[ABUser sharedInstance].abuser.user.sessionid
                             };
    [[DJHttpApi shareInstance] POST:urlPraiseOrUpdate dict:parDic succeed:^(id data) {
        NSLog(@"%@",data);
    } failure:^(NSError *error) {

    }];
    if ([self.chartMessageN.commentModel.flag integerValue] > 0) {
        self.chartMessageN.commentModel.flag = [NSNumber numberWithInteger:0];
        [self.like_btn setImage:[UIImage imageNamed:@"omo_dianzan_new"] forState:(UIControlStateNormal)];
        self.like_lab.text = [NSString stringWithFormat:@"%ld",[self.chartMessageN.commentModel.praiseCount integerValue] - 1];

    }else{
        self.chartMessageN.commentModel.flag = [NSNumber numberWithInteger:1];
        [self.like_btn setImage:[UIImage imageNamed:@"omo_dianzan_finsh"] forState:(UIControlStateNormal)];
        self.like_lab.text = [NSString stringWithFormat:@"%ld",[self.chartMessageN.commentModel.praiseCount integerValue] + 1];
    }
    if ([self.delegate respondsToSelector:@selector(chartCellChangeData: cellFlag:)]) {
        [self.delegate chartCellChangeData:self.indexpath cellFlag:self.chartMessageN.commentModel.flag];
    }
}

@end
