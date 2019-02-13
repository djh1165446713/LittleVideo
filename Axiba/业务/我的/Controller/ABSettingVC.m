//
//  ABSettingVC.m
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABSettingVC.h"
#import "ABRowCell.h"
#import "ABLoginVC.h"
#import "ABChangePassVC.h"
#import "ABAboutVC.h"

@interface ABSettingVC ()
@property (nonatomic, assign) float     cacheSize;
@property (nonatomic, assign) BOOL      isThird;
@end

@implementation ABSettingVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString* third = [[NSUserDefaults standardUserDefaults] objectForKey:@"kuserthird"];
    self.isThird = ![third isEqualToString:@"axiba"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多设置";
    self.showBackBtn = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self loadCacheSize];

}

- (void)loadCacheSize {
    ______WS();
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [cacPath objectAtIndex:0];
        wSelf.cacheSize  = [wSelf folderSizeAtPath:cachePath];
        [wSelf.tableView reloadData];
        TOAST_Hide;
    });
}

- (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

- (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

- (void)clearCache {
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[cachePath stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
        return 2;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (![ABUser isLogined] || self.isThird) {
            return 0;
        }
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"MINECELL";
    ABRowCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
//    cell.separatorInset=UIEdgeInsetsMake(0, 15, 0, 15);
    cell.lblTitle.font = [UIFont systemFontOfSize:16];
//    cell.
    cell.vLine.hidden = YES;
    if (!cell) {
        cell = [[ABRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.layer.masksToBounds = YES;
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell setTitle:@"修改密码" bNext:YES];
        cell.lblValue.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.vLine.hidden = NO;
        
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell setTitle:@"清除缓存" bNext:NO value:[NSString stringWithFormat:@"%.2fM",self.cacheSize] buttonCell:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.vLine.hidden = NO;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        [cell setTitle:@"关于我们" bNext:YES];
        cell.lblValue.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.vLine.hidden = NO;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (![ABUser isLoginedAndPresent]) {
            return;
        }
        ABChangePassVC *vc = [ABChangePassVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要清除缓存吗?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
        [alert show];
        ______WS();
        [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber* x) {
            if (x.integerValue == 1) {
                TOAST_Process;
                [wSelf clearCache];
                [wSelf loadCacheSize];
            }
        }];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        ABAboutVC *vc = [ABAboutVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
