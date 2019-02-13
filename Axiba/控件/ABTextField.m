//
//  ABTextField.m
//  Axiba
//
//  Created by Peter on 16/7/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABTextField.h"

@implementation ABTextField

- (void)setPlaceholder:(NSString *)placeholder {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: HEXCOLOR(0xb6b8b7)}];
}

@end
