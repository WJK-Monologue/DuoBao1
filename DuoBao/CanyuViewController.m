//
//  CanyuViewController.m
//  DuoBao
//
//  Created by 余灏 on 16/11/22.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CanyuViewController.h"
#import "RecordTableViewCell.h"
#import "DuoBaoRecordInfo.h"
#define  WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface CanyuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *recordDataArray;
    int pageNum;
    UITableView *tableivew;
}

@end

@implementation CanyuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.title=@"参与记录";
    recordDataArray = [NSMutableArray array];

    tableivew= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,HEIGHT)];
    tableivew.delegate=self;
    tableivew.dataSource=self;
    tableivew.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:tableivew];

    [self loadDuoBaoRecord];
    
}
- (void)loadDuoBaoRecord
{
    pageNum=1;
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak CanyuViewController *weakSelf = self;
    [helper loadDuoBaoRecordWithGoodsId:_goodId
                                pageNum:[NSString stringWithFormat:@"%d",pageNum]
                               limitNum:@"20"
                                success:^(NSDictionary *resultDic){
//                                    [self hideRefresh];
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                        [weakSelf handleLoadRecordResult:resultDic];
                                    }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                                }fail:^(NSString *decretion){
                                    //[self hideRefresh];
                                    [Tool showPromptContent:decretion onView:self.view];
                                }];
}


- (void)handleLoadRecordResult:(NSDictionary *)resultDic
{
  
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightRecordList"];
  
        for (NSDictionary *dic in resourceArray)
        {
            DuoBaoRecordInfo *info = [dic objectByClass:[DuoBaoRecordInfo class]];
            [recordDataArray addObject:info];
        }
        
     [tableivew reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recordDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"RecordTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.photoImage.tag = indexPath.row;
    cell.photoImage.userInteractionEnabled = YES;
   
  
    cell.seeNumButton.tag = indexPath.row;
   
    cell.seeNumButton.hidden=YES;
    
    DuoBaoRecordInfo *info = [recordDataArray objectAtIndex:indexPath.row];
    
    cell.photoImage.layer.masksToBounds =YES;
    cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.user_header] placeholderImage:PublicImage(@"default_head")];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@ ip:%@)",info.nick_name,info.user_ip_address,info.user_ip];
    cell.joinNameLabel.text = [NSString stringWithFormat:@"参与%@人次  %@",info.count_num,info.fight_time_all];
    
//    if ([info.count_num intValue] > 1) {
//        cell.seeNumButton.hidden = NO;
//        cell.luckNumLabel.hidden = YES;
//    }else{
//        cell.seeNumButton.hidden = YES;
//        cell.luckNumLabel.hidden = NO;
//        cell.luckNumLabel.text = [NSString stringWithFormat:@"幸运号码：%@",info.fight_num];
//    }
    
    
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)setTabelViewRefresh
//{
//    __unsafe_unretained UITableView *tableView = tableivew;
//    __unsafe_unretained __typeof(self) weakSelf = self;
//    // 下拉刷新
//    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        pageNum = 1;
//       
//        [weakSelf loadDuoBaoRecord];
//    }];
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    tableView.mj_header.automaticallyChangeAlpha = YES;
//    //    [tableView.mj_header beginRefreshing];
//    // 上拉刷新
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadDuoBaoRecord];
//    }];
//    tableView.mj_footer.automaticallyHidden = YES;
//}

//- (void)hideRefresh
//{
//    if([_mytableview.mj_header isRefreshing])
//    {
//        [_mytableview.mj_header endRefreshing];
//    }
//    if([_mytableview.mj_footer isRefreshing])
//    {
//        [_mytableview.mj_footer endRefreshing];
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
