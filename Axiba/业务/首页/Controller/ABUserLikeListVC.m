//
//  ABUserLikeListVC.m
//  Axiba
//
//  Created by Michael on 16/6/14.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABUserLikeListVC.h"
#import "ABUserLikeCell.h"
#import "ABMineVC.h"
#import "ABActionLikeModel.h"
#import "ABCommonDataManager.h"

@interface ABUserLikeListVC ()<UITableViewDataSource , UITableViewDelegate>
{
    NSString                            *m_contentids;
    NSMutableArray<ABLikeUserModel *>   *m_arrayLikes;
}

@property (nonatomic, assign) NSInteger m_iPage;

@end

@implementation ABUserLikeListVC
@synthesize m_iPage;

- (id)initWithContentids:(NSString *)_strContentids
{
    m_contentids        = _strContentids;
    
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initUI
{
    self.itemTitle      = @"赞过的用户";
    self.showBackBtn    = YES;
    self.view.frame     = CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight-kTPNavBarHeight);
    UITableView *tableViewContent   = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    tableViewContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewContent.delegate       = self;
    tableViewContent.dataSource     = self;
    tableViewContent.showsVerticalScrollIndicator   = NO;
    tableViewContent.backgroundColor= [UIColor clearColor];
    tableViewContent.stringTag      = @"tag_table_content";
    [self.view addSubview:tableViewContent];
    [self setExtraCellLineHidden:tableViewContent];
    __weak typeof(self) wSelf       = self;
    [tableViewContent addPullNextHandle:^{
        wSelf.m_iPage++;
        [wSelf requestData];
    }];
    m_iPage = 1;
    [self showLoading];
    [self requestData];
}


#pragma mark - private method
/*!
 @method 请求网络数据
 */
- (void)requestData
{
    UITableView *tableViewContent           = (UITableView *)[self.view viewWithStringTag:@"tag_table_content"];
    __weak typeof(self) wSelf               = self;
    __weak typeof(tableViewContent) wTable  = tableViewContent;
    
    [ABLikeListModel requestLikeList:[NSString stringWithFormat:@"%ld",m_iPage] contentids:m_contentids block:^(NSDictionary *resultObject)
    {
        [wSelf hideLoading:NO];
        
        ABLikeListModel* model = [[ABLikeListModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200)
        {
            m_iPage = model.rspObject.page.pageNumber.integerValue;
            if(!m_arrayLikes) m_arrayLikes = [[NSMutableArray alloc] init];
            
            if (model.rspObject.page.totalPage.integerValue < m_iPage) {
                [wTable.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [m_arrayLikes addObjectsFromArray:model.rspObject.praise];
                [wTable.mj_footer endRefreshing];
            }
            
            if(m_arrayLikes.count<= 0)
            {
                [wSelf showEmpty:nil];
            }
            
            [wTable reloadData];
        }
        else
        {
            TOAST_FAILURE(model.rspMsg);
            [wTable.mj_footer endRefreshing];
        }
         
     } failure:^(NSError *requestErr)
     {
         [wTable.mj_footer endRefreshing];
         [wSelf hideLoading:NO];
         TOAST_ERROR(wSelf, requestErr);
     }];
}


#pragma mark - UITableViewDataSource and delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!m_arrayLikes) return 0;
    return m_arrayLikes.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ABUserLikeCell heightForCell];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABUserLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:[ABUserLikeCell identifier]];
    if (cell == nil)
    {
        cell = [[ABUserLikeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[ABUserLikeCell identifier]];
    }
    
    ABLikeUserModel *model = [m_arrayLikes objectAtIndex:indexPath.row];
    [cell updateData:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ABLikeUserModel *model  = [m_arrayLikes objectAtIndex:indexPath.row];
    ABMineVC *vcMine        = [[ABMineVC alloc] init];
    vcMine.userId           = model.ids;
    vcMine.avator           = model.avator;
    vcMine.nickname         = model.nickname;
    vcMine.summary          = model.summary;
    [self.navigationController pushViewController:vcMine animated:YES];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view         = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - delegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
