//
//  ZJRecordViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ZJRecordViewController.h"
#import "ZJRecordListTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import "WantToSDViewController.h"
#import "ZJRecordListInfo.h"
#import "EditAddressViewController.h"
#import "ProductDetailViewController.h"

@interface ZJRecordViewController ()
{
    int pageNum;
    NSMutableArray *dataSourceArray;
}

@end

@implementation ZJRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self setTabelViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"中奖记录";
    pageNum =1;
    dataSourceArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - http

- (void)httpGetRecordList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ZJRecordViewController *weakSelf = self;
    
    [helper getZJRecordWithUserid:[ShareManager shareInstance].userinfo.id
                              pageNum:[NSString stringWithFormat:@"%d",pageNum]
                             limitNum:@"20"
                              success:^(NSDictionary *resultDic){
                                  [self hideRefresh];
                                  if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                      [weakSelf handleloadResult:resultDic];
                                  }else
                                  {
                                      [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                  }
                              }fail:^(NSString *decretion){
                                  [self hideRefresh];
                                  [Tool showPromptContent:decretion onView:self.view];
                              }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightWinRecordList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        if (dataSourceArray.count > 0 && pageNum == 1) {
            [dataSourceArray removeAllObjects];
            
        }
        for (NSDictionary *dic in resourceArray)
        {
            ZJRecordListInfo *info = [dic objectByClass:[ZJRecordListInfo class]];
            [dataSourceArray addObject:info];
        }
        
        if (resourceArray.count < 20) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        
        pageNum++;
    }else{
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
        }
    }
    [_myTableView reloadData];
}




#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSDButtonAction:(UIButton *)btn
{
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:btn.tag];
    
    if ([info.order_status isEqualToString:@"待发货"])
    {
        EditAddressViewController *vc = [[EditAddressViewController alloc]initWithNibName:@"EditAddressViewController" bundle:nil];
        vc.orderInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        if ([info.is_bask isEqualToString:@"y"]) {
           return;
        }else{
            
            WantToSDViewController *vc = [[WantToSDViewController alloc]initWithNibName:@"WantToSDViewController" bundle:nil];
            vc.detailInfo = info;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
    }
    
}

#pragma mark - UITableViewDelegate

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    if ([info.order_status isEqualToString:@"待发货"]) {
        return 158;
    }else{
       return 202;
    }
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZJRecordListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRecordListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ZJRecordListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    //设点点击选择的颜色(无)
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.sdButton.layer.masksToBounds =YES;
    cell.sdButton.layer.cornerRadius = 3;
    
     ZJRecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.good_header] placeholderImage:PublicImage(@"defaultImage")];
    cell.titleLabel.text = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
    cell.orderStatue.text = info.order_status;
    cell.xyhmLabel.text = info.win_num;
    cell.allNumLabel.text = [NSString stringWithFormat:@"%@人次",info.need_people];
    cell.joinNumLabel.text = [NSString stringWithFormat:@"%@人次",info.count_num];
    cell.timeLabel.text = info.lottery_time;
   
    if ([info.order_status isEqualToString:@"待发货"]) {
        cell.wlgsLabel.hidden = YES;
        cell.wlgsLabelHeight.constant = 0;
        cell.wlgsValueLabel.hidden = YES;
        cell.wlgsValueLabelHeight.constant = 0;
        
        cell.wlddLabel.hidden = YES;
        cell.wlddHeight.constant = 0;
        cell.wlddValueLabel.hidden = YES;
        cell.wlddValueHeight.constant = 0;
        [cell.sdButton setTitle:@"修改地址" forState:UIControlStateNormal];
        [cell.sdButton setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1]];
        [cell.sdButton setUserInteractionEnabled:YES];
        
    }else{
        cell.wlgsLabel.hidden = NO;
        cell.wlgsLabelHeight.constant = 22;
        cell.wlgsValueLabel.hidden = NO;
        cell.wlgsValueLabelHeight.constant = 22;
        
        cell.wlddLabel.hidden = NO;
        cell.wlddHeight.constant = 22;
        cell.wlddValueLabel.hidden = NO;
        cell.wlddValueHeight.constant = 22;
        
        cell.wlddValueLabel.text = info.courier_id;
        cell.wlgsValueLabel.text = info.courier_name;
        
        
        if ([info.is_bask isEqualToString:@"y"]) {
            
            [cell.sdButton setTitle:@"已晒单" forState:UIControlStateNormal];
            [cell.sdButton setBackgroundColor:[UIColor lightGrayColor]];
            [cell.sdButton setUserInteractionEnabled:NO];
            
        }else{
            [cell.sdButton setTitle:@"晒单" forState:UIControlStateNormal];
            [cell.sdButton setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1]];
            [cell.sdButton setUserInteractionEnabled:YES];
        }
        
    }
    cell.sdButton.tag = indexPath.row;
    [cell.sdButton addTarget:self action:@selector(clickSDButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    //GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    ProductDetailViewController *vc = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
    //vc.goodsId = info.id;
    NSLog(@"%@",info.id);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetRecordList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       [weakSelf httpGetRecordList];
    }];
    tableView.mj_footer.automaticallyHidden = YES;
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


@end
