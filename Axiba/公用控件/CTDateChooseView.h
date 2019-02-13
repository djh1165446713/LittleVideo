//
//  CTDateChooseView
//  TP
//
//  Created by Peter on 15/9/16.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CTDateChooseBlock)(NSString* date);

@interface CTDateChooseView : UIView
@property (nonatomic,copy) NSString             *placeholder;

- (id)initWithFrame:(NSInteger)startYear end:(NSInteger)endYear frame:(CGRect)frame block:(CTDateChooseBlock)block;
- (void)show;
@end
