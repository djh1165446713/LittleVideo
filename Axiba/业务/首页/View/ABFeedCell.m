//
//  ABFeedCell.m
//  Axiba
//
//  Created by Nemofish on 16/06/9.
//  Copyright (c) 2016年 Nemofish. All rights reserved.
//

#import "ABFeedCell.h"
#import "WMPlayer.h"
#import "VideoModel.h"
#import "ABCommonViewManager.h"
#import "UMSocial.h"
#import "ABCollectionStateModel.h"
#import "ABUser.h"
#import "ABActionLikeModel.h"
#import "ABAddViewModel.h"

#define kHeightOfLikeHeight     26
#define kHeightOfReviewHeight   20
#define kHeightOfSpace          12
#define kHeightOfVideo      kTPScreenWidth * 0.5625
#define WMVideoSrcName(file) [@"WMPlayer.bundle" stringByAppendingPathComponent:file]
#define colorTextGray           RGB(179, 179, 179);
#define UILABEL_LINE_SPACE 6

@interface ABFeedCell()
{
    NSIndexPath         *m_indexPath;
    BOOL                m_isNeedShowReviewAndSpeard;
    NSInteger           m_iCountReview;
    WMPlayer            *ui_player;
    ABContentResult     *m_model;
    BOOL                m_needRelease;
}

@end

@implementation ABFeedCell
@synthesize delegate;

+ (NSString*)identifier
{
    return @"ABFeedCellIdentifier";
}

#pragma mark - Layout Initialization

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle     = UITableViewCellSelectionStyleNone;
        self.backgroundColor    = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.frame  = CGRectMake(0, 0, kTPScreenWidth, 0);
        self.contentView.layer.masksToBounds    = YES;
        self.layer.masksToBounds                = YES;
        m_needRelease           = YES;
        
        //视频部分
        UIImageView *imvVideo       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame),kHeightOfVideo)];
        imvVideo.contentMode        = UIViewContentModeScaleAspectFill;
        imvVideo.backgroundColor    = [UIColor darkGrayColor];
        imvVideo.userInteractionEnabled = YES;
        imvVideo.layer.masksToBounds= YES;
        imvVideo.stringTag          = @"tag_imv_video_bg";
        [self.contentView addSubview:imvVideo];
        
        
        self.backMatte       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame),kHeightOfVideo)];
        self.backMatte .backgroundColor    = [UIColor blackColor];
        self.backMatte .alpha = 0.3;
        self.backMatte .layer.masksToBounds= YES;
        [self.contentView addSubview:self.backMatte ];
        UITapGestureRecognizer  *gesTapVideo    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGesTapVideo:)];
        gesTapVideo.numberOfTapsRequired        = 1;
        gesTapVideo.numberOfTouchesRequired     = 1;
        [self.backMatte  addGestureRecognizer:gesTapVideo];

        
        UILabel *labelTitle         = [[UILabel alloc] init];
        labelTitle.textColor        = [UIColor whiteColor];
        labelTitle.textAlignment    = NSTextAlignmentLeft;
        labelTitle.font             = Font_Chinease_Normal(16);
        labelTitle.userInteractionEnabled = YES;
        labelTitle.stringTag        = @"tag_label_title";
        [self.contentView addSubview:labelTitle];
        
        
        self.channelName = [[UILabel alloc] init];
        self.channelName.textColor        = RGB(179, 179, 179);
        self.channelName.textAlignment = NSTextAlignmentLeft;
        self.channelName.font             = Font_Chinease_Normal(12);
        self.channelName.userInteractionEnabled = YES;
        [self.contentView addSubview:self.channelName];


        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(pauseWMPlayer:) name:Notifycation_Pause_Video object:nil];
    }
    return self;
}

+ (CGFloat)heightForCell:(ABContentResult *)_model isNeedShowGotoReviewAndSpeard:(BOOL)_isNeedShow
{
    NSString *strTitle     = _model.contentInfo.summary;
    CGSize sizeContent     = [ABFeedCell calculateLabelHeightByText:Font_Chinease_Normal(13) width:(kTPScreenWidth-16) heightMax:2000 content:strTitle];
    float fBaseHeight      = 125 + (sizeContent.height+10) + kHeightOfVideo;
    BOOL isHaveLikes       = _model.praiseInfo.praiseTotal.integerValue > 0;
    NSInteger iReviewCount = _model.commentInfo.total != nil ? [_model.commentInfo.total integerValue] : 0;

    if(isHaveLikes)
    {
        fBaseHeight = fBaseHeight + kHeightOfLikeHeight;
    }
    
    if(_isNeedShow)
    {
        if(iReviewCount <= 3)
            fBaseHeight = fBaseHeight + iReviewCount * kHeightOfReviewHeight;
        else
            fBaseHeight = fBaseHeight + 4 * kHeightOfReviewHeight;
    }
    else
    {
        fBaseHeight = fBaseHeight - kHeightOfSpace;
    }
    
    return fBaseHeight;
}


+ (CGFloat)heightForC1ell:(ABContentResult *)_model isNeedShow1GotoReviewAndSpeard:(BOOL)_isNeedShow
{

    NSString *strTitle     = _model.contentInfo.summary;
    CGSize sizeContent     = [ABFeedCell calculateLabelHeightByText:Font_Chinease_Normal(13) width:(kTPScreenWidth-16) heightMax:2000 content:strTitle];
    float fBaseHeight      = 125 + (sizeContent.height+10) + kHeightOfVideo;
    BOOL isHaveLikes       = _model.praiseInfo.praiseTotal.integerValue > 0;
    NSInteger iReviewCount = _model.commentInfo.total != nil ? [_model.commentInfo.total integerValue] : 0;
    
    
    
    
    if(isHaveLikes)
    {
        fBaseHeight = fBaseHeight + kHeightOfLikeHeight;
    }
    
    
    if(_isNeedShow)
    {
        if(iReviewCount <= 3)
            fBaseHeight = fBaseHeight + iReviewCount * kHeightOfReviewHeight;
        else
            fBaseHeight = fBaseHeight + 4 * kHeightOfReviewHeight;
    }
    else
    {
        fBaseHeight = fBaseHeight - kHeightOfSpace;
    }
    
    return fBaseHeight;
}


#pragma mark - public mehtod
-(void)releaseWMPlayer
{
    if(!ui_player) return;
    
    [ui_player.player.currentItem cancelPendingSeeks];
    [ui_player.player.currentItem.asset cancelLoading];
    [ui_player.player pause];
    [ui_player removeFromSuperview];
    [ui_player.playerLayer removeFromSuperlayer];
    [ui_player.player replaceCurrentItemWithPlayerItem:nil];
    ui_player               = nil;
    ui_player.player        = nil;
    ui_player.currentItem   = nil;
    ui_player.playOrPauseBtn= nil;
    ui_player.playerLayer   = nil;
}

- (void)pauseWMPlayer
{
    [self pauseWMPlayer:nil];
}

- (void)pauseWMPlayer:(NSNotification *)_notification
{
    if(!ui_player) return;
    
    //如果有本对象发出,则不做处理
    if(_notification && [[_notification.userInfo allKeys] containsObject:@"info"])
    {
        WMPlayer *player = [_notification.userInfo objectForKey:@"info"];
        if(player == ui_player)
        {
            return;
        }
    }
    
    [ui_player.player.currentItem cancelPendingSeeks];
    [ui_player.player.currentItem.asset cancelLoading];
    [ui_player.playOrPauseBtn setSelected:YES];
    [ui_player.player pause];
}

- (void)setNeedReleasePlayerWhenReload:(BOOL)_needRelease
{
    m_needRelease = _needRelease;
}

- (void)updateData:(ABContentResult *)_model needShowReviewAndSpeard:(BOOL)_isNeedShowReviewAndSpeard index:(NSIndexPath *)_indexPath
{
    m_model                     = _model;
    m_iCountReview              = m_model.commentInfo.total != nil ? [m_model.commentInfo.total integerValue] : 0;
    [self updateData:_isNeedShowReviewAndSpeard index:_indexPath];
}

- (void)updateData:(BOOL)_isNeedShowReviewAndSpeard index:(NSIndexPath *)_indexPath
{
    m_isNeedShowReviewAndSpeard = _isNeedShowReviewAndSpeard;
    if(m_needRelease)
        [self releaseWMPlayer];
    
    m_indexPath = _indexPath;
    
//    //头部
    UILabel *labelTitle     = (UILabel *)[self.contentView viewWithStringTag:@"tag_label_title"];
    UIImageView *imvVideo   = (UIImageView *)[self.contentView viewWithStringTag:@"tag_imv_video_bg"];

//    //动态设置title名字
    ______WS();
    labelTitle.numberOfLines    = 0;
    labelTitle.lineBreakMode    = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(kTPScreenWidth - 30, 9999);//labelsize的最大值
    NSString *strTitle      = m_model.contentInfo.title;
    labelTitle.text         = strTitle;
    CGSize expectSize = [labelTitle sizeThatFits:maximumLabelSize];

    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.contentView.mas_left).offset(15);
        make.bottom.equalTo(wSelf.contentView.mas_bottom).offset(-30);
        make.height.offset(expectSize.height);
        make.right.equalTo(wSelf.contentView.mas_right).offset(-15);

    }];
    
    self.channelName.text = [NSString stringWithFormat:@"%@ /",m_model.channelInfo.classify_name];
    [self.channelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(labelTitle.mas_top).offset(-5);
        make.height.offset(17);
        make.width.offset(wSelf.contentView.width);
        make.left.equalTo(wSelf.contentView.mas_left).offset(15);

    }];
    
    labelTitle.text         = strTitle;
    imvVideo.frame          = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame),kHeightOfVideo);
    [imvVideo sd_setImageWithURL:[NSURL URLWithString:m_model.contentInfo.photo]];
    
}



- (void)setReviewBtnHidden:(BOOL)_hidden
{
    UIButton *btnFeedReview     = (UIButton *)[self.contentView viewWithStringTag:@"tag_btn_feed_review"];
    btnFeedReview.hidden        = _hidden;
    UIButton *btnFeedLike       = (UIButton *)[self.contentView viewWithStringTag:@"tag_btn_feed_like"];
    UIButton *btnFeedShare      = (UIButton *)[self.contentView viewWithStringTag:@"tag_btn_feed_share"];
    btnFeedShare.frame          = CGRectMake(_hidden ? CGRectGetMaxX(btnFeedLike.frame):CGRectGetMaxX(btnFeedReview.frame), CGRectGetMinY(btnFeedShare.frame), CGRectGetWidth(btnFeedShare.frame), CGRectGetHeight(btnFeedShare.frame));
    UIButton *btnFeedJuBao      = (UIButton *)[self.contentView viewWithStringTag:@"tag_btn_feed_jubao"];
    btnFeedJuBao.hidden         = !_hidden;
}

/*!
 @abstract 计算高度
 */
+ (CGSize)calculateLabelHeightByText:(UIFont *)_font
                               width:(float)_fWidth
                           heightMax:(float)_fHeightMax
                             content:(NSString *)_strContent
{
    CGSize size             = CGSizeMake(_fWidth,_fHeightMax); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: _font};
    CGSize labelsize        = [_strContent boundingRectWithSize:size
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:attribute
                                                        context:nil].size;
    return labelsize;
    
}


#pragma mark - onAction
- (void)onActionEnterChannel:(UIButton *)_button
{
    if(delegate && [delegate respondsToSelector:@selector(deActionEnterChannel:)])
    {
        [delegate deActionEnterChannel:m_indexPath.row];
    }
}

- (void)onActionEnterLikes:(UIButton *)_button
{
    if(delegate && [delegate respondsToSelector:@selector(deActionLikesUser:)])
    {
        [delegate deActionLikesUser:m_indexPath.row];
    }
}

- (void)actionGesTapVideo:(UIGestureRecognizer *)_gesture
{
    NSLog(@"点击播放视频");
    NSString *strVideoUrl   = m_model.contentInfo.link;
    if(![strVideoUrl isValid])
    {
        NSLog(@"说明视频不存在");
        TOAST_FAILURE(@"视频不存在");
        return;
    }
    
    if(_gesture.state == UIGestureRecognizerStateEnded)
    {
        VideoModel *model   = [[VideoModel alloc] init];
        model.mp4_url       = strVideoUrl;

        if(!ui_player)
        {
            ui_player = [[WMPlayer alloc]initWithFrame:_gesture.view.frame videoURLStr:model.mp4_url videoTitleStr:model.title];
            [ui_player.player play];
        }
        
        [ABAddViewModel requestAddView:m_model.contentInfo.ids block:^(NSDictionary *resultObject) {
        } failure:^(NSError *requestErr) {
        }];
        
        [self.contentView addSubview:ui_player];
    }
}

- (void)onActionFeedLike:(UIButton *)_button
{
    if (![ABUser isLoginedAndPresent])
    { return; }
    
    __weak typeof(self) wSelf = self;
    __weak typeof(_button) wButton = _button;
    BOOL isPraised = ![m_model.contentInfo.praised isEqualToString:@"0"];
    [ABActionLikeModel requestActionLike:m_model.contentInfo.ids op:isPraised?@"2":@"1" block:^(NSDictionary *resultObject)
    {
        ABActionLikeModel* model = [[ABActionLikeModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200)
        {
            [m_model.contentInfo setPraised:isPraised?@"0":@"1"];
            [wButton setSelected:!isPraised];
            
            ABLoginUser *userLogin = [ABUser sharedInstance].abuser.user;
            if([wButton isSelected])
            {
                m_model.praiseInfo.praiseTotal = [NSNumber numberWithInteger:m_model.praiseInfo.praiseTotal.integerValue+1];

                ABLikeUserModel *userModel     = [[ABLikeUserModel alloc] init];
                userModel.nickname             = userLogin.nickname;
                userModel.ids                  = userLogin.ids;
                userModel.avator               = userLogin.avator;

                NSMutableArray<ABLikeUserModel *> *arrayPraise = [[NSMutableArray<ABLikeUserModel *> alloc] initWithArray:m_model.praiseInfo.praise];
                [arrayPraise insertObject:userModel atIndex:0];
                m_model.praiseInfo.praise                      = [arrayPraise copy];
            }
            else
            {
                NSMutableArray<ABLikeUserModel *> *arrayPraise = [[NSMutableArray<ABLikeUserModel *> alloc] initWithArray:m_model.praiseInfo.praise];
                int i = 0;
                for(ABLikeUserModel *modelLike in arrayPraise)
                {
                    if([modelLike.ids isEqualToString:userLogin.ids])
                    {
                        break;
                    }
                    i++;
                }
                
                if(i < arrayPraise.count)
                {
                    [arrayPraise removeObjectAtIndex:i];
                    m_model.praiseInfo.praise      = [arrayPraise copy];
                    m_model.praiseInfo.praiseTotal = [NSNumber numberWithInteger:m_model.praiseInfo.praiseTotal.integerValue-1];
                }
            }
            
            BOOL needReleaseOld = m_needRelease;
            m_needRelease = NO;
            [wSelf updateData:m_model needShowReviewAndSpeard:m_isNeedShowReviewAndSpeard index:m_indexPath];
            [self setReviewBtnHidden:!m_isNeedShowReviewAndSpeard];
            m_needRelease = needReleaseOld;
            if(delegate && [delegate respondsToSelector:@selector(deReloadCell:)])
            {
                [delegate deReloadCell:m_indexPath];
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

- (void)onActionFeedReview:(UIButton *)_button
{
    NSLog(@"点击评论");
    
    if (![ABUser isLoginedAndPresent])
        return;
    
    if(delegate && [delegate respondsToSelector:@selector(deActionReview:)])
    {
        [delegate deActionReview:m_indexPath.row];
    }
}

- (void)onActionFeedShare:(UIButton *)_button
{
    [self pauseWMPlayer];
    
//    NSString *strPageNumber = [NSString stringWithFormat:@"%ld" , m_indexPath.row/10+1];
    UIImageView *imvVideo   = (UIImageView *)[self.contentView viewWithStringTag:@"tag_imv_video_bg"];
    [[ABCommonViewManager shareInstance] showShareView:@"看爱豆就上今日娱乐头条"
                                        defaultContent:@""
                                                 image:imvVideo.image
                                                 title:m_model.contentInfo.title
                                                   url:urlVideoShare(m_model.contentInfo.ids)
                                           description:m_model.contentInfo.summary
                                            contentids:m_model.contentInfo.ids
                                           isCollected:[@"1" isEqualToString:m_model.contentInfo.collected]
                                                 block:^(NSString *strPlatName ,BOOL success, NSError *error)
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
                BOOL isCollectioned = [m_model.contentInfo.collected isEqualToString:@"1"];
                [ABCollectionStateModel requestCollectionState:(isCollectioned ? @"0" : @"1") collectedIds:m_model.contentInfo.ids type:@"1" block:^(NSDictionary *resultObject)
                 {
                     ABCollectionStateModel* model = [[ABCollectionStateModel alloc] initWithDictionary:resultObject error:nil];
                     if (model.rspCode.integerValue == 200)
                     {
                         if(isCollectioned)
                         {
                             m_model.contentInfo.collected = @"0";
                             TOAST_SUCCESS(@"取消收藏成功");
                         }
                         else
                         {
                             m_model.contentInfo.collected = @"1";
                             TOAST_SUCCESS(@"收藏成功");
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

- (void)onActionFeedJuBao:(UIButton *)_button
{
    TOAST_SUCCESS(@"举报成功");
}

- (void)dealloc
{
    [self releaseWMPlayer];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}


#pragma mark - private method
-  (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result= nil;
    UIWindow * window       = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView   = [[window subviews] objectAtIndex:0];
    id nextResponder    = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
