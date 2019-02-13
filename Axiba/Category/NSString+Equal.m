//
//  NSString+Equal.m
//  TP
//
//  Created by Peter on 15/12/6.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "NSString+Equal.h"

@implementation NSString (Equal)

- (BOOL)isEqualWith:(NSString *)string {
    if (![self isValid] && ![string isValid])
        return YES;
    return [self isEqualToString:string];
}
@end
