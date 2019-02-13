//
//  ABFeedCell.h
//  Axiba
//
//  Created by Nemofish on 16/06/9.
//  Copyright (c) 2016年 Nemofish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABSearchModel.h"

@protocol ABFeedCellDelegate <NSObject>

@optional

- (void)deActionEnterChannel:(NSInteger)_index;
- (void)deActionLikesUser:(NSInteger)_index;
- (void)deActionReview:(NSInteger)_index;
- (void)deReloadCell:(NSIndexPath *)_indexPath;

@end


@interface ABFeedCell : UITableViewCell

@property (nonatomic) BOOL  isSelected;
@property (nonatomic, weak) id<ABFeedCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *imvStartVideo;
@property (nonatomic, strong) UIImageView *backMatte;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *seeImg;

@property (nonatomic, strong) UILabel *seeNumLab;

@property (nonatomic, strong) UILabel *videoIntroduceLab;

@property (nonatomic, strong) UIImageView *likeImg;
@property (nonatomic, strong) UILabel *likeNumLab;

@property (nonatomic, strong) UIImageView *commentsImg;
@property (nonatomic, strong) UILabel *commentNumLab;

@property (nonatomic, strong) UIImageView *collectionImg;
@property (nonatomic, strong) UILabel *collectLab;


@property (nonatomic, strong) UILabel *channelName;

+ (NSString*)identifier;
+ (CGFloat)heightForCell:(ABContentResult *)_model isNeedShowGotoReviewAndSpeard:(BOOL)_isNeedShow;
+ (CGFloat)heightForC1ell:(ABContentResult *)_model isNeedShow1GotoReviewAndSpeard:(BOOL)_isNeedShow;

- (void)actionGesTapVideo:(UIGestureRecognizer *)_gesture;

- (void)updateData:(ABContentResult *)_model needShowReviewAndSpeard:(BOOL)_isNeedShowReviewAndSpeard index:(NSIndexPath *)_indexPath;

- (void)setReviewBtnHidden:(BOOL)_hidden;

- (void)releaseWMPlayer;

- (void)pauseWMPlayer;

- (void)setNeedReleasePlayerWhenReload:(BOOL)_needRelease;

@end
