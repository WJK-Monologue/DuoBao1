//
//  LoginViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPwdViewController.h"
#import "ResigterViewController.h"
#import "BangdingViewController.h"
#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"

//改动
#import "uuid.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([ShareManager shareInstance].userinfo.app_login_id.length > 0  && ![[ShareManager shareInstance].userinfo.app_login_id isEqualToString:@"<null>"]) {
        _phoneText.text = [ShareManager shareInstance].userinfo.app_login_id;
    }else{
        _phoneText.text = @"";
    }

}

- (void)initVariable
{
    self.title = @"登录";
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    _loginButton.layer.masksToBounds =YES;
    _loginButton.layer.cornerRadius = 10;
    
    
    if ([[ShareManager shareInstance].isShowThird isEqualToString:@"y"]) {
        if (([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) || ([QQApiInterface isQQInstalled] &&[QQApiInterface isQQSupportApi]))
        {
            _thirdLoginView.hidden = NO;
            
            if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi])
            {
                _weixinLoginButton.hidden = YES;
            }
            if (![QQApiInterface isQQInstalled] || ![QQApiInterface isQQSupportApi])
            {
                _qqLoginButton.hidden = YES;
            }
        }else{
            _thirdLoginView.hidden = YES;
        }
        
    }else{
        _thirdLoginView.hidden = YES;
    }
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
    back.image = [UIImage imageNamed:@"nav_back.png"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}


- (void)rightItemView
{
    UIView *rightItemView;
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,70, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"绑定微信" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0,8)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)clickRightItemAction:(id)sender
{
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc]initWithNibName:@"ForgetPwdViewController" bundle:nil];
    vc.title = @"绑定微信";
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clickLoginButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    [self httpLogin];
}

- (IBAction)clickResigterButtonAction:(id)sender
{
    ResigterViewController *vc = [[ResigterViewController alloc]initWithNibName:@"ResigterViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickFindPwdButtonAction:(id)sender
{
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc]initWithNibName:@"ForgetPwdViewController" bundle:nil];
    vc.title = @"找回密码";
    vc.isFindPwd = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickQQLoginButtonAction:(id)sender
{
    __weak LoginViewController *weakSelf = self;
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"%d",result);
        if (result) {
            //成功登录后，判断该用户的ID是否在自己的数据库中。
            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
            [self reloadStateWithType:ShareTypeQQSpace];
        }else{
            [Tool showPromptContent:@"授权失败" onView:weakSelf.view];
        }
    }];
}

- (IBAction)clickWeiXinLoginButtonAction:(id)sender
{

   __weak LoginViewController *weakSelf = self;
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    [ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession];
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"%d",result);
         NSLog(@"=====%@",userInfo.uid);
        if (result) {
            //成功登录后，判断该用户的ID是否在自己的数据库中。
            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
            //打印输出用户uid：
            NSLog(@"uid = %@",[userInfo uid]);
            //打印输出用户昵称：
            NSLog(@"name = %@",[userInfo nickname]);
            //打印输出用户头像地址：
            NSLog(@"icon = %@",[userInfo profileImage]);
            
            NSLog(@"用户信息= %@",[userInfo sourceData]);
            [self reloadStateWithType:ShareTypeWeixiSession];
        }else{
            
            [Tool showPromptContent:@"授权失败" onView:weakSelf.view];
            NSLog(@"==================%@",error.errorDescription);
             [self reloadStateWithType:ShareTypeWeixiSession];
            
        }
    }];

  
    
    
}

-(void)reloadStateWithType:(ShareType)type{
    //现实授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
    //    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
    id<ISSPlatformUser> credential = [ShareSDK currentAuthUserWithType:type];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
//                                                            message:[NSString stringWithFormat:
//                                                                     @"uid = %@\ntoken = %@",
//                                                                     [credential uid],
//                                                                     [credential nickname]]
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
//                                                  otherButtonTitles:nil];
//        [alertView show];
    NSLog(@"%@",[NSString stringWithFormat:@"uid = %@; name = %@;image = %@",[credential uid],[credential nickname],[credential profileImage]]);
    NSString *typeStr = nil;
    if (type == ShareTypeWeixiSession) {
        typeStr = @"weixin";
    }else{
        typeStr = @"qq";
    }
    
    [self httpOtherLoginWithId:[credential uid]
                     band_type:typeStr
                     nick_name:[credential nickname]
                    user_photo:[credential profileImage]];
    
}


#pragma mark http

- (void)httpLogin
{
    
    if ( _phoneText.text.length < 1) {
        [Tool showPromptContent:@"请输入手机号" onView:self.view];
        return;
    }
    
    if(![Tool validateMobile:_phoneText.text] )
    {
        [Tool showPromptContent:@"请输入正确手机号" onView:self.view];
        return;
    }
    
    if (_pwdText.text.length < 1) {
        [Tool showPromptContent:@"请输入密码" onView:self.view];
        return;
    }
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak LoginViewController *weakSelf = self;
    [helper loginByWithMobile:_phoneText.text
                     password:_pwdText.text
                     //jpush_id:[JPUSHService registrationID]
                      jpush_id:[uuid getUUID]
                     success:^(NSDictionary *resultDic){
                         [HUD hide:YES];
                         if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                             [weakSelf handleloadResult:[resultDic objectForKey:@"data"]];
                             [self httpCouponsList];
                             [self performSelector:@selector(xiaohondian:) withObject:nil afterDelay:0];
                             [self performSelector:@selector(xinshouhongbao:) withObject:nil afterDelay:0];
                         }else
                         {
                             [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                         }
                     }fail:^(NSString *decretion){
                         [HUD hide:YES];
                         [Tool showPromptContent:@"网络出错了" onView:self.view];
                     }];
    
}

-(void)xiaohondian:(NSNotification *)changer
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dengluhongdian" object:nil];
}
-(void)xinshouhongbao:(NSNotification*)hongbao
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoshouye2" object:nil];
    
}


- (void)handleloadResult:(NSDictionary *)resultDic
{
    UserInfo *info = [resultDic objectByClass:[UserInfo class]];
    [ShareManager shareInstance].userinfo = info;
    [Tool saveUserInfoToDB:YES];
    //登录成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
    [MobClick event:@"__login" attributes:@{@"userid":info.id}];
    //NSLog(@" info.id = %@",info.id);
    [Tool showPromptContent:@"登录成功" onView:self.view];
    [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
}

//第三方登录
- (void)httpOtherLoginWithId:(NSString *)band_id
                   band_type:(NSString *)band_type
                   nick_name:(NSString *)nick_name
                  user_photo:(NSString *)user_photo
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak LoginViewController *weakSelf = self;
    [helper thirdloginByWithLoginId:band_id
                          nick_name:nick_name
                        user_header:user_photo
                               type:band_type
                           //jpush_id:[JPUSHService registrationID]
                           jpush_id:[uuid getUUID]
                       success:^(NSDictionary *resultDic){
                           [HUD hide:YES];
                           if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                               [weakSelf handleloadOtherLoginResult:[resultDic objectForKey:@"data"]];
                               [self httpCouponsList];
                           }else
                           {
                               [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                           }
                       }fail:^(NSString *decretion){
                           [HUD hide:YES];
                           [Tool showPromptContent:@"网络出错了" onView:self.view];
                       }];
    
}

- (void)handleloadOtherLoginResult:(NSDictionary *)resultDic
{
    UserInfo *info = [resultDic objectByClass:[UserInfo class]];
    [ShareManager shareInstance].userinfo = info;
    if (info.user_tel.length >0 && ![info.user_tel isEqualToString:@"<null>"]) {
        [Tool saveUserInfoToDB:YES];
        //登录成功通知
        [MobClick event:@"__login" attributes:@{@"userid":info.id}];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
        [Tool showPromptContent:@"登录成功" onView:self.view];
        [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
    }
    else{
        [MobClick event:@"__login" attributes:@{@"userid":info.id}];
        [Tool saveUserInfoToDB:NO];
        BangdingViewController *vc = [[BangdingViewController alloc]initWithNibName:@"BangdingViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)httpCouponsList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak LoginViewController *weakSelf = self;
    
    NSString *typeStr = @"1";
    int pageNum =1;
    
    [helper getCouponsListWithUserId:[ShareManager shareInstance].userinfo.id
                                type:typeStr
                             pageNum:[NSString stringWithFormat:@"%d",pageNum]
                            limitNum:@"30"
                             success:^(NSDictionary *resultDic){
                                 
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadFriendsListResult:resultDic];
                                 }else
                                 {
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                 }
                             }fail:^(NSString *decretion){
                                
                                 [Tool showPromptContent:decretion onView:self.view];
                             }];
}
- (void)handleloadFriendsListResult:(NSDictionary *)resultDic
{
  
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"ticketList"];
    NSLog(@"红包数量＝＝＝＝＝＝＝＝＝＝＝%lu",(unsigned long)resourceArray.count);
    NSInteger NumHongbao =(unsigned long)resourceArray.count;
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.hongbaoshu=[NSString stringWithFormat:@"%ld",(long)NumHongbao];
    NSLog(@"全局红包数量是＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝%@",appDelegate.hongbaoshu);
   
}

@end
