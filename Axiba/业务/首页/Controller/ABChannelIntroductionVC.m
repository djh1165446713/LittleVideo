//
//  ABChannelDetailVC.m
//  Axiba
//
//  Created by Michael on 16/6/14.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABChannelIntroductionVC.h"
#import "ABCommonViewManager.h"
#import "OmoShareDjhManaage.h"
#import "ABChannelInfoModel.h"
#import "UMSocial.h"
#import "ABCollectionStateModel.h"

@interface ABChannelIntroductionVC ()
{
    NSString            *m_strChannelIds;
    ABChannelInfoModel  *m_model;
}

@end

@implementation ABChannelIntroductionVC

- (id)initWithChannelId:(NSString *)_channelIds
{
    m_strChannelIds = _channelIds;
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
    self.itemTitle      = @"频道简介";
    self.showBackBtn    = YES;
    self.view.frame     = CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight-kTPNavBarHeight);
    
    //分享按钮
    UIButton *btnBarShare           = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBarShare.frame               = CGRectMake(kTPScreenWidth - 62 , 0, 62, 44);
    [btnBarShare setTitle:@"分享" forState:UIControlStateNormal];
    [btnBarShare setTitleColor:colorMain forState:UIControlStateNormal];
    btnBarShare.titleLabel.font     = Font_Chinease_Normal(17);
    btnBarShare.titleEdgeInsets     = UIEdgeInsetsMake(2, 10, 0, -10);
    [btnBarShare addTarget:self action:@selector(onActionShareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem   = [[UIBarButtonItem alloc] initWithCustomView:btnBarShare];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    UIView *viewMain    = [[UIView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-10)];
    viewMain.stringTag  = @"tag_view_main";
    [self.view addSubview:viewMain];
    
    float fHeightHead       = 60;
    float fMarginX          = 8;
    
    UIView *viewHeadBg          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, fHeightHead)];
    viewHeadBg.backgroundColor  = [UIColor whiteColor];
    [viewMain addSubview:viewHeadBg];
    
    UIImageView *imvChannelHead        = [[UIImageView alloc] initWithFrame:CGRectMake(16, 6, fHeightHead-12,fHeightHead-12)];
    imvChannelHead.contentMode         = UIViewContentModeScaleAspectFill;
    imvChannelHead.backgroundColor     = RGB(50, 50, 50);
    imvChannelHead.layer.masksToBounds = YES;
    imvChannelHead.layer.cornerRadius  = CGRectGetHeight(imvChannelHead.frame)/2;
    imvChannelHead.stringTag           = @"tag_imv_channel_head";
    imvChannelHead.hidden              = YES;
    [viewMain addSubview:imvChannelHead];
    
    UILabel *labelChannelName       = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imvChannelHead.frame)+11, 12, CGRectGetWidth(self.view.frame)-fHeightHead-fMarginX*4, 18)];
    labelChannelName.textColor      = RGB(50, 50, 50);
    labelChannelName.font           = Font_Chinease_Blod(15);
    labelChannelName.stringTag      = @"tag_label_channel_name";
    labelChannelName.hidden         = YES;
    [viewMain addSubview:labelChannelName];
   
    UILabel *labelChannelIntro      = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imvChannelHead.frame)+11, CGRectGetMaxY(labelChannelName.frame)+5, CGRectGetWidth(self.view.frame)-fHeightHead-fMarginX*4, 14)];
    labelChannelIntro.textColor     = RGB(90, 90, 90);
    labelChannelIntro.font          = Font_Chinease_Normal(14);
    labelChannelIntro.stringTag     = @"tag_label_channel_intro";
    [viewMain addSubview:labelChannelIntro];
    
    
    UIView *viewLineCenter          = [[UIView alloc] initWithFrame:CGRectMake(0, fHeightHead-0.5, kTPScreenWidth, 0.5)];
    viewLineCenter.backgroundColor  = [UIColor colorWithWhite:0.0 alpha:0.15];
    [viewMain addSubview:viewLineCenter];
    
    //简介内容
    UIView *viewContent         = [[UIView alloc] initWithFrame:CGRectMake(0, fHeightHead, kTPScreenWidth, 0)];
    viewContent.backgroundColor = [UIColor whiteColor];
    viewContent.stringTag       = @"tag_view_content";
    [viewMain addSubview:viewContent];
    
    UILabel *labelContent       = [[UILabel alloc] initWithFrame:CGRectMake(26, 3, kTPScreenWidth-54, 0)];
    labelContent.numberOfLines  = 0;
    labelContent.font           = [UIFont fontWithName:@"Helvetica" size:14];;
    labelContent.textColor      = RGB(50, 50, 50);
    labelContent.stringTag      = @"tag_label_content";
    [viewContent addSubview:labelContent];
    
    for(UIView *viewTemp in viewMain.subviews)
    {
        viewTemp.hidden = YES;
    }
    
    [self requestData];
}


#pragma mark - private method
/*!
 @method 请求网络数据
 */
- (void)requestData
{
    [self showLoading];
    __weak typeof(self) wSelf = self;
//    m_strChannelIds = @"PD0003";
    [ABChannelInfoModel requestChannelInfo:m_strChannelIds block:^(NSDictionary *resultObject)
     {
         [wSelf hideLoading:NO];
         
         ABChannelInfoModel* model = [[ABChannelInfoModel alloc] initWithDictionary:resultObject error:nil];
         if (model.rspCode.integerValue == 200)
         {
             m_model    = model;
             NSLog(@"是否收藏 ： %@" , m_model.rspObject.collected);
             [wSelf updateUI];
         }
         else
         {
             TOAST_FAILURE(model.rspMsg);
         }
         
     } failure:^(NSError *requestErr)
     {
         [wSelf hideLoading:NO];
         TOAST_ERROR(wSelf, requestErr);
     }];
}

- (void)updateUI
{
    if(!m_model) return;
    
    UIView *viewMain = [self.view viewWithStringTag:@"tag_view_main"];
    for(UIView *viewTemp in viewMain.subviews)
    {
        viewTemp.hidden = NO;
    }
    
    UIImageView *imvChannelHead = (UIImageView *)[viewMain viewWithStringTag:@"tag_imv_channel_head"];
    [imvChannelHead sd_setImageWithURL:[NSURL URLWithString:m_model.rspObject.photo] placeholderImage:[UIImage imageNamed:@"icon_need_head"]];
    
    UILabel *labelChannelName   = (UILabel *)[viewMain viewWithStringTag:@"tag_label_channel_name"];
    labelChannelName.text       = m_model.rspObject.name;
    
    UILabel *labelChannelIntro  = (UILabel *)[viewMain viewWithStringTag:@"tag_label_channel_intro"];
    labelChannelIntro.text      = [NSString stringWithFormat:@"明星分类    %@个视频" , m_model.rspObject.total_content];
    
//    NSString *strContent    = @"哈哈哈 的减肥开始的浪费就拉上就的房间里里卡萨丁解放路口就到家了附近的房间爱上了大姐夫拉里卡萨丁解放路口就到家了附近的房间爱上了大姐夫拉里卡萨丁解放路口就到家了附近的房间爱上了大姐夫拉卡萨丁解放路口就到家了附近的房间爱上了大姐夫拉丝机打发拉斯加对方了解到付件莱卡时间都分了就爱上了打开房间辣的减肥拉斯科";
//    strContent = @"111111　";
    NSString *strContent    = [NSString stringWithFormat:@"%@%@", m_model.rspObject.summary , @"　"];
    UIView *viewContent     = [viewMain viewWithStringTag:@"tag_view_content"];
    UILabel *labelContent   = (UILabel *)[viewMain viewWithStringTag:@"tag_label_content"];
    CGSize sizeContent      = [self calculateLabelHeightByText:labelContent.font width:CGRectGetWidth(labelContent.frame) heightMax:2000 content:strContent];
    viewContent.frame       = CGRectMake(CGRectGetMinX(viewContent.frame)  , CGRectGetMinY(viewContent.frame),
                                         CGRectGetWidth(viewContent.frame) , sizeContent.height + 14);
    labelContent.frame      = CGRectMake(CGRectGetMinX(labelContent.frame) , CGRectGetMinY(labelContent.frame),
                                         CGRectGetWidth(labelContent.frame), sizeContent.height + 14);
    NSMutableAttributedString *attrContent  = [[NSMutableAttributedString alloc] initWithString:strContent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attrContent addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strContent length])];
    labelContent.attributedText             = attrContent;
}

- (CGSize)calculateLabelHeightByText:(UIFont *)_font
                               width:(float)_fWidth
                           heightMax:(float)_fHeightMax
                             content:(NSString *)_strContent
{
    CGSize size                             = CGSizeMake(_fWidth,_fHeightMax);//设置一个行高上限
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    NSDictionary *attribute = @{NSFontAttributeName: _font , NSParagraphStyleAttributeName:paragraphStyle};
    CGSize labelsize        = [_strContent boundingRectWithSize:size
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:attribute
                                                        context:nil].size;
    return labelsize;
}


#pragma mark - onAction
- (void)onActionShareBtnClicked:(UIButton *)_button
{
    NSLog(@"点击分享");
    if(!m_model)
    {
        TOAST_FAILURE(@"暂无分享数据");
        return;
    }
    
    UIImageView *imvChannelHead = (UIImageView *)[self.view viewWithStringTag:@"tag_imv_channel_head"];
    [[OmoShareDjhManaage shareInstance] showShareView:@"看爱豆就上今日娱乐头条"
                                        defaultContent:@""
                                                 image:imvChannelHead.image
                                                 title:m_model.rspObject.name
                                                   url:urlChannelShare(m_model.rspObject.ids)
                                           description:m_model.rspObject.theme
                                            contentids:m_model.rspObject.ids
                                           isCollected:[@"1" isEqualToString:m_model.rspObject.collected]
                                                 block:^(NSString *strPlatName , BOOL success, NSError *error)
     {
         if(success)
         {
             //说明是点击收藏
             if([UMShareToEmail isEqualToString:strPlatName])
             {
                 if (![ABUser isLoginedAndPresent]) {
                     return;
                 }
                 
                 //是否收藏
                 BOOL isCollectioned = [m_model.rspObject.collected isEqualToString:@"1"];
                 [ABCollectionStateModel requestCollectionState:(isCollectioned ? @"0" : @"1") collectedIds:m_strChannelIds type:@"2" block:^(NSDictionary *resultObject)
                  {
                      ABCollectionStateModel* model = [[ABCollectionStateModel alloc] initWithDictionary:resultObject error:nil];
                      if (model.rspCode.integerValue == 200)
                      {
                          if(isCollectioned)
                          {
                              m_model.rspObject.collected = @"0";
                              TOAST_SUCCESS(@"取消关注成功");
                          }
                          else
                          {
                              m_model.rspObject.collected = @"1";
                              TOAST_SUCCESS(@"关注成功");
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
             else
             {
                 NSLog(@"分享成功");
             }
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
