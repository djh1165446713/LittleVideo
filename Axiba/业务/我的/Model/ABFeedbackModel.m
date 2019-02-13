//
//  ABFeedbackModel.m
//  Axiba
//
//  Created by Peter on 16/6/11.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABFeedbackModel.h"

@implementation ABFeedbackModel

+ (void)feedback:(NSString*)feedback success:(void(^)(NSDictionary *resultObject))success failure:(void(^)(NSError *requestErr))failure {
    NSString* ccc = nil;
    NSString* city = [TPLocationManager locationCity];
    NSString* p = [TPLocationManager locationProvince];
    if ([city isValid] && [p isValid]) {
        ccc = [NSString stringWithFormat:@"%@-%@",p,city];
    }
    NSDictionary* dicParam = @{@"city":ccc?:@"",@"phone":[[[[ABUser sharedInstance] abuser] user] mobile],@"summary":feedback,@"usernames":[[[[ABUser sharedInstance] abuser] user] nickname]};
    [[CTHttpApi sharedInstance] requestWithURL:urlFeedback paras:dicParam success:success failure:failure];
}
@end
