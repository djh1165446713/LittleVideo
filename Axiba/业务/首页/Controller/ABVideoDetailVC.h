//
//  ABVideoDetailVC.h
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTBaseVC.h"
#import "ABContentsModel.h"
#import "ABActionLikeModel.h"
@interface ABVideoDetailVC : CTBaseVC


- (id)initWithContent:(ABContentResult *)_contentInfo needShowKeyboard:(BOOL)_needShowKeyboard;
- (id)initWithContentids:(NSString *)_contentids needShowKeyboard:(BOOL)_needShowKeyboard;

- (void)setVideoDetailName:(NSString *)_contentName;

@property (strong, nonatomic) NSString *adImageUrl;
@property (strong, nonatomic) UIImageView *adImage;

@end
