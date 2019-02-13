//
//  ABChannelDetailVC.m
//  Axiba
//
//  Created by Michael on 16/6/14.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABChannelDetailVC.h"
#import "UIView+MJExtension.h"
#import "MJRefresh.h"
#import "ABFeedCell.h"
#import "ABCommonDataManager.h"
#import "ABVideoDetailVC.h"
#import "ABChannelIntroductionVC.h"
#import "ABContentsModel.h"
#import "ABUserLikeListVC.h"
#import "OmoShareDjhManaage.h"
#import "ChannelShareView.h"

@interface ABChannelDetailVC ()<UITableViewDataSource , UITableViewDelegate , ABFeedCellDelegate>
{
    NSString                            *m_channelIds;
    NSString                            *m_channelName;
    NSMutableArray<ABContentResult *>   *m_arrayContent;
}
@property (nonatomic, assign) NSInteger m_iPage;
@property (nonatomic, assign) NSInteger indexAdvert;
@property (nonatomic, strong) NSMutableArray *advertArray;
@property (nonatomic, strong) ABContentResult *modeContentOne;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, strong) ChannelShareView *shareView;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn1;
@property (nonatomic, strong) UIButton *rightBtn2;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIButton *headBtn;

@end
@implementation ABChannelDetailVC
@synthesize m_iPage;

- (void)dealloc{
    if (_shareView) {
        [_shareView removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


- (id)initWithChannel:(NSString *)_channelIds
{
    m_channelIds        = _channelIds;
    m_arrayContent      = [[NSMutableArray alloc] init];
    self = [super init];
    if(self)
    {
    }
    return self;
}

- (void)setChannelName:(NSString *)_channelName
{
    m_channelName       = _channelName;
    self.itemTitle      = [m_channelName isValid] ? m_channelName : @"频道详情";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.navigationController.navigationBar.barTintColor = RGB(255, 212, 0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:Notifycation_Pause_Video object:nil];

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    _isShare = NO;
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChannelShareView_TapShare:) name:@"ChannelShare_TapShare" object:nil];
    
    [self initUI];

}



- (void)initUI
{
    ______WS();
    self.showBackBtn    = YES;
    CGFloat y;
    CGFloat height;

    if (KIsiPhoneX) {
         y = 44;
        height = 88;
    }else{
         y = 20;
        height = 64;
    }
    
    UITableView *tableViewContent   = [[UITableView alloc] initWithFrame:CGRectMake(0, -y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) + y) style:UITableViewStyleGrouped];
    tableViewContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewContent.delegate       = self;
    tableViewContent.dataSource     = self;
    tableViewContent.showsVerticalScrollIndicator   = NO;
    tableViewContent.stringTag      = @"tag_table_content";
    [self.view addSubview:tableViewContent];
    
    
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, height)];
    [self.view addSubview:_bgView];
    _bgView.hidden = YES;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height);
    [_bgView addSubview:effectView];

    
    _leftBtn              = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setImage:[UIImage imageNamed:@"omo_back_left"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.view.mas_left).offset(15);
        make.bottom.equalTo(wSelf.bgView.mas_bottom).offset(-12);
        make.width.height.offset(24);
    }];
    
    _rightBtn1              = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn1.hidden = YES;
    [_rightBtn1 addTarget:self action:@selector(exitfeekLiikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn1];
    [_rightBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wSelf.view.mas_right).offset(-15);
        make.bottom.equalTo(wSelf.bgView.mas_bottom).offset(-12);
        make.height.offset(20);
        make.height.offset(56);

    }];
    
    _rightBtn2              = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn2 setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    _rightBtn2.titleLabel.font = Font_Chinease_Normal(10);
    [_rightBtn2 addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn2];
    [_rightBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wSelf.view.mas_right).offset(-15);
        make.bottom.equalTo(wSelf.bgView.mas_bottom).offset(-12);
        make.width.height.offset(20);
    }];
    
    
    _label1 = [[UILabel alloc] init];
    _label1.textColor = [UIColor whiteColor];
    _label1.font = Font_Chinease_Blod(18);
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.text = [m_channelName isValid] ? m_channelName : @"频道详情";
    _label1.hidden = YES;
    [self.view addSubview:_label1];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wSelf.leftBtn);
        make.centerX.equalTo(wSelf.view);
        make.width.equalTo(@150);
        make.height.offset(20);
    }];
    
    [tableViewContent addPullRefreshHandle:^{
        wSelf.m_iPage = 1;
        [wSelf requestData];
    }];
    
    [tableViewContent addPullNextHandle:^{
        wSelf.m_iPage++;
        [wSelf requestData];
    }];
    m_iPage = 1;
    
    [self showLoading];
    [self requestData];
}


#pragma mark - private method
/*!
 @method 请求网络数据
 */
- (void)requestData
{
    UITableView *tableViewContent   = (UITableView *)[self.view viewWithStringTag:@"tag_table_content"];
    __weak typeof(tableViewContent) wTableView  = tableViewContent;
    __weak typeof(self) wSelf       = self;
    
    [ABContentsModel requestContents:[NSString stringWithFormat:@"%ld",(long)m_iPage] classifyids:@"" channelId:m_channelIds block:^(NSDictionary *resultObject)
     {
         [wSelf hideLoading:NO];
         [wTableView.mj_header endRefreshing];
         
         ABContentsModel* model = [[ABContentsModel alloc] initWithDictionary:resultObject error:nil];
         if (model.rspCode.integerValue == 200)
         {
             m_iPage = model.rspObject.page.pageNumber.integerValue;
             if(!m_arrayContent)
                 m_arrayContent = [[NSMutableArray alloc] init];
             
             if(m_arrayContent.count > 0 && m_iPage == 1 && model.rspObject.content.count > 0)
                 m_arrayContent = [[NSMutableArray alloc] init];
            
             if (model.rspObject.page.totalPage.integerValue <= m_iPage)
             {
                 [m_arrayContent addObjectsFromArray:model.rspObject.content];
                 
                 [wTableView.mj_footer endRefreshingWithNoMoreData];
             }
             else
             {
                 [m_arrayContent addObjectsFromArray:model.rspObject.content];
                 [wTableView.mj_footer endRefreshing];
             }
             
             [wTableView reloadData];
            
             if(m_arrayContent.count<= 0)
             {
                 [wSelf showEmpty:nil];
             }
         }
         else
         {
             TOAST_FAILURE(model.rspMsg);
             [wTableView.mj_footer endRefreshing];
         }
         
         
          wSelf.modeContentOne = [m_arrayContent objectAtIndex:0];
         [wSelf.bgView sd_setImageWithURL:[NSURL URLWithString:wSelf.modeContentOne.channelInfo.photo] placeholderImage:nil];
     } failure:^(NSError *requestErr)
     {
         [wSelf hideLoading:NO];
         [wTableView.mj_header endRefreshing];
         [wTableView.mj_footer endRefreshing];
         TOAST_ERROR(wSelf, requestErr);
     }];
}


#pragma mark - on Action

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
        }];
    }
}


- (void)tapCloseAdvert{

    UITableView *tab = (UITableView *)[self.view viewWithStringTag:@"tag_table_content"];
    if (_indexAdvert < _advertArray.count) {
        _indexAdvert++;
        tab.tableHeaderView.backgroundColor = [UIColor blueColor];
    }else{
        tab.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, 0.001)];
        tab.tableHeaderView.backgroundColor = [UIColor clearColor];
    }
    
}


- (void)tapClose{
    [self shareViewlife];
}

#pragma mark - UITableViewDataSource and delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, 200)];
    
    UIImageView *toolImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, 200)];
    [toolImg sd_setImageWithURL:[NSURL URLWithString:self.modeContentOne.channelInfo.photo] placeholderImage:[UIImage imageNamed:@"icon_need_head"]];
    [headView addSubview:toolImg];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, toolImg.frame.size.width, toolImg.frame.size.height);
    [toolImg addSubview:effectView];

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(kTPScreenWidth / 2 - 32, 41, 64, 64)];
    imgV.layer.masksToBounds = YES;
    imgV.layer.cornerRadius = 32;
    [imgV sd_setImageWithURL:[NSURL URLWithString:self.modeContentOne.channelInfo.photo] placeholderImage:[UIImage imageNamed:@"icon_need_head"]];
    [headView addSubview:imgV];


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 119, kTPScreenWidth, 13)];
    label.textColor = RGB(255, 255, 255);
    label.text = @" ";

    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    [headView addSubview:label];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 143, kTPScreenWidth, 13)];
    label2.textColor = RGB(255, 255, 255);
    label2.text = @" ";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:12];
    [headView addSubview:label2];

    _headBtn              = [UIButton buttonWithType:UIButtonTypeCustom];
    _headBtn.layer.borderColor = RGB(179, 179, 179).CGColor;
    _headBtn.layer.borderWidth = 1;
    if ([self.modeContentOne.channelInfo.collected isEqualToString:@"1"]) {
        [_headBtn setTitle:@"取消关注" forState:(UIControlStateNormal)];
        [_rightBtn1 setTitle:@"取消关注" forState:(UIControlStateNormal)];

    }else{
        [_headBtn setTitle:@"关注" forState:(UIControlStateNormal)];
        [_rightBtn1 setTitle:@"关注" forState:(UIControlStateNormal)];

    }
    _headBtn.titleLabel.font = Font_Chinease_Normal(10);
    [_headBtn setTitleColor:RGB(179, 179, 179) forState:(UIControlStateNormal)];
    [_headBtn addTarget:self action:@selector(exitfeekLiikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_headBtn];
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(label);
        make.top.equalTo(label2.mas_bottom).offset(13);
        make.width.offset(80);
        make.height.offset(20);

    }];

    if (self.modeContentOne.channelInfo) {
        label2.text = [NSString stringWithFormat:@"%@",self.modeContentOne.channelInfo.summary];
        label.text = [NSString stringWithFormat:@"%@",self.modeContentOne.channelInfo.name];
    }
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_arrayContent.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTPScreenWidth * 0.5625;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:[ABFeedCell identifier]];
    if (cell == nil)
    {
        cell = [[ABFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[ABFeedCell identifier]];
        cell.delegate = self;
    }
    
    ABContentResult *modeContent  = [m_arrayContent objectAtIndex:indexPath.row];
    [cell updateData:modeContent needShowReviewAndSpeard:YES index:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABContentResult *modeContent            = [m_arrayContent objectAtIndex:indexPath.row];
    ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
    ABVideoDetailVC* vc                     = [[ABVideoDetailVC alloc] initWithContentids:modelContentInfo.ids needShowKeyboard:YES];
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];

//    [self.navigationController pushViewController:vc animated:YES];
    [vc setVideoDetailName:modelContentInfo.title];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view         = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > 180) {
        self.label1.hidden = NO;
        self.bgView.hidden = NO;
        self.rightBtn1.hidden = NO;
        self.rightBtn2.hidden = YES;
        
    }else{
        self.label1.hidden = YES;
        self.bgView.hidden = YES;
        self.rightBtn1.hidden = YES;
        self.rightBtn2.hidden = NO;
    }
}


#pragma mark - touch Action


#pragma mark - delegate
- (void)deActionEnterChannel:(NSInteger)_index
{
    NSLog(@"点击进入频道:%ld  这里啥都不干" , _index);
}

- (void)deActionLikesUser:(NSInteger)_index
{
    ABContentResult *modeContent            = [m_arrayContent objectAtIndex:_index];
    ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
    ABUserLikeListVC *vcLikesList = [[ABUserLikeListVC alloc] initWithContentids:modelContentInfo.ids];
    [self.navigationController pushViewController:vcLikesList animated:YES];
}

- (void)deActionReview:(NSInteger)_index
{
    ABContentResult *modeContent            = [m_arrayContent objectAtIndex:_index];
    ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
    ABVideoDetailVC* vc                     = [[ABVideoDetailVC alloc] initWithContentids:modelContentInfo.ids needShowKeyboard:YES];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setVideoDetailName:modelContentInfo.title];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



#pragma mark ----- 自定义按钮方法
- (void)exitfeekLiikeAction:(UIButton *)button{
    //是否收藏
    ______WS();
    BOOL isCollectioned = [self.modeContentOne.channelInfo.collected isEqualToString:@"1"];
    if (isCollectioned) {

        [_rightBtn1 setTitle:@"取消关注" forState:(UIControlStateNormal)];
        [_headBtn setTitle:@"取消关注" forState:(UIControlStateNormal)];
    }else{
        [_rightBtn1 setTitle:@"关注" forState:(UIControlStateNormal)];
        [_headBtn setTitle:@"关注" forState:(UIControlStateNormal)];
    }
    [ABCollectionStateModel requestCollectionState:(isCollectioned ? @"1" : @"2") collectedIds:self.modeContentOne.contentInfo.channel_ids type:@"2" block:^(NSDictionary *resultObject)
     {
         ABCollectionStateModel* model = [[ABCollectionStateModel alloc] initWithDictionary:resultObject error:nil];
         if (model.rspCode.integerValue == 200)
         {
             if(isCollectioned)
             {
                 wSelf.modeContentOne.channelInfo.collected = @"0";
             }
             else
             {
                 wSelf.modeContentOne.channelInfo.collected = @"1";
             }
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


- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction{
    if (!_shareView) {
        self.shareView = [[ChannelShareView alloc] initWithFrame:CGRectMake(0, kTPScreenHeight, kTPScreenWidth, kTPScreenHeight)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClose)];
        self.shareView.from = @"channel";
        [self.shareView addGestureRecognizer:tap];
        [self.shareView.cancel_btn addTarget:self action:@selector(tapClose) forControlEvents:(UIControlEventTouchUpInside)];

        [[UIApplication sharedApplication].delegate.window addSubview:self.shareView];
    }
    [self shareViewlife];
}


// 分享
- (void)ChannelShareView_TapShare:(NSNotification *)notic{
    NSLog(@"点击分享");
    if(!_modeContentOne)
    {
        TOAST_FAILURE(@"暂无分享数据");
        return;
    }
    NSDictionary *dic = notic.userInfo;
    UMSocialUrlResource *source = [[UMSocialUrlResource alloc] init];
    source.resourceType = UMSocialUrlResourceTypeVideo;
    NSLog(@"%@",urlChannelShare(_modeContentOne.channelInfo.ids));
//    source.url=[urlChannelShare(_modeContentOne.channelInfo.ids) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    source.url = urlChannelShare(_modeContentOne.channelInfo.ids);

    NSLog(@"%@",source.url);
//    source.url =  urlChannelShare(_modeContentOne.channelInfo.ids,_modeContentOne.channelInfo.name);
   UIImage *image   = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_modeContentOne.channelInfo.photo]] scale:1];
    
    if ([dic[@"type"] isEqualToString:@"2"]) {
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_modeContentOne.channelInfo.summary image:image location:nil urlResource:source presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    
    if ([dic[@"type"] isEqualToString:@"1"]) {
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_modeContentOne.channelInfo.name image:image location:nil urlResource:source presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {;
                NSLog(@"分享成功！");
            }
        }];
    }
    
    if ([dic[@"type"] isEqualToString:@"3"]) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_modeContentOne.channelInfo.name image:image location:nil urlResource:source presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    
    
    if ([dic[@"type"] isEqualToString:@"5"]) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_modeContentOne.channelInfo.name image:image location:nil urlResource:source presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    
    
    if ([dic[@"type"] isEqualToString:@"4"]) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_modeContentOne.channelInfo.name image:image location:nil urlResource:source presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    
}

@end
