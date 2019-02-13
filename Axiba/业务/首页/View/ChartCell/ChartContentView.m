//
//  ChartContentView.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kContentStartMargin 25
#import "ChartContentView.h"
#import "ChartMessage.h"
@implementation ChartContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentLabel               = [[UILabel alloc]init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.font          = [UIFont fontWithName:@"HelveticaNeue" size:12];
        [self addSubview:self.contentLabel];


        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)]];
    }
    return self;
}

//-(void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    
//    CGFloat contentLabelX = 0;
//    if(self.chartMessage.messageType == kMessageFrom)
//    {
//        contentLabelX = kContentStartMargin * 0.7;
//        self.contentLabel.frame  = CGRectMake(contentLabelX, 8, self.frame.size.width-kContentStartMargin-5, self.frame.size.height);
////        self.backImageView.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds) + 8, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
//    }
//    else if(self.chartMessage.messageType == kMessageTo)
//    {
//        contentLabelX = kContentStartMargin * 0.8;
//        self.contentLabel.frame  = CGRectMake(contentLabelX, 8, self.frame.size.width-kContentStartMargin-5, self.frame.size.height);
////        self.backImageView.frame = CGRectMake(CGRectGetMinX(self.bounds)+4, CGRectGetMinY(self.bounds) + 8, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
//    }
//}

-(void)longTap:(UILongPressGestureRecognizer *)longTap
{
    if([self.delegate respondsToSelector:@selector(chartContentViewLongPress:content:)]){
        
        [self.delegate chartContentViewLongPress:self content:self.contentLabel.text];
    }
}

-(void)tapPress:(UILongPressGestureRecognizer *)tapPress
{
    if([self.delegate respondsToSelector:@selector(chartContentViewTapPress:content:)]){
    
        [self.delegate chartContentViewTapPress:self content:self.contentLabel.text];
    }
}



@end
