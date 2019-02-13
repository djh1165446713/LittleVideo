//
//  LoopHeaderView.h
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/3.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "HomeSelectModel.h"

@interface LoopHeaderView : UIView<iCarouselDelegate,iCarouselDataSource>
@property (nonatomic, strong) UILabel *title1;  // 标题1
@property (nonatomic, strong) UILabel *title2;  // 标题2
@property (nonatomic, strong) iCarousel *iCarouselView;  // 手动轮播
@property (nonatomic , strong) NSMutableArray *selectArr;     // 精选视频
@property (nonatomic , strong) NSMutableArray *imageiCaArr;     // 精选视频图片
- (instancetype)initWithFrame:(CGRect)frame imageURLStringsGroup:(NSMutableArray *)arr;

@end
