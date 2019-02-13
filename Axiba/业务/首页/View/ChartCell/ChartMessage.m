//
//  ChartMessage.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartMessage.h"

@implementation ChartMessage

-(void)setDict:(NSDictionary *)dict
{
    _dict            = dict;
    self.icon        = dict[@"icon"];
    self.content     = dict[@"content"];
    self.messageType = [dict[@"type"] intValue];
}

- (void)setCommentModel:(ABCommentModel *)commentModel
{
    _commentModel       = commentModel;
    self.icon           = commentModel.my_infoObj.avator;
    self.content        = commentModel.message;
    if([commentModel.other_infoObj.nickname isValid])
    {
        NSString *strOtherInfo = commentModel.other_infoObj.nickname;
        strOtherInfo = [strOtherInfo stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        strOtherInfo = [strOtherInfo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        strOtherInfo = [strOtherInfo stringByReplacingOccurrencesOfString:@" " withString:@""];
        commentModel.other_infoObj.nickname = strOtherInfo;
        self.otherInfo  = [NSString stringWithFormat:@"回复%@:" ,strOtherInfo];
    }
    else
    {
        self.otherInfo  = @"";
    }
    self.messageType    = kMessageFrom;
    self.name           = [commentModel.my_infoObj.nickname isValid] ? commentModel.my_infoObj.nickname : commentModel.my_infoObj.ids;
    if (![self.name isValid]) {
    
    }
    self.time           = [CTTools distanceTimeWithBeforeTime:commentModel.create_time.doubleValue/1000];
}

- (NSString*)name
{
//    if ([_name isValid]) {
        return _name;
//    }
//    return @"佚名";
}
@end
