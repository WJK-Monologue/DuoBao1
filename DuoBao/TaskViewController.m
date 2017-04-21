//
//  TaskViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskListTableViewCell.h"
#import "TaskListInfo.h"
#import "TaskRewardRecordViewController.h"
#import "SafariViewController.h"
#import "CZViewController.h"
#import "YaoqingViewController.h"
#import "ZengQianInfo.h"
#import "ArticleDetailViewController.h"
#import "GoodsListViewController.h"
#import "ShaiDanViewController.h"
#import "MenuViewController.h"
#import "UserCenterViewController.h"
#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "ZhaomuTudiViewController.h"
@interface TaskViewController ()
{
    NSMutableArray *scoreArray;
    NSMutableArray *moneyArray;
    UIView *view2;
}

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
    [self setTabelViewRefresh];
    [self httpGetTaskList];
     [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"任务大厅";
    scoreArray = [NSMutableArray array];
    moneyArray = [NSMutableArray array];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [_myTableView reloadData];

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
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,75, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"奖励记录" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,8)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}


#pragma mark - http

- (void)httpGetTaskList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak TaskViewController *weakSelf = self;
    [helper getHttpWithUrlStr:URL_TaskList
                      success:^(NSDictionary *resultDic){
                          [self hideRefresh];
                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                              [weakSelf handleloadResult:resultDic];
                              [_myTableView reloadData];

                          }else
                          {
                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                          }
                      }fail:^(NSString *decretion){
                          [self hideRefresh];
                          [Tool showPromptContent:@"网络出错了" onView:self.view];
                      }];

}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSLog(@"%@",resultDic);
    if (scoreArray.count > 0) {
        [scoreArray removeAllObjects];
    }
    if (moneyArray.count > 0) {
        [moneyArray removeAllObjects];
    }
    
    NSArray *resoureArray = [[resultDic objectForKey:@"data"] objectForKey:@"taskScoreList"];
    if (resoureArray && resoureArray.count > 0 )
    {
        for (NSDictionary *dic in resoureArray)
        {
            TaskListInfo *info = [dic objectByClass:[TaskListInfo class]];
            [scoreArray addObject:info];
        }
        [_myTableView reloadData];

    }

    resoureArray = [[resultDic objectForKey:@"data"] objectForKey:@"taskMoneyList"];
    if (resoureArray && resoureArray.count > 0 )
    {
        for (NSDictionary *dic in resoureArray)
        {
            TaskListInfo *info = [dic objectByClass:[TaskListInfo class]];
            [moneyArray addObject:info];
        }
        [_myTableView reloadData];

    }
    
    [_myTableView reloadData];
    
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightItemAction:(id)sender
{
    TaskRewardRecordViewController *vc = [[TaskRewardRecordViewController alloc]initWithNibName:@"TaskRewardRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        if (moneyArray.count > 0) {
            return 40;
        }else{
            return 0;
        }
    }else if (section == 1)
    {
        if (scoreArray.count > 0) {
            return 40;
        }else{
            return 0;
        }
    }
    else{
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0)
    {
        if (moneyArray.count == 0) {
            return nil;
            
        }
    }else if (section == 1){
        if (scoreArray.count == 0) {
            return nil;
        }
    }
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 40);
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 39, FullScreen.size.width, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
   // [bgView addSubview:lineview];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, FullScreen.size.width, 20)];
    
    switch (section) {
        case 0:
            nameLabel.text = @"充值任务";
            break;
        case 1:
            nameLabel.text = @"每日任务";
            break;
       
        default:
            break;
    }
    
    nameLabel.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
   
    nameLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:nameLabel];
    
    return bgView;
}


//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return moneyArray.count;
    }

    else if(section==1){
        
        return scoreArray.count;
    }else
    {
        return 1;
    }
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TaskListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"TaskListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     if(indexPath.section == 0)
    {
        
        TaskListInfo *info = [moneyArray objectAtIndex:indexPath.row];
        
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.img] placeholderImage:PublicImage(@"defaultImage")];
        cell.photoImage.layer.masksToBounds =YES;
        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
        cell.titleLabel.text = info.title;
        cell.detailLabel.text = info.remark;
       
        
    }
    else if(indexPath.section == 1)
        {
            TaskListInfo *info = [scoreArray objectAtIndex:indexPath.row];
            [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.img] placeholderImage:PublicImage(@"defaultImage")];
            cell.photoImage.layer.masksToBounds =YES;
            cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
            cell.titleLabel.text = info.title;
            cell.detailLabel.text = info.remark;
            
            if ([info.title isEqualToString:@"邀请好友"]) {
                cell.titleLabel.text=@"招募徒弟";
            }
            if ([info.title isEqualToString:@"晒单赢积分"])
            {
                cell.titleLabel.text=@"晒单最高可获得8元";
            }
            if ([info.title isEqualToString:@"充值有礼"]) {
                cell.titleLabel.text=@"每日签到";
                cell.photoImage.image =[UIImage imageNamed:@"cont_qiandao"];
            }

        }
//    else
//        {
//            cell.photoImage.image = [UIImage imageNamed:@"cont_luckybig"];
//            cell.titleLabel.text = @"幸运大转盘";
//            cell.detailLabel.text = @"每天免费玩一次，惊喜大奖等着你";
//        }
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

     [tableView deselectRowAtIndexPath:indexPath animated:NO];
   //充值任务
    if (indexPath.section ==0) {
        TaskListInfo *info = [moneyArray objectAtIndex:indexPath.row];
        NSLog(@"%@",info.title);
            if ([info.title isEqualToString:@"新手充值礼包"]||[info.title isEqualToString:@"充值有礼"]) {
                CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
        if ([info.title isEqualToString:@"新手红包"]) {
                if ([info.title isEqualToString:@"新手红包"]) {
                    ArticleDetailViewController *vc = [[ArticleDetailViewController alloc]initWithNibName:@"ArticleDetailViewController" bundle:nil];
            
                    vc.urlStr = @"http://m.qmgoubao.com/GetTreasureAppYa/appInterface/newsContentInfo.jhtml?id=131";
                    [self.navigationController pushViewController:vc animated:YES];
                }
        }
        
        
    }
    
    //每日任务
    if (indexPath.section ==1) {
         TaskListInfo *info = [scoreArray objectAtIndex:indexPath.row];
        NSLog(@"%@",info.title);
        
        if ([info.title isEqualToString:@"邀请好友"]) {
            ZhaomuTudiViewController *vc = [[ZhaomuTudiViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
        if ([info.title isEqualToString:@"每日分享"]) {
            
            view2=[[UIView alloc]initWithFrame:CGRectMake(0, self.myTableView.frame.size.height/3,10, 10)];
            [self.myTableView addSubview:view2];
                [ShareManager shareInstance].shareType = 1;
            if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
                [Tool shareMessageToOtherApp:nil
                                 description:[NSString stringWithFormat:@"赶快来下载全民购宝App！我的推荐码:%@",[ShareManager shareInstance].userinfo.id]
                                    titleStr:@"全民购宝App！"
                                    shareUrl:[NSString stringWithFormat:@"%@%@user_id=%@",URL_ShareServer,Wap_ShareDuobao,[ShareManager shareInstance].userinfo.id]
                                    fromView:view2];
            }else
            {
                [Tool shareMessageToOtherApp:nil
                                 description:[NSString stringWithFormat:@"赶快来下载全民购宝App！我的推荐码:%@",[ShareManager shareInstance].userinfo.id]
                                    titleStr:@"全民购宝App！"
                                    shareUrl:[NSString stringWithFormat:@"%@%@user_id=%@",URL_ShareServer,Wap_ShareDuobao,[ShareManager shareInstance].userinfo.id]
                                    fromView:self.view];
            }
            }
        if ([info.title isEqualToString:@"每日参与"]) {
                GoodsListViewController *vc = [[GoodsListViewController alloc]initWithNibName:@"GoodsListViewController" bundle:nil];
                vc.typeId = @"";
                vc.typ=1;
                vc.typeName = @"全部商品";
                [self.navigationController pushViewController:vc animated:YES];
            }
        if ([info.title isEqualToString:@"充值有礼"]) {
                 [self httpUserSign];
            }
        if ([info.title isEqualToString:@"晒单赢积分"]) {
                ShaiDanViewController *vc = [[ShaiDanViewController alloc]initWithNibName:@"ShaiDanViewController" bundle:nil];
                vc.userId = [ShareManager shareInstance].userinfo.id;
                [self.navigationController pushViewController:vc animated:YES];
            }
        if ([info.title isEqualToString:@"晒单分享积分"]) {
                ShaiDanViewController *vc = [[ShaiDanViewController alloc]initWithNibName:@"ShaiDanViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
    }
    
    //幸运大转盘
//    if (indexPath.section==2) {
//                SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
//                vc.title = @"大转盘";
//                vc.urlStr = [NSString stringWithFormat:@"%@%@user_id=%@",URL_Server,Wap_RotaryGameUrl,[ShareManager shareInstance].userinfo.id];
//                vc.isRotaryGame = YES;
//                [self.navigationController pushViewController:vc animated:YES];
//    }
    



//    
    NSLog(@"indexsection========%ld",(long)indexPath.section);
  //   NSLog(@"id=========%@",info.id);
    NSLog(@"indexrow======%ld=========",(long)indexPath.row);
    //NSLog(@"%@",info.title);
    
}

#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    [_myTableView reloadData];
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf httpGetTaskList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
}

- (void)hideRefresh
{
    
    if([_myTableView.mj_footer isRefreshing])
    {
        [_myTableView.mj_footer endRefreshing];
    }
    if([_myTableView.mj_header isRefreshing])
    {
        [_myTableView.mj_header endRefreshing];
    }
}

- (void)httpUserSign
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"签到中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak TaskViewController *weakSelf = self;
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


@end
