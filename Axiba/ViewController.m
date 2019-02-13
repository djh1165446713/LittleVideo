//
//  ViewController.m
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ViewController.h"
#import "ABDemoModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ABDemoModel doDemoGet:^(NSDictionary *resultObject) {
        NSError* error = nil;
        ABDemoModel* model = [[ABDemoModel alloc] initWithDictionary:resultObject error:&error];
        NSLog(@"%@",model.description);
    } failure:^(NSError *requestErr) {
        
    }];
}


@end
