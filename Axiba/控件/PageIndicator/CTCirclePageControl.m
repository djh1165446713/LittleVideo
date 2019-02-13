//
//  CTCirclePageControl.m
//  Tripinsiders
//
//  Created by ZhouQian on 16/4/27.
//  Copyright © 2016年 Tripinsiders. All rights reserved.
//

#import "CTCirclePageControl.h"

@interface CTCirclePageControl ()

@end

@implementation CTCirclePageControl

- (instancetype)init {
    return [self initWithFrame:CGRectZero dotRadius:10];
}
- (instancetype)initWithFrame:(CGRect)frame dotRadius:(CGFloat)dotRadius {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *vCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dotRadius, dotRadius)];
        vCircle.backgroundColor = [UIColor clearColor];
        vCircle.layer.cornerRadius = dotRadius/2;
        vCircle.layer.borderColor = [UIColor whiteColor].CGColor;
        vCircle.layer.borderWidth = 2;
        vCircle.layer.masksToBounds = YES;
        
        UIView *vDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dotRadius, dotRadius)];
        vDot.backgroundColor = [UIColor whiteColor];
        vDot.layer.cornerRadius = dotRadius/2;
        vDot.layer.borderColor = [UIColor whiteColor].CGColor;
        vDot.layer.masksToBounds = YES;
        self.activeImage = [CTTools imageFromViewLayer:vDot];
        self.inactiveImage = [CTTools imageFromViewLayer:vCircle];
    }
    return self;
}


-(void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* dot = [self.subviews objectAtIndex:i];
        UIImageView * newDot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dot.width, dot.height)];
        newDot.layer.masksToBounds = YES;
        newDot.backgroundColor = [UIColor clearColor];
        newDot.layer.cornerRadius = dot.height / 2;
        if (i == self.currentPage) {
            newDot.image = self.activeImage;
        }
        else {
            newDot.image = self.inactiveImage;
        }
        [dot addSubview:newDot];
    }
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}
@end
