//
//  ABHomeVC.m
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABVideoDetailVC.h"
#import "ABFeedCell.h"
#import "UIView+MJExtension.h"
#import "MJRefresh.h"
#import "ChartCell.h"
#import "ABChannelDetailVC.h"
#import "ABSendReviewModel.h"
#import "ABCommandListModel.h"
#import "ABVideoDetailModel.h"
#import "UMSocial.h"
#import "ABCollectionStateModel.h"
#import "ABMineVC.h"
#import "ABUserLikeListVC.h"
#import "VideoDetilCell.h"
#import "VideoPlayEndView.h"
#import "VideoMainCell.h"
#import "ABAddViewModel.h"
#import "ChatTableView.h"
#import "RemmendModel.h"
#import "RelatedRemmCell.h"
#import "ABLoginVC.h"
#import "ChannelShareView.h"
#import "FullShareView.h"
#import "CTWebViewVC.h"
@interface ABVideoDetailVC ()<UITableViewDataSource , UITableViewDelegate , UITextFieldDelegate , ABFeed1CellDelegate,RemarksCellDelegate>
{
    ABContentResult                     *m_modelContent;
    NSString                            *m_contentids;
    NSString                            *m_videoDetailName;
    BOOL                                m_isNeedShowKeyboard;
    NSMutableArray<ChartCellFrame*>     *m_arrayComment;
    ABCommentModel                      *m_commentRepeat;
}

@property (strong,nonatomic) UIView         *ui_viewReview;
@property (strong,nonatomic) UITextField    *ui_tfReview;
@property (strong,nonatomic) VideoMainCell     *ui_cellFeed;
@property (assign,nonatomic) NSInteger      m_iPage;

@property (nonatomic, strong) UIButton *leftBackButton;

@property (nonatomic, strong) NSString *cellIsShowAll;
@property (nonatomic , strong) GuanggaoMoreModel *videomd;

@property (strong,nonatomic) UITableView    *chatTableView;
@property (strong,nonatomic) UILabel        *downscrollLab;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, strong) ChannelShareView *shareView;
@property (nonatomic, strong) FullShareView *fullShareView;             // 全屏分享

@property (nonatomic ,strong) UIView *deliverView; //底部View
@property (nonatomic ,strong) NSMutableArray *dataArr; //底部View
@property (nonatomic ,assign) NSInteger count; //底部View

@end

@implementation ABVideoDetailVC
@synthesize ui_viewReview , ui_tfReview , m_iPage , ui_cellFeed;



- (id)initWithContent:(ABContentResult *)_contentInfo needShowKeyboard:(BOOL)_needShowKeyboard
{
    m_modelContent          = _contentInfo;
    m_isNeedShowKeyboard    = _needShowKeyboard;
    
    self = [super init];
    if(self)
    { }
    return self;
}

- (id)initWithContentids:(NSString *)_contentids needShowKeyboard:(BOOL)_needShowKeyboard
{
    m_contentids            = _contentids;
    m_isNeedShowKeyboard    = _needShowKeyboard;
    
    self = [super init];
    if(self)
    { }
    return self;
}

- (void)setVideoDetailName:(NSString *)_contentName
{
    
    m_videoDetailName = _contentName;
    self.itemTitle = [m_videoDetailName isValid] ? m_videoDetailName : @"视频详情";
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMineVC:) name:@"postmineVC_chatView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePINLUN) name:@"closeRewiue_post" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSCtype:) name:@"changeSCtype" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videodetails_post_share) name:@"videodetails_post_share" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videodetailsFull_post_share) name:@"videodetailsFull_post_share" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeVideoNoticAction) name:@"ChangeVideoNotic" object:nil];
    
    m_iPage = 1;
    self.count = 1;
    self.view.backgroundColor = RGB(53, 49, 50);
    _dataArr = [NSMutableArray array];
    [self requestADAction];
    [self initUI];
}


- (void)requestADAction{
    ______WS();
    UITableView *tableViewContent           = (UITableView *)[self.view viewWithStringTag:@"tag_table_content"];
    NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
    NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
    [repDic setValue:@"3" forKey:@"position"];
    [[DJHttpApi shareInstance] POST:urlAdSever dict:repDic succeed:^(id data) {
        if (![data[@"rspObject"] isKindOfClass:[NSNull class]]) {
            GuanggaoMoreModel *moreModel = [[GuanggaoMoreModel alloc] init];
            [moreModel setValuesForKeysWithDictionary:data[@"rspObject"]];
            wSelf.videomd = moreModel;
            [tableViewContent reloadData];
            if (wSelf.adImage) {
                if (wSelf.count == 1) {
                    [repDic setValue:@"1" forKey:@"type"];
                    [repDic setValue:@"3" forKey:@"position"];
                    [repDic setValue:moreModel.ids forKey:@"aids"];
                    
                    [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
                        NSLog(@"广告展示: %@",data);
                        [MobClick event:@"video_ads_show_num"];
                        
                    } failure:^(NSError *error) {
                    }];
                    wSelf.count++;
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}



- (void)initUI
{
    ______WS();
    CGFloat y = 0;
    if (KIsiPhoneX) {
        y = 44;
    }
    UITableView *tableViewContent   = [[UITableView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame), kTPScreenHeight) style:UITableViewStylePlain];
    tableViewContent.tag = 10002;
    tableViewContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewContent.delegate       = self;
    tableViewContent.dataSource     = self;
    tableViewContent.showsVerticalScrollIndicator   = NO;
    tableViewContent.backgroundColor= RGB(53, 49, 50);
    tableViewContent.stringTag      = @"tag_table_content";
    [self.view addSubview:tableViewContent];
    
    [tableViewContent registerClass:[VideoDetilCell class] forCellReuseIdentifier:@"pindao_idefi"];
    [tableViewContent registerClass:[VideoMainCell class] forCellReuseIdentifier:@"video_idefi"];
    [tableViewContent registerClass:[RelatedRemmCell class] forCellReuseIdentifier:@"RelatedRemmCell_idfi"];
    
    [self setExtraCellLineHidden:tableViewContent];
    
    if (@available(iOS 11.0, *)) {
        tableViewContent.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.cellIsShowAll = @"no";
    //    [self initHead];
    self.downscrollLab = [[UILabel alloc] init];
    self.downscrollLab.text = @"下 拉 关 闭 页 面";
    self.downscrollLab.textColor = [UIColor whiteColor];
    self.downscrollLab.textAlignment = NSTextAlignmentCenter;
    self.downscrollLab.font = [UIFont systemFontOfSize:12];
    self.downscrollLab.hidden = YES;
    [self.view addSubview:self.downscrollLab];
    [self.downscrollLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf.view);
        make.width.offset(kTPScreenWidth);
        make.top.equalTo(wSelf.view.mas_top).offset(20);
        make.height.offset(17);
    }];
    
    self.leftBackButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.leftBackButton.imageEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 10);
    [self.leftBackButton setImage:[UIImage imageNamed:@"omo_back_white"] forState:(UIControlStateNormal)];
    [self.leftBackButton addTarget:self action:@selector(leftbackAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.leftBackButton];
    [self.leftBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view.mas_left).offset(10);
        make.top.equalTo(wSelf.view.mas_top).offset(15 + y);
        make.width.offset(40);
        make.height.offset(20);
    }];
    
    [self requestVideoDetail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[IQKeyboardManager sharedManager] setEnable:NO];
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(m_isNeedShowKeyboard)
    {
        [ui_tfReview becomeFirstResponder];
        m_isNeedShowKeyboard = NO;
    }
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseVideoPlayNocite" object:self];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(ui_cellFeed)
    {
        [ui_cellFeed releaseWMPlayer];
    }
    [[IQKeyboardManager sharedManager] setEnable:YES];

}


#pragma mark - private method
- (void)requestVideoDetail
{
    if(!m_modelContent)
    {
        [self showLoading];
        UITableView *tableViewContent           = (UITableView *)[self.view viewWithStringTag:@"tag_table_content"];
        __weak typeof(tableViewContent) wTable  = tableViewContent;
        __weak typeof(self) wSelf               = self;
        NSLog(@"%@",[ABUser sharedInstance].abuser.user.sessionid);
        [ABVideoDetailModel requestVideoDetail:m_contentids block:^(NSDictionary *resultObject)
         {
             ABVideoDetailModel* model = [[ABVideoDetailModel alloc] initWithDictionary:resultObject error:nil];
             if ([resultObject[@"rspCode"] integerValue] != 200) {
                 TOAST_SUCCESS(@"该视频无法播放! ");
                 [wSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                 return;
             }
             NSDictionary *dic = resultObject[@"rspObject"];
             NSArray *arr = dic[@"recommendInfo"];
             if (arr.count > 0) {
                 for (NSDictionary *dicRem in arr) {
                     RemmendModel *model = [[RemmendModel alloc] init];
                     [model setValuesForKeysWithDictionary:dicRem];
                     [wSelf.dataArr addObject:model];
                 }
             }
             if (model.rspCode.integerValue == 200)
             {
                 m_modelContent = [[ABContentResult alloc] init];
                 m_modelContent.contentInfo = model.rspObject.contentInfo;
                 [[NSUserDefaults standardUserDefaults] setObject:m_modelContent.contentInfo.praised forKey:@"praised"];
                 m_modelContent.channelInfo = model.rspObject.channelInfo;
                 m_modelContent.praiseInfo  = model.rspObject.praiseInfo;
                 m_modelContent.commentInfo = model.rspObject.commentInfo;
                 
                 [wTable reloadData];
                 
                 [wSelf requestCommentList];
             }
             else
             {
                 TOAST_FAILURE(model.rspMsg);
                 [wSelf hideLoading:NO];
             }
             
         } failure:^(NSError *requestErr)
         {
             TOAST_ERROR(wSelf, requestErr);
             [wSelf hideLoading:NO];
         }];
    }
    else
    {
        [self requestCommentList];
    }
}



- (void)updataCommentNumberRequest{
    if(m_modelContent)
    {
        [ABVideoDetailModel requestVideoDetail:m_contentids block:^(NSDictionary *resultObject)
         {
             ABVideoDetailModel* model = [[ABVideoDetailModel alloc] initWithDictionary:resultObject error:nil];
//             NSDictionary *dic = resultObject[@"rspObject"];
             NSLog(@"%@",model.rspObject.commentInfo.total);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNumTotla_post" object:nil userInfo:@{@"totla":model.rspObject.commentInfo.total}];
         } failure:^(NSError *requestErr)
         {

         }];
    }
}

/*!
 @abstract 评论发送
 */
- (void)requestSendReview:(NSString *)_strMessage
{
    if (![ABUser isLoginedAndPresent])
        return;
    
    NSString *strRepeat = @"";
    if(m_commentRepeat)
    {
        strRepeat = m_commentRepeat.my_infoObj.ids;
    }
    
    __weak typeof(self) wSelf = self;
    [ABSendReviewModel sendReview:_strMessage forids:strRepeat contentids:m_modelContent.contentInfo.ids block:^(NSDictionary *resultObject)
    {
        ABSendReviewModel* model = [[ABSendReviewModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200)
        {
            m_iPage = 1;
            [wSelf requestCommentList];
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
    UITableView *tableViewContent          = (UITableView *)[self.view viewWithStringTag:@"tag_table_content"];
    __weak typeof(tableViewContent) wTable = tableViewContent;
    __weak typeof(self) wSelf              = self;
    [ABCommandListModel requestCommandList:[NSString stringWithFormat:@"%ld",m_iPage] contentids:m_modelContent.contentInfo.ids block:^(NSDictionary *resultObject)
    {
        [wTable.mj_header endRefreshing];
        [wSelf hideLoading:NO];
        
        ABCommandListModel* model = [[ABCommandListModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200)
        {
            if(model.rspObject.comment.count > 0)
            {
                m_iPage = model.rspObject.page.pageNumber.integerValue;
                if(m_iPage == 1)
                {
                    [m_arrayComment removeAllObjects];
                }
                if(!m_arrayComment) m_arrayComment = [[NSMutableArray alloc] init];
                
                if (model.rspObject.page.totalPage.integerValue < m_iPage) {
                    [wTable.mj_footer endRefreshingWithNoMoreData];
                }
                else
                {
                    for(ABCommentModel *modelComment  in model.rspObject.comment)
                    {
                        ChartCellFrame *cellFrame       = [[ChartCellFrame alloc]init];
                        ChartMessage *chartMessage      = [[ChartMessage alloc]init];
                        chartMessage.commentModel       = modelComment;
                        cellFrame.chartMessage          = chartMessage;
                        [m_arrayComment addObject:cellFrame];
                    }
                    [wTable.mj_footer endRefreshing];
                }
            }
            else
            {
                [wTable.mj_footer endRefreshingWithNoMoreData];
            }
            
//            [wTable reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            [wTable.mj_header endRefreshing];
            [wTable.mj_footer endRefreshing];
            TOAST_FAILURE(model.rspMsg);
        }
        
    } failure:^(NSError *requestErr)
    {
        [wSelf hideLoading:NO];
        [wTable.mj_footer endRefreshing];
        TOAST_ERROR(wSelf, requestErr);
    }];
}

#pragma mark - on Action
- (void)leftbackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 3;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        if (section == 2) {
            if (self.videomd) {
                return 200;
            }
            return 20;
        }
        return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if(section == 0)
        {
            return 1;
        }
        else if (section == 1){
            return 1;
        }
        else
        {
            return _dataArr.count;
        }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
        if (section == 2) {
            CGFloat height = 0;
            UIView *headView = [[UIView alloc] init];
            headView.userInteractionEnabled = YES;
            if (self.videomd) {
                UITapGestureRecognizer *tapAd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAdAction)];
                self.adImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, kTPScreenWidth, 120)];
                [self.adImage addGestureRecognizer:tapAd];
                self.adImage.userInteractionEnabled = YES;
                [self.adImage sd_setImageWithURL:[NSURL URLWithString:self.videomd.image] placeholderImage:nil];

                [headView addSubview:self.adImage];
                
                UILabel *tit = [[UILabel alloc] init];
                tit.textColor = [UIColor whiteColor];
                tit.backgroundColor = [UIColor blackColor];
                tit.textAlignment = NSTextAlignmentCenter;
                tit.text = @"广告";
                tit.font = [UIFont systemFontOfSize:10];
                [headView addSubview:tit];
                ______WS();
                [tit mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(wSelf.adImage.mas_right).offset(-19);
                    make.top.equalTo(wSelf.adImage.mas_top).offset(15);
                    make.height.offset(16);
                    make.width.offset(25);
                }];
                height = 180;
            }
            height = height + 20;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 200, 17)];
            label.textColor = [UIColor whiteColor];
            label.text = @"相关推荐";
            label.font = [UIFont systemFontOfSize:13];
            [headView addSubview:label];
            headView.backgroundColor =  RGB(53, 49, 50);
            headView.frame = CGRectMake(0, 0, kTPScreenWidth, height);
            return headView;
        }else{
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
            return headView;
        }

 
}




-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]  init];
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return [VideoMainCell heightForC1ell:m_modelContent isNeedShow1GotoReviewAndSpeard:self.cellIsShowAll];
    
    else if (indexPath.section == 1){
        return 55;
    }
    else
    {
        return 100;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(indexPath.section == 0)
        {
            if(!ui_cellFeed)
            {
                ui_cellFeed = [[VideoMainCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"video_idefi"];
                ui_cellFeed.delegate = self;
                ui_cellFeed.delegateMarkCell = self;
                ui_cellFeed.backMatte.userInteractionEnabled = YES;
                [ui_cellFeed setNeedReleasePlayerWhenReload:NO];
            }
            [ui_cellFeed updateData:m_modelContent needShowReviewAndSpeard:NO index:indexPath str:self.cellIsShowAll];
            [ui_cellFeed setReviewBtnHidden:YES];
            return ui_cellFeed;
        }
        else if (indexPath.section == 1 && indexPath.row == 0){
            VideoDetilCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pindao_idefi" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCellmessageModel:m_modelContent];
            return cell;
        }
        else
        {
            RelatedRemmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelatedRemmCell_idfi" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            RemmendModel *model = _dataArr[indexPath.row];
            cell.model = model;
            return cell;
        }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1 && indexPath.row == 0) {
        
        ABChannelDetailVC *vcChannel = [[ABChannelDetailVC alloc] initWithChannel:m_modelContent.channelInfo.ids];
        [self.navigationController pushViewController:vcChannel animated:YES];
        [vcChannel setChannelName:m_modelContent.channelInfo.name];
    }
    
    if (indexPath.section == 2) {
        RemmendModel *model = _dataArr[indexPath.row];
        ABVideoDetailVC* vc= [[ABVideoDetailVC alloc] initWithContentids:model.ids needShowKeyboard:NO];
        [self.navigationController pushViewController:vc animated:NO];

    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(ui_tfReview)
    {
        [ui_tfReview resignFirstResponder];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < -25) {
        self.downscrollLab.hidden = NO;
    }else{
        self.downscrollLab.hidden = YES;

    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y < -50) {
        NSLog(@"准备要下滑结束关闭controller了");
        [self closePINLUN];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}


- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark -- Dalegate
- (void)remarksCellShowContrntWithDic:(NSDictionary *)dic andCellIndexPath:(NSIndexPath *)indexPath
{
    
    UITableView *tableview = (UITableView *)[self.view viewWithStringTag:@"tag_table_content"];
    if ([self.cellIsShowAll isEqualToString:@"yes"]) {
        self.cellIsShowAll = @"no";
    }else{
        self.cellIsShowAll = @"yes";

    }
    [tableview reloadData];
}


- (void)addView{
    
    ______WS();
    ChatTableView *chatView = [[ChatTableView alloc] init];
    chatView.tag = 1001;
    chatView.dataChat = m_arrayComment;
    chatView.m_modelContent = m_modelContent;
    
    [self.view addSubview:chatView];
    [chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.view.mas_top).offset(kTPScreenWidth * 0.5625);
        make.centerX.equalTo(wSelf.view);
        make.width.offset(kTPScreenWidth);
        make.height.offset(kTPScreenHeight - kTPScreenWidth * 0.5625);
    }];
    
    [chatView.chatTableView reloadData];
}



- (void)closePINLUN{
    ChatTableView *view = [(ChatTableView *)self.view viewWithTag:1001];
    m_arrayComment = view.dataChat;
    [self updataCommentNumberRequest];
    if (view) {
        [view removeFromSuperview];
    }
}


#pragma mark - POST notic
- (void)pushMineVC:(NSNotification *)userInfo{
    NSDictionary *dic = userInfo.userInfo;
    ABMineVC *vcMine = [[ABMineVC alloc] init];
    vcMine.userId    = dic[@"userId"];
    vcMine.avator    = dic[@"avator"];
    vcMine.nickname  = dic[@"nickname"];
    vcMine.summary   = dic[@"summary"];
    [self.navigationController pushViewController:vcMine animated:YES];

}


- (void)changeSCtype:(NSNotification *)userInfo{
    NSDictionary *dic = userInfo.userInfo;
    if ([dic[@"type"] isEqualToString:@"1"]) {
        m_modelContent.channelInfo.collected = @"1";
    }else{
        m_modelContent.channelInfo.collected = @"0";

    }
}

- (void)ChangeVideoNoticAction{
    NSLog(@"跳转视频");
    NSInteger index = (NSInteger)(0 + (arc4random() % (self.dataArr.count - 0 + 1)));
    RemmendModel *model = _dataArr[index];
    ABVideoDetailVC* vc= [[ABVideoDetailVC alloc] initWithContentids:model.ids needShowKeyboard:NO];
    [self.navigationController pushViewController:vc animated:NO];

}


- (void)videodetails_post_share{
    if (!_shareView) {
        self.shareView = [[ChannelShareView alloc] initWithFrame:CGRectMake(0, kTPScreenHeight, kTPScreenWidth, kTPScreenHeight)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClose)];
        self.shareView.from = @"video";
        [self.shareView.share_QQ setImage:[UIImage imageNamed:@"videodetl_qq"] forState:(UIControlStateNormal)];
        [self.shareView.share_WX setImage:[UIImage imageNamed:@"videodetl_wx"] forState:(UIControlStateNormal)];
        [self.shareView.share_QQozoe setImage:[UIImage imageNamed:@"videodetl_qqozne"] forState:(UIControlStateNormal)];
        [self.shareView.share_WB setImage:[UIImage imageNamed:@"videodetl_wb"] forState:(UIControlStateNormal)];
        [self.shareView.share_PYQ setImage:[UIImage imageNamed:@"videodetl_wxg"] forState:(UIControlStateNormal)];
        self.shareView.share_titlt.textColor = [UIColor whiteColor];
        [self.shareView.cancel_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.shareView.cancel_btn addTarget:self action:@selector(tapClose) forControlEvents:(UIControlEventTouchUpInside)];
        self.shareView.effectView.hidden = NO;
        self.shareView.summy_lab.hidden = NO;
        self.shareView.summy_lab.text = m_modelContent.contentInfo.title;
        [self.shareView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].delegate.window addSubview:self.shareView];
    }
    [self shareViewlife];
}

- (void)videodetailsFull_post_share{
    NSLog(@"全屏分享");
    if (!_fullShareView) {
        self.fullShareView = [[FullShareView alloc] init];
        self.fullShareView.summy_lab.text = m_modelContent.contentInfo.title;
        [self.fullShareView.back_bigview sd_setImageWithURL:[NSURL URLWithString:m_modelContent.contentInfo.photo] placeholderImage:[UIImage imageNamed:@"backgroud_user"]];
        self.fullShareView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.fullShareView.cancel_btn addTarget:self action:@selector(tapCloseFullshare) forControlEvents:(UIControlEventTouchUpInside)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.fullShareView];
        self.fullShareView.frame = [UIApplication sharedApplication].keyWindow.frame;
    }
}


#pragma mark ------------------ 自定义方法
- (void)shareViewlife{
    ______WS();
    if (!_isShare) {
        [UIView animateWithDuration:0.5 animations:^{
            self.shareView.frame = CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight);
        } completion:^(BOOL finished) {
            NSLog(@"动画已结束");
            _isShare = YES;
            wSelf.shareView.back_bigview.hidden = NO;
            
        }];
    }else{
        wSelf.shareView.back_bigview.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.shareView.frame = CGRectMake(0, kTPScreenHeight, kTPScreenWidth, kTPScreenHeight);
        } completion:^(BOOL finished) {
            NSLog(@"动画已结束");
            _isShare = NO;
            [self.shareView removeFromSuperview];
            self.shareView = nil;
        }];
    }
}

#pragma mark ------------------ 手势方法

- (void)tapAdAction{
    NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
    NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
    [repDic setValue:@"2" forKey:@"type"];
    [repDic setValue:@"3" forKey:@"position"];
    [repDic setValue:self.videomd.ids forKey:@"aids"];
    
    [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
        NSLog(@"点击展示: %@",data);
        [MobClick event:@"video_ads_click_num"];
        
    } failure:^(NSError *error) {
    }];
    
    CTWebViewVC* vc = [[CTWebViewVC alloc] init];
    vc.url          = [NSURL URLWithString:self.videomd.url];
    vc.title        = self.videomd.title;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)tapClose{
    [self shareViewlife];
}

- (void)tapCloseFullshare{
    [self.fullShareView removeFromSuperview];
    self.fullShareView = nil;
}


#pragma mark - delegate
- (void)deActionEnterChannel:(NSInteger)_index
{
    ABContentInfoResult *modelContentInfo   = m_modelContent.contentInfo;
    ABChannelDetailVC *vcChannel            = [[ABChannelDetailVC alloc] initWithChannel:modelContentInfo.channel_ids];
    [self.navigationController pushViewController:vcChannel animated:YES];
    [vcChannel setChannelName:m_modelContent.channelInfo.name];
}

- (void)deActionLikesUser:(NSInteger)_index
{
    ABContentInfoResult *modelContentInfo   = m_modelContent.contentInfo;
    ABUserLikeListVC *vcLikesList = [[ABUserLikeListVC alloc] initWithContentids:modelContentInfo.ids];
    [self.navigationController pushViewController:vcLikesList animated:YES];
}






- (void)dealloc
{
    if (_shareView) {
        [_shareView removeFromSuperview];
        _shareView = nil;
    }
    
    if (_fullShareView) {
        [_fullShareView removeFromSuperview];
        _fullShareView = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
