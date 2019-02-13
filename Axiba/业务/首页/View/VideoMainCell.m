//
//  VideoMainCell.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/4/18.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "VideoMainCell.h"
#import "WMPlayer.h"
#import "VideoModel.h"
#import "ABCommonViewManager.h"
#import "UMSocial.h"
#import "ABCollectionStateModel.h"
#import "ABUser.h"
#import "ABActionLikeModel.h"
#import "ABAddViewModel.h"
#import "UMSocial.h"

#define kHeightOfLikeHeight     26
#define kHeightOfReviewHeight   20
#define kHeightOfSpace          12
#define kHeightOfVideo      kTPScreenWidth * 0.5625
#define WMVideoSrcName(file) [@"WMPlayer.bundle" stringByAppendingPathComponent:file]
#define colorTextGray           RGB(179, 179, 179);
#define UILABEL_LINE_SPACE 6

@interface VideoMainCell()
{
    NSIndexPath         *m_indexPath;
    BOOL                m_isNeedShowReviewAndSpeard;
    NSInteger           m_iCountReview;
    WMPlayer            *ui_player;
    ABContentResult     *m_model;
    BOOL                m_needRelease;
}
@end

@implementation VideoMainCell
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
        
        ______WS();
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aotuPlayVideo:) name:@"autoVideoPlayNocite" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tap1) name:@"videoEndPost" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoeEndPlay_TapBtn:) name:@"videoeEndPlay_TapBtn" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoeEndPlay_TapShare:) name:@"videoeEndPlay_TapShare" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayVideo:) name:@"pauseVideoPlayNocite" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNumTotla_post:) name:@"changeNumTotla_post" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoeEndPlay_TapShare:) name:@"videoeFullShare_TapShare" object:nil];

        self.selectionStyle     = UITableViewCellSelectionStyleNone;
//        self.backgroundColor    = RGB(22, 21, 16);
        self.contentView.backgroundColor =  RGB(55, 49, 47);
        self.contentView.frame  = CGRectMake(0, 0, kTPScreenWidth, 0);
        self.contentView.layer.masksToBounds    = YES;
        self.layer.masksToBounds                = YES;
        m_needRelease           = YES;
        
        
        //视频部分
        UIImageView *imvVideo       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame),kHeightOfVideo)];
        imvVideo.contentMode        = UIViewContentModeScaleAspectFill;
        imvVideo.backgroundColor    = [UIColor darkGrayColor];
        imvVideo.userInteractionEnabled = YES;
        //        imvVideo.alpha = 0.3;
        imvVideo.layer.masksToBounds= YES;
        imvVideo.stringTag          = @"tag_imv_video_bg";
        [self.contentView addSubview:imvVideo];
        

        self.backMatte       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame),kHeightOfVideo)];
        self.backMatte .backgroundColor    = [UIColor blackColor];
        self.backMatte .alpha = 0.3;
        //        self.backMatte .userInteractionEnabled = YES;
        self.backMatte .layer.masksToBounds= YES;
        [self.contentView addSubview:self.backMatte ];
        UITapGestureRecognizer  *gesTapVideo    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGesTapVideo:)];
        gesTapVideo.numberOfTapsRequired        = 1;
        gesTapVideo.numberOfTouchesRequired     = 1;
        [self.backMatte  addGestureRecognizer:gesTapVideo];
        
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.font = [UIFont systemFontOfSize:15];
        self.titleLab.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView.mas_left).offset(10);
            make.right.equalTo(wSelf.contentView.mas_right).offset(-10);
            make.top.equalTo(imvVideo.mas_bottom).offset(12);
            make.height.offset(16);
        }];
        
        self.type_time = [[UILabel alloc] init];
        self.type_time.textColor = [UIColor whiteColor];
        self.type_time.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.type_time];
        [self.type_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView.mas_left).offset(10);
            make.top.equalTo(wSelf.titleLab.mas_bottom).offset(12);
            make.height.offset(17);
            make.width.offset(74);
        }];
        
        
        
        self.seeImg = [[UIImageView alloc] init];
        self.seeImg.image = [UIImage imageNamed:@"omo_seeNumber_detiel"];
        [self.contentView addSubview:self.seeImg];
        [self.seeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.type_time.mas_right).offset(50);
            make.top.equalTo(wSelf.titleLab.mas_bottom).offset(12);
            make.height.offset(15);
            make.width.offset(15);
        }];
        
        
        
        self.seeNumLab = [[UILabel alloc] init];
        self.seeNumLab.textColor = [UIColor whiteColor];
        self.seeNumLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.seeNumLab];
        [self.seeNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.seeImg.mas_right).offset(7);
            make.centerY.equalTo(wSelf.seeImg);
            make.width.offset(200);
            make.height.offset(13);
        }];
        
        [self initVideoTitle];
        
//        self.autoIMG_im = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [self.autoIMG_im setImage:[UIImage imageNamed:@"ico_share_collection"] forState:(UIControlStateNormal)];
//        [self.autoIMG_im addTarget:self action:@selector(tapA) forControlEvents:(UIControlEventTouchUpInside)];
//        [self.contentView addSubview:self.autoIMG_im];
        
        
        self.likeImg = [[UIImageView alloc] init];
        self.likeImg.image = [UIImage imageNamed:@"omo_dianzan_new"];
        self.likeImg.userInteractionEnabled = YES;
        [self.contentView addSubview:self.likeImg];
        
        
        self.likeNumLab = [[UILabel alloc] init];
//        self.likeNumLab.text = @"50";
        self.likeNumLab.userInteractionEnabled = YES;
        self.likeNumLab.textColor =[UIColor whiteColor];
        self.likeNumLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.likeNumLab];
        
        self.commentsImg = [[UIImageView alloc] init];
        self.commentsImg.image = [UIImage imageNamed:@"talkicon_new"];
        self.commentsImg.userInteractionEnabled = YES;
        [self.contentView addSubview:self.commentsImg];
        
        
        self.commentNumLab = [[UILabel alloc] init];
//        self.commentNumLab.text = @"10";
        self.commentNumLab.userInteractionEnabled = YES;
        self.commentNumLab.textColor = [UIColor whiteColor];
        self.commentNumLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.commentNumLab];
        
        
        self.collectionImg = [[UIImageView alloc] init];
        self.collectionImg.image = [UIImage imageNamed:@"shoucan1"];
        self.collectionImg.userInteractionEnabled = YES;
        [self.contentView addSubview:self.collectionImg];
        
        
        self.collectLab = [[UILabel alloc] init];
        self.collectLab.userInteractionEnabled = YES;
        self.collectLab.textColor = [UIColor whiteColor];
        self.collectLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.collectLab];
        

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(pauseWMPlayer:) name:Notifycation_Pause_Video object:nil];
        
    }
    return self;
}


- (void)tapA{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:self.indexPath_video.row] forKey:@"row"];
    [dic setObject:[NSNumber numberWithBool:self.autoIMG_im.selected] forKey:@"isShow"];
    // 协议回调，改变Controller中存放Cell展开收起状态的字典
    if (self.delegateMarkCell && [self.delegateMarkCell respondsToSelector:@selector(remarksCellShowContrntWithDic:andCellIndexPath:)]) {
        [self.delegateMarkCell remarksCellShowContrntWithDic:dic andCellIndexPath:self.indexPath_video];
    }
}


+ (CGFloat)heightForCell:(ABContentResult *)_model isNeedShowGotoReviewAndSpeard:(BOOL)_isNeedShow
{
    NSString *strTitle     = _model.contentInfo.summary;
    CGSize sizeContent     = [VideoMainCell calculateLabelHeightByText:Font_Chinease_Normal(13) width:(kTPScreenWidth-16) heightMax:2000 content:strTitle];
    float fBaseHeight      = 110 + (sizeContent.height+10) + kHeightOfVideo;

    return fBaseHeight;
}


+ (CGFloat)heightForC1ell:(ABContentResult *)_model isNeedShow1GotoReviewAndSpeard:(NSString *)_isNeedShow
{
    NSString *strTitle     = _model.contentInfo.summary;
    if ([_isNeedShow isEqualToString:@"yes"]) {
        CGSize sizeContent     = [VideoMainCell calculateLabelHeightByText:Font_Chinease_Normal(12) width:(kTPScreenWidth-20) heightMax:2000 content:strTitle];
        float fBaseHeight      = 100 + (sizeContent.height + 10) + kHeightOfVideo;
        return fBaseHeight;
    }else{
        float fBaseHeight      = 100 + (24 + 10) + kHeightOfVideo;
        return fBaseHeight;
    }
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

- (void)updateData:(ABContentResult *)_model needShowReviewAndSpeard:(BOOL)_isNeedShowReviewAndSpeard index:(NSIndexPath *)_indexPath str:(NSString *)cellIsShow
{
    m_model                     = _model;
    self.indexPath_video = _indexPath;
    m_iCountReview              = m_model.commentInfo.total != nil ? [m_model.commentInfo.total integerValue] : 0;
    [self updateData:_isNeedShowReviewAndSpeard index:_indexPath str:cellIsShow];
}

- (void)updateData:(BOOL)_isNeedShowReviewAndSpeard index:(NSIndexPath *)_indexPath str:(NSString *)cellIsShow
{
    m_isNeedShowReviewAndSpeard = _isNeedShowReviewAndSpeard;
    if(m_needRelease)
        [self releaseWMPlayer];
    
    m_indexPath = _indexPath;

    UIImageView *imvVideo   = (UIImageView *)[self.contentView viewWithStringTag:@"tag_imv_video_bg"];
    ______WS();
    CGSize maximumLabelSize = CGSizeMake(kTPScreenWidth - 20, 9999);//labelsize的最大值
    
    
    imvVideo.frame          = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame),kHeightOfVideo);
    [imvVideo sd_setImageWithURL:[NSURL URLWithString:m_model.contentInfo.photo]];
    
    self.commentNumLab.text = [NSString stringWithFormat:@"%@",m_model.commentInfo.total];;
    NSString *videoIntro =m_model.contentInfo.summary;
    
    CGSize expectSize1 = [self.videoIntroduceLab sizeThatFits:maximumLabelSize];
    self.hgrt = expectSize1.height;
    
    if ([cellIsShow isEqualToString:@"yes"]) {
        [self.videoIntroduceLab removeFromSuperview];
        [self initVideoTitle];

        [self.videoIntroduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(wSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(wSelf.contentView.mas_right).offset(-10);
            make.top.mas_equalTo(wSelf.seeImg.mas_bottom).offset(15);
            make.height.mas_equalTo(expectSize1.height);
        }];
//        [self.contentView layoutIfNeeded];

    }else{
        [self.videoIntroduceLab removeFromSuperview];
        [self initVideoTitle];
        [self.videoIntroduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(wSelf.contentView.mas_left).offset(10);
            make.right.mas_equalTo(wSelf.contentView.mas_right).offset(-10);
            make.top.mas_equalTo(wSelf.seeImg.mas_bottom).offset(12);
            make.height.mas_equalTo(24);
        }];

    }
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3)];

    [self.likeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.contentView.mas_left).offset(13);
        make.bottom.equalTo(wSelf.contentView.mas_bottom).offset(-12);
        make.height.offset(16);
        make.width.offset(16);
    }];
    
    [self.likeNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.likeImg.mas_right).offset(5);
        make.centerY.equalTo(wSelf.likeImg);
        make.width.offset(80);
        make.height.offset(18);
    }];
    
    [self.commentsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.likeImg.mas_right).offset(80);
        make.centerY.equalTo(wSelf.likeImg);
        make.height.offset(13);
        make.width.offset(14);
    }];
    
    [self.commentNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.commentsImg.mas_right).offset(5);
        make.centerY.equalTo(wSelf.likeImg);
        make.width.offset(80);
        make.height.offset(18);
    }];
    
    [self.collectionImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.commentsImg.mas_right).offset(80);
        make.centerY.equalTo(wSelf.likeImg);
        make.height.offset(12);
        make.width.offset(13);
    }];
    
    
    [self.collectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.collectionImg.mas_right).offset(5);
        make.centerY.equalTo(wSelf.likeImg);
        make.width.offset(100);
        make.height.offset(18);
    }];
    
    
    [self.likeNumLab addGestureRecognizer:tap1];
    [self.commentNumLab addGestureRecognizer:tap2];
    [self.collectLab addGestureRecognizer:tap3];
    [self.likeImg addGestureRecognizer:tap4];
    [self.commentsImg addGestureRecognizer:tap5];
    [self.collectionImg addGestureRecognizer:tap6];

    self.videoIntroduceLab.text = videoIntro;

    
    if ([m_model.contentInfo.praised isEqualToString:@"1"]) {
        self.likeImg.image = [UIImage imageNamed:@"omo_dianzan_finsh"];
    }else{
        self.likeImg.image = [UIImage imageNamed:@"omo_dianzan_new"];
    }
    
    
    if ([m_model.contentInfo.collected isEqualToString:@"1"]) {
        self.collectionImg.image = [UIImage imageNamed:@"omo_sc_no"];
        self.collectLab.text = @"已收藏";
        _isShoucan = YES;
    }else{
        self.collectionImg.image = [UIImage imageNamed:@"omo_sc_yes"];
        self.collectLab.text = @"收藏";
        _isShoucan = NO;
    }
    
    if (!m_model.praiseInfo.praiseTotal) {
        self.likeNumLab.text = @"0";
    }else{
        self.likeNumLab.text = [NSString stringWithFormat:@"%@",m_model.praiseInfo.praiseTotal];
    }
    
    if (!m_model.commentInfo.total) {
        self.commentNumLab.text = @"0";
    }else{
        self.commentNumLab.text = [NSString stringWithFormat:@"%@",m_model.commentInfo.total];
    }
    
    self.type_time.text = m_model.channelInfo.classify_name;
    
    if (!m_model.contentInfo.views) {
        self.seeNumLab.text = @"0次观看";
    }else{
        self.seeNumLab.text = [NSString stringWithFormat:@"%@次观看", m_model.contentInfo.views];
    }
    
    self.number = m_model.praiseInfo.praiseTotal;
    self.titleLab.text = m_model.contentInfo.title;
    if(!ui_player && m_model.contentInfo.link)
    {
        ui_player = [[WMPlayer alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame),kHeightOfVideo) videoURLStr:m_model.contentInfo.link videoTitleStr:m_model.contentInfo.title];
        [ui_player.shareButton addTarget:self action:@selector(onActionFeedShare:) forControlEvents:(UIControlEventTouchUpInside)];
        [ui_player.fullshareButton addTarget:self action:@selector(onActionfullFeedShare:) forControlEvents:(UIControlEventTouchUpInside)];
        [ui_player.player play];
        
        // 播放埋点
        [MobClick event:@"play_video_day_num"];
        [ABAddViewModel requestAddView:m_model.contentInfo.ids block:^(NSDictionary *resultObject) {
        } failure:^(NSError *requestErr) {
        }];
        [self.contentView addSubview:ui_player];
    }

}


// 公用的UI
- (void)initVideoTitle{
    UITapGestureRecognizer *tapAAAAA= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapA)];
    self.videoIntroduceLab = [[UILabel alloc] init];
    self.videoIntroduceLab.numberOfLines    = 0;
    self.videoIntroduceLab.lineBreakMode    = NSLineBreakByTruncatingTail;
    //        self.videoIntroduceLab.text = @"楼上的咖啡机圣诞快乐解放路大开杀asd戒弗兰克的设计费死定了空间施蒂利克  辽";
    self.videoIntroduceLab.textColor = [UIColor whiteColor];
    self.videoIntroduceLab.userInteractionEnabled  = YES;
    [self.videoIntroduceLab addGestureRecognizer:tapAAAAA];
    self.videoIntroduceLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.videoIntroduceLab];

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
- (void)videoeEndPlay_TapBtn:(NSNotification *)notic{
    [self tap3];
}


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
    NSString *strVideoUrl   = m_model.contentInfo.link;
    if(![strVideoUrl isValid])
    {
        TOAST_FAILURE(@"抱歉,该视频暂时无法播放");
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
             [wSelf updateData:m_model needShowReviewAndSpeard:m_isNeedShowReviewAndSpeard index:m_indexPath str:nil];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videodetails_post_share" object:self];
}


- (void)onActionfullFeedShare:(UIButton *)_button{
    [self pauseWMPlayer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videodetailsFull_post_share" object:self];
}


- (void)videoeEndPlay_TapShare:(NSNotification *)notic{
    NSDictionary *dic = notic.userInfo;
    UMSocialUrlResource *source = [[UMSocialUrlResource alloc] init];
    source.resourceType = UMSocialUrlResourceTypeVideo;
    source.url =   urlVideoShare(m_model.contentInfo.ids);
    UIImageView *imvVideo   = (UIImageView *)[self.contentView viewWithStringTag:@"tag_imv_video_bg"];
    
    if ([dic[@"type"] isEqualToString:@"2"]) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:m_model.contentInfo.title image:imvVideo.image location:nil urlResource:source presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    
    if ([dic[@"type"] isEqualToString:@"1"]) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:m_model.contentInfo.title image:imvVideo.image location:nil urlResource:source presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    
    if ([dic[@"type"] isEqualToString:@"3"]) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:m_model.contentInfo.title image:imvVideo.image location:nil urlResource:source presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    
    if ([dic[@"type"] isEqualToString:@"5"]) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:m_model.contentInfo.title image:imvVideo.image location:nil urlResource:source presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    
    
    if ([dic[@"type"] isEqualToString:@"4"]) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:m_model.contentInfo.title image:imvVideo.image location:nil urlResource:source presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    
}


- (void)onActionFeedJuBao:(UIButton *)_button
{
    TOAST_SUCCESS(@"举报成功");
}

- (void)dealloc
{
    NSLog(@"cell已经销毁");
    [self releaseWMPlayer];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}



- (void)changeNumTotla_post:(NSNotification *)notifc{
    NSDictionary *dic = notifc.userInfo;
    NSString *totlaNum = [NSString stringWithFormat:@"%@",dic[@"totla"]];
    self.commentNumLab.text = totlaNum;
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


- (void)pausePlayVideo:(NSNotification *)notic{
    
    [self releaseWMPlayer];
    
}



- (void)tap1{
    if (![ABUser isLogined])
    {
        TOAST_FAILURE(@"要登录才可以哦");
        return;
    }
    
    if ([m_model.contentInfo.praised isEqualToString:@"1"]) {
        self.likeImg.image = [UIImage imageNamed:@"omo_dianzan_new"];
        m_model.contentInfo.praised = @"0";
        self.likeBuff = @"no";
        NSInteger num = [m_model.praiseInfo.praiseTotal integerValue];
        num = num - 1;
        m_model.praiseInfo.praiseTotal = [NSNumber numberWithInteger:num];
        self.number = [NSNumber numberWithInteger:num];
        self.likeNumLab.text = [NSString stringWithFormat:@"%ld",(long)num];
        [ABActionLikeModel requestActionLike:m_model.contentInfo.ids op:@"2" block:^(NSDictionary *resultObject)
         {
             ABActionLikeModel* model = [[ABActionLikeModel alloc] initWithDictionary:resultObject error:nil];
             if (model.rspCode.integerValue == 200)
             {
                 
             }
             else
             {
                 TOAST_FAILURE(model.rspMsg);
             }
         } failure:^(NSError *requestErr)
         {
             TOAST_ERROR(wSelf, requestErr);
         }];

    }else{
        self.likeImg.image = [UIImage imageNamed:@"omo_dianzan_finsh"];
        m_model.contentInfo.praised = @"1";
        self.likeBuff = @"yes";
        NSInteger num = [m_model.praiseInfo.praiseTotal integerValue];
        num = num + 1;
        m_model.praiseInfo.praiseTotal = [NSNumber numberWithInteger:num];
        self.likeNumLab.text = [NSString stringWithFormat:@"%ld",(long)num];
        [ABActionLikeModel requestActionLike:m_model.contentInfo.ids op:@"1" block:^(NSDictionary *resultObject)
         {
             ABActionLikeModel* model = [[ABActionLikeModel alloc] initWithDictionary:resultObject error:nil];
             if (model.rspCode.integerValue == 200)
             {
                 
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLikeImg_post" object:nil userInfo:@{@"likeBuff":self.likeBuff}];
    
}


- (void)tap2{
       // 协议回调，改变Controller中存放Cell展开收起状态的字典
    if (self.delegateMarkCell && [self.delegateMarkCell respondsToSelector:@selector(remarksCellShowContrntWithDic:andCellIndexPath:)]) {
        [self.delegateMarkCell addView];
    }

    
}


- (void)tap3{
    if (![ABUser isLogined]) {
        
//        ABLoginVC *vc = [[ABLoginVC alloc] init];
        TOAST_FAILURE(@"要登录才可以哦");

        return;
    }
    ______WS();
    //是否收藏
    BOOL isCollectioned = [m_model.contentInfo.collected isEqualToString:@"1"];
    [ABCollectionStateModel requestCollectionState:(isCollectioned ? @"0" : @"1") collectedIds:m_model.contentInfo.ids type:@"1" block:^(NSDictionary *resultObject)
     {
         ABCollectionStateModel* model = [[ABCollectionStateModel alloc] initWithDictionary:resultObject error:nil];
         if (model.rspCode.integerValue == 200)
         {
             if(isCollectioned)
             {
                 wSelf.collectionImg.image = [UIImage imageNamed:@"omo_sc_yes"];
                 wSelf.collectLab.text = @"收藏";
                 [ui_player.videoEndView.scBtn setImage:[UIImage imageNamed:@"sc_share"] forState:(UIControlStateNormal)];
                 m_model.contentInfo.collected = @"0";
                 TOAST_SUCCESS(@"取消收藏成功");
             }
             else
             {
                 wSelf.collectionImg.image = [UIImage imageNamed:@"omo_sc_no"];
                 wSelf.collectLab.text = @"已收藏";
                 [ui_player.videoEndView.scBtn setImage:[UIImage imageNamed:@"omo_ysc_share"] forState:(UIControlStateNormal)];
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



@end
