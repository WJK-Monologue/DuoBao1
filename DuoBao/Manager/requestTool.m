//
//  requestTool.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/16.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "requestTool.h"
#import "HttpHelper.h"
#import "UserInfo.h"
#import "ShareManager.h"
#import "ProductDetailViewController.h"
#import "CZViewController.h"
#import "HttpHelper.h"
#import "ProductDetailViewController.h"
#import "SocketInteraction.h"
#import "BeatViewController.h"
#import "uuid.h"

#import "ProductDetailViewController.h"
#import "HomePageViewController.h"
#import "haoyoupkViewController.h"
#import "ZengQianViewController.h"
#import "UserCenterViewController.h"
#import "MenuViewController.h"

@implementation requestTool
{
    NSDictionary *Paydic;
    BeatViewController *beatVC;
    MenuViewController *menuViewController;

}
/**/
-(void)handleUserResultBlock:(void (^)(NSDictionary *))block
{
    UserInfo *info = [[UserInfo alloc]init];
    HttpHelper *helper = [[HttpHelper alloc] init];
    info.id = [ShareManager shareInstance].userinfo.id;
    [helper loadUserDetailUserId:info.id
                         success:^(NSDictionary *resultDic){
                             if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                 //用户详情
                                 //NSLog(@"resultDic = %@",resultDic);
                                 block(resultDic);
                            }
                         }fail:^(NSString *decretion){
                             NSLog(@"数据请求失败");
                         }];
}
/*
-(void)handleOtherResultBlock:(void (^)(NSDictionary *))Otherblock
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    NSLog(@"self.reveId = %@",self.reveId);
    [helper loadUserDetailUserId:self.reveId
                         success:^(NSDictionary *resultDic){
                             if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                 //对手详情
                                 //NSLog(@" 对手详情 resultDic = %@",resultDic);
                                 Otherblock(resultDic);
                             }
                         }fail:^(NSString *decretion){
                             NSLog(@"数据请求失败");
                         }];
}
*/

/*
-(void)handleMoreUsersBlock:(void (^)(NSDictionary *Dic))block
{
    UserInfo *info = [[UserInfo alloc]init];
    HttpHelper *helper = [[HttpHelper alloc] init];
    info.id = [ShareManager shareInstance].userinfo.id;
    
    ProductDetailViewController *pro = [[ProductDetailViewController alloc]init];
    NSString *ids = [NSString stringWithFormat:@"%@,%@",info.id,pro.otherId];
    NSLog(@"ids = %@",ids);
    [helper loadMoreUserDetailUsersId:ids success:^(NSDictionary *resultDic) {
        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
            //用户详情
           // NSLog(@"商品详情页多用户信息 = %@",resultDic);
            block(resultDic);
        }
    }fail:^(NSString *decretion){
        NSLog(@"数据请求失败");
    }];
}
*/
/*
- (void)loadUserResult
{
    UserInfo *info = [[UserInfo alloc]init];
    HttpHelper *helper = [[HttpHelper alloc] init];
    info.id = [ShareManager shareInstance].userinfo.id;
    [helper loadUserDetailUserId:info.id
                           success:^(NSDictionary *resultDic){
                               if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                   //[weakSelf handleUserResult: resultDic];
                                   [self handleUserResult:resultDic];
                                   [self handleUserResultBlock:^(NSDictionary *Dic) {
                                       Dic = resultDic;
                                   }];
                               }
                             
                           }fail:^(NSString *decretion){
                               NSLog(@"数据请求失败");
                           }];
}

- (void)handleUserResult:(NSDictionary *)resultDic
{
    //取数据
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    //self.userDic = dic;
    NSLog(@"%@",dic);
}
*/

#pragma  mark - 封装方法。 再战一局
-(void)requestuserId:(NSString *)userId goodId:(NSString *)goodId NumPeople:(NSString *)NumPeople peoplePrice:(NSString *)peoplePrice
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper loadPayUserId:userId payType:@"1" payment:peoplePrice productId:goodId number:NumPeople success:^(NSDictionary *resultDic) {
        NSLog(@".....%@",resultDic);
        Paydic = resultDic;
    } fail:^(NSString *description) {
        NSLog(@".....支付失败");
    }];
    
    if ([Paydic[@"status"]isEqualToString:@"93"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"余额不足" message:@"请充值" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [alert show];
    }
    else{
        ////判断是否登录
       // if ([Tool islogin]) {
            
            NSString *struuid = [uuid getUUID];
            NSString *str = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"cmd\":\"login\",\"game_type\":\"1\",\"room_people_number\":\"%@\",\"goods_id\":\"%@\",\"is_upper_screen\":\"false\",\"device_code\":\"%@\"}",userId,NumPeople,goodId,struuid];
            
            //传给服务器
            SocketInteraction *sock = [[SocketInteraction alloc]init];
            [sock ClientConnectionServerMsg:str];
            //通知接收值
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DataAction:) name:@"msg" object:nil];
        //}
        //else
        //{
           // [Tool loginWithAnimated:YES viewController:nil];
            //return;
        //}
    }
}
-(void)DataAction:(NSNotification *)send
{
    NSDictionary *dic = send.userInfo;
    NSString *cmd = dic[@"cmd"];
    /**/
    if ([cmd isEqualToString:@"pk_play"])
    {
        [UIView animateWithDuration:0.1 animations:^{
            [beatVC.scrollDown setContentOffset:CGPointMake(WIDTH, 0)];
        }];
    }
}

#pragma  mark - 封装方法。休息一下
-(void)haverest
{
    // 首页
    HomePageViewController *homePageVC = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    
    haoyoupkViewController *haoyoupkVC = [[haoyoupkViewController alloc]init];
    UINavigationController *haoyoupkNav = [[UINavigationController alloc]initWithRootViewController:haoyoupkVC];
    
    ZengQianViewController *zengQianVC = [[ZengQianViewController alloc] initWithNibName:@"ZengQianViewController" bundle:nil];
    UINavigationController *zengQianNav = [[UINavigationController alloc] initWithRootViewController:zengQianVC];
    
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
    
    //[menuViewController dismissViewControllerAnimated:NO completion:nil];

    menuViewController.selectedIndex = 0;
    
    menuViewController.tabBarTransparent = NO;//YES:将controller.view的大小设置成全屏；NO:将controller.view的大小设置成menuViewController的内容页
    
    [UIApplication sharedApplication].delegate.window.rootViewController = menuViewController;
}


#pragma  mark - 封装方法。 字符串转Json
-(void) strChangeJsonStr:(NSString *)str
{
    NSString * zifu= [NSString stringWithString:str];
    NSData * data = [[NSData alloc]initWithData:[zifu dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"字符串转JSON = %@",result);
    self.BlockDic(result);
}

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
