//
//  CTEmptyView.m
//  TP
//
//  Created by Peter on 15/9/22.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "CTEmptyView.h"

@implementation CTEmptyView
{
    UILabel     *lblText;
}

- (id)initWithFrame:(CGRect)frame {
     self = [super initWithFrame:frame];
     if (self) {
         self.backgroundColor = colorMainBG;
              ______WS();
         UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_none"]];
         [self addSubview:img];
    
         [img mas_makeConstraints:^(MASConstraintMaker* maker) {
             maker.centerY.mas_equalTo(wSelf).with.offset(-50);
             maker.centerX.mas_equalTo(wSelf);
             maker.size.mas_equalTo(CGSizeMake(120, 165));
         }];
        
         lblText = [[UILabel alloc] init];
         lblText.textColor = RGB(179, 179, 179);
         lblText.font = Font_Chinease_Normal(15);
         [self addSubview:lblText];

     }
     return self;
 }

- (void)setEmptyText:(NSString *)text {
    lblText.text = text;
    [CTTools setLineSpace:lblText];
    lblText.textAlignment = NSTextAlignmentCenter;
    lblText.numberOfLines = 0;
    lblText.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize s = [text textSizeWithFont:lblText.font constrainedToSize:CGSizeMake(kTPScreenWidth-60, 999) lineBreakMode:NSLineBreakByWordWrapping];
    NSInteger line = [CTTools getLineCount:text font:lblText.font width:kTPScreenWidth-60 lineMode:NSLineBreakByWordWrapping];
    ______WS();
    [lblText mas_makeConstraints:^(MASConstraintMaker* maker) {
        maker.centerY.equalTo(wSelf);
        maker.left.equalTo(wSelf.mas_left).with.offset(30);
        maker.right.equalTo(wSelf.mas_right).with.offset(-30);
        maker.height.mas_equalTo(s.height + line*CTLineSpace);
    }];
}

@end
