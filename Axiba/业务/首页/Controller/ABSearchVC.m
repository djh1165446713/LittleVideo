//
//  ABSearchVC.m
//  Axiba
//
//  Created by Hu Zejiang on 16/6/9.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ABSearchVC.h"
#import "ABSearchCell.h"
#import "ABFeedCell.h"
#import "ABChannelCell.h"
#import "ABCommonDataManager.h"
#import "ABSearchModel.h"
#import "ABVideoDetailVC.h"
#import "ABChannelDetailVC.h"
#import "ABUserLikeListVC.h"
#import "HotseachcollCell.h"
#import "SearchCollectHeaderView.h"
@interface ABSearchVC ()<UITextFieldDelegate , UITableViewDataSource , UITableViewDelegate , ABFeedCellDelegate , ABSearchCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray  *m_arrayHistory;
    ABSearchModel   *m_modelSearch;
    
    NSMutableArray  *hotSearchArr;

}

//@property (nonatomic ,strong) UITableView *ui_tbHistory;
@property (nonatomic ,strong) UITableView *ui_tbResult;

@property (nonatomic ,strong) UICollectionView *ui_hot_cl;
@property (nonatomic ,strong) UILabel *hottitle;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *advertArray;
@end

@implementation ABSearchVC
@synthesize  ui_tbResult;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hotSearchArr = [NSMutableArray array];
    [self initBar];
    [self requestHot];
    [self initUI];
}

- (void)initBar
{
    self.view.frame = CGRectMake(0, 0, kTPScreenWidth, kTPScreenHeight-kTPNavBarHeight);
    self.navigationItem.hidesBackButton = YES;
    
    UIView *viewTitle               = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth, kTPNavBarHeight)];
    self.navigationItem.titleView   = viewTitle;
    

    UITextField* tfSearch           = [[UITextField alloc] initWithFrame:CGRectMake(6, (kTPNavBarHeight-26)/2, kTPScreenWidth - 68, 26)];
    tfSearch.delegate               = self;
    tfSearch.autocorrectionType     = UITextAutocorrectionTypeNo;
    tfSearch.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tfSearch.placeholder            = @"请输入要搜索的内容";
    tfSearch.backgroundColor        = RGB(52, 51, 48);
    tfSearch.font                   = Font_Chinease_Normal(13);
    tfSearch.keyboardType           = UIKeyboardTypeDefault;
    tfSearch.returnKeyType          = UIReturnKeyDone;
    tfSearch.layer.masksToBounds    = YES;

    tfSearch.textColor              = [UIColor whiteColor];
    tfSearch.leftViewMode           = UITextFieldViewModeAlways;
    tfSearch.stringTag              = @"tag_textfield_search";
    [tfSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    UIButton *btnLeftImage          = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(tfSearch.frame), CGRectGetHeight(tfSearch.frame))];
    [btnLeftImage  setImage:[UIImage imageNamed:@"ico_home_search"] forState:UIControlStateNormal];
    btnLeftImage.imageEdgeInsets    = UIEdgeInsetsMake(6, 6, 6, 6);
    tfSearch.leftView               = btnLeftImage;
    [viewTitle addSubview:tfSearch];
    
    //取消按钮
    UIButton *btnCancel             = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame                 = CGRectMake(kTPScreenWidth - 56 ,(kTPNavBarHeight-36)/2, 56, 36);
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:RGB(179, 179, 179) forState:UIControlStateNormal];
    btnCancel.titleEdgeInsets       = UIEdgeInsetsMake(0, -12, 0, 12);
    btnCancel.titleLabel.font       = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [btnCancel addTarget:self action:@selector(onActionCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.stringTag             = @"tag_btn_head_cancel";
    [viewTitle addSubview:btnCancel];
    
}

- (void)initUI
{
    _advertArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    self.view.backgroundColor =RGB(22, 21, 16);
    _index = 0;

    //搜索的结果集
    ui_tbResult   = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
    ui_tbResult.separatorStyle  = UITableViewCellSeparatorStyleNone;
    ui_tbResult.delegate        = self;
    ui_tbResult.dataSource      = self;
    ui_tbResult.hidden          = YES;
    ui_tbResult.backgroundColor = [UIColor clearColor];
    ui_tbResult.stringTag = @"ui_tbResult_tab";
    [self.view addSubview:ui_tbResult];
    [self setExtraCellLineHidden:ui_tbResult];
    
   
//    [self.view addSubview:ui_tbHistory];
//    [self setExtraCellLineHidden:ui_tbHistory];

    [self registerForKeyboardNotifications];
    
    ______WS();
    _hottitle = [[UILabel alloc] init];
    _hottitle.text = @"热门搜索";
    _hottitle.textColor = RGB(179, 179, 179);
    _hottitle.font = Font_Chinease_Blod(12);
    [self.view addSubview:_hottitle];
    [_hottitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.view.mas_top).offset(20);
        make.left.equalTo(wSelf.view.mas_left).offset(20);
        make.width.offset(60);
        make.height.offset(17);

    }];
    
    
    // 热门搜索
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _ui_hot_cl = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 40, kTPScreenWidth - 40, 400) collectionViewLayout:layout];
    _ui_hot_cl.delegate = self;
    _ui_hot_cl.dataSource = self;
    _ui_hot_cl.backgroundColor= [UIColor clearColor];
    [self.view addSubview:_ui_hot_cl];
    [_ui_hot_cl registerClass:[HotseachcollCell class] forCellWithReuseIdentifier:@"hotcell"];
    [_ui_hot_cl registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchCollectHeaderView"];
    
    m_arrayHistory  = [ABCommonDataManager getSearchKeyHistory];
    
    [_ui_hot_cl reloadData];
}


/*!
 @abstract 注册键盘消息
 */
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyKeyBoaryWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyKeyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}


// hot request
- (void)requestHot{
    ______WS();
    [[DJHttpApi shareInstance] POST:urlSearchHot dict:nil succeed:^(id data) {
        hotSearchArr = data[@"rspObject"];
        [wSelf.ui_hot_cl reloadData];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - private method
- (void)startSearch:(NSString *)_keyword
{
    UITextField *tfSearch = (UITextField *)[self.navigationController.navigationBar viewWithStringTag:@"tag_textfield_search"];
    tfSearch.text = _keyword;
    [MobClick endEvent:@"search_num_day"];
    _ui_hot_cl.hidden = YES;
    _hottitle.hidden = YES;
//    [_ui_hot_cl reloadData];
    [self showLoading];
    [self hideEmpty];
    __weak typeof(self) wSelf               = self;
    __weak typeof(ui_tbResult) wTbResult    = ui_tbResult;
    [ABSearchModel requestSearch:_keyword type:Type_Search_All pageNumber:@"1" block:^(NSDictionary *resultObject)
    {
        [wSelf hideLoading:NO];
        ABSearchModel* model = [[ABSearchModel alloc] initWithDictionary:resultObject error:nil];
        if (model.rspCode.integerValue == 200)
        {
            m_modelSearch       = model;
            wTbResult.hidden    = NO;
            [wTbResult reloadData];
            if(m_modelSearch.rspObject.content.count <= 0 && m_modelSearch.rspObject.channel.count<= 0)
            {
                [wSelf showEmpty:@""];
            }
        }
        else
        {
            TOAST_FAILURE(model.rspMsg);
        }
        
    } failure:^(NSError *requestErr)
    {
        [wSelf hideLoading:NO];
        TOAST_ERROR(wSelf, requestErr);
    }];
}


#pragma mark - on Action
// 点击取消按钮
-(void)onActionCancelBtnClicked:(UIButton *)_button
{
    UITextField *tfSearch = (UITextField *)[self.navigationController.navigationBar viewWithStringTag:@"tag_textfield_search"];
    [tfSearch resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

// 点击历史记录
- (void)touchHistoryAction:(UIButton *)button{
    NSInteger i = button.tag - 2000;
    NSString *strKey    = [m_arrayHistory objectAtIndex:i];
    [self startSearch:strKey];
}

// 删除搜索记录
- (void)onActionclearSearchClicked{
    NSLog(@"点击清空历史记录");
    [m_arrayHistory removeAllObjects];
    [ABCommonDataManager removeAllSearchKey];
    [_ui_hot_cl reloadData];
}

#pragma mark -------- collectview delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
         CGSize size = CGSizeMake(0, 0);
        return size;

    }else{
        CGSize size = CGSizeMake(kTPScreenWidth, 90);
        return size;

    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SearchCollectHeaderView" forIndexPath:indexPath];
        //添加头视图的内容
        //头视图添加view
        SearchCollectHeaderView *view = [[SearchCollectHeaderView alloc] initWithFrame:CGRectMake(0, 0, kTPScreenWidth - 40, 90)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onActionclearSearchClicked)];
        [view.clear_img addGestureRecognizer:tap];
        [view.clear_lab addGestureRecognizer:tap];
        [header addSubview:view];
        return header;
    }

    return nil;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return hotSearchArr.count;
    }else{
        return m_arrayHistory.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HotseachcollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotcell" forIndexPath:indexPath];
        cell.model = hotSearchArr[indexPath.row];
        return cell;
    }else{
        HotseachcollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotcell" forIndexPath:indexPath];
        cell.model = m_arrayHistory[indexPath.row];
        return cell;
    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGSize size = [hotSearchArr[indexPath.row] boundingRectWithSize:CGSizeMake(1000, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        size.width = size.width + 10;
        return size;
    }else{
        CGSize size = [m_arrayHistory[indexPath.row] boundingRectWithSize:CGSizeMake(1000, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        size.width = size.width + 10;
        return size;
    }

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(15, 2 ,0, 2);
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 30;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 16;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *strKey    = [hotSearchArr objectAtIndex:indexPath.row];
        [self startSearch:strKey];
    }else{
        NSString *strKey    = [m_arrayHistory objectAtIndex:indexPath.row];
        [self startSearch:strKey];
    }
}


#pragma mark - UITableViewDataSource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
        return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        if(section == 0)
            return 10;
        else
            return m_modelSearch && m_modelSearch.rspObject.channel.count > 0 ? 10 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 1)];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    if(!m_modelSearch) return 0;
    
    if(section == 0)
    {
        return m_modelSearch.rspObject.channel.count;
    }
    else
    {
        return m_modelSearch.rspObject.content.count;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        {
            return [ABChannelCell heightForCell];
        }
        else
        {
            return kTPScreenWidth * 0.5625;
        }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(indexPath.section == 0)
        {
            ABChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:[ABChannelCell identifier]];
            if (cell == nil)
            {
                cell = [[ABChannelCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[ABChannelCell identifier]];
            }
            
            ABChannelInfoResult *modelChannel = [m_modelSearch.rspObject.channel objectAtIndex:indexPath.row];
            [cell updateData:modelChannel];
            return cell;
        }
        else
        {
            ABFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:[ABFeedCell identifier]];
            if (cell == nil)
            {
                cell = [[ABFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[ABFeedCell identifier]];
                cell.delegate   = self;
            }
            
            ABContentResult *modelContent = [m_modelSearch.rspObject.content objectAtIndex:indexPath.row];
            [cell updateData:modelContent needShowReviewAndSpeard:YES index:indexPath];
            
            return cell;
        }
//    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        if(indexPath.section == 0)
        {
            ABChannelInfoResult *modelChannel       = [m_modelSearch.rspObject.channel objectAtIndex:indexPath.row];
            ABChannelDetailVC *vcChannel            = [[ABChannelDetailVC alloc] initWithChannel:modelChannel.ids];
            [self.navigationController pushViewController:vcChannel animated:YES];
            [vcChannel setChannelName:modelChannel.name];
        }
        else
        {
            ABContentResult *modeContent            = [m_modelSearch.rspObject.content objectAtIndex:indexPath.row];
            ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
            ABVideoDetailVC* vc                     = [[ABVideoDetailVC alloc] initWithContentids:modelContentInfo.ids needShowKeyboard:NO];
            UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navi animated:YES completion:nil];
            [vc setVideoDetailName:modelContentInfo.title];
        }
}


- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _ui_hot_cl.hidden = NO;
    _hottitle.hidden = NO;
    ui_tbResult.hidden  = YES;
    [self hideEmpty];
     m_arrayHistory = [ABCommonDataManager getSearchKeyHistory];
    [_ui_hot_cl reloadData];
}


- (void)textFieldDidChange:(UITextField *)textFile{
    if ([textFile.text isValid]) {
        _ui_hot_cl.hidden = NO;
        _hottitle.hidden = NO;
        ui_tbResult.hidden  = YES;
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"用户准备搜索 ： %@" , textField.text);
    if (![textField.text isValid] && hotSearchArr.count <= 0) {
        ui_tbResult.hidden  = YES;
    }else{
        _ui_hot_cl.hidden = YES;
        _hottitle.hidden = YES;
        ui_tbResult.hidden  = NO;
        if([textField.text isValid])
        {
            //做历史记录存储
            [m_arrayHistory addObject:textField.text];
            [_ui_hot_cl reloadData];
            [ABCommonDataManager addSearchKey:textField.text];
        }
        [self startSearch:textField.text];
    }
    [textField resignFirstResponder];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}


#pragma mark - delegate
- (void)deRemoveSearchKey:(NSString *)_strKey
{
    [m_arrayHistory removeObject:_strKey];
    [ABCommonDataManager removeSearchKey:_strKey];
}

- (void)deActionEnterChannel:(NSInteger)_index
{
    ABContentResult *modeContent            = [m_modelSearch.rspObject.content objectAtIndex:_index];
    ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
    ABChannelDetailVC *vcChannel            = [[ABChannelDetailVC alloc] initWithChannel:modelContentInfo.channel_ids];
    [self.navigationController pushViewController:vcChannel animated:YES];
    [vcChannel setChannelName:modeContent.channelInfo.name];
}

- (void)deActionLikesUser:(NSInteger)_index
{
    ABContentResult *modeContent            = [m_modelSearch.rspObject.content objectAtIndex:_index];
    ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
    ABUserLikeListVC *vcLikesList           = [[ABUserLikeListVC alloc] initWithContentids:modelContentInfo.ids];
    [self.navigationController pushViewController:vcLikesList animated:YES];
}

- (void)deActionReview:(NSInteger)_index
{
    ABContentResult *modeContent            = [m_modelSearch.rspObject.content objectAtIndex:_index];
    ABContentInfoResult *modelContentInfo   = modeContent.contentInfo;
    ABVideoDetailVC* vc                     = [[ABVideoDetailVC alloc] initWithContentids:modelContentInfo.ids needShowKeyboard:YES];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setVideoDetailName:modelContentInfo.title];
}


#pragma mark - notification
- (void)notifyKeyBoaryWasShown:(NSNotification *)_notification
{
    CGRect keyboardBounds;
    [[_notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    NSLog(@"keyBoard:%f", keyboardBounds.size.height);
    
//    ui_tbHistory.frame  = CGRectMake(0, 0, kTPScreenWidth, CGRectGetHeight(self.view.frame) - keyboardBounds.size.height);
}

- (void)notifyKeyboardWasHidden:(NSNotification *)_notification
{
    CGRect keyboardBounds;
    [[_notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
