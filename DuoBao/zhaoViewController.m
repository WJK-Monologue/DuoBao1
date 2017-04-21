//
//  zhaoViewController.m
//  DuoBao
//
//  Created by 余灏 on 16/10/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "zhaoViewController.h"
#import "FriendsInfo.h"
#import <CoreText/CoreText.h>
#import "whyViewController.h"
#import "howViewController.h"

@implementation ServiceLiInfo

@end
@interface zhaoViewController ()
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

@implementation zhaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self httpGetFriendsList];
    [self httpBaseData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)httpBaseData
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak zhaoViewController *weakSelf = self;
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
                
                NSDictionary* style1 = @{@"body":[UIFont fontWithName:@"HelveticaNeue" size:15.0],  @"red": colord};
                
                NSString * textvalue=[NSString stringWithFormat:@"获得充值金额<body><red>%.f%%</red></body>分成" ,[str4 doubleValue]*100.0];
                
                _baifen.attributedText = [textvalue attributedStringWithStyleBook:style1];
                
            }
        }
    }
    //_num.text = [NSString stringWithFormat:@"%@",allFriendsNum];
    _weishu.text=[NSString stringWithFormat:@"%@",allFriendsNum];
    
   
    
    

}

- (void)httpGetFriendsList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak zhaoViewController *weakSelf = self;
    
    [helper getFriendsByLevelWithUserId:[ShareManager shareInstance].userinfo.id
                                  level:[NSString stringWithFormat:@"%ld",(long)selectType]
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
        
        //        if (resourceArray.count < 30) {
        //            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        //        }else{
        //            [_myTableView.mj_footer resetNoMoreData];
        //        }
        
        pageNum++;
    }
    
    // [_myTableView reloadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
