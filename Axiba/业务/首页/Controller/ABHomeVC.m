//
//  ABHomeVC.m
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABHomeVC.h"
#import "ABSearchVC.h"
#import "ABFeedCell.h"
#import "UIView+MJExtension.h"
#import "MJRefresh.h"
#import "ABVideoDetailVC.h"
#import "ABCommonDataManager.h"
#import "ABChannelDetailVC.h"
#import "SDCycleScrollView.h"
#import "ABUserLikeListVC.h"
#import "ABHomeIndexModel.h"
#import "ABBannersModel.h"
#import "ABContentsModel.h"
#import "CTWebViewVC.h"
#import <UIViewController+MMDrawerController.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "HeaderADView.h"
#import "LoopHeaderView.h"
#import "CoverADView.h"
#import "HomeAdCell.h"
#import "AppDelegate.h"

@interface ABHomeVC ()<UITableViewDataSource , UITableViewDelegate , ABFeedCellDelegate , SDCycleScrollViewDelegate>
{
    NSInteger                                            m_iCurrentIndex;    //记录当前选择的功能项位置
    ABUpdateUserDataModel                               *m_modelClassify;
    ABBannersModel                                      *m_modelBanner;
    NSMutableArray<NSMutableArray<ABContentResult*> *>  *m_arrayContent;    //元素的NSMutable中的内容是ABContentResult对象
    NSMutableArray<NSString *>                          *m_arrayPage;
}


@property (nonatomic , strong) SDCycleScrollView        *ui_cycleView;
@property (nonatomic , strong) CoverADView *viewCover;
@property (nonatomic , strong) GuanggaoMoreModel *bannermd;
@property (nonatomic , strong) GuanggaoMoreModel *channlemd;

@property (nonatomic , assign) NSInteger adNumber;
@property (nonatomic , strong) UIImageView *btnMenu_img;    // 侧滑按钮
@property (nonatomic , strong) HeaderADView      *adHview;
@property (nonatomic , strong) LoopHeaderView      *loopHview;
@property (nonatomic , assign) BOOL      isFristShareAd;
@property (nonatomic , strong) GuanggaoMoreModel *sharemd;
@property (nonatomic , strong) GuanggaoMoreModel *hotmd;


@end

@implementation ABHomeVC

- (NSMutableArray *)arrayUrls{
    if (!_arrayUrls) {
        _arrayUrls = [NSMutableArray array];
    }
    return _arrayUrls;
}

@synthesize ui_cycleView;
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //未启动时－》接收推送消息
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.userInfo) {
        
        //1.userInfo就是推送传来的数据
        NSDictionary *pushMsgDic = app.userInfo;
        
        //2.以pushMsgType字段作判断,跳转不同的界面
        NSString   *contentids = [pushMsgDic objectForKey:@"contentids"];
        ABVideoDetailVC* vc                     = [[ABVideoDetailVC alloc] initWithContentids:contentids needShowKeyboard:NO];
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
    }  
    _isFristShareAd = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestVideoListshareAd];
    [self requestVideoListhotAd];
    [self initUI];
    
    if (![ABUser isLogined]) {
        [UMessage addAlias:[ABUser sharedInstance].abuser.user.ids type:@"userId" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
 
        }];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];  
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notificationUpdateMain:) name:Notifycation_Main_Fun object:nil];
    [center addObserver:self selector:@selector(bannerADpost) name:@"bannerADpost" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selctVideoJump_post_action:) name:@"selctVideoJump_post" object:nil];
    _btnMenu_img.hidden = NO;
    if ([ABUser isLogined]) {
        [_btnMenu_img sd_setImageWithURL:[NSURL URLWithString:[[[[ABUser sharedInstance] abuser] user] avator]]   placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
    }
    else {
        _btnMenu_img.image = [UIImage imageNamed:@"icon_default_head"];
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:Notifycation_Pause_Video object:nil];
    [center removeObserver:self];
    _btnMenu_img.hidden = YES;
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}


- (void)initUI
{
    ______WS();

//    self.itemTitle  = @"首页";
    self.view.frame = CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight-kTPNavBarHeight);
    m_iCurrentIndex = 0;
    [self showLoading];
    
    //head init
    UIView *viewHeadFunction            = [[UIView alloc] initWithFrame:CGRectMake(50*kTPScreenScale, (kTPNavBarHeight-36)/2,
                                                                                   220*kTPScreenScale, 36)];
    viewHeadFunction.stringTag          = @"tag_view_title_function";
    self.navigationItem.titleView       = viewHeadFunction;
    
    //搜索按钮
    UIButton *btnBarSearch          = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBarSearch.frame              = CGRectMake(0 , 0, 44, CGRectGetHeight(viewHeadFunction.frame));
    [btnBarSearch setImage:[UIImage imageNamed:@"ico_home_search"] forState:UIControlStateNormal];
    btnBarSearch.imageEdgeInsets    = UIEdgeInsetsMake(5, 12, 5, 0);
    btnBarSearch.imageView.contentMode  = UIViewContentModeScaleAspectFit;
    btnBarSearch.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [btnBarSearch addTarget:self action:@selector(onActionSearchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnBarSearch.stringTag          = @"tag_btn_head_search";
    UIBarButtonItem *rightBarItem   = [[UIBarButtonItem alloc] initWithCustomView:btnBarSearch];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
//    侧边菜单按钮
    _btnMenu_img       = [[UIImageView alloc] init];
    _btnMenu_img.frame              = CGRectMake(18 , 8, 28, 28);
    _btnMenu_img.stringTag          = @"tag_btn_head_menu";
    _btnMenu_img.layer.masksToBounds = YES;
    _btnMenu_img.layer.cornerRadius = 14;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onActionMenuBtnClicked:)];
    _btnMenu_img.userInteractionEnabled = YES;
    [_btnMenu_img addGestureRecognizer:tap];
    [self.navigationController.navigationBar addSubview:_btnMenu_img];

    
    UITableView *tableViewContent   = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    tableViewContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewContent.delegate       = self;
    tableViewContent.dataSource     = self;
    tableViewContent.showsVerticalScrollIndicator   = NO;
    tableViewContent.backgroundColor= [UIColor clearColor];
    tableViewContent.stringTag      = @"tag_table_content";
    [self.view addSubview:tableViewContent];
    [self setExtraCellLineHidden:tableViewContent];
    [tableViewContent registerClass:[HomeAdCell class] forCellReuseIdentifier:@"adcell"];
    
    [tableViewContent addPullRefreshHandle:^{
        if(m_arrayPage.count > m_iCurrentIndex)
        {
            [m_arrayPage replaceObjectAtIndex:m_iCurrentIndex withObject:(m_iCurrentIndex == 0 ? @"0" : @"1")];
        }
        wSelf.isFristShareAd = YES;
        [wSelf actionMainTypeChanged];
    }];
    
    [tableViewContent addPullNextHandle:^{
        if(m_arrayPage.count > m_iCurrentIndex)
        {
            NSInteger iPage = [m_arrayPage objectAtIndex:m_iCurrentIndex].integerValue;
            iPage ++;

            [m_arrayPage replaceObjectAtIndex:m_iCurrentIndex withObject:[NSString stringWithFormat:@"%ld" , (long)iPage]];
        }
        [wSelf actionMainTypeChanged];
    }];
    [self updateMainFunction];
}

#pragma mark - private method
- (void)actionMainTypeChanged
{
//    ______WS();

    if(m_iCurrentIndex == 0)
    {
        self.isFristShareAd = YES;
        [self requestBannerAndContent];
    }
    else
    {
        self.isFristShareAd = NO;
        [self requestContent];
    }
}


/*!
 @abstract 更新首页大功能项
 */
- (void)updateMainFunction
{
    m_modelClassify = [ABCommonDataManager getClassifyModel];
    if(!m_modelClassify) return;
    
    m_arrayContent              = [[NSMutableArray alloc] init];
    m_arrayPage                 = [[NSMutableArray alloc] init];
    NSInteger iCountClassify    = m_modelClassify.rspObject.classify.count;
    for(int i = 0 ; i < iCountClassify ; i++)
    {
        NSMutableArray *arrayNull  = [[NSMutableArray alloc] init];
        [m_arrayContent addObject:arrayNull];
        [m_arrayPage addObject:@"1"];
    }
    
    UIView *viewHeadFunction    = [self.navigationController.navigationBar viewWithStringTag:@"tag_view_title_function"];
    for(UIView *viewTemp in viewHeadFunction.subviews)
    {
        [viewTemp removeFromSuperview];
    }
    float fWithFunctionBtn      = MIN(CGRectGetWidth(viewHeadFunction.frame)/m_modelClassify.rspObject.classify.count , 64);
    float fLeftMargin           = (CGRectGetWidth(viewHeadFunction.frame) - fWithFunctionBtn*m_modelClassify.rspObject.classify.count)/2;
    
    int index = 0;
    for(ABClassifyDetailResult *modelTemp in m_modelClassify.rspObject.classify)
    {
        UIButton *btnBarFunction            = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBarFunction.frame                = CGRectMake(fLeftMargin+fWithFunctionBtn*index, 0,
                                                         fWithFunctionBtn, CGRectGetHeight(viewHeadFunction.frame));
        [btnBarFunction setTitle:modelTemp.name forState:UIControlStateNormal];
        [btnBarFunction setTitleColor:colorMainText forState:UIControlStateSelected];
        [btnBarFunction setTitleColor:RGB(172, 172, 172) forState:UIControlStateNormal];
        btnBarFunction.titleLabel.font      = Font_Chinease_Blod(15);
        btnBarFunction.titleLabel.contentMode   = UIViewContentModeCenter;
        btnBarFunction.tintAdjustmentMode   = UIViewTintAdjustmentModeDimmed;
        [btnBarFunction addTarget:self action:@selector(onActionFunBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnBarFunction.tag                  = 100+index;
        [viewHeadFunction addSubview:btnBarFunction];
        [btnBarFunction setSelected:(m_iCurrentIndex == index)];
        
        index ++;
    }
    
    UIView *viewColorCircle = [viewHeadFunction viewWithStringTag:@"tag_view_head_circle"];
    if(!viewColorCircle)
    {
        viewColorCircle = [[UIView alloc] initWithFrame:CGRectMake(fLeftMargin, viewHeadFunction.frame.size.height, fWithFunctionBtn - 2,
                                                                   2)];
        viewColorCircle.backgroundColor     = colorMainText;
//        viewColorCircle.layer.cornerRadius  = 10;
//        viewColorCircle.layer.masksToBounds = YES;

        viewColorCircle.stringTag = @"tag_view_head_circle";
        [viewHeadFunction insertSubview:viewColorCircle atIndex:0];
    }
    
    [self updateLunBoView];
    [self requestBannerAndContent];
    
    if(!m_arrayContent || m_arrayContent.count<=0)
        [self showLoading];
}

/*!
 @method 请求网络数据
 */
- (void)requestBannerAndContent
{
    UITableView *tableViewContent               = (UITableView *)[self.view viewWithStringTag:@"tag_table_content"];
    __weak typeof(tableViewContent) wTableView  = tableViewContent;
    __weak typeof(self) wSelf                   = self;
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
    
    [ABBannersModel requestBannerList:dic blcok:^(NSDictionary *resultObject)  {
        [wTableView.mj_header endRefreshing];
        
        
        ABBannersModel* model = [[ABBannersModel alloc] initWithDictionary:resultObject error:nil];
//        wSelf.urlAd = 
        if (model.rspCode.integerValue == 200)
        {
            //说明是为了推荐数据请求的
            if([wSelf isNeedShowBanner])
            {
                m_modelBanner = model;
            }
            
            [wSelf requestContent];
        }
        else
        {
            TOAST_FAILURE(model.rspMsg);
            [wSelf hideLoading:NO];
        }
        
    } failure:^(NSError *requestErr)
     {
         [wSelf hideLoading:NO];
         [wTableView.mj_header endRefreshing];
         TOAST_ERROR(wSelf, requestErr);
     }];
    
}


// 请求推荐视频流广告
- (void)requestVideoListshareAd{
    ______WS();
        NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
        NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
        [repDic setValue:@"5" forKey:@"position"];
        [[DJHttpApi shareInstance] POST:urlAdSever dict:repDic succeed:^(id data) {
            if (![data[@"rspObject"] isKindOfClass:[NSNull class]]) {
                wSelf.sharemd = [[GuanggaoMoreModel alloc] init];
                [wSelf.sharemd setValuesForKeysWithDictionary:data[@"rspObject"]];
                [repDic setValue:@"1" forKey:@"type"];
                [repDic setValue:wSelf.sharemd.ids forKey:@"aids"];
                [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
                    NSLog(@"推荐页面广告展示: %@",data);
                    [MobClick event:@"recomm_ads_show_num"];
                    
                } failure:^(NSError *error) {
                }];            }
        }
        failure:^(NSError *error) {
        }];
}


// 请求热门视频流广告
- (void)requestVideoListhotAd{
        ______WS();
        NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
        NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
        [repDic setValue:@"6" forKey:@"position"];
        [[DJHttpApi shareInstance] POST:urlAdSever dict:repDic succeed:^(id data) {
            if (![data[@"rspObject"] isKindOfClass:[NSNull class]]) {
                wSelf.hotmd = [[GuanggaoMoreModel alloc] init];
                [wSelf.hotmd setValuesForKeysWithDictionary:data[@"rspObject"]];
                [repDic setValue:@"1" forKey:@"type"];
                [repDic setValue:wSelf.hotmd.ids forKey:@"aids"];
                [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
                    NSLog(@"推荐页面广告展示: %@",data);
                    [MobClick event:@"hot_ads_show_num"];
                    
                } failure:^(NSError *error) {
                }];
            }
        }
        failure:^(NSError *error) {
            
        }];
}


/*!
 @method 请求视频列表
 */
- (void)requestContent
{
    UITableView *tableViewContent               = (UITableView *)[self.view viewWithStringTag:@"tag_table_content"];
    __weak typeof(tableViewContent) wTableView  = tableViewContent;
    __weak typeof(self) wSelf                   = self;
    
    if(m_arrayContent.count <= m_iCurrentIndex || ![m_arrayContent objectAtIndex:m_iCurrentIndex])
    {
        [self showLoading];
    }
    
    ABClassifyDetailResult *modelClassify       = [m_modelClassify.rspObject.classify objectAtIndex:m_iCurrentIndex];
    NSString *strPage                           = [m_arrayPage objectAtIndex:m_iCurrentIndex];
    [ABContentsModel requestContents:strPage classifyids:modelClassify.ids channelId:@"" block:^(NSDictionary *resultObject)
    {
        [wSelf hideLoading:NO];
        [wTableView.mj_header endRefreshing];
        
        NSLog(@"home page number : %@" , [m_arrayPage objectAtIndex:m_iCurrentIndex]);
        
        ABContentsModel* model = [[ABContentsModel alloc] initWithDictionary:resultObject error:nil];
        
        if (model.rspCode.integerValue == 200)
        {
            if (!(model.rspObject.content.count <= 0)) {
                [m_arrayPage replaceObjectAtIndex:m_iCurrentIndex withObject:[NSString stringWithFormat:@"%@" , model.rspObject.page.pageNumber]];
            }
            if([[m_arrayPage objectAtIndex:m_iCurrentIndex] isEqualToString:@"1"])
            {
                [m_arrayContent replaceObjectAtIndex:m_iCurrentIndex withObject:[[NSMutableArray alloc] init]];
            }
            
            if(model.rspObject.content.count > 0)
            {
                BOOL isNeedScrollToTop = NO;
                NSMutableArray *arrayContentInfo = [m_arrayContent objectAtIndex:m_iCurrentIndex];
                if(!arrayContentInfo || arrayContentInfo.count <= 0)
                {
                    isNeedScrollToTop = YES;
                }
                [arrayContentInfo addObjectsFromArray:model.rspObject.content];
                if (wSelf.isFristShareAd && ![arrayContentInfo[2] isKindOfClass:[GuanggaoMoreModel class]] && wSelf.sharemd) {
                    if (m_iCurrentIndex == 0) {
                        [arrayContentInfo insertObject:wSelf.sharemd atIndex:2];
                    }
                }else{
                    if (m_iCurrentIndex == 1 && ![arrayContentInfo[2] isKindOfClass:[GuanggaoMoreModel class]] && wSelf.hotmd) {
                        [arrayContentInfo insertObject:wSelf.hotmd atIndex:2];
                    }
                }
                [m_arrayContent replaceObjectAtIndex:m_iCurrentIndex withObject:arrayContentInfo];
                
                if(m_iCurrentIndex == 0)
                {
                    [wSelf updateLunBoView];
                }
                else
                {
                    [wTableView reloadData];
                    if(isNeedScrollToTop && wTableView)
                    {
                        [wTableView setContentOffset:CGPointMake(0,0) animated:NO];
                    }
                }
                
                [wTableView.mj_footer endRefreshing];
            }
            else
            {
                [wTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else
        {
            TOAST_FAILURE(model.rspMsg);
            [wTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *requestErr)
    {
        [wSelf hideLoading:NO];
        [wTableView.mj_header endRefreshing];
        [wTableView.mj_footer endRefreshing];
        TOAST_ERROR(wSelf, requestErr);
    }];
}

/*!
 @abstract 更新轮播的页面
 */

- (void)updateLunBoView
{
    ______WS();
    ;
    UITableView *tableViewContent = (UITableView *)[self.view viewWithStringTag:@"tag_table_content"];
    if(!m_modelBanner)
    {
        ui_cycleView = nil;
        [tableViewContent reloadData];
        return;
    }
    [self.arrayUrls removeAllObjects];
    for(ABBannerResult *banner in m_modelBanner.rspObject)
    {
        NSString *strUrl = @"nil";
        if([banner.photo isValid])
        {
            strUrl = banner.photo;
        }
        [self.arrayUrls  addObject:strUrl];
    }
    NSInteger count = self.arrayUrls.count;

    if(self.arrayUrls .count <= 0)
    {
        ui_cycleView = nil;
    }
    else
    {
        NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
        NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
        [repDic setValue:@"4" forKey:@"position"];
        [[DJHttpApi shareInstance] POST:urlAdSever dict:repDic succeed:^(id data) {
            GuanggaoMoreModel *moreModel = [[GuanggaoMoreModel alloc] init];

            if (![data[@"rspObject"] isKindOfClass:[NSNull class]]) {
                [moreModel setValuesForKeysWithDictionary:data[@"rspObject"]];
                wSelf.bannermd = moreModel;
                [wSelf.arrayUrls insertObject:moreModel.image atIndex:0];
            }

                ui_cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kTPScreenWidth, 150*kTPScreenScale) imageURLStringsGroup:wSelf.arrayUrls ];
                ui_cycleView.pageControlAliment     = SDCycleScrollViewPageContolAlimentCenter;
                ui_cycleView.delegate               = wSelf;
                ui_cycleView.pageDotColor           = [UIColor whiteColor];
                ui_cycleView.currentPageDotColor    = colorMain;
                ui_cycleView.autoScrollTimeInterval = 3;
            
#pragma mark   ********如果需要左右滑动来控制轮播图,请在第一个广告消失之后进行隐藏*********
                
                if (wSelf.arrayUrls.count > count) {
                    wSelf.viewCover = [[CoverADView alloc] init];
                    wSelf.viewCover.ids = moreModel.ids;
                    [ui_cycleView addSubview:wSelf.viewCover];
                    [wSelf.viewCover mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(ui_cycleView.mas_left).offset(0);
                        make.top.equalTo(ui_cycleView.mas_top).offset(0);
                        make.bottom.equalTo(ui_cycleView.mas_bottom).offset(0);
                        make.right.equalTo(ui_cycleView.mas_right).offset(0);
                    }];
            
                }
                if (wSelf.arrayUrls.count > count) {
                    wSelf.lab = [[UILabel alloc] init];
                    wSelf.lab.text = @"广告";
                    wSelf.lab.backgroundColor = [UIColor blackColor];
                    wSelf.lab.textColor = [UIColor whiteColor];
                    wSelf.lab.font = [UIFont systemFontOfSize:11];
                    wSelf.lab.alpha = 0.5;
                    [ui_cycleView addSubview:wSelf.lab];
            
                    [wSelf.lab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(ui_cycleView.mas_left).offset(0);
                        make.width.offset(30);
                        make.bottom.equalTo(ui_cycleView.mas_bottom).offset(0);
                        make.height.offset(20);
                    }];
            
                }
                
                [tableViewContent reloadData];

//            }
        } failure:^(NSError *error) {
            
        }];
        
        [self requestchannelAd];
    }
    [tableViewContent reloadData];
}


/*!
 @abstract 判断当前是否在推荐下
 */
- (BOOL)isNeedShowBanner
{
    return m_iCurrentIndex == 0;
}


#pragma mark - on Action
/*!
 @method 功能按钮点击
 */
- (void)onActionFunBtnClicked:(UIButton *)_button
{
    for(UIView *viewTemp in _button.superview.subviews)
    {
        if([viewTemp isKindOfClass:[UIButton class]])
        {
            UIButton *btnTemp = (UIButton *)viewTemp;
            [btnTemp setSelected:(btnTemp == _button)];
        }
    }
    
    m_iCurrentIndex = _button.tag-100;
    [m_arrayPage replaceObjectAtIndex:m_iCurrentIndex withObject:[NSString stringWithFormat:@"%ld" , (long)m_iCurrentIndex]];
    [self actionMainTypeChanged];
    UIView *viewColorCircle = [self.navigationController.navigationBar viewWithStringTag:@"tag_view_head_circle"];
    __weak typeof(viewColorCircle) wViewCircle = viewColorCircle;
    [UIView animateWithDuration: 0.3
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         wViewCircle.frame = CGRectMake(CGRectGetMinX(_button.frame), CGRectGetMinY(wViewCircle.frame),
                                                        CGRectGetWidth(wViewCircle.frame), 2);
                     }
                     completion:^(BOOL finished){
                     }];
}


-(void)onActionSearchBtnClicked:(UIButton *)_button
{
    ABSearchVC *vcSearch    = [[ABSearchVC alloc] init];
    [self.navigationController pushViewController:vcSearch animated:NO];
}


- (void)onActionMenuBtnClicked:(UIButton *)button{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)touchAdAction:(UIButton *)button{
    ______WS();
    NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
    NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
    [repDic setValue:@"1" forKey:@"type"];
    [repDic setValue:@"7" forKey:@"position"];
    [repDic setValue:self.channlemd.ids forKey:@"aids"];
    
    [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
        NSLog(@"通道栏广告展示: %@",data);
        [MobClick event:@"plaque_ads_click_num"];
        CTWebViewVC* vc = [[CTWebViewVC alloc] init];
        vc.url          = [NSURL URLWithString:wSelf.channlemd.url];
        vc.title        = wSelf.channlemd.title;
        [wSelf.navigationController pushViewController:vc animated:YES];

    } failure:^(NSError *error) {
    }];
}


#pragma mark - UITableViewDataSource and delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([self isNeedShowBanner] && ui_cycleView)
    {
        if (self.channlemd) {
            return 150*kTPScreenScale + 44 + 315;
        }else{
            return 150*kTPScreenScale + 315;
        }
    }
    else
    {return 0.01;}
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([self isNeedShowBanner] && ui_cycleView)
    {
        UIView *viewHead             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, ui_cycleView ? 150*kTPScreenScale + 12 : 0.01)];
        viewHead.layer.masksToBounds = YES;
        if(ui_cycleView){
            NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
            NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
            [repDic setValue:@"1" forKey:@"type"];
            [repDic setValue:@"4" forKey:@"position"];
            [repDic setValue:self.bannermd.ids forKey:@"aids"];

            [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
                NSLog(@"banner广告展示: %@",data);
                [MobClick event:@"banner_ads_show_num"];

            } failure:^(NSError *error) {
            }];
            [viewHead addSubview:ui_cycleView];
            
        }

        CGFloat height = 0;
        if (self.channlemd) {
            height = 150*kTPScreenScale+44;
            self.adHview = [[HeaderADView alloc] initWithFrame:CGRectMake(0, ui_cycleView ? 150*kTPScreenScale: 0.01, kTPScreenWidth, 44)];
            [self.adHview.adbutton addTarget:self action:@selector(touchAdAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [viewHead addSubview:self.adHview];
            self.adHview.adtitle.text = self.channlemd.summary;
            NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
            NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
            [repDic setValue:@"1" forKey:@"type"];
            [repDic setValue:@"7" forKey:@"position"];
            [repDic setValue:self.channlemd.ids forKey:@"aids"];
            [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
                NSLog(@"通道栏广告展示: %@",data);
                [MobClick event:@"plaque_ads_show_num"];
            } failure:^(NSError *error) {
            }];
        }else{
            height = ui_cycleView ? 150*kTPScreenScale: 0.01;
        }

        self.loopHview = [[LoopHeaderView alloc] initWithFrame:CGRectMake(0,height, kTPScreenWidth, 315) imageURLStringsGroup:nil];
        [viewHead addSubview:self.loopHview];
        return viewHead;
    }
    else
    {
        return [[UIView alloc] init];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!m_arrayContent || m_arrayContent.count <= m_iCurrentIndex)
        return 0;
    else
    {
        NSMutableArray *arrayContentInfo = [m_arrayContent objectAtIndex:m_iCurrentIndex];
        return arrayContentInfo.count;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_arrayContent.count <= m_iCurrentIndex)
    {
        return 0;
    }
    
    NSMutableArray *arrayContentInfo    = [m_arrayContent objectAtIndex:m_iCurrentIndex];
    if(arrayContentInfo.count > indexPath.row)
    {
        return kTPScreenWidth * 0.5625;
    }
    else
        return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 ) {
        if ([m_arrayContent objectAtIndex:m_iCurrentIndex].count > 3 && ([[[m_arrayContent objectAtIndex:m_iCurrentIndex] objectAtIndex: 2] isKindOfClass:[GuanggaoMoreModel class]])) {
            HomeAdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adcell" forIndexPath:indexPath];
            NSMutableArray *arrayContentInfo    = [m_arrayContent objectAtIndex:m_iCurrentIndex];
            cell.model = arrayContentInfo[2];
            return cell;
        }else{
            ABFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:[ABFeedCell identifier]];
            if (cell == nil)
            {
                cell = [[ABFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[ABFeedCell identifier] ];
                cell.delegate   = self;
            }
            
            if(m_arrayContent.count <= m_iCurrentIndex)
            {
                return nil;
            }
            
            NSMutableArray *arrayContentInfo    = [m_arrayContent objectAtIndex:m_iCurrentIndex];
            if(arrayContentInfo.count > indexPath.row)
            {
                ABContentResult *modeContent        = [arrayContentInfo objectAtIndex:indexPath.row];
                [cell updateData:modeContent needShowReviewAndSpeard:YES index:indexPath];
            }
            return cell;
        }
        
    }else{
        ABFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:[ABFeedCell identifier]];
        if (cell == nil)
        {
            cell = [[ABFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[ABFeedCell identifier] ];
            cell.delegate   = self;
        }
        
        if(m_arrayContent.count <= m_iCurrentIndex)
        {
            return nil;
        }
        
        NSMutableArray *arrayContentInfo    = [m_arrayContent objectAtIndex:m_iCurrentIndex];
        if(arrayContentInfo.count > indexPath.row)
        {
            ABContentResult *modeContent        = [arrayContentInfo objectAtIndex:indexPath.row];
            [cell updateData:modeContent needShowReviewAndSpeard:YES index:indexPath];
        }
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_arrayContent.count <= m_iCurrentIndex) return;
    if (indexPath.row == 2 && [[[m_arrayContent objectAtIndex:m_iCurrentIndex] objectAtIndex:2] isKindOfClass:[GuanggaoMoreModel class]]) {
        
        NSMutableArray *arrayContentInfo        = [m_arrayContent objectAtIndex:m_iCurrentIndex];
        GuanggaoMoreModel *adModel            = [arrayContentInfo objectAtIndex:indexPath.row];
        CTWebViewVC* vc = [[CTWebViewVC alloc] init];
        vc.url          = [NSURL URLWithString:adModel.url];
        vc.title        = adModel.title;
        NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
        NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
        [repDic setValue:@"2" forKey:@"type"];
        [repDic setValue:adModel.ids forKey:@"aids"];
        if (m_iCurrentIndex == 0) {
            [repDic setValue:@"5" forKey:@"position"];
            [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
                NSLog(@"推荐页面广告点击: %@",data);
                [MobClick event:@"  recomm_ads_click_num"];
                
            } failure:^(NSError *error) {
            }];
        }else{
            [repDic setValue:@"6" forKey:@"position"];
            [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
                NSLog(@"推荐页面广告点击: %@",data);
                [MobClick event:@"hot_ads_click_num"];
                
            } failure:^(NSError *error) {
            }];
        }

        [repDic setValue:@"6" forKey:@"position"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSMutableArray *arrayContentInfo        = [m_arrayContent objectAtIndex:m_iCurrentIndex];
        ABContentResult *modeContent            = [arrayContentInfo objectAtIndex:indexPath.row];
        ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
        ABVideoDetailVC* vc                     = [[ABVideoDetailVC alloc] initWithContentids:modelContentInfo.ids needShowKeyboard:NO];
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
    }
}


- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view         = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - delegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [MobClick event:@"banner_clickNum_day"];
    if(m_modelBanner && index <= m_modelBanner.rspObject.count)
    {
        
        ABBannerResult *model    = [m_modelBanner.rspObject objectAtIndex:(self.arrayUrls.count > m_modelBanner.rspObject.count)? index - 1:index];
        NSLog(@"点击链接 : %@" , model.link);
        if([@"1" isEqualToString:model.type])
        {
            ABVideoDetailVC* vc = [[ABVideoDetailVC alloc] initWithContentids:model.link needShowKeyboard:NO];
            UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navi animated:YES completion:nil];
        }
    }
}



- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    if (self.arrayUrls.count >= 2) {
        if (index > 0) {
            self.lab.hidden = YES;
            self.viewCover.hidden = YES;
         }else{
            self.lab.hidden = NO;
            self.viewCover.hidden = NO;
        }
    }else{
        if (self.lab && self.viewCover) {
            self.lab.hidden = YES;
            self.viewCover.hidden = YES;
        }
    }
}


#pragma mark - notification
- (void)bannerADpost{
    CTWebViewVC* vc = [[CTWebViewVC alloc] init];
    vc.url          = [NSURL URLWithString:self.bannermd.url];
    vc.title        = self.bannermd.title;
    [self.navigationController pushViewController:vc animated:YES];
}





- (void)notificationUpdateMain:(NSNotification *)_notification
{
    NSLog(@"接收到更新首页UI的通知");
    ABUpdateUserDataModel *modelNew = [ABCommonDataManager getClassifyModel];
    //判断两次classify是否相同
    
    if(modelNew && m_modelClassify)
    {
        if(modelNew.rspObject.classify.count == m_modelClassify.rspObject.classify.count)
        {
            int index  = 0;
            for(ABClassifyDetailResult *modelA in modelNew.rspObject.classify)
            {
                ABClassifyDetailResult *modelB = [m_modelClassify.rspObject.classify objectAtIndex:index];
                if(![modelA.ids isEqualToString:modelB.ids])
                {
                    break;
                }
                index ++;
            }
            //说明是一模一样的，不刷新
            if(index == modelNew.rspObject.classify.count)
            {
                return;
            }
        }
    }
    
    m_modelClassify = modelNew;
    [self updateMainFunction];
}

- (void)selctVideoJump_post_action:(NSNotification *)notic{
    NSDictionary *userIF = notic.userInfo;
    HomeSelectModel *model = userIF[@"userIf"];
    ABVideoDetailVC* vc                     = [[ABVideoDetailVC alloc] initWithContentids:model.ids needShowKeyboard:NO];
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)requestchannelAd{
    ______WS();
    NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
    NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
    [repDic setValue:@"7" forKey:@"position"];
    [[DJHttpApi shareInstance] POST:urlAdSever dict:repDic succeed:^(id data) {
        if (![data[@"rspObject"] isKindOfClass:[NSNull class]]) {
            wSelf.channlemd = [[GuanggaoMoreModel alloc] init];
            [wSelf.channlemd setValuesForKeysWithDictionary:data[@"rspObject"]];
            
        }
    }
    failure:^(NSError *error) {
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
