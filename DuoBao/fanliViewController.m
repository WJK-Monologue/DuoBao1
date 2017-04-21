//
//  fanliViewController.m
//  DuoBao
//
//  Created by 余灏 on 16/10/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "fanliViewController.h"
#import "FriendsInfo.h"
#import "FriendsInfoTableViewCell.h"
#import "UserViewController.h"

@implementation ServiceInfo

@end

@interface fanliViewController ()
{
    NSInteger selectType;//1 一级 2 二级  3 三级
    UIButton *_yjButton;
    UIButton *_ejButton;
    UIButton *_sjButton;
    
    UILabel *_yjLine;
    UILabel *_ejLine;
    UILabel *_sjLine;
    
    NSString *allFriendsNum;
    NSString *yjFriendsNum;
    NSString *ejFriendsNum;
    NSString *sjFriendsNum;
    
    NSMutableArray *serverSourceArray;
    NSMutableArray *dataSourceArray;
    int pageNum;
}

@end

@implementation fanliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   [self setTabelViewRefresh];
    [self httpGetFriendsList];
    [self httpBaseData];
    pageNum = 1;
    serverSourceArray = [NSMutableArray array];
    dataSourceArray = [NSMutableArray array];
    selectType = 1;
    [_tableview.mj_header beginRefreshing];
    [_tableview reloadData];
   // [_tableview.mj_header endRefreshing];
     [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (void)httpBaseData
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak fanliViewController *weakSelf = self;
    [helper getInviteFriendsInfoWithUserId:[ShareManager shareInstance].userinfo.id
                                   success:^(NSDictionary *resultDic){
                                       if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                           [weakSelf handleloadResult:resultDic];
                                       }else
                                       {
                                           [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                       }
                                   }fail:^(NSString *decretion){
                                       [Tool showPromptContent:@"网络出错了" onView:self.view];
                                   }];
}




- (void)handleloadResult:(NSDictionary *)resultDic
{
    allFriendsNum = [NSString stringWithFormat:@"%@位",[[resultDic objectForKey:@"data"] objectForKey:@"friends_all"]];
    yjFriendsNum = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"friends_level_one"]];
    ejFriendsNum = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"friends_level_two"]];
    sjFriendsNum = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"friends_level_three"]];
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"serviceList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            
            ServiceInfo *info = [dic objectByClass:[ServiceInfo class]];
            [serverSourceArray addObject:info];
                   }
    }
  
    
    [_tableview reloadData];
    
    
    
}

- (void)httpGetFriendsList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak fanliViewController *weakSelf = self;
    
    [helper getFriendsByLevelWithUserId:[ShareManager shareInstance].userinfo.id
                                  level:[NSString stringWithFormat:@"%ld",(long)selectType]
                                pageNum:[NSString stringWithFormat:@"%d",pageNum]
                               limitNum:@"30"
                                success:^(NSDictionary *resultDic){
                                    [self hideRefresh];
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                        [weakSelf handleloadFriendsListResult:resultDic];
                                    }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                                }fail:^(NSString *decretion){
                                    [self hideRefresh];
                                    [Tool showPromptContent:decretion onView:self.view];
                                }];

}
- (void)handleloadFriendsListResult:(NSDictionary *)resultDic
{
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
        
    }
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"friendsList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            FriendsInfo *info = [dic objectByClass:[FriendsInfo class]];
            [dataSourceArray addObject:info];
        }
        
        if (resourceArray.count < 30) {
            [_tableview.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableview.mj_footer resetNoMoreData];
        }
        
        pageNum++;
    }
    
    [_tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
   return dataSourceArray.count;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        return 95;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    FriendsInfoTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsInfoTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsInfoTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    FriendsInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    cell.photoImage.layer.masksToBounds =YES;
    cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.user_header] placeholderImage:PublicImage(@"default_head")];
    if(info.nick_name.length > 0 && ![info.nick_name isEqualToString:@"<null>"])
    {
        cell.nameLabel.text = info.nick_name;
    }else{
        cell.nameLabel.text = @"";
    }
     [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    cell.hyIdStr.text = info.id;
    cell.dbrcLabel.text = [NSString stringWithFormat:@"%@人次",info.fight_record_num];
    cell.timeLabel.text = info.create_time;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
        UserViewController *vc = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        FriendsInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
        vc.userId = info.id;
        [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.tableview;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetFriendsList];
        [weakSelf httpBaseData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetFriendsList];
        
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    
    if([_tableview.mj_footer isRefreshing])
    {
        [_tableview.mj_footer endRefreshing];
    }
    if([_tableview.mj_header isRefreshing])
    {
        [_tableview.mj_header endRefreshing];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
