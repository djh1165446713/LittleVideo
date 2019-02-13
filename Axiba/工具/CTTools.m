//
//  CTTools.m
//  TP
//
//  Created by Peter on 15/9/14.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "CTTools.h"
#import "UIImage+ImageEffects.h"
#import "sys/utsname.h"
#import <objc/runtime.h>


#define kMoneyType  @"kMoneyType"
#define kUserLang   @"kUserLang"

static NSString *shareUrlApp;

@interface CTTools()

@end

@implementation CTTools


+ (BOOL)isChinaLang {
    return [[[CTTools getCurrentLang] lowercaseString] isEqualToString:@"zh-hans"];
}

+ (BOOL)isHantLang {
    return [[[CTTools getCurrentLang] lowercaseString] isEqualToString:@"zh-hant"];
}

+ (UIViewController* )rootViewController {
    UIViewController* root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return root;
}

+ (UIViewController* )currentRootController {
    UIViewController* root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    return root;
}

+ (NSString*)getTimezone {
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    return zone.name;
}

+ (NSString*)getDateByString:(NSString*)date bHasTime:(BOOL)bHasTime {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dt = [f dateFromString:date];
    NSString* d = [CTTools getDateString:[dt timeIntervalSince1970]*1000 bHasTime:bHasTime];
    return d;
}

+ (NSString*)getDateString:(NSTimeInterval)gmt bHasTime:(BOOL)bHasTime {
    return [CTTools getDateString:gmt bHasTime:bHasTime zoneName:nil];
}

+ (NSString*)getDateString:(NSTimeInterval)gmt bHasTime:(BOOL)bHasTime zoneName:(NSString*)zoneName {
    NSString* dateString = [self getDateString:gmt bHasTime:bHasTime zoneName:zoneName format:nil];
    return dateString;
}

+ (NSString*)getDateString:(NSTimeInterval)gmt bHasTime:(BOOL)bHasTime zoneName:(NSString*)zoneName format:(NSString*)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:gmt > 9999999999.0 ? gmt/1000 : gmt];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = nil;
    if ([zoneName isValid])
        timeZone = [NSTimeZone timeZoneWithName:zoneName];
    else
        timeZone = [NSTimeZone localTimeZone];
    if ([format isValid]) {
        [dateFormatter setDateFormat:format];
    }
    else {
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    NSString* dateString = [dateFormatter stringFromDate:date];
    if (bHasTime) {
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        dateString = [NSString stringWithFormat:@"%@ %@",dateString,[dateFormatter stringFromDate:date]];
    }
    return dateString;
}

+ (NSTimeInterval)getTimeInterval:(NSString*)dateString zoneName:(NSString*)zoneName {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = nil;
    if ([zoneName isValid])
        timeZone = [NSTimeZone timeZoneWithName:zoneName];
    else
        timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [dateFormatter dateFromString:dateString];
    return [date timeIntervalSince1970];
}

+ (NSString*)getTimeInterval:(NSDate *)date zoneName:(NSString *)zoneName format:(NSString*)format {
    NSDateFormatter* f_timezone = [[NSDateFormatter alloc] init];
    if ([format isValid]) {
        [f_timezone setDateFormat:format];
    }
    else {
        [f_timezone setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString* dateString = [f_timezone stringFromDate:date];
    
    NSTimeZone* timezone = [NSTimeZone timeZoneWithName:zoneName];
    [f_timezone setTimeZone:timezone];
    NSDate* d = [f_timezone dateFromString:dateString];
    //若当前的时间是非时令时区，查看时令时间需要处理偏移量；若已在时令时区，转化时系统已处理偏移
    double daylightSaveOffset_dest = [timezone daylightSavingTimeOffsetForDate:d];
    double daylightSaveOffset_today = [timezone daylightSavingTimeOffsetForDate:[NSDate date]];
    double dayOffset = daylightSaveOffset_dest - daylightSaveOffset_today;
    NSString* t = [NSString stringWithFormat:@"%.0f",([d timeIntervalSince1970] + timezone.secondsFromGMT + dayOffset) * 1000];
    return t;
}

+ (NSString*)getOSCountry {
    NSLocale *currentLocale = [NSLocale currentLocale];
    return [currentLocale objectForKey:NSLocaleCountryCode];
}

+ (void)setCurrentLang:(NSString*)lang {
    
    [[NSUserDefaults standardUserDefaults] setObject:lang forKey:kUserLang];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (NSString*)getCurrentLang {
    NSString* lang = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLang];
    if ([lang isValid])
        return lang;
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSArray* parts = [currentLanguage componentsSeparatedByString:@"-"];
    //移除地区代码
    if (![currentLanguage isEqualToString:@"zh-Hans"] && ![currentLanguage isEqualToString:@"zh-Hant"]) {
        if (parts.count > 1) {
            NSMutableArray* mutableParts = [NSMutableArray arrayWithArray:parts];
            [mutableParts removeLastObject];
            parts = mutableParts;
        }
    }
    NSMutableString* string = [NSMutableString string];
    for (NSString* item in parts) {
        [string appendString:item];
        [string appendString:@"-"];
    }
    if (string.length > 0) {
        currentLanguage = [string stringByReplacingCharactersInRange:NSMakeRange(string.length-1, 1) withString:@""];
    }
    //可能的值：zh, zh-Hans, zh-Hant (zh从zh-HK, zh-TW来)
    if ([currentLanguage isEqualToString:@"zh"])
        return @"zh-Hant";
    return currentLanguage;
}

+ (NSString*)getGlobalLang {
    NSString* lang = [CTTools getCurrentLang];
    if ([lang isEqualToString:@"zh-Hans"])
        return @"zh_cn";
    if ([lang isEqualToString:@"zh-Hant"])
        return @"zh_tw";
    return @"en";
}

+ (NSString*)getGlobalLangIfEnWasNull {
    NSString* lang = [CTTools getCurrentLang];
    if ([lang isEqualToString:@"zh-Hans"])
        return @".zh-cn";
    if ([lang isEqualToString:@"zh-Hant"])
        return @".zh-tw";
    return @"";
}

+ (NSString *)filterHTML:(NSString *)html {
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"[p" intoString:NULL] ;
        [theScanner scanUpToString:@"]" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@]", text] withString:@""];
    }
    return html;
}

+ (void)setLineSpace:(UILabel*)lbl {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[lbl.text isValid] ? lbl.text : @""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:CTLineSpace];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lbl.text.length)];
    lbl.attributedText = attributedString;
}

+ (CGFloat)setLineSpace:(UILabel*)lbl lineSpaceTimes:(CGFloat)lineSpaceTimes {
    CGSize s1 = [@"啊" textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(kTPScreenWidth, 999) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat lineSpace = lineSpaceTimes * s1.height;
    __block NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[lbl.text isValid] ? lbl.text : @""];
    
    [lbl.attributedText enumerateAttributesInRange:NSMakeRange(0, lbl.text.length) options:NSAttributedStringEnumerationReverse usingBlock:
     ^(NSDictionary *attributes, NSRange range, BOOL *stop) {
         NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
         [attributedString setAttributes:mutableAttributes range:range];
         
     }];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lbl.text.length)];
    lbl.attributedText = attributedString;
    
    return lineSpace;
}

+ (int)getLineCount:(NSString*)text font:(UIFont*)font width:(CGFloat)width lineMode:(NSLineBreakMode)lineMode {
    CGSize s1 = [@"啊" textSizeWithFont:font constrainedToSize:CGSizeMake(width, 999) lineBreakMode:lineMode];
    CGSize s2 = [text textSizeWithFont:font constrainedToSize:CGSizeMake(width, 999) lineBreakMode:lineMode];
    int lineCount = ceil(s2.height / s1.height);
    return lineCount;
}

+ (CGFloat)getHeightWithLine:(UILabel*)lbl width:(CGFloat)width lineMode:(NSLineBreakMode)lineMode {
    return [self getHeightWithLine:lbl width:width lineMode:lineMode lineNum:0];
}

+ (CGFloat)getHeightWithLine:(UILabel*)lbl width:(CGFloat)width lineMode:(NSLineBreakMode)lineMode lineNum:(NSInteger)lineNum {
    [CTTools setLineSpace:lbl];
    [lbl setNumberOfLines:lineNum];
    [lbl setLineBreakMode:lineMode];
    CGFloat height = 0;
    NSInteger line = [CTTools getLineCount:lbl.text font:lbl.font width:width lineMode:lineMode];
    if (lineNum > 0) {
        CGSize s = [@"啊" textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:lineMode];
        height = (s.height + CTLineSpace) * MIN(lineNum, line);
    }
    else {
        CGSize s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:lineMode];
        height = s.height+ line*CTLineSpace;
    }
    return height;
}

+ (CGFloat)getHeightOfLabel:(UILabel*)lbl maxWidth:(CGFloat)width lineSpaceTimes:(CGFloat)linsSpaceTimes {
    CGFloat lineSpace = [CTTools setLineSpace:lbl lineSpaceTimes:linsSpaceTimes];
    lbl.numberOfLines = 0;
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat height = 0;
    NSInteger line = [CTTools getLineCount:lbl.text font:lbl.font width:width lineMode:lbl.lineBreakMode];
    
    CGSize s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:lbl.lineBreakMode];
    height = s.height;
    if (line > 1) {
        height = height + (line-1)*lineSpace;
    }
    return height;
}

+ (NSString*)getMoenyType {
    NSString* type = [[NSUserDefaults standardUserDefaults] objectForKey:kMoneyType];
    if ([type isValid])
        return type;
    NSString *currentLanguage = [CTTools getCurrentLang];
    if ([currentLanguage isEqualToString:@"en"])
        return @"USD";
    else if ([currentLanguage isEqualToString:@"ja"])
        return @"JPY";
    else if ([currentLanguage isEqualToString:@"ko"])
        return @"KRW";
    else if ([currentLanguage isEqualToString:@"zh-Hant"])
        return @"TWD";
    else if ([currentLanguage isEqualToString:@"zh-Hans"])
        return @"CNY";
    return @"USD";
}

+ (void)setMoneyType:(NSString*)type {
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:kMoneyType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)getPayMoneyType {
    return [CTTools getMoenyType];
}

+ (NSInteger)getDays:(NSString*)toDate {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [f setLocale:[NSLocale currentLocale]];
    NSDate* dt = [f dateFromString:toDate];
    NSTimeInterval t = [dt timeIntervalSinceNow];
    NSInteger days = t / (60 * 60 * 24);
    if ((NSInteger)t % (60*60*24) > 0) {
        days ++ ;
    }
    return days;
}

+ (NSString *)getDeviceCategroy
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSArray *modelArray = @[
                            
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            @"iPhone7,2",
                            @"iPhone7,1",
                            @"iPhone8,1",
                            @"iPhone8,2",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            
                            @"iPad4,1",
                            @"iPad4,2",
                            @"iPad4,3",
                            
                            @"iPad5,3",
                            @"iPad5,4",
                            
                            @"iPad6,7",
                            @"iPad6,8",
                            
                            @"iPad4,4",
                            @"iPad4,5",
                            @"iPad4,6",
                            
                            @"iPad4,7",
                            @"iPad4,8",
                            @"iPad4,9",
                            
                            @"iPad5,1",
                            @"iPad5,2",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator",
                                @"iPhone Simulator",
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                @"iPhone 6",
                                @"iPhone 6 Plus",
                                @"iPhone 6s",
                                @"iPhone 6s Plus",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                
                                @"iPad air (WiFi)",
                                @"iPad air (GSM)",
                                @"ipad air (GSM+CDMA)",
                                
                                @"iPad air2 (WiFi)",
                                @"iPad air2 (GSM+CDMA)",
                                
                                @"iPad Pro (WiFi)",
                                @"iPad Pro (GSM+CDMA)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)",
                                
                                @"iPad mini2 (WiFi)",
                                @"iPad mini2 (GSM)",
                                @"ipad mini2 (GSM+CDMA)",
                                
                                @"iPad mini3 (WiFi)",
                                @"iPad mini3 (GSM)",
                                @"ipad mini3 (GSM+CDMA)",
                                
                                @"iPad mini4 (WiFi)",
                                @"iPad mini4 (GSM+CDMA)",
                                
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    return modelNameString ?: deviceString;
}

+ (NSDictionary *)toDictionary:(NSObject*)model {
    Class clazz = [model class];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        NSString* property = [NSString stringWithUTF8String:propertyName];
        [propertyArray addObject:property];
        id value =  [model valueForKey:property];//kvc读值
        if(!value) {
            [valueArray addObject:@""];
        }
        else {
            if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
                [valueArray addObject:value];
            }
            else {
                NSDictionary* dic = [CTTools toDictionary:value];
                [valueArray addObject:dic];
            }
        }
    }
    free(properties);
    NSDictionary* dtoDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    return dtoDic;
}

+ (UIButton*)getButton:(NSString*)title frame:(CGRect)frame {
    UIButton* btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = colorMain;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    return btn;
}

+ (UIButton*)getButtonNoRoundCorder:(NSString*)title frame:(CGRect)frame {
    UIButton* btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = colorMain;
    return btn;
}

+ (UIButton*)getNormalButton:(NSString*)title frame:(CGRect)frame {
    UIButton* btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:colorMain forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = colorMain.CGColor;
    btn.layer.borderWidth = 1;
    return btn;
}

+ (NSString*)getPaypalSecret:(NSString*)paypalStr {
    if (![paypalStr isValid]) return @"";
    NSString* paypal = [paypalStr copy];
    if ([paypal containsString:@"@"]) {
        NSRange r1 = [paypal rangeOfString:@"@"];
        NSString* front = [paypal substringToIndex:r1.location];
        NSString* end = [paypal substringFromIndex:r1.location];
        if (front.length > 3) {
            front = [front substringToIndex:3];
        }
        paypal = [NSString stringWithFormat:@"%@***%@",front,end];
    }
    else if (paypal.length > 3){
        if (paypal.length < 7) {
            NSString* front = [paypal substringToIndex:paypal.length / 2];
            NSString* end = [paypal substringFromIndex:paypal.length / 2];
            paypal = [NSString stringWithFormat:@"%@****%@",front,end];
        }
        else {
            NSString* front = [paypal substringToIndex:3];
            NSString* end = [paypal substringFromIndex:paypal.length - 4];
            paypal = [NSString stringWithFormat:@"%@****%@",front,end];
        }
    }
    return paypal;
}

+ (UIImage*)getBlurImage {
    UIImage *screenshot = [self getScreenshot];
    return [screenshot applyDarkEffect];
}

+ (UIImage*)getBlurLightImage {
    UIImage *screenshot = [self getScreenshot];
    return [screenshot applyLightEffectAdjust];
}

+ (UIImage *)getScreenshot {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = keyWindow.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [keyWindow drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage *blurredScreenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blurredScreenShot;
}

+ (UIImage*)createImageWithColor:(UIColor*) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)imageFromViewLayer:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageFromView:(UIView *)view {
//    UIGraphicsBeginImageContext(view.size);
    UIGraphicsBeginImageContextWithOptions(view.size, YES, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage*)cutImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

+ (NSString *)formattedCurrency:(NSString *)currency valueString:(NSString *)value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.currencySymbol = currency;
    
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithDouble:[value doubleValue]]];
    NSString *result = [formatted substringFromIndex:3];
    return result;
}

+ (NSString *)formattedCurrencyWithoutDot:(NSString *)currency valueString:(NSString *)value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.currencySymbol = currency;
    NSString *formatted = [formatter stringFromNumber:@(value.integerValue)];
    return formatted;
}

+ (NSString *)currencySymbolFromCode:(NSString *)currency {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currency];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@", [locale displayNameForKey:NSLocaleCurrencySymbol value:currency]];
    return currencySymbol;
}

+ (NSNumber *)numberFromCurrency:(NSString *)currency valueString:(NSString *)value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.currencySymbol = currency;
    NSString *currencyValue = [currency stringByAppendingString:value];
    NSNumber *number = [formatter numberFromString:currencyValue];
    return number;
}

#pragma mark - location
static NSDictionary* localCodes = nil;
+ (NSDictionary* )localCodes
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                      @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                      @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                      @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                      @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                      @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                      @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                      @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                      @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                      @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                      @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                      @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                      @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                      @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                      @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                      @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                      @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                      @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                      @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                      @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                      @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                      @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                      @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                      @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                      @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                      @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                      @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                      @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                      @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                      @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                      @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                      @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                      @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                      @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                      @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                      @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                      @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                      @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                      @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                      @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                      @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                      @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                      @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                      @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                      @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                      @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                      @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                      @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                      @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                      @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                      @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                      @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                      @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                      @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                      @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                      @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                      @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                      @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                      @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                      @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                      @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
        
    });
    return localCodes;
}

static NSString* localCode=nil;
+ (NSString* )defaultLocalCode {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLocale *locale = [NSLocale currentLocale];
        NSString* tt=[locale objectForKey:NSLocaleCountryCode];
        NSString* defaultCode=[[self localCodes] objectForKey:tt];
        localCode =  [NSString stringWithFormat:@"%@",defaultCode];        
    });
    return localCode;
}

static NSString* defaultCountry=nil;
+ (NSString* )defaultCountry
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLocale *locale = [NSLocale currentLocale];
        NSString* tt=[locale objectForKey:NSLocaleCountryCode];
        defaultCountry = [locale displayNameForKey:NSLocaleCountryCode value:tt];
    });
    return defaultCountry;
    
}


#pragma mark - 表情
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (NSString* )stringRemoveEmoji:(NSString *)string {
    NSMutableString* resultStr = [[NSMutableString alloc] init];
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            [resultStr appendString:@"[emoji]"];
                                        } else
                                            [resultStr appendString:substring];
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        [resultStr appendString:@"[emoji]"];
                                    } else
                                        [resultStr appendString:substring];
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        [resultStr appendString:@"[emoji]"];
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        [resultStr appendString:@"[emoji]"];
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        [resultStr appendString:@"[emoji]"];
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        [resultStr appendString:@"[emoji]"];
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        [resultStr appendString:@"[emoji]"];
                                    } else
                                        [resultStr appendString:substring];
                                }
                            }];
    
    return resultStr;
}


+ (NSString *)getFirstCharactor:(NSString *)aString {
    if (![aString isValid])
        return @"#";
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

+ (NSString*)getErrorDes:(NSError*)error {
    NSDictionary* dicUserinfo = [error userInfo];
    return [dicUserinfo objectForKey:NSLocalizedDescriptionKey];
}

+ (NSDictionary*)parseUrlParam:(NSURL*)url {
    NSString* params = url.query;
    if (![params isValid])
        return nil;
    NSMutableDictionary* dicParams = [[NSMutableDictionary alloc] init];
    NSArray* arr = [params componentsSeparatedByString:@"&"];
    for (NSString* item in arr) {
        NSString* key = [[item componentsSeparatedByString:@"="] objectAtIndex:0];
        NSString* value = [[item componentsSeparatedByString:@"="] objectAtIndex:1];
        [dicParams setObject:[value URLDecodeUsingEncoding:NSUTF8StringEncoding] forKey:key];
    }
    return dicParams;
}

+ (void)changeColorWithAnimation:(CGFloat)duration fromColorHex:(NSString*)fromColorHex toHex:(NSString*)toHex doBlock:(void(^)(UIColor* color))doBlock {
    unsigned long fromcolor = strtoul([fromColorHex UTF8String],0,16);
    CGFloat from_r = (float)((fromcolor & 0xFF0000) >> 16);
    CGFloat from_g = (float)((fromcolor & 0xFF00) >> 8);
    CGFloat from_b = (float)(fromcolor & 0xFF);
 
    unsigned long tocolor = strtoul([toHex UTF8String],0,16);
    CGFloat to_r = (float)((tocolor & 0xFF0000) >> 16);
    CGFloat to_g = (float)((tocolor & 0xFF00) >> 8);
    CGFloat to_b = (float)(tocolor & 0xFF);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int p = duration / 0.01;
        for (int i = 0; i <= p; i++) {
            CGFloat r = (to_r - from_r) * (1.0 * i / p) + from_r;
            CGFloat g = (to_g - from_g) * (1.0 * i / p) + from_g;
            CGFloat b = (to_b - from_b) * (1.0 * i / p) + from_b;
            
            UIColor* color = [UIColor colorWithRed:r/255.0 green:g/255. blue:b/255. alpha:1];;
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (doBlock != NULL)
                    doBlock(color);
            });
            
            [NSThread sleepForTimeInterval:0.01];
        }
    });
}

+ (UIColor*)convertColor:(UIColor*)fromColor toColor:(UIColor*)toColor progress:(CGFloat)progress {
    const CGFloat *components_from = CGColorGetComponents(fromColor.CGColor);
    CGFloat from_r = components_from[0];
    CGFloat from_g = components_from[1];
    CGFloat from_b = components_from[2];
    
    const CGFloat *components_to = CGColorGetComponents(toColor.CGColor);
    CGFloat to_r = components_to[0];
    CGFloat to_g = components_to[1];
    CGFloat to_b = components_to[2];
    
    UIColor* color = [UIColor colorWithRed:(from_r + progress * (to_r - from_r)) green:(from_g + progress * (to_g - from_g)) blue:(from_b + progress * (to_b - from_b)) alpha:1];
    return color;
}

+ (void)storeImage2Cache:(NSString*)url image:(UIImage*)image {
    [[SDImageCache sharedImageCache] storeImage:image forKey:url];
}

+ (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now   = [[NSDate date]timeIntervalSince1970];
    double distanceTime  = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate      = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr   = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay    = [df stringFromDate:[NSDate date]];
    NSString * lastDay   = [df stringFromDate:beDate];
    
    if (distanceTime < 60) //小于一分钟
    {
        distanceStr = @"刚刚";
    }
    else if (distanceTime < 60*60) //时间小于一个小时
    {
        distanceStr = [NSString stringWithFormat:@"%ld分钟",(long)distanceTime/60];
    }
    else if(distanceTime < 24*60*60 && [nowDay integerValue] == [lastDay integerValue]) //时间小于一天
    {
//        distanceStr = [NSString stringWithFormat:@"今天%@",timeStr];
        distanceStr = [NSString stringWithFormat:@"%ld小时",(long)distanceTime/3600];
    }
    else if(distanceTime < 24*60*60*30)
    {
        distanceStr = [NSString stringWithFormat:@"%ld天",(long)distanceTime/(3600*24)];
    }
    else if(distanceTime < 24*60*60*365)
    {
        distanceStr = [NSString stringWithFormat:@"%ld个月",(long)distanceTime/(3600*24*30)];
//        [df setDateFormat:@"MM-dd HH:mm"];
//        distanceStr = [df stringFromDate:beDate];
    }
    else
    {
        [df setDateFormat:@"yyyy年MM月dd日"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

@end
