//
//  JxbHUDPicker
//
//

#import "JxbHUDPicker.h"

@interface JxbHUDPicker()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString*     _currentSelectedString;
    NSInteger     _currentSelectedIndex;
    NSArray*      _dataSource;
    NSString*     _title;
}

@property (nonatomic, strong) UIView*       containerView;
@property (nonatomic, strong) UIWindow*     HUDwindow;
@property (nonatomic, strong) UIPickerView  *_pickerView;
@property (nonatomic, copy  ) JxbPickerSelect   selectblock;
@end

@implementation JxbHUDPicker

+ (instancetype)sharedInstance
{
    static JxbHUDPicker* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JxbHUDPicker new];
    });
    return instance;
}



- (id)init
{
    self = [super init];
    
    if (self) {
       
        // CGRect windowRect = [UIApplication sharedApplication].keyWindow.frame;
        _HUDwindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _HUDwindow.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3f];
        _HUDwindow.windowLevel = UIWindowLevelStatusBar + 1;
        _HUDwindow.hidden = YES;
        
    }
    return self;
}

+  (void)showPicker:(NSArray*)data Title:(NSString*)title selectBlock:(JxbPickerSelect)selectBlock
{
    JxbHUDPicker* picker = [self sharedInstance];
    picker->_dataSource = [data copy];
    picker->_title      = [title copy];
    picker->_selectblock = selectBlock;
    [picker showPickerInternal];

}

+ (void)hidePicker
{
    [[self sharedInstance] hidePickerInternal];
}
- (void)showPickerInternal
{

    ______WS();
    
     //毛玻璃效果
//    UIImage* bluredImg = [self bluredImage];
    UIImageView* imgv = [[UIImageView alloc]initWithFrame:_HUDwindow.bounds];
//    imgv.image = bluredImg;
    imgv.userInteractionEnabled = YES;
    [imgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSelfTapped:)]];
    [_HUDwindow addSubview:imgv];

    [self layoutSubViews];
    _HUDwindow.hidden = NO;
    [_HUDwindow bringSubviewToFront:_containerView];
    int w = [UIScreen mainScreen].bounds.size.width;
    int h = [UIScreen mainScreen].bounds.size.height;
    int p_h = CGRectGetHeight(_containerView.frame);
    _containerView.frame = CGRectMake(0, h,w, p_h);
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.containerView.frame = CGRectMake(0, h-p_h+20, w, p_h);
    } completion:^(BOOL finished) {
    }];
}

- (void)hidePickerInternal
{
    ______WS();
    [_HUDwindow bringSubviewToFront:_containerView];
    int w = [UIScreen mainScreen].bounds.size.width;
    int h = [UIScreen mainScreen].bounds.size.height;
    int p_h = CGRectGetHeight(_containerView.frame);
    _containerView.frame = CGRectMake(0, h-p_h, w, p_h);
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.containerView.frame = CGRectMake(0, h,w, p_h);
        wSelf.HUDwindow.alpha = 0;
    } completion:^(BOOL finished) {
        wSelf.HUDwindow.alpha = 1;
        [wSelf removeSubViews];
        wSelf.HUDwindow.hidden = YES;
        [wSelf reset];
    }];
}

- (void)layoutSubViews
{
    _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 244)];
    _containerView.backgroundColor = [UIColor clearColor];
    [_HUDwindow addSubview:_containerView];
   
//    ______WX(_containerView, weakCon);
    
    int w = [UIScreen mainScreen].bounds.size.width;
    //add a headerview
    UIView* _pickerHeaderView = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, w+4, 44)];
    _pickerHeaderView.backgroundColor = HEXCOLOR(0xFAFAFA);
    _pickerHeaderView.layer.borderColor =  HEXCOLOR(0x9B9B9B).CGColor;
    _pickerHeaderView.layer.borderWidth = 0.5f;
    [_containerView addSubview:_pickerHeaderView];
    
    __weak typeof (_pickerHeaderView) weakHead = _pickerHeaderView;
    
    UIButton* cancelBtn = [[UIButton alloc]init];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [cancelBtn addTarget:self action:@selector(onCacnelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pickerHeaderView addSubview:cancelBtn];
    CGSize sCancel = [cancelBtn.titleLabel.text textSizeWithFont:cancelBtn.titleLabel.font constrainedToSize:CGSizeMake(999, 999) lineBreakMode:NSLineBreakByWordWrapping];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakHead.mas_left).with.offset(16);
        make.centerY.mas_equalTo(weakHead);
        make.size.mas_equalTo(CGSizeMake(sCancel.width + 5, 18));
    }];
    
    UIButton* comfirmBtn = [[UIButton alloc]init];
    comfirmBtn.backgroundColor = [UIColor clearColor];
    [comfirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [comfirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [comfirmBtn addTarget:self action:@selector(onConfirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pickerHeaderView addSubview:comfirmBtn];
    CGSize sOK = [comfirmBtn.titleLabel.text textSizeWithFont:comfirmBtn.titleLabel.font constrainedToSize:CGSizeMake(999, 999) lineBreakMode:NSLineBreakByWordWrapping];
    [comfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakHead.mas_right).with.offset(-16);
        make.centerY.mas_equalTo(weakHead);
        make.size.mas_equalTo(CGSizeMake(sOK.width + 5, 18));
    }];
    
    
    __weak typeof (comfirmBtn) weakComfirm = comfirmBtn;
    __weak typeof (cancelBtn) weakCancel = cancelBtn;
    
    UILabel* label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = colorNormalText;
    label.text = _title;
    [_pickerHeaderView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakCancel.mas_right).with.offset(5);
        make.right.equalTo(weakComfirm.mas_left).with.offset(-5);
        make.centerY.mas_equalTo(weakHead);
        make.height.mas_equalTo(20);
    }];
    [label layoutIfNeeded];
    CGSize sTitle = [label.text textSizeWithFont:label.font constrainedToSize:CGSizeMake(label.width, 999) lineBreakMode:NSLineBreakByWordWrapping];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(sTitle.height);
    }];


    
    //add a pickerview
    UIPickerView* _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, w, 200)];
    _pickerView.delegate   = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [_pickerView selectRow:[JxbHUDPicker sharedInstance]->_currentSelectedIndex inComponent:0 animated:NO];
    [_containerView addSubview:_pickerView];

}

- (void)removeSubViews
{
    //remove subviews
    [_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_containerView removeFromSuperview];
    _containerView = nil;

    //remove subviews from window
    for (UIView* v in _HUDwindow.subviews ) {
        [v removeFromSuperview];
    }
}

- (void)reset
{
    _currentSelectedIndex = 0;
    _currentSelectedString = @"";
}

- (void)onSelfTapped:(id)sender
{
    [self hidePickerInternal];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - callback
                                                                    
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _dataSource.count;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _dataSource[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if (_dataSource.count == 0) {
        return;
    }
    _currentSelectedString = _dataSource[row];
    _currentSelectedIndex  = row;
}

- (void)onCacnelBtnClicked:(UIButton*)btn
{
    [self hidePickerInternal];
}
- (void)onConfirmBtnClicked:(UIButton*)btn
{
    [self hidePickerInternal];
    
    if (_dataSource.count == 0) {
        return;
    }
    if (_currentSelectedString.length == 0) {
        _currentSelectedString =  _dataSource[0];
    }
    
    if (self.selectblock != NULL) {
        self.selectblock(_currentSelectedIndex, _currentSelectedString);
    }
}
                
                                                                    
                                                                    
@end
