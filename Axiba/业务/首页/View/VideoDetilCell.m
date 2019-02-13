//
//  VideoDetilCell.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/4/18.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "VideoDetilCell.h"

@implementation VideoDetilCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ______WS();
//        self.backgroundColor    = RGB(22, 21, 16);
        self.contentView.backgroundColor = RGB(53, 49, 50);
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 20;
        [self.contentView addSubview:_headImg];
        [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.contentView).offset(10);
            make.centerY.equalTo(wSelf.contentView);
            make.width.height.offset(40);
        }];
        
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = [UIColor whiteColor];
        _nickName.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nickName];
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.headImg.mas_right).offset(15);
            make.centerY.equalTo(wSelf.headImg).offset(-10);
            make.width.offset(150);
            make.height.offset(20);
        }];
        
        
        _channleSummy = [[UILabel alloc] init];
        _channleSummy.textColor = [UIColor whiteColor];
        _channleSummy.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_channleSummy];
        [_channleSummy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.headImg.mas_right).offset(15);
            make.centerY.equalTo(wSelf.headImg).offset(10);
            make.width.offset(200);
            make.height.offset(14);
        }];
        

        _isSelectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _isSelectBtn.layer.masksToBounds = YES;
        _isSelectBtn.layer.cornerRadius = 13;
        _isSelectBtn.backgroundColor = RGB(23, 128, 207);
        _isSelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_isSelectBtn addTarget:self action:@selector(shoucanAciton) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_isSelectBtn];
        [_isSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.contentView.mas_right).offset(-18);
            make.centerY.equalTo(wSelf.contentView);
            make.width.offset(73);
            make.height.offset(26);

        }];
        
    }
    return self;
}

- (void)shoucanAciton{

    if (![ABUser isLogined]) {
        TOAST_FAILURE(@"要登录才可以哦");

        return;
    }
    
   //是否收藏
    BOOL isCollectioned = [self.model.channelInfo.collected isEqualToString:@"1"];
    if (isCollectioned) {
        [_isSelectBtn setTitle:@"+ 关注" forState:(UIControlStateNormal)];
    }else{
        [_isSelectBtn setTitle:@"已关注" forState:(UIControlStateNormal)];

    }
    [ABCollectionStateModel requestCollectionState:(isCollectioned ? @"0" : @"1") collectedIds:self.model.contentInfo.channel_ids type:@"2" block:^(NSDictionary *resultObject)
     {
         ABCollectionStateModel* model = [[ABCollectionStateModel alloc] initWithDictionary:resultObject error:nil];
         if (model.rspCode.integerValue == 200)
         {
             if(isCollectioned)
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSCtype" object:self userInfo:@{@"type":@"0"}];
                 TOAST_SUCCESS(@"取消关注成功");
             }
             else
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSCtype" object:self userInfo:@{@"type":@"1"}];

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

-(void)setCellmessageModel:(ABContentResult *)model{
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.channelInfo.photo] placeholderImage:[UIImage imageNamed:@"icon_need_head"]];
    if ([model.channelInfo.collected isEqualToString:@"1"]) {
        [_isSelectBtn setTitle:@"已关注" forState:(UIControlStateNormal)];

    }else{
        [_isSelectBtn setTitle:@"+ 关注" forState:(UIControlStateNormal)];

    }
    self.model = model;
    _nickName.text = model.channelInfo.name;
    _channleSummy.text = model.channelInfo.summary;
}


@end
