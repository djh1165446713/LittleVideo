//
//  CTBaseTabVC.m
//  JXBFramework
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/3/22.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "CTBaseTabVC.h"
#import "CTBaseNavVC.h"

@implementation CTBaseTabItem
@end

@interface CTBaseTabVC()<UITabBarDelegate>
@property (nonatomic, strong) UILabel     *lblBadge;

@end

@implementation CTBaseTabVC

- (CTBaseTabVC*)initWithItems:(NSArray *)items {
    self = [super init];
    if(self)
    {
        [self setMyVCS:items];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
        [self.tabBar insertSubview:bgView atIndex:0];
       
        UIColor* uncolor = [UIColor lightGrayColor];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:uncolor} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:colorMain} forState:UIControlStateSelected];
    }
    
    return self;
}

- (void)setMyVCS:(NSArray*)items {
    NSMutableArray* navVCs = [NSMutableArray array];
    for(CTBaseTabItem* item in items)
    {
        item.rootVC.title = item.title;
        UIColor* uncolor = [UIColor lightGrayColor];
        item.rootVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:item.title image:[[[UIImage imageNamed:item.unselectedImage] imageWithTintColor:uncolor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[[UIImage imageNamed:item.selectedImage] imageWithTintColor:colorMain] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        CTBaseNavVC* nav = [[CTBaseNavVC alloc] initWithRootViewController:item.rootVC];
        [navVCs addObject:nav];
    }
    self.viewControllers = navVCs;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblBadge = [[UILabel alloc] init];
    self.lblBadge.textColor = [UIColor whiteColor];
    self.lblBadge.textAlignment = NSTextAlignmentCenter;
    self.lblBadge.font = [UIFont systemFontOfSize:11];
    self.lblBadge.backgroundColor = [UIColor redColor];
    self.lblBadge.layer.masksToBounds = YES;
    self.lblBadge.layer.cornerRadius = 5;
    self.lblBadge.hidden = YES;
    [self.tabBar addSubview:self.lblBadge];
    
    ______WS();
    [RACObserve(self.lblBadge, text) subscribeNext:^(NSString* text) {
        CGFloat x = kTPScreenWidth / 2 + 12;
        dispatch_async(dispatch_get_main_queue(), ^{
            wSelf.lblBadge.frame = CGRectMake(x, 4, 10, 10);
        });
    }];

    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:KCTNotityUnreadCount object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification *obj) {
        NSNumber *num = (NSNumber*)obj.object;
        wSelf.lblBadge.hidden = num.intValue == 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            wSelf.lblBadge.text = @"";
        });
    }];
    
}


-(BOOL)shouldAutorotate
{
    return YES;
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

