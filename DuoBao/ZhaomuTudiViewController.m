//
//  ZhaomuTudiViewController.m
//  DuoBao
//
//  Created by 余灏 on 16/12/1.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ZhaomuTudiViewController.h"
#import "FriendsInfo.h"
#import <CoreText/CoreText.h>
#import "whyViewController.h"
#import "howViewController.h"
#import "FriendsInfoTableViewCell.h"
#import "UserViewController.h"
@interface ZhaomuTudiViewController ()
{
 int selectType;//0 夺宝记录、1中奖记录、晒单分享
   // NSInteger selectType;//1 一级 2 二级  3 三级
    UIButton *_yjButton;
    UIButton *_ejButton;
    UIButton *_sjButton;
     NSInteger selectType1;
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

@implementation ZhaomuTudiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_zhaomuguize setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_fanlixiangqing setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    pageNum = 1;
    serverSourceArray = [NSMutableArray array];
    dataSourceArray = [NSMutableArray array];
    selectType = 0;
    selectType1=1;
    [self updateSlectStatue];
    [self httpBaseData];
    [self httpGetFriendsList];
     [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)httpGetFriendsList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ZhaomuTudiViewController *weakSelf = self;
    
    [helper getFriendsByLevelWithUserId:[ShareManager shareInstance].userinfo.id
                                  level:[NSString stringWithFormat:@"%ld",(long)selectType1]
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


- (void)httpBaseData
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ZhaomuTudiViewController *weakSelf = self;
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
            NSString *str4;
            ServiceLiInfo *info = [dic objectByClass:[ServiceLiInfo class]];
            [serverSourceArray addObject:info];
            if ([info.type isEqualToString:@"buy_divide_one"]) {
                str4 = info.value;
                UIColor* colord = [UIColor colorWithRed:252/255.0f green:139/255.0f blue:54/255.0f alpha:1];
                
                NSDictionary* style1 = @{@"body":[UIFont fontWithName:@"HelveticaNeue" size:13.0],  @"red": colord};
                
                NSString * textvalue=[NSString stringWithFormat:@"获得充值金额<body><red>%.f%%</red></body>分成" ,[str4 doubleValue]*100.0];
                
                _huode.attributedText = [textvalue attributedStringWithStyleBook:style1];
                
            }
        }
    }
    //_num.text = [NSString stringWithFormat:@"%@",allFriendsNum];
    _jiwei.text=[NSString stringWithFormat:@"%@",allFriendsNum];
    _yaoqingweishu.text=[NSString stringWithFormat:@"%@",allFriendsNum];
    
    
    
    
}




- (void)updateSlectStatue
{
    UIColor *normalCorlor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    UIColor *selectCorlor = [UIColor colorWithRed:210.0/255.0 green:16.0/255.0 blue:31.0/255.0 alpha:1];
    
    [_zhaomuguize setTitleColor:normalCorlor forState:UIControlStateNormal];
    [_fanlixiangqing setTitleColor:normalCorlor forState:UIControlStateNormal];
   
    
    _zhaomuguizeview.hidden = YES;
    _fanlixiangqingview.hidden = YES;
   
    
    switch (selectType) {
        case 0:
        {
            [_zhaomuguize setTitleColor:selectCorlor forState:UIControlStateNormal];
            _zhaomuguizeview.hidden = NO;
        }
            break;
        default:
        {
            [_fanlixiangqing setTitleColor:selectCorlor forState:UIControlStateNormal];
            _fanlixiangqingview.hidden = NO;
        }
            break;
      
    }
}
- (IBAction)zhaomuguize:(id)sender
{
    selectType = 0;
    _tableview.hidden=YES;
    [self updateSlectStatue];
}
- (IBAction)fanlixiangq:(id)sender
{
    selectType = 1;
    _tableview.hidden=NO;
    [self updateSlectStatue];
}
- (IBAction)fenxiang:(id)sender
{
    [ShareManager shareInstance].shareType = 1;
    [Tool shareMessageToOtherApp:nil
                     description:[NSString stringWithFormat:@"赶快来下载全民购宝App！我的推荐码:%@",[ShareManager shareInstance].userinfo.id]
                        titleStr:@"全民购宝App！"
                        shareUrl:[NSString stringWithFormat:@"%@%@user_id=%@",URL_ShareServer,Wap_ShareDuobao,[ShareManager shareInstance].userinfo.id]
                        fromView:self.view];
    
    
    
    
}
- (IBAction)why:(id)sender
{
    whyViewController *vc = [[whyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)how:(id)sender
{
    howViewController *vc = [[howViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

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
