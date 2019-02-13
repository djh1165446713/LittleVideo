
//
//  LoopHeaderView.m
//  Axiba
//
//  Created by bianKerMacBook on 2018/1/3.
//  Copyright © 2018年 Peter. All rights reserved.
//

#import "LoopHeaderView.h"
#import "ABVideoDetailVC.h"

@implementation LoopHeaderView

- (instancetype)initWithFrame:(CGRect)frame  imageURLStringsGroup:(NSMutableArray *)arr
{
    if ([super initWithFrame:frame]) {
        self.selectArr = [NSMutableArray array];
        self.imageiCaArr = [NSMutableArray array];

        ______WS();
        self.backgroundColor = RGB(35, 34, 33);
        _title1 = [[UILabel alloc] init];
        _title1.text = @"精选";
        _title1.textColor = [UIColor whiteColor];
        _title1.font = [UIFont systemFontOfSize:18];
        [self addSubview:_title1];
        [_title1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wSelf.mas_top).offset(20);
            make.centerX.equalTo(wSelf);
            make.height.offset(28);
            make.width.offset(37);

        }];
        
        // 创建带标题的图片轮播器
        self.iCarouselView = [[iCarousel alloc] init];
        self.iCarouselView.type = iCarouselTypeCustom;
//        self.iCarouselView.currentItemIndex = 1;
        self.iCarouselView.delegate               = self;
        self.iCarouselView.dataSource            = self;
        self.iCarouselView.pagingEnabled=YES;
        [self addSubview:self.iCarouselView];
        [_iCarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wSelf.title1.mas_bottom).offset(15);
            make.left.equalTo(wSelf).offset(20);
            make.height.offset(189);
            make.width.offset(kTPScreenWidth -40);
            
        }];
        
        _title2 = [[UILabel alloc] init];
        _title2.text = @"推荐";
        _title2.textColor = [UIColor whiteColor];
        _title2.font = [UIFont systemFontOfSize:18];
        [self addSubview:_title2];
        [_title2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(wSelf.mas_bottom).offset(-15);
            make.centerX.equalTo(wSelf);
            make.height.offset(28);
            make.width.offset(37);
        }];
        
        [self requestSelectVideo];
    }
    return self;
}


#pragma mark  ---------------iCarousel Delegate-------------
- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    return kTPScreenWidth * 0.78;
}


-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.selectArr.count;
    
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth - 40, 189)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:bgview.frame];
    [bgview addSubview:imgView];
    HomeSelectModel  *model = self.selectArr[index];
    [imgView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
    return bgview;
}


-(void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    NSLog(@"carousel %ld",(long)carousel.currentItemIndex);
    //    _iCarouselindex = carousel.currentItemIndex;
}



- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel {
   
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if(self.selectArr.count < 1) return;
    HomeSelectModel  *model = self.selectArr[index];
    NSDictionary *userInfo = @{@"userIf":model};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selctVideoJump_post" object:self userInfo:userInfo];
    
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 1.0f;
    if (offset <= 1 && offset >= -1){

        float tempScale = offset < 0 ? 1 + offset : 1 - offset;
        float slope = (max_sacle-min_scale) / 1;
        CGFloat scale = min_scale + slope * tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);

    }else{

        transform = CATransform3DScale(transform, min_scale, min_scale, 1);

    }
    return CATransform3DTranslate(transform, offset * self.iCarouselView.itemWidth * 1.2, 0.0, 0.0);
}

/**
 精选视频请求
 */
- (void)requestSelectVideo{
    ______WS();
    [[DJHttpApi shareInstance] POST:urlHomeSelect dict:nil succeed:^(id data) {
        NSMutableArray *arr = data[@"rspObject"];
        
        for (NSDictionary *dicSelect in arr) {
            HomeSelectModel *model = [[HomeSelectModel alloc] init];
            [model setValuesForKeysWithDictionary:dicSelect];
            [wSelf.selectArr addObject:model];
            [wSelf.iCarouselView reloadData];
            wSelf.iCarouselView.currentItemIndex = 1;

        }
    } failure:^(NSError *error) {
        
    }];
}

@end
