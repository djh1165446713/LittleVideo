//
//  ChartCell.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartCellFrame.h"

@class ChartCell;

@protocol ChartCellDelegate <NSObject>

-(void)chartCell:(ChartCell *)chartCell tapContent:(NSString *)content;
-(void)chartCell:(ChartCell *)chartCell tapUser:(ABCommentModel *)_model;
-(void)chartCellChangeData:(NSIndexPath *)index cellFlag:(NSNumber *)flag;                       //修改数据状态

@end

@interface ChartCell : UITableViewCell
@property (nonatomic,strong) ChartCellFrame *cellFrame;
@property (nonatomic,assign) id<ChartCellDelegate> delegate;
@property (nonatomic,strong) UIButton       *like_btn;
@property (nonatomic,strong) NSIndexPath       *indexpath;
@property (nonatomic,strong) UILabel       *like_lab;
@property (nonatomic,strong) ChartMessage *chartMessageN;
@property (nonatomic, strong)UIVisualEffectView *effectView;        //模糊

+ (NSString *)identifier;
@end
