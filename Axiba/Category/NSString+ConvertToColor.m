//
//  NSString+ConvertToColor.m
//  TP
//
//  Created by ZhouQian on 16/1/26.
//  Copyright © 2016年 VizLab. All rights reserved.
//

#import "NSString+ConvertToColor.h"

@implementation NSString (ConvertToColor)

+ (UIColor *)colorFromString:(NSString *)str {
    unsigned colorInt = 0;
    [[NSScanner scannerWithString:str] scanHexInt:&colorInt];
    return HEXCOLOR(colorInt);
}
@end
