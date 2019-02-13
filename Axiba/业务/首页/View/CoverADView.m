
//
//  CoverADView.m
//  Axiba
//
//  Created by bianKerMacBook on 2017/4/25.
//  Copyright © 2017年 Peter. All rights reserved.
//

#import "CoverADView.h"

@implementation CoverADView
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;

    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSDictionary *par = [[NSUserDefaults standardUserDefaults] objectForKey:@"adDic"];
    NSMutableDictionary *repDic = [NSMutableDictionary dictionaryWithDictionary:par];
    [repDic setValue:@"4" forKey:@"position"];
    [repDic setValue:@"2" forKey:@"type"];
    [repDic setValue:self.ids forKey:@"aids"];

    [[DJHttpApi shareInstance] POST:urlAdTopReport dict:repDic succeed:^(id data) {
        NSLog(@"广告点击: %@",data);
        [MobClick event:@"banner_ads_click_num"];

    } failure:^(NSError *error) {
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bannerADpost" object:self];
}

- (void)dealloc{
    NSLog(@"覆盖的View销毁了");
}



@end
