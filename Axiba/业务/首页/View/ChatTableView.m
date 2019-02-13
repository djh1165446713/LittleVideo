//
//  ChatTableView.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/4/20.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "ChatTableView.h"
#import "ChartCell.h"
#import "ABSendReviewModel.h"
#import "CTLoadingView.h"
#import "ABMineVC.h"
#import "CommentsVideoView.h"

#define MAXTEXTLENGTH 100
@interface ChatTableView()<UITableViewDelegate,UITableViewDataSource,ChartCellDelegate,UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic, strong)ABCommentModel *m_commentRepeat;
@property (nonatomic, strong) CTLoadingView   *vLoad;
@property (nonatomic, strong) CommentsVideoView *commentView;
@property (nonatomic, strong) NSString *endStr;

@end

@implementation ChatTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


- (void)initUI{
    ______WS();

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self addSubview:_effectView];
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.mas_top).offset(0);
        make.width.offset(kTPScreenWidth);
        make.height.offset(kTPScreenHeight);
        make.left.equalTo(wSelf.mas_left).offset(0);
    }];
    
    UITapGestureRecognizer *taplose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePINLUN)];
    
    self.headViewTab_Chat = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, 50)];
    self.headViewTab_Chat.backgroundColor = RGB(22, 21, 16);
    self.headIcon_Img = [[UIImageView alloc] init];
    self.headIcon_Img.image = [UIImage imageNamed:@"input_chat"];
    [self.headViewTab_Chat addSubview:self.headIcon_Img];
    [self.headIcon_Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.headViewTab_Chat).offset(10);
        make.centerY.equalTo(wSelf.headViewTab_Chat);
        make.width.height.offset(22);
    }];
    [self addSubview:self.headViewTab_Chat];
    
    UITapGestureRecognizer *tapText = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapText)];
    self.speakTextFile = [[UILabel alloc] init];
    self.speakTextFile.text = @"发表你的评论...";
    self.speakTextFile.userInteractionEnabled = YES;
    self.speakTextFile.textColor = [UIColor whiteColor];
    [self.speakTextFile addGestureRecognizer:tapText];
    self.speakTextFile.font = [UIFont systemFontOfSize:12];
    [self.headViewTab_Chat addSubview:self.speakTextFile];
    [self.speakTextFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.headIcon_Img.mas_right).offset(18);
        make.centerY.equalTo(wSelf.headIcon_Img);
        make.right.equalTo(wSelf.headViewTab_Chat.mas_right).offset(-50);
        make.height.offset(19);
    }];
    
    
    self.clickView = [[UIView alloc] init];
    self.clickView.userInteractionEnabled = YES;
    [self.clickView addGestureRecognizer:taplose];
    [self.headViewTab_Chat addSubview:self.clickView];
    [self.clickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wSelf.headViewTab_Chat.mas_right).offset(0);
        make.width.height.offset(40);
        make.centerY.equalTo(wSelf.speakTextFile);
    }];
    
    
    self.closeChaCha_btn = [[UIImageView alloc] init];
    self.closeChaCha_btn.image = [UIImage imageNamed:@"omo_new_chacha"];
    self.closeChaCha_btn.userInteractionEnabled = YES;
    [self.closeChaCha_btn addGestureRecognizer:taplose];
    [self.headViewTab_Chat addSubview:self.closeChaCha_btn];
    [self.closeChaCha_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.headViewTab_Chat.mas_right).offset(-25);
        make.width.height.offset(15);
        make.centerY.equalTo(wSelf.speakTextFile);
    }];
    
    
    
    self.lineView_ie = [[UIView alloc] init];
    self.lineView_ie.backgroundColor = RGB(179, 179, 179);
    [self.headViewTab_Chat addSubview:self.lineView_ie];
    [self.lineView_ie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kTPScreenWidth);
        make.height.offset(1);
        make.centerX.equalTo(wSelf.headViewTab_Chat);
        make.top.equalTo(wSelf.headViewTab_Chat.mas_bottom).offset(-2);
    }];
    
    

    
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kTPScreenWidth, kTPScreenHeight - kTPScreenWidth * 0.5625 - 40) style:UITableViewStylePlain];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.tableFooterView = [[UIView alloc] init];
    self.chatTableView.tableHeaderView = [[UIView alloc] init];
    self.chatTableView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.chatTableView];
    [self.chatTableView registerClass:[ChartCell class] forCellReuseIdentifier:@"chart_cell_ID"];
    [self.chatTableView addPullNextHandle:^{
        wSelf.m_iPage++;
        [wSelf requestCommentList];
    }];

    self.m_iPage = 1;
    
    
//    [self requestCommentList];
    
    
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//            self.ui_viewReview = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kTPScreenWidth, 40)];
//            self.ui_viewReview.backgroundColor   = [UIColor colorWithWhite:242.0/255 alpha:1.0];
//            self.ui_tfReview = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.ui_viewReview.frame) - 10, 40)];
//            self.ui_tfReview.backgroundColor     = [UIColor whiteColor];
//            if([self.ui_tfReview respondsToSelector:@selector(setTintColor:)])
//            {
//                self.ui_tfReview.tintColor       = [UIColor darkGrayColor];
//            }
//            self.ui_tfReview.placeholder         = @"期待您的评论";
//            self.ui_tfReview.font                = [UIFont systemFontOfSize:14];
//            self.ui_tfReview.delegate            = self;
//            self.ui_tfReview.returnKeyType       = UIReturnKeySend;
//            self.ui_tfReview.leftViewMode        = UITextFieldViewModeAlways;
//            self.ui_tfReview.autocorrectionType  = UITextAutocorrectionTypeNo;
//            self.ui_tfReview.clearButtonMode     = UITextFieldViewModeAlways;
//            self.ui_tfReview.layer.masksToBounds = YES;
//            self.ui_tfReview.layer.cornerRadius  = 3;
//            self.ui_tfReview.layer.borderColor   = [UIColor colorWithWhite:0.0 alpha:0.1].CGColor;
//            self.ui_tfReview.layer.borderWidth   = 0.5;
//    
//            UIImageView *imvIco     = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 32, 20)];
//            imvIco.contentMode      = UIViewContentModeScaleAspectFit;
//            imvIco.image            = [UIImage imageNamed:@"ico_head_review"];
//            self.ui_tfReview.leftView    = imvIco;
//            [self.ui_viewReview addSubview:self.ui_tfReview];
//    
//    return self.ui_viewReview;
//}
//

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    ______WS();
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chart_cell_ID" forIndexPath:indexPath];
//    ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chart_cell_ID"];
    ChartCell *cell = [[ChartCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"chart_cell_ID"];
    cell.delegate = self;
    cell.cellFrame    = self.dataChat[indexPath.row];
    cell.indexpath = indexPath;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_dataChat) {
        return 0;
    }else{
        return self.dataChat.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_dataChat) return 0;
    return [_dataChat[indexPath.row] cellHeight] + 20;
}



#pragma mark ---------- chatDelegate
-(void)chartCell:(ChartCell *)chartCell tapContent:(NSString *)content
{
    if(![ABUser isLoginedAndPresent])
    {
        return;
    }
    
    //说明要点击回复了 , 呵呵哒
    ChartCellFrame *cellFrame  = chartCell.cellFrame;
    ChartMessage *chartMessage = cellFrame.chartMessage;
    
    if([[ABUser sharedInstance].abuser.user.ids isEqualToString:chartMessage.commentModel.my_infoObj.ids])
    {
        TOAST_SUCCESS(@"不能回复自己哦");
        return;
    }
    
    self.m_commentRepeat         = chartMessage.commentModel;
    [self tapText];
//    [self.speakTextFile becomeFirstResponder];
}

-(void)chartCell:(ChartCell *)chartCell tapUser:(ABCommentModel *)_model
{
//    ABMineVC *vcMine = [[ABMineVC alloc] init];
//    vcMine.userId    = _model.my_infoObj.ids;
//    vcMine.avator    = _model.my_infoObj.avator;
//    vcMine.nickname  = _model.my_infoObj.nickname;
//    vcMine.summary   = _model.my_infoObj.summary;
    
    NSDictionary *userInfo = @{@"userId":_model.my_infoObj.ids,
                               @"avator":_model.my_infoObj.avator,
                               @"nickname":_model.my_infoObj.nickname,
                               @"summary":_model.my_infoObj.summary};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postmineVC_chatView" object:nil userInfo:userInfo];
    
}

- (void)chartCellChangeData:(NSIndexPath *)index cellFlag:(NSNumber *)flag{
    NSLog(@"sfhsdkjfhsdkjhfsdkjhf");
    ChartCellFrame *cellFrame = self.dataChat[index.row];
    NSNumber *praiseCount = cellFrame.chartMessage.commentModel.praiseCount;
    cellFrame.chartMessage.commentModel.flag = flag;
    cellFrame.chartMessage.commentModel.praiseCount = [NSNumber numberWithInteger:([flag integerValue] > 0)? [praiseCount integerValue] + 1 : [praiseCount integerValue] - 1];
    
}

//#pragma mark - textfield delegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if (![ABUser isLoginedAndPresent])
//        return NO;
//    else
//    {
//        ______WS();
//        textField.placeholder = _m_commentRepeat ? [NSString stringWithFormat:@"回复%@的评论" , _m_commentRepeat.my_infoObj.nickname] : @"期待您的评论" ;
//        
//        UITapGestureRecognizer *tapComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapComment)];
//        self.commentView = [[CommentsVideoView alloc] init];
//        self.commentView.textView_comm.delegate = self;
//        [self.commentView.send_btn addTarget:self action:@selector(sendAction) forControlEvents:(UIControlEventTouchUpInside)];
//        [self.commentView.closeImg_comm addGestureRecognizer:tapComment];
//        [self addSubview:self.commentView];
//        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(wSelf).offset(0);
//            make.right.equalTo(wSelf).offset(0);
//            make.top.equalTo(wSelf).offset(0);
//            make.bottom.equalTo(wSelf).offset(0);
//
//        }];
//        
////        [self.speakTextFile resignFirstResponder];
//        [self.commentView.textView_comm becomeFirstResponder];
//
//        return YES;
//        
//    }
//}

- (void)tapText{
    if (![ABUser isLogined]){
        TOAST_FAILURE(@"要登录才可以哦");
    }
    else
    {
        ______WS();
//        textField.placeholder = _m_commentRepeat ? [NSString stringWithFormat:@"回复%@的评论" , _m_commentRepeat.my_infoObj.nickname] : @"期待您的评论" ;
        UITapGestureRecognizer *tapComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapComment)];
        self.commentView = [[CommentsVideoView alloc] init];
        self.commentView.textView_comm.delegate = self;
        self.commentView.textView_comm.textColor = [UIColor whiteColor];
        [self.commentView.send_btn addTarget:self action:@selector(sendAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.commentView.closeImg_comm addGestureRecognizer:tapComment];
        [self addSubview:self.commentView];
        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf).offset(0);
            make.right.equalTo(wSelf).offset(0);
            make.top.equalTo(wSelf).offset(0);
            make.bottom.equalTo(wSelf).offset(0);
        }];
        
        //   [self.speakTextFile resignFirstResponder];
        [self.commentView.textView_comm becomeFirstResponder];
        
    }

}


- (void)tapComment{
    [self.commentView removeFromSuperview];
}


- (void)sendAction{
    if (_m_commentRepeat) {
        NSString *string1 = self.commentView.textView_comm.text;
        NSString *string2 = [NSString stringWithFormat:@"回复%@" , _m_commentRepeat.my_infoObj.nickname];
        NSRange range = [string1 rangeOfString:string2];
        self.endStr = [string1 substringFromIndex:range.length];
    }else{
        self.endStr = self.commentView.textView_comm.text;
    }
    
    [self requestSendReview:self.endStr];
    
    _m_commentRepeat         = nil;
    [self.commentView.textView_comm resignFirstResponder];
    [self.commentView removeFromSuperview];
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
      textView.text = _m_commentRepeat ? [NSString stringWithFormat:@"回复%@" , _m_commentRepeat.my_infoObj.nickname] : textView.text ;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"点击完成评论");
    if([textView.text isValid])
    {
        [textView resignFirstResponder];
//        [self requestSendReview:textView.text];
        
//        textView.text          = @"";
//        textView.   = @"期待您的评论";
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:MAXTEXTLENGTH];
    }
}


//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    NSLog(@"点击完成评论");
//    if([textField.text isValid])
//    {
//        [textField resignFirstResponder];
//        [self requestSendReview:textField.text];
////        [self.dataChat insertObject:textField.text atIndex:0];
//        textField.text          = @"";
//        textField.placeholder   = @"期待您的评论";
//        _m_commentRepeat         = nil;
//        return YES;
//    }
//    else
//    {
//        TOAST_SUCCESS(@"您未输入评论");
//        return NO;
//    }
//}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    if([textField.text isValid])
//    {
//        //        textField.text          = @"";
//        //        textField.placeholder   = @"期待您的评论";
//        //        m_commentRepeat         = nil;
//    }
//}


- (void)requestSendReview:(NSString *)_strMessage
{
    if (![ABUser isLoginedAndPresent])
        return;
    
    NSString *strRepeat = @"";
    if(_m_commentRepeat)
    {
        strRepeat = _m_commentRepeat.my_infoObj.ids;
    }
    
    __weak typeof(self) wSelf = self;
    [ABSendReviewModel sendReview:_strMessage forids:strRepeat contentids:_m_modelContent.contentInfo.ids block:^(NSDictionary *resultObject)
     {
         ABSendReviewModel* model = [[ABSendReviewModel alloc] initWithDictionary:resultObject error:nil];
         if (model.rspCode.integerValue == 200)
         {
             self.m_iPage = 1;
             [wSelf requestCommentList];
             [MobClick event:@"day_comment_num"];
             TOAST_SUCCESS(@"评论成功!");
         }
         else
         {
             TOAST_FAILURE(model.rspMsg);
         }
         
     } failure:^(NSError *requestErr)
     {
         TOAST_ERROR(wSelf, requestErr);
     }];
}

- (void)requestCommentList
{
    __weak typeof(self) wSelf              = self;
    [ABCommandListModel requestCommandList:[NSString stringWithFormat:@"%ld",(long)_m_iPage] contentids:_m_modelContent.contentInfo.ids block:^(NSDictionary *resultObject)
     {
         NSLog(@"%@",resultObject);
         
         [wSelf.chatTableView.mj_header endRefreshing];
         
         [wSelf hideLoading:NO];
         
         ABCommandListModel* model = [[ABCommandListModel alloc] initWithDictionary:resultObject error:nil];
         if (model.rspCode.integerValue == 200)
         {
             if(model.rspObject.comment.count > 0)
             {
                 wSelf.m_iPage = model.rspObject.page.pageNumber.integerValue;
                 if(wSelf.m_iPage == 1)
                 {
                     [wSelf.dataChat removeAllObjects];
                 }
//                 if(wSelf.dataChat) wSelf.dataChat = [[NSMutableArray alloc] init];
                 
                 if (model.rspObject.page.totalPage.integerValue < wSelf.m_iPage) {
                     [wSelf.chatTableView.mj_footer endRefreshingWithNoMoreData];
                 }
                 else
                 {
                     if (wSelf.dataChat) {
                         
                     }else{
                         wSelf.dataChat = [[NSMutableArray alloc] init];
                     }
                     for(ABCommentModel *modelComment  in model.rspObject.comment)
                     {
                         ChartCellFrame *cellFrame       = [[ChartCellFrame alloc]init];
                         ChartMessage *chartMessage      = [[ChartMessage alloc]init];
                         chartMessage.commentModel       = modelComment;
                         cellFrame.chartMessage          = chartMessage;
                         [wSelf.dataChat addObject:cellFrame];
                     }
                     [wSelf.chatTableView.mj_footer endRefreshing];
                     [wSelf.chatTableView reloadData];
                 }
             }
             else
             {
                 [wSelf.chatTableView.mj_footer endRefreshingWithNoMoreData];
             }
//             [wSelf.chatTableView reloadData];

            [wSelf.chatTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
         }
         else
         {
             [wSelf.chatTableView.mj_header endRefreshing];
             [wSelf.chatTableView.mj_footer endRefreshing];
             TOAST_FAILURE(model.rspMsg);
             [wSelf.chatTableView reloadData];

         }
         
     } failure:^(NSError *requestErr)
     {
         [wSelf hideLoading:NO];
         [wSelf.chatTableView.mj_footer endRefreshing];
         TOAST_ERROR(wSelf, requestErr);
     }];
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

// 关闭评论
- (void)closePINLUN{
    NSLog(@"22222");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeRewiue_post" object:nil];
}

@end
