//
//  Tool.m
//  Matsu
//
//  Created by linqsh on 15/5/13.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import "Tool.h"
#import "MBProgressHUD.h"
#import "SJAvatarBrowser.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "LKDBHelper.h"
#import "LoginViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import <MessageUI/MFMessageComposeViewController.h>
//改动
#import "uuid.h"

#define IOS6_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

@implementation Tool

/**
 *  显示提示信息
 *
 *  @param content  提示内容
 *  @param selfView 提示信息所在的页面
 */
+ (void)showPromptContent:(NSString *)content onView:(UIView *)selfView
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:selfView animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = content;
    HUD.margin = 10.f;
    HUD.yOffset = 90.f ;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:1.5];
    
}

/**
 *  present ViewController
 *
 *  @param viewController        presenting viewController
 *  @param presentViewController presented viewController
 *  @param animated              animation
 */
+ (void)presentModalFromViewController:(UIViewController *)viewController
                 presentViewController:(UIViewController *)presentViewController
                              animated:(BOOL)animated
{
    if (IOS6_OR_LATER)
    {
        [viewController presentViewController:presentViewController
                                     animated:animated
                                   completion:nil];
    }
    else
    {
        [viewController presentViewController:presentViewController animated:YES completion:nil];
    }
}

/**
 *  dismiss viewController
 *
 *  @param dismissViewController dismissed viewController
 *  @param animated              animation
 */
+ (void)dismissModalViewController:(UIViewController *)dismissViewController
                          animated:(BOOL)animated
{
    if (IOS6_OR_LATER)
    {
        [dismissViewController dismissViewControllerAnimated:animated completion:nil];
    }
    else
    {
        [dismissViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 *  16进制颜色值转RGB
 *
 *  @param hexString 16进制字符串色值
 *
 *  @return RGB色值
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor clearColor];;
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSRange range = NSMakeRange(0, 2);
    
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:((float)red / 255.0f)
                           green:((float)green / 255.0f)
                            blue:((float)blue / 255.0f)
                           alpha:1.0f];
}

/**
 *  保存图片到document
 */
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage,0.5);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

/**
 *  压缩图片
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

/**
 *  获取公共图片
 */
+ (UIImage *)imageInPublic:(NSString *)imageName{
    NSString *imgName = [NSString stringWithFormat:@"%@.png", imageName];
    return [UIImage imageNamed:imgName];
}


/**
 *  获取连接的wifi的信息
 */
+ (NSDictionary *)wifiInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count])
        {
            NSMutableDictionary *proccessWifiInfo = [NSMutableDictionary dictionary];
            [proccessWifiInfo setObject:[info objectForKey:@"SSID"] forKey:@"SSID"];
            [proccessWifiInfo setObject:[info objectForKey:@"SSIDDATA"] forKey:@"SSIDDATA"];
            
            NSString *bssid = [info objectForKey:@"BSSID"];
            NSArray *array = [bssid componentsSeparatedByString:@":"];
            
            NSMutableString *proccessBSSID = [NSMutableString string];
            for (int i=0; i<array.count; i++)
            {
                NSString *ipComponent = [array objectAtIndex:i];
                if (ipComponent.length == 1) {
                    [proccessBSSID appendFormat:@"0%@", ipComponent];
                }else{
                    [proccessBSSID appendString:ipComponent];
                }
                
                if (i != array.count-1) {
                    [proccessBSSID appendString:@":"];
                }
            }
            
            [proccessWifiInfo setObject:proccessBSSID forKey:@"BSSID"];
            
            return proccessWifiInfo;
            break;
        }
    }
    
    return nil;
}


/**
 *  全屏查看图片（单张）
 */

+ (void)FullScreenToSeePicture:(UIImage*)image 
{
    
    [SJAvatarBrowser showImage:image];
}

/**
 *  获取当前时间
 *  @param dateFormatString 时间格式
 */

+ (NSString *)getCurrentTimeWithFormat:(NSString *)dateFormatString
{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:dateFormatString];
    NSString * curTime = [df stringFromDate:currentDate];
    
    //    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    //    [formater setDateFormat:dateFormatString];
    //    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //    [formater setTimeZone:timeZone];
    //    NSString * curTime = [formater stringFromDate:[NSDate date]];
    
    return curTime;
}

+ (BOOL)isMobileNumberClassification:(NSString*)phone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if (([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES)
        || ([regextestphs evaluateWithObject:phone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)islogin
{
    if ([ShareManager shareInstance].userinfo ) {
        return [ShareManager shareInstance].userinfo.islogin;
    }
    return NO;
}

+ (void)loginWithAnimated:(BOOL)animated viewController:(UIViewController *)viewControl
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    if (!viewControl) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:animated completion:nil];
    }else{
        [viewControl presentViewController:nav animated:animated completion:nil];
    }
}


+ (void)autoLoginSuccess:(void (^)(NSDictionary *))success
                    fail:(void (^)(NSString *))fail {
    
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    HttpHelper *helper = [[HttpHelper alloc] init];
    if (userInfo && userInfo.islogin) {
        
        if (userInfo.password.length < 1 || [userInfo.password isEqualToString:@"<null>"]) {
            
            NSString *loginIdStr = nil;
            NSString *typeStr = nil;
            if (userInfo.qq_login_id.length > 0 && ![userInfo.qq_login_id isEqualToString:@"<null>"] ) {
                loginIdStr = userInfo.qq_login_id ;
                typeStr = @"qq";
            }else{
                loginIdStr = userInfo.weixin_login_id ;
                typeStr = @"weixin";
            }
            
            [helper thirdloginByWithLoginId:loginIdStr
                                  nick_name:userInfo.nick_name
                                user_header:userInfo.user_header
                                       type:typeStr
                                   jpush_id:[uuid getUUID]
            // jpush_id:[JPUSHService registrationID]
                                    success:^(NSDictionary *resultDic){
                                        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                            UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
                                            [ShareManager shareInstance].userinfo = info;
                                            [Tool saveUserInfoToDB:YES];
                                        }
                                        success(resultDic);
                                    }fail:^(NSString *decretion){
                                        if (fail) {
                                            fail(decretion);
                                        }
                                    }];
            
            
        }
        else{
            [helper loginByWithMobile:userInfo.app_login_id
                             password:userInfo.password
                             //jpush_id:[JPUSHService registrationID]
                               jpush_id:[uuid getUUID]
                              success:^(NSDictionary *resultDic){
                                  if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                      UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
                                      [ShareManager shareInstance].userinfo = info;
                                      [Tool saveUserInfoToDB:YES];
                                  }
                                  success(resultDic);
                              }fail:^(NSString *decretion){
                                  if (fail) {
                                      fail(decretion);
                                  }
                              }];
        }
        
    }
}

/**
 *  统一收起键盘
 */
+ (void)hideAllKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


/**
 *  获取数据库相关信息(用户信息)
 */
+ (void)getUserInfoFromSqlite
{
    LKDBHelper *DBHelper = [LKDBHelper getUsingLKDBHelper];
    
    if ([DBHelper getTableCreatedWithClass:[UserInfo class]]) {
        NSArray *array = [DBHelper search:[UserInfo class] where:nil orderBy:nil offset:0 count:0];
        
        if (array && array.count > 0) {
            for (UserInfo *info in array) {
                [ShareManager shareInstance].userinfo = info;
                break;
            }
        }
        
    }
}


/**
*  存储当前账号信息，本地只保存一次，覆盖逻辑
*/
+ (void)saveUserInfoToDB:(BOOL)islogin
{
    if (islogin) {
        [ShareManager shareInstance].userinfo.islogin = YES;
    }else{
        [ShareManager shareInstance].userinfo.islogin = NO;
    }
    LKDBHelper *DBHelper = [LKDBHelper getUsingLKDBHelper];
    if([DBHelper getTableCreatedWithClass:[UserInfo class]])
    {
        [DBHelper deleteWithClass:[UserInfo class] where:nil];
    }
    
    [DBHelper insertToDB:[ShareManager shareInstance].userinfo];
}




/**
 *  指定大小压缩图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 * label 自适应字体大小
 */
+ (void)setFontSizeThatFits:(UILabel*)label
{
    label.adjustsFontSizeToFitWidth = YES;
}


/**
 *  32位MD5加密
 *
 *  @param string           加密字符串
 *  @param LetterCaseOption 加密选项 {UpperLetter:大写；LowerLetter:小写}
 *
 *  @return 加密后的字符串
 */
+ (NSString *)encodeUsingMD5ByString:(NSString *)srcString
                    letterCaseOption:(LetterCaseOption)letterCaseOption
{
    if (!srcString) {
        srcString = @"";
    }
    
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned)strlen(cStr), digest );
    NSMutableString *encodeString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [encodeString appendFormat:@"%02x", digest[i]];
    
    if (letterCaseOption == UpperLetter) {
        return [encodeString uppercaseString];
    }else{
        return [encodeString lowercaseString];
    }
    
}

/*
 * 时间戳转为时间字符串
 *
 */
+ (NSString *)timeStringToDateSting:(NSString *)timestr format:(NSString *)format
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestr longLongValue]/1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];//
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


/**
 *  判断号码是否是合法手机号
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (BOOL)validateMobile:(NSString *)checkString
{
    NSString * regex = @"(^[0-9]{11}$)";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:checkString];
    return isMatch && (checkString.length == 11);
}


/**
 *  判断是否输入的金额是否合法
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/**
 *  随机生成字符串
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (NSString *)randomlyGeneratedStrWithLength:(NSInteger)lenght
{
    char data[lenght];
    for (int x=0;x<lenght;data[x++] = (char)('a' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:lenght encoding:NSUTF8StringEncoding];
}

/**
 *  发送短信
 *
 *  @param viewController 从哪个viewConotroller弹出的短信窗口
 *  @param recipients     收件人
 *  @param content        短信内容
 */
+ (void)sendMessageByViewController:(UIViewController *)viewController
                         recipients:(NSArray *)recipients
                            content:(NSString *)content
{
    
    BOOL canSendSMS = [MFMessageComposeViewController canSendText];
    if (!canSendSMS) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备无法发送短信"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        return;
    }
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = (id)viewController;
    picker.body = content;
    picker.recipients = [NSArray arrayWithArray:recipients];
    
//    [FindMeTool presentModalFromViewController:viewController
//                         presentViewController:picker
//                                      animated:NO];
    [viewController presentViewController:picker animated:YES completion:nil];
}

/*
 * 校验身份证
 *
 */
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    BOOL flag;
    if (cardNo.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:cardNo];
}

/**
 *  注入本地JavaScript代码
 */
+ (void)injectLocalJavaScript:(UIWebView *)webview jsFileName:(NSString *)jsFileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsFileName ofType:@"js"];
    NSString *jsString = [[NSString alloc] initWithContentsOfFile:filePath
                                                         encoding:NSASCIIStringEncoding
                                                            error:nil];
    [webview stringByEvaluatingJavaScriptFromString:jsString];
}

/*
 * 获取个人信息
 *
 */
+ (void)getUserInfo
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          success:^(NSDictionary *resultDic){
                              if ([[resultDic objectForKey:@"result_code"] integerValue] == 0)
                              {
                                  UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
                                  [ShareManager shareInstance].userinfo = info;
                                  [Tool saveUserInfoToDB:YES];
                              }
                          }fail:^(NSString *decretion){
                          }];
}

/*
 * 分享
 *
 */
+ (void)shareMessageToOtherApp:(NSString *)shareImageUrl
                   description:(NSString *)description
                      titleStr:(NSString *)titleStr
                      shareUrl:(NSString *)shareUrl
                      fromView:(UIView *)fromView
{
    
    
    //    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    id<ISSContent> publishContent = nil;
    
    if(shareImageUrl)
    {
        //构造分享内容
        publishContent = [ShareSDK content:description
                            defaultContent:description
                                     image:[ShareSDK imageWithUrl:shareImageUrl]
                                     title:titleStr
                                       url:shareUrl
                               description:description
                                 mediaType:SSPublishContentMediaTypeNews];
        //定制新浪信息
        [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@(%@)",description,shareUrl] image:[ShareSDK imageWithUrl:shareImageUrl]];
    }else{
        //构造分享内容
        publishContent = [ShareSDK content:description
                            defaultContent:description
                                     image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"logo_duobao.png"]]
                                     title:titleStr
                                       url:shareUrl
                               description:description
                                 mediaType:SSPublishContentMediaTypeNews];
        //定制新浪信息
        [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@(%@)",description,shareUrl] image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"logo_duobao.png"]]];
    }
    
    
    //自定义新浪微博分享菜单项
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                                      clickHandler:^{
                                                                          [ShareSDK shareContent:publishContent
                                                                                            type:ShareTypeSinaWeibo
                                                                                     authOptions:nil
                                                                                   statusBarTips:YES
                                                                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                              
                                                                                              if (state == SSPublishContentStateSuccess)
                                                                                              {
                                                                                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                                                                                  [Tool shareAppSuccessBackCall];
                                                                                              }
                                                                                              else if (state == SSPublishContentStateFail)
                                                                                              {
                                                                                                  [Tool showPromptContent:@"分享失败" onView:[UIApplication sharedApplication].keyWindow];
                                                                                                  NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                                                                              }
                                                                                          }];
                                                                      }];
    
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:fromView
                            arrowDirect:UIPopoverArrowDirectionUp];
    
    
    NSArray *shareList = nil;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi] && [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi])
    {
        shareList = [ShareSDK customShareListWithType:
                     sinaItem,
                     [NSNumber numberWithInteger:ShareTypeWeixiSession],
                     [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
                     [NSNumber numberWithInteger:ShareTypeQQ],
                     [NSNumber numberWithInteger:ShareTypeQQSpace],
                     nil];
        
    }
    if (([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && !([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
    {
        
        shareList = [ShareSDK customShareListWithType:
                     sinaItem,
                     [NSNumber numberWithInteger:ShareTypeWeixiSession],
                     [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
                     nil];
    }
    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
    {
        
        shareList = [ShareSDK customShareListWithType:
                     sinaItem,
                     [NSNumber numberWithInteger:ShareTypeQQ],
                     [NSNumber numberWithInteger:ShareTypeQQSpace],
                     nil];
    }
    
    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) && !([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]))
    {
        
        shareList = [ShareSDK customShareListWithType:
                     sinaItem,
                     nil];
    }
    
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [Tool shareAppSuccessBackCall];
                                   
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [Tool showPromptContent:@"分享失败" onView:[UIApplication sharedApplication].keyWindow];
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    NSLog(@"发布失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
                                    
                                }
                            }];
      
    
}

+ (void)shareAppSuccessBackCall
{
    
    [Tool showPromptContent:@"分享成功" onView:[UIApplication sharedApplication].keyWindow];
    if ([ShareManager shareInstance].shareType == 1) {
        HttpHelper *helper = [[HttpHelper alloc] init];
        [helper getShareBackWithUserId:[ShareManager shareInstance].userinfo.id
                               news_id:[ShareManager shareInstance].shareContentId
                               success:^(NSDictionary *resultDic){
                                   NSLog(@"%@",resultDic);
                                   
                               }fail:^(NSString *decretion){
                               }];
    }
    else if ([ShareManager shareInstance].shareType == 2){
        HttpHelper *helper = [[HttpHelper alloc] init];
        [helper getShaiDanOrAppShareBackWithUserId:[ShareManager shareInstance].userinfo.id
                                              type:@"9"
                                         target_id:[ShareManager shareInstance].shareContentId
                                           success:^(NSDictionary *resultDic){
                                               NSLog(@"%@",resultDic);
                                           }fail:^(NSString *decretion){
                                           }];
    }else if ([ShareManager shareInstance].shareType == 3){
        HttpHelper *helper = [[HttpHelper alloc] init];
        [helper getShaiDanOrAppShareBackWithUserId:[ShareManager shareInstance].userinfo.id
                                              type:@"4"
                                         target_id:nil
                                           success:^(NSDictionary *resultDic){
                                               NSLog(@"%@",resultDic);
                                              
                                           }fail:^(NSString *decretion){
                                           }];
        
    }
    
}

//上架屏蔽数据判断接口
+ (void)httpGetIsShowThridView
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getHttpWithUrlStr:URL_GetIsSJ
                      success:^(NSDictionary *resultDic){
                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                              [ShareManager shareInstance].isShowThird = [[resultDic objectForKey:@"data"] objectForKey:@"is_money_pay"];
                              [ShareManager shareInstance].serverPhoneNum = [[resultDic objectForKey:@"data"] objectForKey:@"tel"];
                          }
                      }fail:^(NSString *decretion){
                      }];
}

@end
