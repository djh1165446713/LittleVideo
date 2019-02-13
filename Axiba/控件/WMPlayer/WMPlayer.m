
/*!
 @header WMPlayer.m
 
 @author   Created by zhengwenming on  16/1/24
 
 @version 1.00 16/1/24 Creation(版本信息)
 
 Copyright © 2016年 郑文明. All rights reserved.
 */

#import "WMPlayer.h"

#define WMVideoSrcName(file) [@"WMPlayer.bundle" stringByAppendingPathComponent:file]
#define WMVideoFrameworkSrcName(file) [@"Frameworks/WMPlayer.framework/WMPlayer.bundle" stringByAppendingPathComponent:file]


static void *PlayViewCMTimeValue = &PlayViewCMTimeValue;

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface WMPlayer ()

@property (nonatomic, assign) CGPoint           firstPoint;
@property (nonatomic, assign) CGPoint           secondPoint;
@property (nonatomic, retain) NSTimer           *durationTimer;
@property (nonatomic, retain) NSTimer           *autoDismissTimer;
@property (nonatomic, retain) NSDateFormatter   *dateFormatter;

@end


@implementation WMPlayer
{
    UISlider    *systemSlider;
    CGRect      m_frameInCell;      //老的加载在Cell上的frame
    CGRect      m_frameInWindow;    //老的加载在Window上的frame
    UIView      *ui_viewSuper;      //老的super View 即Cell的contentView
}


-(AVPlayerItem *)getPlayItemWithURLString:(NSString *)urlString
{
    if ([urlString containsString:@"http"])
    {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    }
    else
    {
        AVAsset *movieAsset         = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:urlString] options:nil];
        AVPlayerItem *playerItem    = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
}


- (instancetype)initWithFrame:(CGRect)frame videoURLStr:(NSString *)videoURLStr videoTitleStr:(NSString *)videoTitle
{
    self = [super init];
    if (self)
    {
        self.videoTitle = videoTitle;
        NSLog(@"%@",videoTitle);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLikeImg:) name:@"changeLikeImg_post" object:nil];
        
        m_frameInCell           = frame;
        ui_viewSuper            = self.superview;
        __weak typeof(self) wSelf = self;
        
        self.frame              = frame;
        self.backgroundColor    = [UIColor blackColor];
        self.currentItem        = [self getPlayItemWithURLString:videoURLStr];
        
        self.player             = [AVPlayer playerWithPlayerItem:self.currentItem];
        self.playerLayer        = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame  = self.layer.bounds;
        //        self.playerLayer.videoGravity = AVLayerVideoGravityResize;
        [self.layer addSublayer:_playerLayer];
        
        if([self.player respondsToSelector:@selector(setAllowsAirPlay:)])
        {
            self.player.allowsAirPlayVideo                              = NO;
            self.player.usesExternalPlaybackWhileExternalScreenIsActive = NO;
        }
        [self performSelector:@selector(hidAriDrope) withObject:nil afterDelay:0.1];
        NSDictionary *dicUserInfo = @{@"info" : self};
        [[NSNotificationCenter defaultCenter] postNotificationName:Notifycation_Pause_Video object:self userInfo:dicUserInfo];
        
        
        // share btn
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareButton  setImage:[UIImage imageNamed:@"omo_share_white"] forState:(UIControlStateNormal)];
        self.shareButton.alpha = 0.0;
        [self addSubview:self.shareButton];
        [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.mas_right).offset(-16);
            make.top.equalTo(wSelf.mas_top).offset(15);
            make.width.offset(25);
            make.height.offset(20);
            
        }];
        
        
        // share btn
        self.fullshareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.fullshareButton  setImage:[UIImage imageNamed:@"omo_share_white"] forState:(UIControlStateNormal)];
        self.fullshareButton.hidden = YES;
        [self addSubview:self.fullshareButton];
        [self.fullshareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.mas_right).offset(-16);
            make.top.equalTo(wSelf.mas_top).offset(15);
            make.width.offset(25);
            make.height.offset(20);

        }];
        
        
        MPVolumeView *volumeView = [[MPVolumeView alloc]init];
        [self addSubview:volumeView];
        [volumeView sizeToFit];
        // like Btn
        self.likeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.likeButton.alpha = 0.0;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"praised"] isEqualToString:@"1"]) {
            [self.likeButton setImage:[UIImage imageNamed:@"omo_dianzan_finsh"] forState:(UIControlStateNormal)];
            _isLike = YES;
            
        }else{
            [self.likeButton setImage:[UIImage imageNamed:@"omo_dianzan_new"] forState:(UIControlStateNormal)];
            _isLike = NO;
        }
        [self.likeButton addTarget:self action:@selector(likeBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.likeButton];
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.shareButton.mas_left).offset(-16);
            make.top.equalTo(wSelf.mas_top).offset(15);
            make.width.offset(25);
            make.height.offset(20);
            
        }];
        
        // full back Btn
        self.fullScreenBackBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.fullScreenBackBtn setImage:[UIImage imageNamed:@"omo_back_left"] forState:(UIControlStateNormal)];
        [self.fullScreenBackBtn addTarget:self action:@selector(cancelFullScreenAction:) forControlEvents:(UIControlEventTouchUpInside)];
        self.fullScreenBackBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 10);
        self.fullScreenBackBtn.hidden = YES;
        [self addSubview:self.fullScreenBackBtn];
        [self.fullScreenBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.mas_left).offset(15);
            make.top.equalTo(wSelf.mas_top).offset(12);
            make.width.height.offset(30);
        }];
        
        // full video lab
        self.fullVideoLab = [[UILabel alloc] init];
        self.fullVideoLab.text = videoTitle;
        self.fullVideoLab.hidden = YES;
        self.fullVideoLab.textColor = [UIColor whiteColor];
        self.fullVideoLab.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.fullVideoLab];
        [self.fullVideoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.fullScreenBackBtn.mas_right).offset(10);
            make.centerY.equalTo(wSelf.fullScreenBackBtn);
            make.width.offset(kTPScreenHeight - 100);
        }];
        
        //bottomView
        self.bottomView = [[UIView alloc]init];
        [self addSubview:self.bottomView];
        //autoLayout bottomView
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf).with.offset(0);
            make.right.equalTo(wSelf).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wSelf).with.offset(0);
            
        }];
        [self setAutoresizesSubviews:NO];
        
        
        self.playOrPauseBtn         = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playOrPauseBtn.frame   = CGRectMake(0, 0, 44, 44);
        self.playOrPauseBtn.showsTouchWhenHighlighted = YES;
        [self.playOrPauseBtn addTarget:self action:@selector(PlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"video_zt"] forState:UIControlStateNormal];
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"video_bf"] forState:UIControlStateSelected];

//        [self.playOrPauseBtn setImage:[UIImage imageNamed:WMVideoSrcName(@"play")]  ?: [UIImage imageNamed:WMVideoFrameworkSrcName(@"play")]  forState:UIControlStateSelected];
        //        [self.playOrPauseBtn setImage:[UIImage imageNamed:WMVideoSrcName(@"play")] ?: [UIImage imageNamed:WMVideoFrameworkSrcName(@"play")] forState:UIControlStateNormal];
        //        [self.playOrPauseBtn setImage:[UIImage imageNamed:WMVideoSrcName(@"pause")]  ?: [UIImage imageNamed:WMVideoFrameworkSrcName(@"pause")]  forState:UIControlStateSelected];
        self.playOrPauseBtn.center  = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        [self addSubview:self.playOrPauseBtn];
        
        self.leftChangeBtn         = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftChangeBtn.frame   = CGRectMake(0, 0, 44, 44);
        self.leftChangeBtn.showsTouchWhenHighlighted = YES;
        [self.leftChangeBtn addTarget:self action:@selector(changevideoAction) forControlEvents:UIControlEventTouchUpInside];
        [self.leftChangeBtn setImage:[UIImage imageNamed:@"nextleft_icon"] forState:UIControlStateNormal];
        [self addSubview:self.leftChangeBtn];
        [self.leftChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.playOrPauseBtn.mas_left).offset(-30);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.centerY.equalTo(wSelf.playOrPauseBtn);
        }];
        
        self.rightChangeBtn         = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightChangeBtn.frame   = CGRectMake(0, 0, 44, 44);
        self.rightChangeBtn.showsTouchWhenHighlighted = YES;
        [self.rightChangeBtn addTarget:self action:@selector(changevideoAction) forControlEvents:UIControlEventTouchUpInside];
        [self.rightChangeBtn setImage:[UIImage imageNamed:@"nextright_icon"] forState:UIControlStateNormal];
        [self addSubview:self.rightChangeBtn];
        [self.rightChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.playOrPauseBtn.mas_right).offset(30);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.centerY.equalTo(wSelf.playOrPauseBtn);
        }];
        
        
        self.nowCurrentLabel = [[UILabel alloc] init];
        self.nowCurrentLabel.textColor = [UIColor whiteColor];
        self.nowCurrentLabel.font = [UIFont systemFontOfSize:14];
        self.nowCurrentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nowCurrentLabel];
        [self.nowCurrentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf.playOrPauseBtn);
            make.width.equalTo(@200);
            make.height.equalTo(@15);
            make.top.equalTo(wSelf.playOrPauseBtn.mas_bottom).offset(10);
        }];
        
        systemSlider = [[UISlider alloc]init];
        systemSlider.backgroundColor = [UIColor clearColor];
        for (UIControl *view in volumeView.subviews) {
            if ([view.superclass isSubclassOfClass:[UISlider class]]) {
                NSLog(@"1");
                systemSlider = (UISlider *)view;
            }
        }
        systemSlider.autoresizesSubviews = NO;
        systemSlider.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:systemSlider];
        systemSlider.hidden = YES;
        
        
        self.volumeSlider               = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.volumeSlider.tag           = 1000;
        self.volumeSlider.hidden        = YES;
        self.volumeSlider.minimumValue  = systemSlider.minimumValue;
        self.volumeSlider.maximumValue  = systemSlider.maximumValue;
        self.volumeSlider.value         = systemSlider.value;
        [self.volumeSlider addTarget:self action:@selector(updateSystemVolumeValue:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.volumeSlider];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        
        self.videoEndView = [[VideoPlayEndView alloc] initWithFrame:frame];
        [self.videoEndView.seeAgainImg addGestureRecognizer:tap1];
        [self.videoEndView.againLab addGestureRecognizer:tap2];
        self.videoEndView.hidden = YES;
        [self addSubview:self.videoEndView];
        
        
        //时间话筒条_full
        self.progressSliderFull                = [[UISlider alloc]init];
        self.progressSliderFull.hidden = YES;
        self.progressSliderFull.minimumValue    = 0.0;
        [self.progressSliderFull setThumbImage:[UIImage imageNamed:WMVideoSrcName(@"dot")] ?: [UIImage imageNamed:WMVideoFrameworkSrcName(@"dot")]  forState:UIControlStateNormal];
        self.progressSliderFull.minimumTrackTintColor = RGB(253, 173, 9);
        self.progressSliderFull.value           = 0.0;//指定初始值
        [self.progressSliderFull addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventValueChanged];
        [self.bottomView addSubview:self.progressSliderFull];
        [self.progressSliderFull mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(wSelf.bottomView.mas_left).with.offset(50);
             make.right.equalTo(wSelf.bottomView.mas_right).with.offset(-70);
             make.height.mas_equalTo(60);
             make.top.equalTo(wSelf.bottomView.mas_top).with.offset(0);
         }];
        
        
        self.progressSlider                 = [[UISlider alloc]init];
        self.progressSlider.minimumValue    = 0.0;
        [self.progressSlider setThumbImage:[UIImage imageNamed:WMVideoSrcName(@"dot")] ?: [UIImage imageNamed:WMVideoFrameworkSrcName(@"dot")]  forState:UIControlStateNormal];
        self.progressSlider.minimumTrackTintColor = RGB(253, 173, 9);
        self.progressSlider.value           = 0.0;//指定初始值
        [self.progressSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.progressSlider];
        [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(wSelf.mas_left).with.offset(0);
             make.right.equalTo(wSelf.mas_right).with.offset(0);
             make.height.mas_equalTo(2);
             make.bottom.equalTo(wSelf.mas_bottom).with.offset(0);
         }];
        
        
        //_fullScreenBtn
        self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.fullScreenBtn.showsTouchWhenHighlighted = YES;
        [self.fullScreenBtn addTarget:self action:@selector(onActionFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"full_srceen"] forState:UIControlStateNormal];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"full_srceen"] forState:UIControlStateSelected];
        [self.bottomView addSubview:self.fullScreenBtn];
        [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(wSelf.bottomView.mas_right).with.offset(0);
             make.height.mas_equalTo(40);
             make.centerY.equalTo(wSelf.progressSliderFull);
             make.width.mas_equalTo(40);
         }];
        
        
        //时间进度
        self.timeCurrentLabel                   = [[UILabel alloc]init];
        self.timeCurrentLabel.textColor         = [UIColor whiteColor];
        self.timeCurrentLabel.backgroundColor   = [UIColor clearColor];
        self.timeCurrentLabel.textAlignment     = NSTextAlignmentRight;
        self.timeCurrentLabel.font              = [UIFont systemFontOfSize:11];
        self.timeCurrentLabel.hidden = YES;
        [self.bottomView addSubview:self.timeCurrentLabel];
        [self.timeCurrentLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(wSelf.progressSliderFull.mas_top).offset(0);
             make.left.equalTo(wSelf.bottomView.mas_left).offset(0);
             make.height.mas_equalTo(wSelf.progressSliderFull.mas_height);
             make.width.mas_equalTo(45);
         }];
        [self bringSubviewToFront:self.bottomView];
        
        //视频最大时间
        self.timeMaxLabel                   = [[UILabel alloc]init];
        self.timeMaxLabel.textAlignment     = NSTextAlignmentLeft;
        self.timeMaxLabel.textColor         = [UIColor whiteColor];
        self.timeMaxLabel.backgroundColor   = [UIColor clearColor];
        self.timeMaxLabel.font              = [UIFont systemFontOfSize:11];
        self.timeMaxLabel.hidden = YES;
        [self.bottomView addSubview:self.timeMaxLabel];
        [self.timeMaxLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(wSelf.progressSliderFull.mas_top).offset(0);
             make.right.equalTo(wSelf.bottomView.mas_right).offset(-15);
             make.height.mas_equalTo(wSelf.progressSliderFull.mas_height);
             make.width.mas_equalTo(45);
         }];
        
        
        [self bringSubviewToFront:self.bottomView];
        
        
        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.loadingView hidesWhenStopped];
        [self addSubview:self.loadingView];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(wSelf);
        }];
        [self.loadingView startAnimating];
        self.bottomView.alpha       = 0.0;
        self.playOrPauseBtn.alpha   = 0.0;
        wSelf.leftChangeBtn.alpha   = 0.0;
        wSelf.rightChangeBtn.alpha = 0.0;
        // 单击的 Recognizer
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        singleTap.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleTap];
        
        // 双击的 Recognizer
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
        doubleTap.numberOfTapsRequired = 2; // 双击
        [self addGestureRecognizer:doubleTap];
        
        
        [self.currentItem addObserver:self
                           forKeyPath:@"status"
                              options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                              context:PlayViewStatusObservationContext];
        [self initTimer];
    }
    return self;
}

- (void)updateSystemVolumeValue:(UISlider *)slider
{
    systemSlider.value = slider.value;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}


#pragma mark - fullScreenAction and cancel full
-(void)fullScreenAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    //用通知的形式把点击全屏的时间发送到app的任何地方，方便处理其他逻辑
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fullScreenBtnClickNotice" object:sender];
}

- (double)duration{
    AVPlayerItem *playerItem = self.player.currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
        
    {
        return CMTimeGetSeconds([[playerItem asset] duration]);
    }
    else
    {
        return 0.f;
    }
}

- (void)cancelFullScreenAction:(UIButton *)button{
    
    self.fullScreenBtn.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    __weak typeof(self) wSelf               = self;
    __weak typeof(ui_viewSuper) wViewSuper  = ui_viewSuper;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         wSelf.transform            = CGAffineTransformMakeRotation(0);
         wSelf.frame                = CGRectMake(m_frameInWindow.origin.x, m_frameInWindow.origin.y, m_frameInWindow.size.width, m_frameInWindow.size.height);
         wSelf.playerLayer.frame    = wSelf.bounds;
         wSelf.playOrPauseBtn.center= CGPointMake(CGRectGetWidth(wSelf.frame)/2 , CGRectGetHeight(wSelf.frame)/2);
         wSelf.shareButton.hidden = NO;
         wSelf.fullScreenBackBtn.hidden = YES;
         wSelf.fullVideoLab.hidden = YES;
         wSelf.timeCurrentLabel.hidden = YES;
         wSelf.timeMaxLabel.hidden = YES;
         wSelf.progressSliderFull.hidden = YES;
         wSelf.progressSlider.hidden = NO;
         if (@available(iOS 11.0, *)) {
             
         } else {
             [wSelf.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.height.mas_equalTo(44);
                 make.top.mas_equalTo(m_frameInWindow.size.height-44);
                 make.width.mas_equalTo(m_frameInWindow.size.width);
             }];
         }
         

         wSelf.videoEndView.transform = CGAffineTransformMakeRotation(0);
         wSelf.videoEndView.frame = wSelf.bounds;
         //             wSelf.videoEndView.center = CGPointMake(CGRectGetHeight(wSelf.frame)/2, CGRectGetWidth(wSelf.frame)/2);
         wSelf.videoEndView.backImg.frame = wSelf.bounds;
         
         
         
     } completion:^(BOOL finished) {
         if(finished)
         {
             [wSelf removeFromSuperview];
             wSelf.frame    = m_frameInCell;
             [wViewSuper addSubview:wSelf];
         }
     }];
    
    [self bringSubviewToFront:self.bottomView];
}




- (double)currentTime
{
    return CMTimeGetSeconds([[self player] currentTime]);
}

- (void)setCurrentTime:(double)time
{
    [[self player] seekToTime:CMTimeMakeWithSeconds(time, 1)];
}


#pragma mark


- (void)tap{
    NSLog(@".........");
    [self handleDoubleTap];
}

- (void)likeBtnAction{
    
//    if (![ABUser isLogined]) {
//        TOAST_FAILURE(@"要登录才可以哦");
//        return;
//    }
    
    if (_isLike) {
        _isLike = NO;
        [self.likeButton setImage:[UIImage imageNamed:@"omo_dianzan_new"] forState:(UIControlStateNormal)];
    }else{
        _isLike = YES;
        [self.likeButton setImage:[UIImage imageNamed:@"omo_dianzan_finsh"] forState:(UIControlStateNormal)];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoEndPost" object:nil];
    
}


- (void)shareBtnAction{
    NSLog(@"分享");
}



- (void)changeLikeImg:(NSNotification *)notifc{
    NSDictionary *dic = notifc.userInfo;
    if ([dic[@"likeBuff"] isEqualToString:@"yes"]) {
        _isLike = YES;
        [self.likeButton setImage:[UIImage imageNamed:@"omo_dianzan_finsh"] forState:(UIControlStateNormal)];
        
    }else{
        _isLike = NO;
        [self.likeButton setImage:[UIImage imageNamed:@"omo_dianzan_new"] forState:(UIControlStateNormal)];
    }
}

#pragma mark - PlayOrPause
- (void)PlayOrPause:(UIButton *)sender
{
    NSDictionary *dicUserInfo = @{@"info" : self};
    [[NSNotificationCenter defaultCenter] postNotificationName:Notifycation_Pause_Video object:self userInfo:dicUserInfo];
    
    if (self.durationTimer==nil)
    {
        self.durationTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(finishedPlay:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
    }
    sender.selected = !sender.selected;
    if (self.player.rate != 1.f)
    {
        if ([self currentTime] == [self duration])
            [self setCurrentTime:0.f];
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"video_zt"] forState:UIControlStateNormal];

        [self.player play];
    }
    else
    {
        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"video_bf"] forState:UIControlStateNormal];

        [self.player pause];
    }
    //    CMTime time = [self.player currentTime];
    
    [self hidAriDrope];
}

/*!
 @abstract 进入全屏
 */
-(void)onActionFullScreen:(UIButton *)_button
{
//    [_button setSelected:!_button.selected];
    self.fullScreenBtn.hidden = YES;

    //说明是全屏
//    if(YES)
//    {
        if(!ui_viewSuper) ui_viewSuper = self.superview;
        
        //        UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self removeFromSuperview];
        m_frameInWindow    = [self convertRect:m_frameInCell toView:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.frame         = m_frameInWindow;
        __weak typeof(self) wSelf = self;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
         {
             
             wSelf.transform             = CGAffineTransformMakeRotation(M_PI_2);
             wSelf.frame                 = CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight);
             wSelf.playerLayer.frame     = wSelf.bounds;
             wSelf.playOrPauseBtn.center = CGPointMake(CGRectGetHeight(wSelf.frame)/2, CGRectGetWidth(wSelf.frame)/2);
             wSelf.fullScreenBackBtn.hidden = NO;
             wSelf.fullVideoLab.hidden = NO;
             wSelf.progressSliderFull.hidden = NO;
             wSelf.shareButton.hidden = YES;
             wSelf.fullshareButton.hidden = NO;
//             wSelf.likeButton.hidden = YES;
             wSelf.timeCurrentLabel.hidden = NO;
             wSelf.timeMaxLabel.hidden = NO;
             wSelf.progressSlider.hidden = YES;

             if (@available(iOS 11.0, *)) {
                 
             } else {
                 [wSelf.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                     make.height.mas_equalTo(44);
                     make.top.mas_equalTo(kTPScreenWidth-44);
                     make.width.mas_equalTo(kTPScreenHeight);
                 }];
             }
             


//             [wSelf.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                 make.height.mas_equalTo(44);
//                 make.bottom.equalTo(wSelf.mas_bottom).offset(-44);
//                 make.width.mas_equalTo(kTPScreenHeight);
//                 make.left.equalTo(wSelf.mas_key).offset(0);
//                 
//             }];
             
             
             wSelf.nowCurrentLabel.transform = CGAffineTransformMakeRotation(M_PI * 2.0);
             
             wSelf.videoEndView.transform = CGAffineTransformMakeRotation(M_PI * 2.0);
             wSelf.videoEndView.frame = wSelf.bounds;
             //           wSelf.videoEndView.center = CGPointMake(CGRectGetHeight(wSelf.frame)/2, CGRectGetWidth(wSelf.frame)/2);
             wSelf.videoEndView.backImg.frame = wSelf.bounds;
             
         } completion:^(BOOL finished) {
         }];
        
        [self bringSubviewToFront:self.bottomView];
//    }
    //说明是退出全屏
//    else
//    {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//
//        __weak typeof(self) wSelf               = self;
//        __weak typeof(ui_viewSuper) wViewSuper  = ui_viewSuper;
//        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^
//         {
//             wSelf.transform            = CGAffineTransformMakeRotation(0);
//             wSelf.frame                = CGRectMake(m_frameInWindow.origin.x, m_frameInWindow.origin.y, m_frameInWindow.size.width, m_frameInWindow.size.height);
//             wSelf.playerLayer.frame    = wSelf.bounds;
//             wSelf.playOrPauseBtn.center= CGPointMake(CGRectGetWidth(wSelf.frame)/2 , CGRectGetHeight(wSelf.frame)/2);
////             wSelf.shareButton.hidden = NO;
////             wSelf.likeButton.hidden = NO;
//             wSelf.fullScreenBackBtn.hidden = YES;
//             wSelf.fullVideoLab.hidden = YES;
//
//             if (@available(iOS 11.0, *)) {
//
//             } else {
//                 [wSelf.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//                     make.height.mas_equalTo(44);
//                     make.top.mas_equalTo(m_frameInWindow.size.height-44);
//                     make.width.mas_equalTo(m_frameInWindow.size.width);
//                 }];
//             }
//
//
//             wSelf.videoEndView.transform = CGAffineTransformMakeRotation(0);
//             wSelf.videoEndView.frame = wSelf.bounds;
//             //             wSelf.videoEndView.center = CGPointMake(CGRectGetHeight(wSelf.frame)/2, CGRectGetWidth(wSelf.frame)/2);
//             wSelf.videoEndView.backImg.frame = wSelf.bounds;
//
//
//
//         } completion:^(BOOL finished) {
//             if(finished)
//             {
//                 [wSelf removeFromSuperview];
//                 wSelf.frame    = m_frameInCell;
//                 [wViewSuper addSubview:wSelf];
//             }
//         }];
//
//        [self bringSubviewToFront:self.bottomView];
//    }
}


#pragma mark - 单击手势方法
- (void)handleSingleTap
{
    ______WS();
    self.likeButton.alpha = 1.0;
    self.shareButton.alpha = 1.0;
    self.fullshareButton.alpha = 1.0;
    if (self.currentTime == self.duration&&self.player.rate==.0f)
   {
        self.playOrPauseBtn.hidden = YES;
       self.nowCurrentLabel.hidden = YES;
       self.leftChangeBtn.hidden = YES;
       self.rightChangeBtn.hidden = YES;

    }
    [self performSelector:@selector(hidAriDrope) withObject:nil afterDelay:0.5];
    [UIView animateWithDuration:0.5 animations:^{
        if (wSelf.bottomView.alpha == 0.0)
        {
            wSelf.bottomView.alpha           = 1.0;
            wSelf.playOrPauseBtn.alpha       = 1.0;
            wSelf.nowCurrentLabel.alpha = 1.0;
            wSelf.leftChangeBtn.alpha       = 1.0;
            wSelf.rightChangeBtn.alpha = 1.0;
        }
        else
        {
            wSelf.bottomView.alpha           = 0.0;
            wSelf.playOrPauseBtn.alpha   = 0.0;
            wSelf.nowCurrentLabel.alpha = 0.0;
            wSelf.leftChangeBtn.alpha       = 0.0;
            wSelf.rightChangeBtn.alpha = 0.0;
            //            }
        }
    } completion:^(BOOL finish){
        
    }];
    
}


#pragma mark - 双击手势方法
- (void)handleDoubleTap
{
    self.videoEndView.hidden = YES;
    self.playOrPauseBtn.hidden = NO;
    self.nowCurrentLabel.hidden = NO;
    self.leftChangeBtn.hidden = NO;
    self.rightChangeBtn.hidden = NO;
    NSDictionary *dicUserInfo = @{@"info" : self};
    [[NSNotificationCenter defaultCenter] postNotificationName:Notifycation_Pause_Video object:self userInfo:dicUserInfo];
    
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    if (self.player.rate != 1.f)
    {
        if ([self currentTime] == self.duration)
            [self setCurrentTime:0.f];
        self.durationTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(finishedPlay:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
        
        [self.player play];
    }
    else
    {
        [self.player pause];
    }
}

- (void)hidAriDrope
{
    //移除aridrope
    for (UIView* vvv in self.subviews)
    {
        if ([vvv isKindOfClass:[MPVolumeView class]])
        {
            for (UIView* vvvv in vvv.subviews)
            {
                if ([NSStringFromClass([vvvv class]) isEqualToString:@"MPButton"])
                {
                    vvvv.hidden = YES;
                }
            }
        }
    }
}


#pragma mark - 设置播放的视频
- (void)setVideoURLStr:(NSString *)videoURLStr
{
    _videoURLStr = videoURLStr;
    
    if (self.currentItem)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        [self.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    self.currentItem = [self getPlayItemWithURLString:videoURLStr];
    [self.currentItem addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:PlayViewStatusObservationContext];
    
    [self.player replaceCurrentItemWithPlayerItem:self.currentItem];
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
}

- (void)moviePlayDidEnd:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf.progressSlider setValue:0.0 animated:YES];
        [weakSelf.progressSliderFull setValue:0.0 animated:YES];
        weakSelf.playOrPauseBtn.selected = NO;
    }];
}


#pragma mark - 播放进度
- (void)updateProgress:(UISlider *)slider
{
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value, 1)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ______WS();
    /* AVPlayerItem "status" property value observer. */
    if (context == PlayViewStatusObservationContext)
    {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
            {
                [self.loadingView startAnimating];
                [UIView animateWithDuration:0.4 animations:^{
                    wSelf.bottomView.alpha       = 0.0;
                    wSelf.playOrPauseBtn.alpha   = 0.0;
                    wSelf.nowCurrentLabel.alpha = 0.0;
                    wSelf.leftChangeBtn.alpha   = 0.0;
                    wSelf.rightChangeBtn.alpha = 0.0;
                } completion:^(BOOL finish){
                    
                }];
            }
                break;
                
            case AVPlayerStatusReadyToPlay:
            {
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                if (CMTimeGetSeconds(self.player.currentItem.duration)) {
                    self.progressSlider.maximumValue = CMTimeGetSeconds(self.player.currentItem.duration);
                    self.progressSliderFull.maximumValue = CMTimeGetSeconds(self.player.currentItem.duration);
                }
                
                [self initTimer];
                if (self.durationTimer==nil) {
                    self.durationTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(finishedPlay:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
                }
                
                //5s dismiss bottomView
                if (self.autoDismissTimer==nil) {
                    self.autoDismissTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoDismissBottomView:) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
                }
                
                [self.loadingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.4];
            }
                break;
                
            case AVPlayerStatusFailed:
            {
                [self.loadingView stopAnimating];
                TOAST_FAILURE(@"抱歉,该视频无法播放");
            }
                break;
        }
    }
}


#pragma mark
#pragma mark finishedPlay
- (void)finishedPlay:(NSTimer *)timer
{
//    NSLog(@"%f -------------> %f",self.currentTime,self.duration);
    if (self.currentTime == self.duration&&self.player.rate==.0f)
    {
        self.playOrPauseBtn.selected = YES;
        //播放完成后的通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedPlay" object:self.durationTimer];
        [self.durationTimer invalidate];
        self.durationTimer = nil;
        self.videoEndView.hidden = NO;
        self.playOrPauseBtn.hidden = YES;
        self.nowCurrentLabel.hidden = YES;
        self.leftChangeBtn.hidden = YES;
        self.rightChangeBtn.hidden = YES;
    }
    
    
}


#pragma mark
#pragma mark autoDismissBottomView
-(void)autoDismissBottomView:(NSTimer *)timer
{
    ______WS();
    if (self.player.rate==.0f&&self.currentTime != self.duration) //暂停状态
    {
    }
    else if(self.player.rate==1.0f)
    {
        if (self.bottomView.alpha==1.0)
        {
            [UIView animateWithDuration:0.5 animations:^
             {
                 wSelf.bottomView.alpha       = 0.0;
                 wSelf.playOrPauseBtn.alpha   = 0.0;
                 wSelf.shareButton.alpha = 0.0;
                 wSelf.fullshareButton.alpha = 0.0;
                 wSelf.likeButton.alpha = 0.0;
                 wSelf.nowCurrentLabel.alpha = 0.0;
                 wSelf.leftChangeBtn.alpha   = 0.0;
                 wSelf.rightChangeBtn.alpha = 0.0;
             } completion:^(BOOL finish){
             }];
        }
    }
}


#pragma  maik - 定时器
-(void)initTimer
{
    double interval = .1f;
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([self.progressSlider bounds]);
        interval = 0.5f * duration / width;
    }
    NSLog(@"interva === %f",interval);
    
    __weak typeof(self) weakSelf = self;
    
    [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)  queue:NULL /* If you pass NULL, the main queue is used. */ usingBlock:^(CMTime time){
        [weakSelf syncScrubber];
    }];
}

- (void)syncScrubber
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        self.progressSlider.minimumValue = 0.0;
        self.progressSliderFull.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        float minValue          = [self.progressSlider minimumValue];
        float maxValue          = [self.progressSlider maximumValue];
        float minValue1          = [self.progressSliderFull minimumValue];
        float maxValue1          = [self.progressSliderFull maximumValue];
        double time             = CMTimeGetSeconds([self.player currentTime]);
        _timeCurrentLabel.text  = [self convertTime:time];
        _timeMaxLabel.text      = [self convertTime:duration];
        _nowCurrentLabel.text   = [NSString stringWithFormat:@"%@/%@",[self convertTime:time],[self convertTime:duration]];
        
        if([self.progressSlider isTouchInside])
        {
            NSLog(@"正在响应事件");
            return;
        }
        
        [self.progressSlider setValue:(maxValue - minValue) * time / duration + minValue];
        [self.progressSliderFull setValue:(maxValue1 - minValue1) * time / duration + minValue1];

    }
}

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return([playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}

- (NSString *)convertTime:(CGFloat)second
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *newTime = [[self dateFormatter] stringFromDate:d];
    return newTime;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in event.allTouches)
    {
        self.firstPoint = [touch locationInView:self];
    }
    
    UISlider *volumeSlider = (UISlider *)[self viewWithTag:1000];
    volumeSlider.value = systemSlider.value;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in event.allTouches)
    {
        self.secondPoint = [touch locationInView:self];
    }
    
    systemSlider.value += (self.firstPoint.y - self.secondPoint.y)/500.0;
    UISlider *volumeSlider = (UISlider *)[self viewWithTag:1000];
    volumeSlider.value = systemSlider.value;
    self.firstPoint = self.secondPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.firstPoint = self.secondPoint = CGPointZero;
}

- (void)changevideoAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeVideoNotic" object:self];
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player pause];
    self.autoDismissTimer   = nil;
    self.durationTimer      = nil;
    self.player             = nil;
    [self.currentItem removeObserver:self forKeyPath:@"status"];
}
@end
