//
//  VideoMainCell.h
//  Axiba
//
//  Created by bianKerMacBook on 2017/4/18.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABSearchModel.h"

@protocol RemarksCellDelegate <NSObject>

- (void)remarksCellShowContrntWithDic:(NSDictionary *)dic andCellIndexPath:(NSIndexPath *)indexPath;

- (void)addView;

@end



@protocol ABFeed1CellDelegate <NSObject>

@optional

- (void)deActionEnterChannel:(NSInteger)_index;
- (void)deActionLikesUser:(NSInteger)_index;
- (void)deActionReview:(NSInteger)_index;
- (void)deReloadCell:(NSIndexPath *)_indexPath;

@end

@interface VideoMainCell : UITableViewCell
@property (nonatomic) BOOL  isSelected;
@property (nonatomic, weak) id<ABFeed1CellDelegate> delegate;
@property (nonatomic, weak) id<RemarksCellDelegate> delegateMarkCell;

@property (nonatomic, strong) UIImageView *imvStartVideo;
@property (nonatomic, strong) UIImageView *backMatte;

@property (nonatomic, assign) CGFloat hgrt;


@property (nonatomic, strong) NSIndexPath *indexPath_video;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *type_time;

@property (nonatomic, strong) UIImageView *seeImg;

@property (nonatomic, strong) UILabel *seeNumLab;

@property (nonatomic, strong) UILabel *videoIntroduceLab;

@property (nonatomic, strong) UIButton *autoIMG_im;


@property (nonatomic, strong) UIImageView *likeImg;
@property (nonatomic, strong) UILabel *likeNumLab;

@property (nonatomic, strong) UIImageView *commentsImg;
@property (nonatomic, strong) UILabel *commentNumLab;

@property (nonatomic, strong) UIImageView *collectionImg;
@property (nonatomic, strong) UILabel *collectLab;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isShoucan;
@property (nonatomic, strong) NSString *likeBuff;
@property (nonatomic, strong) NSNumber *number;


+ (NSString*)identifier;
+ (CGFloat)heightForCell:(ABContentResult *)_model isNeedShowGotoReviewAndSpeard:(BOOL)_isNeedShow;
+ (CGFloat)heightForC1ell:(ABContentResult *)_model isNeedShow1GotoReviewAndSpeard:(NSString *)_isNeedShow;

- (void)actionGesTapVideo:(UIGestureRecognizer *)_gesture;

- (void)updateData:(ABContentResult *)_model needShowReviewAndSpeard:(BOOL)_isNeedShowReviewAndSpeard index:(NSIndexPath *)_indexPath str:(NSString *)cellIsShow;

- (void)setReviewBtnHidden:(BOOL)_hidden;

- (void)releaseWMPlayer;

- (void)pauseWMPlayer;

- (void)setNeedReleasePlayerWhenReload:(BOOL)_needRelease;

@end
