//
//  CTTools.h
//  TP
//
//  Created by Peter on 15/9/14.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JxbAlertView;

@interface CTTools : NSObject


/**
 *  是否中文版
 *
 *  @return 
 */
+ (BOOL)isChinaLang;

+ (BOOL)isHantLang;
/**
 *  获取主root
 *
 *  @return 
 */
+ (UIViewController* )rootViewController;

/**
 *  获取主root(带present)
 *
 *  @return
 */
+ (UIViewController* )currentRootController;

/**
 *  获取本地时区
 *
 *  @return
 */
+ (NSString*)getTimezone;

/**
*  获取用户设置区域日期显示
*
*  @param gmt      时间戳
*  @param bHasTime 是否显示时间
*
*  @return 中文 2015-12-12 12:12:12 ; 其他  Dec.12,2015 12:12:12
*/
+ (NSString*)getDateByString:(NSString*)date bHasTime:(BOOL)bHasTime;
+ (NSString*)getDateString:(NSTimeInterval)gmt bHasTime:(BOOL)bHasTime;
+ (NSString*)getDateString:(NSTimeInterval)gmt bHasTime:(BOOL)bHasTime zoneName:(NSString*)zoneName;
+ (NSString*)getDateString:(NSTimeInterval)gmt bHasTime:(BOOL)bHasTime zoneName:(NSString*)zoneName format:(NSString*)format;

/**
 *  根据时间字符串转时间戳
 *
 *  @param dateString 2012-08-09 23:11:12
 *  @param zoneName   时区名称
 *
 *  @return 时间戳
 */
+ (NSTimeInterval)getTimeInterval:(NSString*)dateString zoneName:(NSString*)zoneName;
+ (NSString*)getTimeInterval:(NSDate *)date zoneName:(NSString *)zoneName format:(NSString*)format;

/**
 *  获取国家
 *
 *  @return 
 */
+ (NSString*)getOSCountry;

/**
 *  设置手机使用语言
 *
 *  @param lang en,zh-Hans,zh-Hant
 */
+ (void)setCurrentLang:(NSString*)lang;

/**
 *  获取手机当前语言
 *
 *  @return 语言
 */
+ (NSString*)getCurrentLang;

/**
 *  获取标准语言
 *
 *  @return zh_cn  zh_tw  en
 */
+ (NSString*)getGlobalLang;

/**
 *  获取标准语言
 *
 *  @return .zh-cn  .zh-tw  (en为空)
 */
+ (NSString*)getGlobalLangIfEnWasNull;

/**
 *  过滤Html标签
 *
 *  @param html
 *
 *  @return     
 */
+ (NSString *)filterHTML:(NSString *)html;

/**
 *  设置行间距
 *
 *  @param lbl 
 */
+ (void)setLineSpace:(UILabel*)lbl;

/**
 *  设置行间距的具体值
 *
 *  @param lbl       要设置行间距的label
 *  @param lineSpaceTimes 行高的倍数
 *  @return 行间距
 */
+ (CGFloat)setLineSpace:(UILabel*)lbl lineSpaceTimes:(CGFloat)lineSpaceTimes;
/**
 *  获取行数
 *
 *  @param text  文字
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 行数
 */
+ (int)getLineCount:(NSString*)text font:(UIFont*)font width:(CGFloat)width lineMode:(NSLineBreakMode)lineMode;

/**
 *  获取文本的高度
 *
 *  @param lbl      文本label
 *  @param width    宽度
 *  @param lineMode 换行模式
 *
 *  @return 高度
 */
+ (CGFloat)getHeightWithLine:(UILabel*)lbl width:(CGFloat)width lineMode:(NSLineBreakMode)lineMode;
+ (CGFloat)getHeightWithLine:(UILabel*)lbl width:(CGFloat)width lineMode:(NSLineBreakMode)lineMode lineNum:(NSInteger)lineNum;
+ (CGFloat)getHeightOfLabel:(UILabel*)lbl maxWidth:(CGFloat)width lineSpaceTimes:(CGFloat)linsSpaceTimes;

/**
 *  Model转字典
 *
 *  @param model
 *
 *  @return
 */
+ (NSDictionary *)toDictionary:(NSObject*)model;

/**
 *  获取当前屏幕截图
 *
 *  @return
 */
+ (UIImage *)getScreenshot;
/**
 *  获取货币单位
 *
 *  @return TWD/CNY
 */
+ (NSString*)getMoenyType;
+ (void)setMoneyType:(NSString*)type;

/**
 *  获取支付币种
 *
 *  @return
 */
+ (NSString*)getPayMoneyType;

/**
 *  获取相差还有几天
 *
 *  @param toDate 到哪天
 *
 *  @return 
 */
+ (NSInteger)getDays:(NSString*)toDate;

/**
 *  获取手机型号
 *
 *  @return 
 */
+ (NSString *)getDeviceCategroy;

/**
 *  通用按钮
 *
 *  @return
 */
+ (UIButton*)getButton:(NSString*)title frame:(CGRect)frame;
+ (UIButton*)getNormalButton:(NSString*)title frame:(CGRect)frame;
+ (UIButton*)getButtonNoRoundCorder:(NSString*)title frame:(CGRect)frame;
/**
 *  Paypal隐式
 *
 *  @return
 */
+ (NSString*)getPaypalSecret:(NSString*)paypalStr;

/**
 *  获取当前界面的高斯效果图片
 *
 *  @return
 */
+ (UIImage*)getBlurImage;

/**
 *  获取当前界面的高斯效果图片，白色主题
 *
 *  @return
 */
+ (UIImage*)getBlurLightImage;

/**
 *  根据颜色生成uiiamge
 *
 *  @param color
 *
 *  @return 
 */
+ (UIImage*)createImageWithColor:(UIColor*)color;
+ (UIImage *)imageFromView:(UIView *)view;
+ (UIImage *)imageFromViewLayer:(UIView *)view;

/**
 *  剪裁图片
 *
 *  @param image 原始图片
 *  @param size  大小
 *
 *  @return
 */
+ (UIImage*)cutImage:(UIImage *)image scaleToSize:(CGSize)size;

/**
 *  获取国家代码
 *
 *  @return 86
 */
+ (NSString* )defaultLocalCode;

/**
 *  是否包含表情
 *
 *  @param string
 *
 *  @return 
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (NSString* )stringRemoveEmoji:(NSString *)string;

/**
 *  获取拼音首字母
 *
 *  @param aString
 *
 *  @return 
 */
+ (NSString *)getFirstCharactor:(NSString *)aString;


/**
 *  获取error的描述
 *
 *  @param error
 *
 *  @return 
 */
+ (NSString*)getErrorDes:(NSError*)error;

/**
 *  解析url参数
 *
 *  @param url
 *
 *  @return 
 */
+ (NSDictionary*)parseUrlParam:(NSURL*)url;

/**
 *  动画修改颜色
 *
 *  @param duration            时间
 *  @param fromColorHex        000000
 *  @param toHex               ffffff
 *  @param doBlock             操作
 */
+ (void)changeColorWithAnimation:(CGFloat)duration fromColorHex:(NSString*)fromColorHex toHex:(NSString*)toHex doBlock:(void(^)(UIColor* color))doBlock;

/**
 *  根据currency symbol把数字转化成对应的货币格式
 *
 *  @param currency currency symbol
 *  @param value    数字
 *
 *  @return formatted value
 */
+ (NSString *)formattedCurrency:(NSString *)currency valueString:(NSString *)value;
+ (NSString *)formattedCurrencyWithoutDot:(NSString *)currency valueString:(NSString *)value;
+ (NSString *)currencySymbolFromCode:(NSString *)currency;
/**
 *  把货币转化为数字
 *
 *  @param value currency string
 *
 *  @return nsnumber
 */
+ (NSNumber *)numberFromCurrency:(NSString *)currency valueString:(NSString *)value;

/**
 *  颜色渐变(只支持RGB颜色，[UIColor grayColor]这种目标暂不支持)
 *
 *  @param fromColor 初始颜色
 *  @param toColor   目标颜色
 *  @param progress  进度
 *
 *  @return 颜色
 */
+ (UIColor*)convertColor:(UIColor*)fromColor toColor:(UIColor*)toColor progress:(CGFloat)progress;

/**
 *  缓存图片（SD/）
 *
 *  @param url   图片地址
 *  @param image 图片Image
 */
+ (void)storeImage2Cache:(NSString*)url image:(UIImage*)image;

/*
 @method 牛逼的XB
 */
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;

@end






