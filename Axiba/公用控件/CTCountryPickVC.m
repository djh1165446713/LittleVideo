//
//  CTCountryPickVC.m
//  TP
//
//  Created by Peter on 15/11/16.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "CTCountryPickVC.h"

@interface CTCountryPickVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSDictionary *dicLetters;

@end

@implementation CTCountryPickVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self.title isValid])
        self.title = @"城市";
    ______WS();

    [self initUIS];
    [self showLoading];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [wSelf loadData];
    });
}

- (void)loadData {
    NSString* dataString = @"{\"result\":[{\"locationId\":\"252\",\"hasChild\":1,\"name\":\"安徽\",\"abbr\":\"CN-34\"},{\"locationId\":\"241\",\"hasChild\":1,\"name\":\"北京\",\"abbr\":\"CN-11\"},{\"locationId\":\"262\",\"hasChild\":1,\"name\":\"重庆\",\"abbr\":\"CN-50\"},{\"locationId\":\"253\",\"hasChild\":1,\"name\":\"福建\",\"abbr\":\"CN-35\"},{\"locationId\":\"268\",\"hasChild\":1,\"name\":\"甘肃\",\"abbr\":\"CN-62\"},{\"locationId\":\"259\",\"hasChild\":1,\"name\":\"广东\",\"abbr\":\"CN-44\"},{\"locationId\":\"260\",\"hasChild\":1,\"name\":\"广西\",\"abbr\":\"CN-45\"},{\"locationId\":\"264\",\"hasChild\":1,\"name\":\"贵州\",\"abbr\":\"CN-52\"},{\"locationId\":\"261\",\"hasChild\":1,\"name\":\"海南\",\"abbr\":\"CN-46\"},{\"locationId\":\"243\",\"hasChild\":1,\"name\":\"河北\",\"abbr\":\"CN-13\"},{\"locationId\":\"248\",\"hasChild\":1,\"name\":\"黑龙江\",\"abbr\":\"CN-23\"},{\"locationId\":\"256\",\"hasChild\":1,\"name\":\"河南\",\"abbr\":\"CN-41\"},{\"locationId\":\"257\",\"hasChild\":1,\"name\":\"湖北\",\"abbr\":\"CN-42\"},{\"locationId\":\"258\",\"hasChild\":1,\"name\":\"湖南\",\"abbr\":\"CN-43\"},{\"locationId\":\"245\",\"hasChild\":1,\"name\":\"内蒙古\",\"abbr\":\"CN-15\"},{\"locationId\":\"250\",\"hasChild\":1,\"name\":\"江苏\",\"abbr\":\"CN-32\"},{\"locationId\":\"254\",\"hasChild\":1,\"name\":\"江西\",\"abbr\":\"CN-36\"},{\"locationId\":\"247\",\"hasChild\":1,\"name\":\"吉林\",\"abbr\":\"CN-22\"},{\"locationId\":\"246\",\"hasChild\":1,\"name\":\"辽宁\",\"abbr\":\"CN-21\"},{\"locationId\":\"270\",\"hasChild\":1,\"name\":\"宁夏\",\"abbr\":\"CN-64\"},{\"locationId\":\"269\",\"hasChild\":1,\"name\":\"青海\",\"abbr\":\"CN-63\"},{\"locationId\":\"267\",\"hasChild\":1,\"name\":\"陕西\",\"abbr\":\"CN-61\"},{\"locationId\":\"255\",\"hasChild\":1,\"name\":\"山东\",\"abbr\":\"CN-37\"},{\"locationId\":\"249\",\"hasChild\":1,\"name\":\"上海\",\"abbr\":\"CN-31\"},{\"locationId\":\"244\",\"hasChild\":1,\"name\":\"山西\",\"abbr\":\"CN-14\"},{\"locationId\":\"263\",\"hasChild\":1,\"name\":\"四川\",\"abbr\":\"CN-51\"},{\"locationId\":\"242\",\"hasChild\":1,\"name\":\"天津\",\"abbr\":\"CN-12\"},{\"locationId\":\"266\",\"hasChild\":1,\"name\":\"西藏\",\"abbr\":\"CN-54\"},{\"locationId\":\"271\",\"hasChild\":1,\"name\":\"新疆\",\"abbr\":\"CN-65\"},{\"locationId\":\"265\",\"hasChild\":1,\"name\":\"云南\",\"abbr\":\"CN-53\"},{\"locationId\":\"251\",\"hasChild\":1,\"name\":\"浙江\",\"abbr\":\"CN-33\"}]}";
    NSDictionary* dicData = [dataString toDictinary];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    for (NSDictionary* d in dicData[@"result"]) {
        NSString* name = d[@"name"];
        NSString* first = [name substringToIndex:1];
        NSString* letter = [CTTools getFirstCharactor:first];
        if ([dic objectForKey:letter]) {
            NSMutableArray* arr = [dic objectForKey:letter];
            [arr addObject:name];
            [dic setObject:arr forKey:letter];
        }
        else {
            NSMutableArray* arr = [NSMutableArray arrayWithObject:name];
            [dic setObject:arr forKey:letter];
        }
    }
    self.dicLetters = dic;
    ______WS();
    dispatch_async(dispatch_get_main_queue(), ^{
        [wSelf hideLoading:YES];
        [wSelf.tableView reloadData];
    });
}

- (void)initUIS {
    [self setShowBackBtn:YES];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = colorNormalText;
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSArray*)sortKeys:(NSArray*)keys {
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    return sortedArray;
}

#pragma mark - uitableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dicLetters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* keys = [self sortKeys:self.dicLetters.allKeys];
    NSArray* values = [self.dicLetters objectForKey:[keys objectAtIndex:section]];
    return values.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray* keys = [self sortKeys:self.dicLetters.allKeys];
    return [keys objectAtIndex:section];
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray* keys = [self sortKeys:self.dicLetters.allKeys];
    return keys;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"COUNTRYCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray* keys = [self sortKeys:self.dicLetters.allKeys];
    NSArray* values = [self.dicLetters objectForKey:[keys objectAtIndex:indexPath.section]];
    NSString* name = [values objectAtIndex:indexPath.row];
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray* keys = [self sortKeys:self.dicLetters.allKeys];
    NSArray* values = [self.dicLetters objectForKey:[keys objectAtIndex:indexPath.section]];
    NSString* name = [values objectAtIndex:indexPath.row];
    if (self.block != NULL) {
        self.block(name);
    }
}
@end
