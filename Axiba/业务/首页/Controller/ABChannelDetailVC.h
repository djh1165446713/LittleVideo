//
//  ABChannelDetailVC.h
//  Axiba
//
//  Created by Michael on 16/6/14.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseVC.h"
#import "ABCommonViewManager.h"
#import "ABChannelInfoModel.h"
#import "UMSocial.h"
#import "ABCollectionStateModel.h"

typedef void(^backChannleName)(void);

@interface ABChannelDetailVC : CTBaseVC

- (id)initWithChannel:(NSString *)_channelIds;

- (void)setChannelName:(NSString *)_channelName;

@property (assign, nonatomic) CGPoint downClick;
@property (assign, nonatomic) CGPoint  upClick;
@property (strong, nonatomic) NSString *adImageUrl;

@property (nonatomic , strong) NSMutableArray *clickArr;    // 点击曝光
@property (nonatomic , strong) NSMutableArray *imprArr;     // 展示曝光
@property (nonatomic , strong) NSString *urlAd;     // 广告地址
@property (nonatomic , copy) backChannleName blockChannle;    


@property (strong, nonatomic) NSString *click1;
@property (strong, nonatomic) NSString *click2;


@end
