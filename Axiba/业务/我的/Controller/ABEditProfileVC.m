//
//  ABEditProfileVC.m
//  Axiba
//
//  Created by Peter on 16/6/10.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABEditProfileVC.h"
#import "ABEditProfileCell.h"
#import "CTRowEditVC.h"
#import "JxbHUDPicker.h"
#import "ABProfileModel.h"
#import "CTDateChooseView.h"
#import "CTCountryPickVC.h"
#import "CTBriefVC.h"
#import "JxbPickTool.h"

@interface ABEditProfileVC ()
@property (nonatomic, strong) NSString  *imageUrl;
@end

@implementation ABEditProfileVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑个人资料";
    self.showBackBtn = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageUrl = [[[[ABUser sharedInstance] abuser] user] avator];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 80;
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"MINECELL";
    ABEditProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[ABEditProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    [cell setHead:nil];
    cell.vLine.hidden = false;
    if (indexPath.row == 0) {
        cell.lblValue.hidden = YES;
        [cell setTitle:nil title:@"头像" bNext:YES value:nil buttonCell:NO];
        [cell setHead:[self.imageUrl isValid]?self.imageUrl:@"aa"];
    }
    else if (indexPath.row == 1) {
        NSString* sum = [[[[ABUser sharedInstance] abuser] user] nickname];
        if (sum.length > 15) {
            sum = [NSString stringWithFormat:@"%@...",[sum substringToIndex:15]];
        }
        [cell setTitle:nil title:@"昵称" bNext:YES value:sum buttonCell:NO];
    }
    else if (indexPath.row == 2) {
         [cell setTitle:nil title:@"性别" bNext:YES value:[[[[ABUser sharedInstance] abuser] user] sexFormat] buttonCell:NO];
    }
    else if (indexPath.row == 3) {
         [cell setTitle:nil title:@"生日" bNext:YES value:[[[[ABUser sharedInstance] abuser] user] birthday] buttonCell:NO];
    }
    else if (indexPath.row == 4) {
        [cell setTitle:nil title:@"城市" bNext:YES value:[[[[ABUser sharedInstance] abuser] user] city] buttonCell:NO];
    }
    else if (indexPath.row == 5) {
        NSString* sum = [[[[ABUser sharedInstance] abuser] user] summary];
        if (sum.length > 15) {
            sum = [NSString stringWithFormat:@"%@...",[sum substringToIndex:15]];
        }
        [cell setTitle:nil title:@"简介" bNext:YES value:sum buttonCell:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ______WS();
    if (indexPath.row == 0) {
        ______WS();
        [[CTTakePhotoTool sharedInstance] takePhoto:self placeholder:@"请上传头像" autoUpload:YES chooseBlock:^(NSString * _Nonnull picName, UIImage * _Nonnull image) {
            
        } errorBlock:nil completeUploadBlock:^(NSString * _Nonnull picUrl, UIImage * _Nonnull image) {
            wSelf.imageUrl = picUrl;
            [[[[ABUser sharedInstance] abuser] user] setAvator:picUrl];
            [[ABUser sharedInstance] syncUser];
            [wSelf.tableView reloadData];
        }];
    }
    else if (indexPath.row == 1) {
        CTRowEditVC* vc = [CTRowEditVC new];
        vc.title = @"昵称";
        vc.tipMsg = @"1-20个字符，支持英文、数字、“_”或-";
        vc.placeholder = @"请输入昵称";
        vc.maxLength = 20;
        vc.keyName = @"nickname";;
        vc.text = [[[[ABUser sharedInstance] abuser] user] nickname];
        vc.completeBlock = ^(NSString* key, NSString* value) {
            [[[[ABUser sharedInstance] abuser] user] setNickname:value];
            [[ABUser sharedInstance] syncUser];
            [wSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2) {
        [JxbHUDPicker showPicker:@[@"女",@"男",@"无性生物"] Title:@"请选择性别" selectBlock:^(NSInteger index, NSString *text) {
            [wSelf updateProfile:@"sex" value:[NSString stringWithFormat:@"%zd",index]];
            [[[[ABUser sharedInstance] abuser] user] setSex:[NSString stringWithFormat:@"%zd",index]];
            [[ABUser sharedInstance] syncUser];
            [wSelf.tableView reloadData];
        }];
    }
    
    else if (indexPath.row == 3) {
        CTDateChooseView* dateView = [[CTDateChooseView alloc] initWithFrame:1980 end:2016 frame:[UIScreen mainScreen].bounds block:^(NSString *date) {
            [wSelf updateProfile:@"birthday" value:date];
            [[[[ABUser sharedInstance] abuser] user] setBirthday:date];
            [[ABUser sharedInstance] syncUser];
            [wSelf.tableView reloadData];
        }];
        [dateView show];
    }
    else if (indexPath.row == 4) {
        NSString* file = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:file];
        JxbPickTool* tool = [JxbPickTool new];
        tool.itemData = [[JxbPickItem alloc] initWithDictionary:dic displayProperty:nil];
        tool.block = ^(NSArray* arr) {
            NSString* name = [NSString stringWithFormat:@"%@-%@",arr.firstObject,arr.lastObject];
            [wSelf updateProfile:@"city" value:name];
            [[[[ABUser sharedInstance] abuser] user] setCity:name];
             [[ABUser sharedInstance] syncUser];
            [wSelf.tableView reloadData];
        };
        [tool show:YES];
    }
    else if (indexPath.row == 5) {
        CTBriefVC* vc = [CTBriefVC new];
        vc.summary = [[[[ABUser sharedInstance] abuser] user] summary];
        [self.navigationController pushViewController:vc animated:YES];
        vc.block = ^(NSString* text) {
            if (text.length > 34) {
                TOAST_FAILURE(@"个人简介长度不能超过34");
                return ;
            }
            [wSelf updateProfile:@"summary" value:text?:@""];
            [[[[ABUser sharedInstance] abuser] user] setSummary:text?:@""];
            [[ABUser sharedInstance] syncUser];
            [wSelf.tableView reloadData];
            [wSelf.navigationController popViewControllerAnimated:YES];
        };
    }
}

- (void)updateProfile:(NSString*)keyname value:(NSString*)value {
    TOAST_Process;
    [ABProfileModel updateProfile:keyname value:value success:^(NSDictionary *resultObject) {
        ABProfileModel* model = [[ABProfileModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200) {
            TOAST_SUCCESS(@"保存成功");
        }
        else {
            TOAST_FAILURE(model.rspMsg);
        }
    } failure:^(NSError *requestErr) {
        TOAST_ERROR(wSelf, requestErr);
    }];
}
@end
