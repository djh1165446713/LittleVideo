//
//  CTPlayTimeChooseView.m
//  TP
//
//  Created by Peter on 15/9/16.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "CTDateChooseView.h"


@interface CTDateChooseView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    
    UILabel         *lblTitle;
    
    NSMutableArray         *arrYear;
    NSMutableArray         *arrMonth;
    NSMutableArray         *arrDay;
    
    
    
    
}
@property (nonatomic, strong)UIView          *vOpt;
@property (nonatomic, strong)UIPickerView    *pickView;
@property (nonatomic, strong)NSString        *year;
@property (nonatomic, strong)NSString        *month;
@property (nonatomic, strong)NSString        *day;
@property (nonatomic,assign) int min;
@property (nonatomic,assign) int max;

@property (nonatomic, copy  ) CTDateChooseBlock selectBlock;
@end

@implementation CTDateChooseView

- (void)dealloc {
    NSLog(@"CTDateChooseView dealloc");
}

- (id)initWithFrame:(NSInteger)startYear end:(NSInteger)endYear frame:(CGRect)frame block:(CTDateChooseBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectBlock = block;
        arrYear = [NSMutableArray array];
        arrMonth = [NSMutableArray array];
        arrDay = [NSMutableArray array];
        
//        NSDate *currentDate = [NSDate date];
//        NSCalendar* calendar = [NSCalendar currentCalendar];
//        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        
        for (NSInteger i = startYear; i <= endYear; i++) {
            [arrYear addObject:[NSNumber numberWithInteger:i]];
        }
        
        arrMonth = [NSMutableArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
        
        self.year = [NSString stringWithFormat:@"%zd",startYear]; //[NSString stringWithFormat:@"%zd",components.year];
        self.month = @"01";
        self.day = @"01";
        
        
        [self initUIS];
    }
    return self;
}

- (void)initUIS {
    __weak typeof (self) wSelf = self;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        [wSelf hide];
    }];
    [self addGestureRecognizer:tap];
   
    self.vOpt = [[UIView alloc] initWithFrame:CGRectMake(0, kTPScreenHeight, kTPScreenWidth, 44)];
    self.vOpt.backgroundColor = HEXCOLOR(0xfafafa);
    [self.vOpt addGestureRecognizer:[UITapGestureRecognizer new]];
    [self addSubview:self.vOpt];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = colorNormalText;
    [self.vOpt addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.vOpt);
        make.right.equalTo(wSelf.vOpt);
        make.bottom.equalTo(wSelf.vOpt);
        make.height.mas_equalTo(0.5);
    }];
    
    self.pickView = [[UIPickerView alloc] init];
    [self addSubview:self.pickView];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    self.pickView.backgroundColor =  [UIColor whiteColor];
    self.pickView.tintColor = colorMain;
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf);
        make.right.equalTo(wSelf);
        make.top.equalTo(wSelf.vOpt.mas_bottom);
        make.height.mas_equalTo(200);
    }];

    
    UIButton* btnCancel = [[UIButton alloc] init];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCancel.titleLabel.font = Font_Chinease_Normal(15);
    [btnCancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.vOpt addSubview:btnCancel];
    CGSize sCancel = [btnCancel.titleLabel.text textSizeWithFont:btnCancel.titleLabel.font constrainedToSize:CGSizeMake(999, 999) lineBreakMode:NSLineBreakByWordWrapping];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wSelf.vOpt.mas_left).with.offset(16);
        make.centerY.mas_equalTo(wSelf.vOpt);
        make.size.mas_equalTo(CGSizeMake(sCancel.width + 5, 18));
    }];
    
    UIButton* btnOK = [[UIButton alloc] init];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnOK.titleLabel.font = Font_Chinease_Normal(15);
    [self.vOpt addSubview:btnOK];
    CGSize sOK = [btnOK.titleLabel.text textSizeWithFont:btnOK.titleLabel.font constrainedToSize:CGSizeMake(999, 999) lineBreakMode:NSLineBreakByWordWrapping];
    [btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wSelf.vOpt.mas_right).with.offset(-16);
        make.centerY.mas_equalTo(wSelf.vOpt);
        make.size.mas_equalTo(CGSizeMake(sOK.width + 5, 18));
    }];
    [[btnOK rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (wSelf.selectBlock != NULL) {
            wSelf.selectBlock([NSString stringWithFormat:@"%@-%@-%@",wSelf.year,wSelf.month,wSelf.day]);
        }
        [wSelf hide];
    }];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    lblTitle.text = self.placeholder;
    lblTitle.textColor = colorNormalText;
    lblTitle.font = Font_Chinease_Normal(15);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [self.vOpt addSubview:lblTitle];
    
    [self performSelector:@selector(reloadDay) withObject:nil afterDelay:0.5];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    lblTitle.text = placeholder;
}

- (void)reloadDay {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSString* date = [NSString stringWithFormat:@"%@-%@-10",self.year,self.month];
    NSDate *today = [f dateFromString:date];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:today];
    [arrDay removeAllObjects];
    for (int i = 1; i <= days.length; i++) {
        if (i < 10)
            [arrDay addObject:[NSString stringWithFormat:@"0%d",i]];
        else
            [arrDay addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.pickView reloadAllComponents];
   
    NSInteger row1 = self.year.integerValue - [[arrYear objectAtIndex:0] integerValue];
    [self.pickView selectRow:row1 inComponent:0 animated:YES];
    
    NSInteger row2 = self.month.integerValue-1;
    [self.pickView selectRow:row2 inComponent:1 animated:YES];
}

#pragma mark- 设置数据
//一共多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

//每列对应多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return arrYear.count;
    } else if (component == 1) {
        return arrMonth.count;
    } else {
        return arrDay.count;
    }
}

//每列每行对应显示的数据是什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSNumber* num = [arrYear objectAtIndex:row];
        return num.stringValue;
    }
    else if (component == 1) {
        return [arrMonth objectAtIndex:row];
    }
    else {
        return [arrDay objectAtIndex:row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSNumber* num = [arrYear objectAtIndex:row];
        self.year = num.stringValue;
        [self reloadDay];
    }
    else if (component == 1) {
        self.month = [arrMonth objectAtIndex:row];
        [self reloadDay];
    }
    else {
        self.day = [arrDay objectAtIndex:row];
    }
}

#pragma mark - open
- (void)show {
    __weak typeof (self) wSelf = self;
    self.vOpt.y = kTPScreenHeight;
    [self.pickView layoutIfNeeded];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        wSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        wSelf.vOpt.y = kTPScreenHeight - 200;
        [wSelf.pickView layoutIfNeeded];
    } completion:^(BOOL b) {
        if (b) {
            [wSelf.pickView selectRow:wSelf.min inComponent:0 animated:YES];
            [wSelf.pickView selectRow:wSelf.max-wSelf.min-1 inComponent:1 animated:YES];
        }
    }];
    
}

- (void)hide {
    __weak typeof (self) wSelf = self;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        wSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        wSelf.vOpt.y = kTPScreenHeight;
        [wSelf.pickView layoutIfNeeded];
    } completion:^(BOOL b) {
        [wSelf removeFromSuperview];
    }];
}

@end
