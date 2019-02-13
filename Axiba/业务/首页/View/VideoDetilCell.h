//
//  VideoDetilCell.h
//  Axiba
//
//  Created by bianKerMacBook on 2017/4/18.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABContentsModel.h"
#import "ABCollectionStateModel.h"
@interface VideoDetilCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIButton *isSelectBtn;
@property (nonatomic, strong) ABContentResult *model;
@property (nonatomic, strong) UILabel *channleSummy;

-(void)setCellmessageModel:(ABContentResult *)model;

@end
