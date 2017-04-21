//
//  AppDelegate.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "haoyoupkViewController.h"

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "judge.h"
#import "Freshinfo.h"
#import "MenuViewController.h"
#import "HomePageViewController.h"
#import "JieXiaoViewController.h"
#import "ZengQianViewController.h"
#import "QingDanViewController.h"
#import "UserCenterViewController.h"
#import <IapppayKit/IapppayOrderUtils.h>
#import <IapppayKit/IapppayKit.h>
#import "UMMobClick/MobClick.h"
#import <UserNotifications/UserNotifications.h>
#import "CouponsListInfo.h"
#import "Hongbao.h"
#import "CouponsViewController.h"
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
{
    MenuViewController *menuViewController;
    NSMutableArray *data;
    CouponsListInfo *couinfo;
    Hongbao *hongbaoview;
    UIView *view4;
    NSMutableArray *dataSourceArray;
}

@end

@implementation AppDelegate
{
    // UIView *view2;
    UIImageView*view2;
    UIView *view3;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2.0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController =  [[UIViewController alloc] init];
    
    [self httpGetShareList];
    
    //web加载内存控制
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 30*1024*1024; // 30MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    
    [Tool getUserInfoFromSqlite];
    
    //爱贝支付设置
    [[IapppayKit sharedInstance] setAppAlipayScheme:@"quanmingoubao"];
    
    [[IapppayKit sharedInstance] setIapppayPayWindowOrientationMask:UIInterfaceOrientationMaskPortrait];
    
    //注册极光
    [self registerJGPushWithLaunchOptions:launchOptions];
    
    [self initShareFunction];
    //友盟统计。
    UMConfigInstance.appKey = @"58032e5fe0f55a287e003b0a";
    //UMConfigInstance.appKey = @"58ace2f88630f53f46002623";
    UMConfigInstance.channelId = @"App Store";
    
    
    [MobClick startWithConfigure:UMConfigInstance];
    //是否屏蔽支付接口
    [Tool httpGetIsShowThridView];
    
    //初始化tab
    [self initlizeMainViewControllerWithLaunchOptions:launchOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoshouye:) name:@"gotoshouye" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoshouye2:) name:@"gotoshouye2" object:nil];
    [self autoLogin];
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    if(launchOptions) {//点击了推送消息
        
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if(remoteNotification) {// 如果​remoteNotification不为空，代表有推送发过来
            NSLog(@"推送过来的消息是%@",remoteNotification);
            //点击推送通知进入指定界面（这个肯定是相当于从后台进入的）
            
        }
    }
    return YES;
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    //功能：可设置是否在应用内弹出通知
    completionHandler(UNNotificationPresentationOptionAlert);
}

//点击推送消息后回调
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

//标记 自动登录
- (void)autoLogin
{
    if ([Tool islogin])
    {
        if (![ShareManager shareInstance].userinfo)
        {
            return;
        }
        [Tool autoLoginSuccess:^(NSDictionary *resultDic)
         {
             NSInteger resultCode = [resultDic[@"status"] integerValue];
             
             if (resultCode != 0) {
                 NSLog(@"自动登录失败");
                 [Tool saveUserInfoToDB:NO];
                 [Tool showPromptContent:@"自动登录失败" onView:self.window];
             }
             if (resultCode ==0)
             {
                 [self performSelector:@selector(changing:) withObject:nil afterDelay:0];
             }
             
         } fail:^(NSString *description) {
             NSLog(@"自动登录失败");
             //自动登录失败，显示登录对话框
             [Tool saveUserInfoToDB:NO];
             [Tool showPromptContent:@"自动登录失败" onView:self.window];
         }];
    }
}

#pragma mark - 初始化主页面
- (void)initlizeMainViewControllerWithLaunchOptions:(NSDictionary *)launchOptions
{
    //导航栏背景图
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:49.0/255.0 blue:64.0/255.0 alpha:1]];//
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 首页
    HomePageViewController *homePageVC = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    //标记。跳转到揭晓
//    JieXiaoViewController *jieXiaoVC = [[JieXiaoViewController alloc] initWithNibName:@"JieXiaoViewController" bundle:nil];
//    UINavigationController *jieXiaoNav = [[UINavigationController alloc] initWithRootViewController:jieXiaoVC];
    
    haoyoupkViewController *haoyoupkVC = [[haoyoupkViewController alloc]init];
    UINavigationController *haoyoupkNav = [[UINavigationController alloc]initWithRootViewController:haoyoupkVC];
    
    
    ZengQianViewController *zengQianVC = [[ZengQianViewController alloc] initWithNibName:@"ZengQianViewController" bundle:nil];
    UINavigationController *zengQianNav = [[UINavigationController alloc] initWithRootViewController:zengQianVC];
    
    //    QingDanViewController *qingDanVC = [[QingDanViewController alloc] initWithNibName:@"QingDanViewController" bundle:nil];
    //    UINavigationController *qingDanNav = [[UINavigationController alloc] initWithRootViewController:qingDanVC];
    
    UserCenterViewController * userCenterVC = [[UserCenterViewController alloc]initWithNibName:@"UserCenterViewController" bundle:nil];
    UINavigationController *userCentervcNav = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
    
    NSArray *navArray = [NSArray arrayWithObjects:homePageNav,haoyoupkNav,zengQianNav,userCentervcNav, nil];
    
    NSMutableDictionary *itemDic0 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic0 setObject:@"猜拳竞宝" forKey:@"Title"];
    [itemDic0 setObject:[NSString stringWithFormat:@"tabbtn2"] forKey:@"Default"];
    [itemDic0 setObject:[NSString stringWithFormat:@"tabbtn02"] forKey:@"Seleted"];
    
    NSMutableDictionary *itemDic1 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic1 setObject:@"好友PK" forKey:@"Title"];
    [itemDic1 setObject:[NSString stringWithFormat:@"tabbtn4"] forKey:@"Default"];
    [itemDic1 setObject:[NSString stringWithFormat:@"tabbtn04"] forKey:@"Seleted"];
    
    NSMutableDictionary *itemDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic2 setObject:@"一元夺宝" forKey:@"Title"];
    [itemDic2 setObject:[NSString stringWithFormat:@"tabbtn3"] forKey:@"Default"];
    [itemDic2 setObject:[NSString stringWithFormat:@"tabbtn03"] forKey:@"Seleted"];
    
    //    NSMutableDictionary *itemDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    //    [itemDic3 setObject:@"清单" forKey:@"Title"];
    //    [itemDic3 setObject:[NSString stringWithFormat:@"button4"] forKey:@"Default"];
    //    [itemDic3 setObject:[NSString stringWithFormat:@"button04"] forKey:@"Seleted"];
    
    NSMutableDictionary *itemDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic3 setObject:@"我的" forKey:@"Title"];
    [itemDic3 setObject:[NSString stringWithFormat:@"tabbtn1"] forKey:@"Default"];
    [itemDic3 setObject:[NSString stringWithFormat:@"tabbtn01"] forKey:@"Seleted"];
    
    NSArray *itemArr = [NSArray arrayWithObjects:itemDic0,itemDic1, itemDic2,itemDic3, nil];
    
    menuViewController = [[MenuViewController alloc] initWithViewControllers:navArray imageArray:itemArr];
    
    menuViewController.selectedIndex = 0;
    
    menuViewController.tabBarTransparent = NO;//YES:将controller.view的大小设置成全屏；NO:将controller.view的大小设置成menuViewController的内容页
    
    [[menuViewController.tabBarController.tabBar.items objectAtIndex:2]setBadgeValue:@"99"];
    
    self.window.rootViewController = menuViewController;
}
-(void)gotoshouye:(NSNotification *)sender
{
    //导航栏背景图
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:49.0/255.0 blue:64.0/255.0 alpha:1]];//
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 首页
    HomePageViewController *homePageVC = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    
//    JieXiaoViewController *jieXiaoVC = [[JieXiaoViewController alloc] initWithNibName:@"JieXiaoViewController" bundle:nil];
//    UINavigationController *jieXiaoNav = [[UINavigationController alloc] initWithRootViewController:jieXiaoVC];
    
    haoyoupkViewController *haoyoupkVC = [[haoyoupkViewController alloc]init];
    UINavigationController *haoyoupkNav = [[UINavigationController alloc]initWithRootViewController:haoyoupkVC];
    
    ZengQianViewController *zengQianVC = [[ZengQianViewController alloc] initWithNibName:@"ZengQianViewController" bundle:nil];
    UINavigationController *zengQianNav = [[UINavigationController alloc] initWithRootViewController:zengQianVC];
    
    //    QingDanViewController *qingDanVC = [[QingDanViewController alloc] initWithNibName:@"QingDanViewController" bundle:nil];
    //    UINavigationController *qingDanNav = [[UINavigationController alloc] initWithRootViewController:qingDanVC];
    
    UserCenterViewController * userCenterVC = [[UserCenterViewController alloc]initWithNibName:@"UserCenterViewController" bundle:nil];
    UINavigationController *userCentervcNav = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
    
    NSArray *navArray = [NSArray arrayWithObjects:homePageNav,haoyoupkNav,zengQianNav,userCentervcNav, nil];
    
    NSMutableDictionary *itemDic0 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic0 setObject:@"猜拳竞宝" forKey:@"Title"];
    [itemDic0 setObject:[NSString stringWithFormat:@"tabbtn2"] forKey:@"Default"];
    [itemDic0 setObject:[NSString stringWithFormat:@"tabbtn02"] forKey:@"Seleted"];
    
    NSMutableDictionary *itemDic1 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic1 setObject:@"好友PK" forKey:@"Title"];
    [itemDic1 setObject:[NSString stringWithFormat:@"tabbtn4"] forKey:@"Default"];
    [itemDic1 setObject:[NSString stringWithFormat:@"tabbtn04"] forKey:@"Seleted"];
    
    NSMutableDictionary *itemDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic2 setObject:@"一元夺宝" forKey:@"Title"];
    [itemDic2 setObject:[NSString stringWithFormat:@"tabbtn3"] forKey:@"Default"];
    [itemDic2 setObject:[NSString stringWithFormat:@"tabbtn03"] forKey:@"Seleted"];

    
    NSMutableDictionary *itemDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic3 setObject:@"我的" forKey:@"Title"];
    [itemDic3 setObject:[NSString stringWithFormat:@"tabbtn1"] forKey:@"Default"];
    [itemDic3 setObject:[NSString stringWithFormat:@"tabbtn01"] forKey:@"Seleted"];
    
    NSArray *itemArr = [NSArray arrayWithObjects:itemDic0,itemDic1, itemDic2,itemDic3, nil];
    
    menuViewController = [[MenuViewController alloc] initWithViewControllers:navArray imageArray:itemArr];
    
    menuViewController.selectedIndex = 0;
    
    menuViewController.tabBarTransparent = NO;//YES:将controller.view的大小设置成全屏；NO:将controller.view的大小设置成menuViewController的内容页
    
    [[menuViewController.tabBarController.tabBar.items objectAtIndex:2]setBadgeValue:@"99"];
    
    self.window.rootViewController = menuViewController;
}

-(void)gotoshouye2:(NSNotification *)sender
{
    //导航栏背景图
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:49.0/255.0 blue:64.0/255.0 alpha:1]];//
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 首页
    HomePageViewController *homePageVC = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    
//    JieXiaoViewController *jieXiaoVC = [[JieXiaoViewController alloc] initWithNibName:@"JieXiaoViewController" bundle:nil];
//    UINavigationController *jieXiaoNav = [[UINavigationController alloc] initWithRootViewController:jieXiaoVC];
    haoyoupkViewController *haoyoupkVC = [[haoyoupkViewController alloc]init];
    UINavigationController *haoyoupkNav = [[UINavigationController alloc]initWithRootViewController:haoyoupkVC];
    
    ZengQianViewController *zengQianVC = [[ZengQianViewController alloc] initWithNibName:@"ZengQianViewController" bundle:nil];
    UINavigationController *zengQianNav = [[UINavigationController alloc] initWithRootViewController:zengQianVC];
    
    //    QingDanViewController *qingDanVC = [[QingDanViewController alloc] initWithNibName:@"QingDanViewController" bundle:nil];
    //    UINavigationController *qingDanNav = [[UINavigationController alloc] initWithRootViewController:qingDanVC];
    
    UserCenterViewController * userCenterVC = [[UserCenterViewController alloc]initWithNibName:@"UserCenterViewController" bundle:nil];
    UINavigationController *userCentervcNav = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
    
    NSArray *navArray = [NSArray arrayWithObjects:homePageNav,haoyoupkNav,zengQianNav,userCentervcNav, nil];
    
    NSMutableDictionary *itemDic0 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic0 setObject:@"购宝" forKey:@"Title"];
    [itemDic0 setObject:[NSString stringWithFormat:@"tabbtn2"] forKey:@"Default"];
    [itemDic0 setObject:[NSString stringWithFormat:@"tabbtn02"] forKey:@"Seleted"];
    
    NSMutableDictionary *itemDic1 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic1 setObject:@"揭晓" forKey:@"Title"];
    [itemDic1 setObject:[NSString stringWithFormat:@"tabbtn4"] forKey:@"Default"];
    [itemDic1 setObject:[NSString stringWithFormat:@"tabbtn04"] forKey:@"Seleted"];
    
    NSMutableDictionary *itemDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic2 setObject:@"发现" forKey:@"Title"];
    [itemDic2 setObject:[NSString stringWithFormat:@"tabbtn3"] forKey:@"Default"];
    [itemDic2 setObject:[NSString stringWithFormat:@"tabbtn03"] forKey:@"Seleted"];
    
    //    NSMutableDictionary *itemDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    //    [itemDic3 setObject:@"清单" forKey:@"Title"];
    //    [itemDic3 setObject:[NSString stringWithFormat:@"button4"] forKey:@"Default"];
    //    [itemDic3 setObject:[NSString stringWithFormat:@"button04"] forKey:@"Seleted"];
    
    NSMutableDictionary *itemDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [itemDic3 setObject:@"我的" forKey:@"Title"];
    [itemDic3 setObject:[NSString stringWithFormat:@"tabbtn1"] forKey:@"Default"];
    [itemDic3 setObject:[NSString stringWithFormat:@"tabbtn01"] forKey:@"Seleted"];
    
    NSArray *itemArr = [NSArray arrayWithObjects:itemDic0,itemDic1, itemDic2,itemDic3, nil];
    
    menuViewController = [[MenuViewController alloc] initWithViewControllers:navArray imageArray:itemArr];
    
    menuViewController.selectedIndex = 0;
    
    menuViewController.tabBarTransparent = NO;//YES:将controller.view的大小设置成全屏；NO:将controller.view的大小设置成menuViewController的内容页
    
    [[menuViewController.tabBarController.tabBar.items objectAtIndex:2]setBadgeValue:@"99"];
    
    self.window.rootViewController = menuViewController;
    
    [self httpCouponsList2];
}
- (void)httpCouponsList2
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak AppDelegate *weakSelf = self;
    
    NSString *typeStr = @"1";
    int pageNum =1;
    
    [helper getCouponsListWithUserId:[ShareManager shareInstance].userinfo.id
                                type:typeStr
                             pageNum:[NSString stringWithFormat:@"%d",pageNum]
                            limitNum:@"30"
                             success:^(NSDictionary *resultDic){
                                 
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadFriendsListResult2:resultDic];
                                 }else
                                 {
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.window];
                                 }
                             }fail:^(NSString *decretion){
                                 
                                 // [Tool showPromptContent:decretion onView:self.view];
                             }];
    
}

- (void)handleloadFriendsListResult2:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"ticketList"];
    for (NSDictionary *dic in resourceArray)
    {
        couinfo = [dic objectByClass:[CouponsListInfo class]];
        [dataSourceArray addObject:couinfo];
    }
    
    if ([couinfo.ticket_name containsString:@"新手面值"]) {
        [MobClick event:@"__register" attributes:@{@"userid":[ShareManager shareInstance].userinfo.id}];
        hongbaoview = [[[NSBundle mainBundle] loadNibNamed:@"Hongbao" owner:self options:nil] lastObject];
        CGRect tmpFrame = [[UIScreen mainScreen] bounds];
        //设置自定义视图的中点为屏幕的中点
        [hongbaoview setCenter:CGPointMake(tmpFrame.size.width / 2, tmpFrame.size.height / 3+65)];
        view4=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        view4.backgroundColor = [UIColor blackColor];
        view4.alpha=0.7;
        hongbaoview.backgroundColor = [UIColor clearColor];
        
        [hongbaoview.button1 addTarget:self action:@selector(yichu:) forControlEvents:UIControlEventTouchUpInside];
        [hongbaoview.button2 addTarget:self action:@selector(tiaozhuan:) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:view4];
        [self.window addSubview:hongbaoview];
        
    }
    
}

-(void)yichu:(UIButton*)sender
{
    [view4 removeFromSuperview];
    [hongbaoview removeFromSuperview];
}

-(void)tiaozhuan:(UIButton *)sender
{
    [view4 removeFromSuperview];
    [hongbaoview removeFromSuperview];
    
    CouponsViewController *talkVC = [[CouponsViewController alloc]init];
    UINavigationController *pushNav = [[UINavigationController alloc]initWithRootViewController:talkVC];
    talkVC.status=1;
    [self.window.rootViewController presentViewController:pushNav animated:YES completion:nil];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //应用图标标签清零
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - 各平台回调

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    
    
    [[IapppayKit sharedInstance] handleOpenUrl:url];
    
    if([url.host isEqualToString:@"data_success"])
    {
        //在safari中支付成功
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessInSafari object:nil userInfo:nil];
    }
    
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方 法里面处理跟 callback 一样的逻辑】
                                                      NSLog(@"result = %@",resultDic);
                                                      NSString *resultStatue = (NSString *)[resultDic objectForKey:@"resultStatus"];
                                                      [self handlePayResultNotification:resultStatue];
                                                  }];
    }
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

/**
 *  支付结果处理支付结果
 */
- (void)handlePayResultNotification:(NSString *)resultStatue
{
    switch ([resultStatue intValue] ) {
        case 9000:
            [Tool showPromptContent:@"恭喜您，支付成功！" onView:self.window];
            break;
        case 8000:
            [Tool showPromptContent:@"正在处理中,请稍候查看！" onView:self.window];
            break;
        case 4000:
            [Tool showPromptContent:@"很遗憾，您此次支付失败，请您重新支付！" onView:self.window];
            break;
        case 6001:
            [Tool showPromptContent:@"您已取消了支付操作！" onView:self.window];
            break;
        case 6002:
            [Tool showPromptContent:@"网络连接出错，请您重新支付！" onView:self.window];
            break;
        default:
            break;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[IapppayKit sharedInstance] handleOpenUrl:url];
    return [ShareSDK handleOpenURL:url  wxDelegate:self];
}

#pragma mark - 微信支付回调

-(void)onResp:(BaseResp *)resp{
    NSString *strTitle = nil;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        int isSuccess  = 0;
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                NSLog(@"支付成功!");
                isSuccess = 0;
            }
                break;
            case WXErrCodeCommon:
                isSuccess = -1;
                break;
            case WXErrCodeUserCancel:
                isSuccess = -2;
                break;
            case WXErrCodeSentFail:
                isSuccess = -3;
                break;
            case WXErrCodeUnsupport:
                isSuccess = -5;
                break;
            case WXErrCodeAuthDeny:
                isSuccess = -4;
                break;
            default:
                break;
        }
        
        NSDictionary *parameters = nil;
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",isSuccess],@"statue",nil];
        //登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeiXinPayNotif object:nil userInfo:parameters];
        
    }
}

#pragma mark - init sharesdk

//  标记  分享
- (void)initShareFunction
{
    [ShareSDK registerApp:@"1ba6d9bd6df8a"];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:WeiBoKey
                               appSecret:WeiBoSecret
                             redirectUri:@"http://sns.whalecloud.com/sina2/callback"];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:WeiBoKey
                                appSecret:WeiBoSecret
                              redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:QQKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:QQKey
                           appSecret:QQSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:WeiXinID
                           appSecret:WeiXinAppKey
                           wechatCls:[WXApi class]];
    
    
}


#pragma mark - jpush
//  标记  极光推送
- (void)registerJGPushWithLaunchOptions:(NSDictionary *)launchOptions
{
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    
    BOOL isProduction = NO;
#if DEBUG
    isProduction = NO;
#else
    isProduction = YES;
#endif
    
    [JPUSHService setupWithOption:launchOptions appKey:JGPushKey channel:@"public" apsForProduction:isProduction];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}




- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

-(void)changing:(NSNotification *)changer
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tongzhishuaxin" object:nil];
}

- (void)httpGetShareList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak AppDelegate *weakSelf = self;
    
    NSString *userId = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userId = [ShareManager shareInstance].userinfo.id;
    }
    
    [helper GetFresh:userId success:^(NSDictionary *resultDic) {
        [weakSelf handleloadResult:resultDic];
    } fail:^(NSString *description) {
        
    }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic valueForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前版本:%@",currentVersion);
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"repair_inform"];
    
    for (NSDictionary *dic in resourceArray)
    {
        Freshinfo *info = [dic objectByClass:[Freshinfo class]];
        if ([currentVersion floatValue]<[info.nowVersion floatValue]) {
            
            judge *ju = [[judge alloc]init];
            
            ju.content = info.desc;
            
            [ju drawView];
            ju.center = self.window.center;
            view2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width,self.window.frame.size.height)];
            //                UIImageView *iamge =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height)];
            view2.image=[UIImage imageNamed:@"640X1136副本"];
            view3 = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.window.frame.size.width, self.window.frame.size.height)];
            view3.backgroundColor = [UIColor blackColor];
            view3.alpha = 0.7;
            [self.window addSubview:view2];
            [self.window addSubview:view3];
            // [self.window addSubview:view2];
            [self.window addSubview:ju];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remom:) name:@"removefrom" object:nil];
    
}

-(void)remom:(NSNotification *)sender
{
    [view2 removeFromSuperview];
    [view3 removeFromSuperview];
}

@end
@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
