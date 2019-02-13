//
//  CTLikeContentVC.m
//  Axiba
//
//  Created by Peter on 16/6/21.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "CTLikeContentVC.h"
#import "CTLikeContentModel.h"
#import "ABFeedCell.h"
#import "ABVideoDetailVC.h"
#import "ABChannelDetailVC.h"
#import "ABUserLikeListVC.h"
#import "MylikeVideoCell.h"

@interface CTLikeContentVC ()<ABFeedCellDelegate>
@property (nonatomic, assign) NSInteger        page;
@property (nonatomic, strong) NSMutableArray   *list;
@property (nonatomic, strong) UIButton    *alldelebtn;
@property (nonatomic, strong) UIButton   *delebtn;
@property (nonatomic, strong) UIView   *bottomView;

@end

@implementation CTLikeContentVC

- (NSMutableArray*)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ______WS();
    self.title = @"我的收藏";
    self.showBackBtn = YES;
    
    //编辑按钮
    UIButton *btnBaredit          = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBaredit.frame              = CGRectMake(0 , 0, 44, 44);
    btnBaredit.titleLabel.font = Font_Chinease_Blod(14);
    btnBaredit.titleLabel.textAlignment = NSTextAlignmentRight;
    [btnBaredit setTitle:@"编辑" forState:UIControlStateNormal];
    [btnBaredit addTarget:self action:@selector(onActioneditBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnBaredit.stringTag          = @"tag_btn_head_edit";
    UIBarButtonItem *rightBarItem   = [[UIBarButtonItem alloc] initWithCustomView:btnBaredit];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    

    
    [self.tableView addPullNextHandle:^{
        wSelf.page++;
        [wSelf loadData:nil];
    }];
    
    [self setExtraCellLineHidden:self.tableView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = RGB(179, 179, 179);
    [self.tableView registerClass:[MylikeVideoCell class] forCellReuseIdentifier:@"likecell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.page = 1;
    [self showLoading];
    [self loadData:nil];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.hidden = YES;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.view.mas_bottom).offset(-44);
        make.width.offset(kTPScreenWidth);
        make.left.equalTo(wSelf.view.mas_left).offset(0);
        make.height.offset(44);
    }];
    
    _alldelebtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_alldelebtn setTitleColor:colorMain forState:(UIControlStateNormal)];
    [_alldelebtn setTitle:@"清空收藏记录" forState:(UIControlStateNormal)];
    _alldelebtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_alldelebtn addTarget:self action:@selector(allDeleteList:) forControlEvents:(UIControlEventTouchUpInside)];
    [_bottomView addSubview:_alldelebtn];
    [_alldelebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.bottomView.mas_left).offset(15);
        make.centerY.equalTo(wSelf.bottomView);
        make.width.offset(95);
        make.height.offset(20);
        
    }];
    
    _delebtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_delebtn setTitleColor:colorMain forState:(UIControlStateNormal)];
    [_delebtn setTitle:@"删除" forState:(UIControlStateNormal)];
    _delebtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_delebtn addTarget:self action:@selector(delebtnlittle:) forControlEvents:(UIControlEventTouchUpInside)];
    [_bottomView addSubview:_delebtn];
    [_delebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wSelf.bottomView.mas_right).offset(-15);
        make.centerY.equalTo(wSelf.bottomView);
        make.width.offset(40);
        make.height.offset(20);
        
    }];
    
}

- (void)loadData:(void(^)(void))block
{
    ______WS();
    [CTLikeContentModel getContent:self.userId page:self.page success:^(NSDictionary *resultObject) {
        [wSelf.tableView.mj_header endRefreshing];
        [wSelf.tableView.mj_footer endRefreshing];
        if (block != NULL) {
            block();
        }
        CTLikeContentModel* model = [[CTLikeContentModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200) {
            wSelf.page = model.rspObject.page.pageNumber.integerValue;
            [wSelf hideLoading:YES];
            if (model.rspObject.contents.count > 0) {
                [wSelf.list addObjectsFromArray:model.rspObject.contents];
            }
            if (wSelf.list.count == 0) {
                [wSelf showEmpty:nil];
            }
            if (model.rspObject.page.totalPage.integerValue <= wSelf.page) {
                [wSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (wSelf.tableView.editing == YES) {
                return ;
            }else{
                [wSelf.tableView reloadData];
            }
        }
        else {
            TOAST_FAILURE(model.rspMsg);
        }
    } failure:^(NSError *requestErr) {
        TOAST_ERROR(wSelf, requestErr);
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ABContentResult *modeContent = [self.list objectAtIndex:indexPath.row];
//    return [ABFeedCell heightForCell:modeContent isNeedShowGotoReviewAndSpeard:YES];
    
    return 110;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MylikeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"likecell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil)
    {
        cell = [[MylikeVideoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"likecell"];
    }
    ABContentResult *modeContent = [self.list objectAtIndex:indexPath.row];
    [cell setCelllabandimg:modeContent];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing == YES) {
        NSArray *subviews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
        for (id subCell in subviews) {
            if ([subCell isKindOfClass:[UIControl class]]) {
                
                for (UIImageView *circleImage in [subCell subviews]) {
                    circleImage.image = [UIImage imageNamed:@"edit_select_yes"];
                }
            }
        }
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //TODO: 转到视频界面
        ABContentResult *modeContent            = [self.list objectAtIndex:indexPath.row];
        ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
        ABVideoDetailVC* vc                     = [[ABVideoDetailVC alloc] initWithContentids:modelContentInfo.ids needShowKeyboard:NO];
        //    [self.navigationController pushViewController:vc animated:YES];
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
        [vc setVideoDetailName:modelContentInfo.title];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray *subviews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
    for (id subCell in subviews) {
        if ([subCell isKindOfClass:[UIControl class]]) {
            for (UIImageView *circleImage in [subCell subviews]) {
                if (cell.selected == YES) {
                    circleImage.image = [UIImage imageNamed:@"edit_select_yes"];
                }else{
                    circleImage.image = [UIImage imageNamed:@"edit_select_nor"];
                }
            }
        }
    }
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view         = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
      NSArray *subviews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
        for (id subCell in subviews) {
            if ([subCell isKindOfClass:[UIControl class]]) {
                for (UIImageView *circleImage in [subCell subviews]) {
                    circleImage.image = [UIImage imageNamed:@"edit_select_nor"];
                }
            }
        }
    //    [self.deleteArr removeObject:[self.dataArr objectAtIndex:indexPath.row]];
    //    self.deleteNum -= 1;
    //    [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.deleteNum] forState:UIControlStateNormal];
}


#pragma mark - touch up
- (void)deActionEnterChannel:(NSInteger)_index
{
    ABContentResult *modeContent            = [self.list objectAtIndex:_index];
    ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
    ABChannelDetailVC *vcChannel            = [[ABChannelDetailVC alloc] initWithChannel:modelContentInfo.channel_ids];
    [self.navigationController pushViewController:vcChannel animated:YES];
    [vcChannel setChannelName:modeContent.channelInfo.name];
}

- (void)deActionLikesUser:(NSInteger)_index
{
    ABContentResult *modeContent            = [self.list objectAtIndex:_index];
    ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
    ABUserLikeListVC *vcLikesList = [[ABUserLikeListVC alloc] initWithContentids:modelContentInfo.ids];
    [self.navigationController pushViewController:vcLikesList animated:YES];
}

- (void)deActionReview:(NSInteger)_index
{
    ABContentResult *modeContent            = [self.list objectAtIndex:_index];
    ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
    ABVideoDetailVC* vc                     = [[ABVideoDetailVC alloc] initWithContentids:modelContentInfo.ids needShowKeyboard:YES];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setVideoDetailName:modelContentInfo.title];
}


// 点击编辑
- (void)onActioneditBtnClicked:(UIButton *)button{
    if (button.selected) {
        button.selected = NO;
        [self.tableView setEditing:NO animated:YES];
        _bottomView.hidden = YES;
        // 有点影响动画效果
        [self.tableView reloadData];
        
        
    }else{
        button.selected = YES;
        [self.tableView setEditing:YES animated:YES];
        // 编辑模式的时候可以多选
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        _bottomView.hidden = NO;
    }
}

- (void)allDeleteList:(UIButton *)button{
    ______WS();

        for (int i = 0; i < self.list.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            NSArray *subviews = [[self.tableView cellForRowAtIndexPath:indexPath] subviews];
            for (id subCell in subviews) {
                if ([subCell isKindOfClass:[UIControl class]]) {
                    for (UIImageView *circleImage in [subCell subviews]) {
                        circleImage.image = [UIImage imageNamed:@"edit_select_yes"];
                    }
                }
            }
        }
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要清除全部收藏吗?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
        [alert show];
        [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber* x) {
            if (x.integerValue == 1) {
                wSelf.alldelebtn.enabled = NO;
                NSString *collectedids = nil;
                for (ABContentResult *model in wSelf.list) {
                    collectedids = [NSString stringWithFormat:@"%@,%@",collectedids,model.contentInfo.ids];
                }
                NSString *sessionid = [ABUser sharedInstance].abuser.user.sessionid;
                [[DJHttpApi shareInstance] POST:urlDelete dict:@{@"collectedids":collectedids,@"sessionid":sessionid} succeed:^(id data) {
                    [wSelf.list removeAllObjects];
                    [wSelf.tableView reloadData];
                    wSelf.alldelebtn.enabled = NO;
                } failure:^(NSError *error) {
                }];
            }
            if (x.integerValue == 0) {
                for (int i = 0; i < wSelf.list.count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [wSelf.tableView deselectRowAtIndexPath:indexPath animated:NO ];
                    NSArray *subviews = [[wSelf.tableView cellForRowAtIndexPath:indexPath] subviews];
                    for (id subCell in subviews) {
                        if ([subCell isKindOfClass:[UIControl class]]) {
                            
                            for (UIImageView *circleImage in [subCell subviews]) {
                                circleImage.image = [UIImage imageNamed:@"edit_select_nor"];
                            }
                        }
                        
                    }
                }
            }

        }];

}

- (void)delebtnlittle:(UIButton *)button{
    ______WS();
    
    NSArray *array = self.tableView.indexPathsForSelectedRows;
    NSString *collectedids = nil;
    if (array.count == 0 || !array) {
        return;
    }
    for (NSIndexPath *indexpath in array) {
        ABContentResult *modeContent = [self.list objectAtIndex:indexpath.row];
        collectedids = [NSString stringWithFormat:@"%@,%@",collectedids,modeContent.contentInfo.ids];
    }
    NSString *sessionid = [ABUser sharedInstance].abuser.user.sessionid;
    [[DJHttpApi shareInstance] POST:urlDelete dict:@{@"collectedids":collectedids,@"sessionid":sessionid} succeed:^(id data) {
        for (NSIndexPath *indexpath in array) {
            [wSelf.list removeObjectAtIndex:indexpath.row];
        }
        [wSelf.tableView reloadData];
    } failure:^(NSError *error) {

    }];
}


@end
