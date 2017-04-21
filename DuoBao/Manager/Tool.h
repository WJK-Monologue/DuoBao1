//
//  Tool.h
//  Matsu
//
//  Created by linqsh on 15/5/13.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonDefine.h"

@interface Tool : NSObject


/**
 *  显示提示信息
 *
 *  @param content  提示内容
 *  @param selfView 提示信息所在的页面
 */
+ (void)showPromptContent:(NSString *)content onView:(UIView *)selfView;

/**
 *  present ViewController
 *
 *  @param viewController        presenting viewController
 *  @param presentViewController presented viewController
 *  @param animated              animation
 */
+ (void)presentModalFromViewController:(UIViewController *)viewController
                 presentViewController:(UIViewController *)presentViewController
                              animated:(BOOL)animated;

/**
 *  dismiss viewController
 *
 *  @param dismissViewController dismissed viewController
 *  @param animated              animation
 */
+ (void)dismissModalViewController:(UIViewController *)dismissViewController
                          animated:(BOOL)animated;

/**
 *  16进制颜色值转RGB
 *
 *  @param hexString 16进制字符串色值
 *
 *  @return RGB色值
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  保存图片到document
 */
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

/**
 *  压缩图片
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  获取公共图片
 */
+ (UIImage *)imageInPublic:(NSString *)imageName;

/**
 *  获取连接的wifi的信息
 */
+ (NSDictionary *)wifiInfo;


/**
 *  全屏查看图片
 */
+ (void)FullScreenToSeePicture:(UIImage*)image;

/**
 *  获取当前时间
 *  @param dateFormatString 时间格式
 */
+ (NSString *)getCurrentTimeWithFormat:(NSString *)dateFormatString;

/*
 * 检查手机号是否合法
 *
 */

+ (BOOL)isMobileNumberClassification:(NSString*)phone;

/**
 *  判断用户是否登录
 */
+ (BOOL)islogin;

/**
 *  用户登录
 */
+ (void)loginWithAnimated:(BOOL)animated viewController:(UIViewController *)viewControl;

/**
 *  自动登录
 */
+ (void)autoLoginSuccess:(void (^)(NSDictionary *))success
                    fail:(void (^)(NSString *))fail;

/**
 *  统一收起键盘
 */
+ (void)hideAllKeyboard;

/**
 *  获取数据库相关信息(用户信息)
 */
+ (void)getUserInfoFromSqlite;

/**
 *  存储当前账号信息，本地只保存一次，覆盖逻辑
 */
+ (void)saveUserInfoToDB:(BOOL)islogin;

/**
 *  指定大小压缩图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


/**
 * label 自适应字体大小
 */
+ (void)setFontSizeThatFits:(UILabel*)label;

/**
 *  32位MD5加密
 *
 *  @param string           加密字符串
 *  @param LetterCaseOption 加密选项 {UpperLetter:大写；LowerLetter:小写}
 *
 *  @return 加密后的字符串
 */
+ (NSString *)encodeUsingMD5ByString:(NSString *)srcString
                    letterCaseOption:(LetterCaseOption)letterCaseOption;


/*
 * 时间戳转为时间字符串
 *
 */
+ (NSString *)timeStringToDateSting:(NSString *)timestr format:(NSString *)format;

/**
 *  判断号码是否是合法手机号
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (BOOL)validateMobile:(NSString *)checkString;

/**
 *  判断是否输入的金额是否合法
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (BOOL)isPureFloat:(NSString *)string;

/**
 *  随机生成字符串
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (NSString *)randomlyGeneratedStrWithLength:(NSInteger)lenght;

/**
 *  发送短信
 *
 *  @param viewController 从哪个viewConotroller弹出的短信窗口
 *  @param recipients     收件人
 *  @param content        短信内容
 */
+ (void)sendMessageByViewController:(UIViewController *)viewController
                         recipients:(NSArray *)recipients
                            content:(NSString *)content;
/*
 * 校验身份证
 *
 */
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;


/**
 *  注入本地JavaScript代码
 */
+ (void)injectLocalJavaScript:(UIWebView *)webview jsFileName:(NSString *)jsFileName;

/*
 * 获取个人信息
 *
 */
+ (void)getUserInfo;

/*
 * 分享
 *
 */
+ (void)shareMessageToOtherApp:(NSString *)shareImageUrl
                   description:(NSString *)description
                      titleStr:(NSString *)titleStr
                      shareUrl:(NSString *)shareUrl
                      fromView:(UIView *)fromView;

//上架屏蔽数据判断接口
+ (void)httpGetIsShowThridView;
@end
