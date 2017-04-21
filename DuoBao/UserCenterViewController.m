//
//  UserCenterViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterHeadTableViewCell.h"
#import "IconTableViewCell.h"
#import "DuoBaoRecordViewController.h"
#import "MessageListViewController.h"
#import "ZJRecordViewController.h"
#import "ShaiDanViewController.h"
#import "JFDHViewController.h"
#import "SafariViewController.h"
#import "TaskViewController.h"
#import "InviteFriendsViewController.h"
#import "MoreViewController.h"
#import "UserInfoViewController.h"
#import "CouponsViewController.h"
#import "CZViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "ConnectOurViewController.h"
#import "YaoqingViewController.h"
#import "SystemListInfo.h"
#import "AppDelegate.h"
#import "CouponsListInfo.h"
#import "Hongbao.h"
#import "ZhaomuTudiViewController.h"
@interface UserCenterViewController ()<UINavigationControllerDelegate,IconTableViewCellDelegate>
{
    CouponsListInfo *couinfo;
    Hongbao *hongbaoview;
    UIView *view2;
    NSMutableArray *dataSourceArray;
    NSMutableArray *titleArray;
    NSMutableArray *imageArray;
  
    
    NSMutableArray *data;
    NSString *hongbao;
   
    NSInteger zhe;
}

@end

@implementation UserCenterViewController

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachableNetworkStatusChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateUserInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQuitLoginSuccess object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameter];
    [self createUI];
    [self registerNotif];
    [_myTableView reloadData];
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"zheyici================%ld",(long)[appDelegate.zheyici integerValue]);
    
    zhe=[appDelegate.zheyici intValue];
    
    NSUserDefaults *defult = [NSUserDefaults standardUserDefaults];
    hongbao = [defult objectForKey:@"xiaoxi"];
   

}

-(void)chang:(NSNotification *)shuaxin
{

    [self httpGetSystemMessgae];
    [self httpCouponsList];
    [_myTableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chang:) name:@"tongzhishuaxin" object:nil];
//      [self httpCouponsList2];
    
    //[self registerNotif];
    [_myTableView reloadData];
}
//改动 系统消息
- (void)httpGetSystemMessgae
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak UserCenterViewController *weakSelf = self;
     int pageNum =1;
    UserInfo *info = [[UserInfo alloc]init];
    info.id = [ShareManager shareInstance].userinfo.id;
    [helper getSystemMessageWithPageNum:[NSString stringWithFormat:@"%d",pageNum]
                               limitNum:@"30"
                               userId:info.id
                                success:^(NSDictionary *resultDic){
                                    
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                        [weakSelf handleloadResult:resultDic];
                                         NSLog(@"系统消息 2- %@",resultDic);
                                    }else
                                    {
                                      //  [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                                }fail:^(NSString *decretion){
                                   
                                    [Tool showPromptContent:decretion onView:self.view];
                                }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"messageList"];
    NSInteger NumHongbao =(unsigned long)resourceArray.count;
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.zheyici=[NSString stringWithFormat:@"%ld",(long)NumHongbao];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initParameter
{
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    
}

- (void)createUI
{
    UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.myTableView.bounds.size.width, 35)];
    warnLabel.text = @"声明：所有商品抽奖活动与苹果公司（apple inc.）无关";
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.font = [UIFont systemFontOfSize:12];
    warnLabel.textColor =[UIColor colorWithRed:240.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];    warnLabel.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    self.myTableView.tableFooterView = warnLabel;
}


#pragma mark - notif Action
- (void)registerNotif
{
    /**
     *  监听网络状态变化
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachableNetworkStatusChange
                                               object:nil];
    
    //刷新首页数据
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateUserInfoData)
                                                name:kUpdateUserInfo
                                              object:nil];
    //刷新首页数据
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateUserInfoData)
                                                name:kLoginSuccess
                                              object:nil];
    
    //刷新首页数据
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(quitLoginReload)
                                                name:kQuitLoginSuccess
                                              object:nil];
    
}

//网络状态捕捉
- (void)checkNetworkStatus:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    if(userInfo)
    {
        [self httpUserInfo];
    }
}

- (void)updateUserInfoData
{
    [self httpUserInfo];
    
}

- (void)quitLoginReload
{
    [_myTableView reloadData];
    
}
#pragma mark - http

- (void)httpUserSign
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"签到中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak UserCenterViewController *weakSelf = self;
    [helper userSignWithUserId:[ShareManager shareInstance].userinfo.id
                       success:^(NSDictionary *resultDic){
                           [HUD hide:YES];
                           if ([[resultDic objectForKey:@"result_code"] integerValue] == 0)
                           {
                               [weakSelf handleloadSignResult:[resultDic objectForKey:@"data"]];
                           }else{
                               [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                           }
                           
                       }fail:^(NSString *decretion){
                           [HUD hide:YES];
                           [Tool showPromptContent:@"网络出错了" onView:self.view];
                       }];
}

- (void)handleloadSignResult:(NSDictionary *)resultDic
{
    [ShareManager shareInstance].userinfo.user_is_sign = @"y";
    [Tool saveUserInfoToDB:YES];
    [_myTableView reloadData];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"签到提示" message:[resultDic objectForKey:@"alertData"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)httpUserInfo
{
    if (![ShareManager shareInstance].userinfo.islogin) {
        return;
    }
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak UserCenterViewController *weakSelf = self;
    [helper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                       success:^(NSDictionary *resultDic){
                           
                           if ([[resultDic objectForKey:@"result_code"] integerValue] == 0)
                           {
                               [weakSelf handleloadUserInfoResult:[resultDic objectForKey:@"data"]];
                           }else{
                               [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                           }
                           
                       }fail:^(NSString *decretion){
                           [Tool showPromptContent:@"网络出错了" onView:self.view];
                       }];
}

- (void)handleloadUserInfoResult:(NSDictionary *)resultDic
{
    UserInfo *info = [resultDic objectByClass:[UserInfo class]];
    [ShareManager shareInstance].userinfo = info;
    [Tool saveUserInfoToDB:YES];
    [_myTableView reloadData];
}


#pragma -mark buttonAction
//推送出的信息
- (void)clickMessageButtonAction:(id)sender
{
    MessageListViewController *vc = [[MessageListViewController alloc]initWithNibName:@"MessageListViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}
//是否登录
- (void)clickSignButtonAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    [self httpUserSign];
}
//充值
- (void)clickCZButtonAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
//点击头像
- (void)clickUserPhotoAction:(UITapGestureRecognizer*)tap
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    UserInfoViewController *vc = [[UserInfoViewController alloc]initWithNibName:@"UserInfoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//登录
- (void)clickLoginAction
{
    [Tool loginWithAnimated:YES viewController:nil];
}

#pragma mark - UITableViewDelegate
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 230;
    }else{
        //只创建一个cell用作测量高度
        static IconTableViewCell *cell = nil;
        if (!cell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IconTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            [cell initImageCollectView];
            cell.collectView.delegate = cell;
            cell.collectView.dataSource = cell;
        }
        
        [self loadGoodsCellContent:cell indexPath:indexPath];
        return [self getGoodsCellHeight:cell];
    }
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UserCenterHeadTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterHeadTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCenterHeadTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (zhe>[hongbao intValue]&&[Tool islogin]) {
            
            cell.hongdian.hidden=NO;
            
        }else if(![Tool islogin])
        {
            cell.hongdian.hidden=YES;
        }
        else
        {
            cell.hongdian.hidden=YES;
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([ShareManager shareInstance].userinfo.islogin) {
            
            cell.noLoginControl.hidden = YES;
            cell.normalView.hidden = NO;
            
            cell.photoImage.layer.masksToBounds =YES;
            cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
            cell.photoImage.layer.borderColor = [[UIColor whiteColor] CGColor];
            cell.photoImage.layer.borderWidth = 3.0f;
            
            cell.photoImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserPhotoAction:)];
            [cell.photoImage addGestureRecognizer:tap];
            
            cell.rankLabel.layer.masksToBounds =YES;
            cell.rankLabel.layer.cornerRadius = cell.rankLabel.frame.size.height/2;
            
            cell.signButton.layer.masksToBounds =YES;
            cell.signButton.layer.cornerRadius = cell.signButton.frame.size.height/2;
            
            cell.czButton.layer.masksToBounds =YES;
            cell.czButton.layer.cornerRadius = cell.czButton.frame.size.height/2;
            
            [cell.messageButton addTarget:self action:@selector(clickMessageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.czButton addTarget:self action:@selector(clickCZButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.signButton addTarget:self action:@selector(clickSignButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[ShareManager shareInstance].isShowThird isEqualToString:@"y"]) {
                cell.czButton.hidden = NO;
                cell.signButtonCenterX.constant = -54;
            }else{
                cell.czButton.hidden = YES;
                cell.signButtonCenterX.constant = 0;
            }
            
            UserInfo *info = [ShareManager shareInstance].userinfo;
            [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.user_header] placeholderImage:PublicImage(@"default_head")];
    
            cell.numLabel.text = [NSString stringWithFormat:@"ID:%@",info.id];
            if ([info.nick_name isEqualToString:@"<null>"]) {
                cell.nameLabel.text = @"未设置";
            }else{
                cell.nameLabel.text = info.nick_name;
            }
            cell.rankLabel.text = info.level_name;
            CGSize size = [cell.rankLabel sizeThatFits:CGSizeMake(MAXFLOAT, 17)];
            cell.rankLabelWidth.constant = size.width+16;
            
            cell.pointLabel.text = [NSString stringWithFormat:@"%ld",(long)info.user_score];
            size = [cell.pointLabel sizeThatFits:CGSizeMake(MAXFLOAT, 17)];
            cell.poinrLabelWidth.constant = size.width;
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",info.user_money];
            
            if ([info.user_is_sign isEqualToString:@"y"]) {
                [cell.signButton setTitle:@"已签到" forState:UIControlStateNormal];
            }else{
                [cell.signButton setTitle:@"签到" forState:UIControlStateNormal];
            }

        }else{
            cell.numLabel.text = @"ID:--";
            cell.noLoginControl.hidden = NO;
            cell.normalView.hidden = YES;
            
            cell.noLoginImage.layer.masksToBounds =YES;
            cell.noLoginImage.layer.cornerRadius = cell.noLoginImage.frame.size.height/2;
            cell.noLoginImage.layer.borderColor = [[UIColor whiteColor] CGColor];
            cell.noLoginImage.layer.borderWidth = 4.0f;
            [cell.noLoginControl addTarget:self action:@selector(clickLoginAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }else{
        IconTableViewCell*cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"IconTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IconTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            
            [cell initImageCollectView];
            cell.delegate = self;
            cell.collectView.delegate = cell;
            cell.collectView.dataSource = cell;
        }
        [self loadGoodsCellContent:cell indexPath:indexPath];
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (void)loadGoodsCellContent:(IconTableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    [cell.collectView reloadData];
}

- (CGFloat)getGoodsCellHeight:(IconTableViewCell*)cell
{
    
    [cell layoutIfNeeded];
    [cell updateConstraintsIfNeeded];
    CGFloat height = cell.collectView.contentSize.height + 12;
    
    if (FullScreen.size.height - 230 - 49 - 35 > height) {
        height = FullScreen.size.height - 230 - 49 - 35;
    }
    return height;
}

#pragma mark - IconTableViewCellDelegate

- (void)selectIconInfo:(NSInteger)index
{
    switch (index) {
        case 0:
        {
        //夺宝纪录
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            DuoBaoRecordViewController *vc = [[DuoBaoRecordViewController alloc]initWithNibName:@"DuoBaoRecordViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            //中奖纪录
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            ZJRecordViewController *vc = [[ZJRecordViewController alloc]initWithNibName:@"ZJRecordViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            //我的晒单
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            ShaiDanViewController *vc = [[ShaiDanViewController alloc]initWithNibName:@"ShaiDanViewController" bundle:nil];
            vc.userId = [ShareManager shareInstance].userinfo.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:
        {
            //招募徒弟
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            ZhaomuTudiViewController *vc = [[ZhaomuTudiViewController alloc]initWithNibName:@"ZhaomuTudiViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            //积分兑换
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            JFDHViewController *vc = [[JFDHViewController alloc]initWithNibName:@"JFDHViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            //积分提现
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            JFDHViewController *vc = [[JFDHViewController alloc]initWithNibName:@"JFDHViewController" bundle:nil];
            vc.isTiXian = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            //红包
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            CouponsViewController *vc = [[CouponsViewController alloc]initWithNibName:@"CouponsViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            //任务
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            TaskViewController *vc = [[TaskViewController alloc]initWithNibName:@"TaskViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 8:
        {
            //联系客服
            ConnectOurViewController *vc = [[ConnectOurViewController alloc]initWithNibName:@"ConnectOurViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:
        {
            //常见问题
            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.urlStr = [NSString stringWithFormat:@"%@%@",URL_Server,Wap_CJWT];
            vc.title = @"常见问题";
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 10:
        {
            //设置
            SettingViewController *vc = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
       
        default:
            break;
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([viewController isEqual:self])
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.menuViewController hidesTabBar:NO animated:NO];
        self.menuViewController.tabBarTransparent = NO;
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO ];
        [self.menuViewController hidesTabBar:YES animated:YES];
        self.menuViewController.tabBarTransparent = YES;
    }
}
- (void)httpCouponsList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak UserCenterViewController *weakSelf = self;
    
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
                                 
                                // [Tool showPromptContent:decretion onView:self.view];
                             }];
}

- (void)handleloadFriendsListResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"ticketList"];

    NSLog(@"红包数量＝＝＝＝＝＝＝＝＝＝＝%lu",(unsigned long)resourceArray.count);
    NSInteger NumHongbao =(unsigned long)resourceArray.count;
    NSUserDefaults *defult = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)NumHongbao];
    [defult setObject:str forKey:@"hongbaoshuliang"];
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.hongbaoshu=[NSString stringWithFormat:@"%ld",(long)NumHongbao];
    NSLog(@"全局红包数量是＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝%@",appDelegate.hongbaoshu);
}




@end
