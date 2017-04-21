//
//  DuoBaoRecordViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "DuoBaoRecordViewController.h"
#import "DuoBaoRecordListTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import "DBNumViewController.h"
#import "SelfDuoBaoRecordInfo.h"
#import "SafariViewController.h"
#import "WkwebViewController.h"
@interface DuoBaoRecordViewController ()
{
    int selectOptionType;//0全部 1 进行中 2 已揭晓
    int pageNum;
    NSMutableArray *dataSourceArray;
}

@end

@implementation DuoBaoRecordViewController

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"购宝记录";
    selectOptionType = 0;
    [self updateHeadButtonView];
    pageNum = 1;
    _headIconWidth.constant = FullScreen.size.width/3;
    dataSourceArray = [NSMutableArray array];
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


- (void)updateHeadButtonView
{
    [_allButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_jxzButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_yjxButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    _allLine.hidden = YES;
    _jxzLine.hidden = YES;
    _yjxLine.hidden = YES;
    
    switch (selectOptionType) {
        case 0:
        {
            [_allButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
            _allLine.hidden = NO;
        }
            break;
        case 1:
        {
            [_jxzButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
            _jxzLine.hidden = NO;
        }
            break;
        default:
        {
            [_yjxButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
            _yjxLine.hidden = NO;
        }
            break;
    }
    
    
    
}


#pragma mark - http

- (void)httpGetRecordList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak DuoBaoRecordViewController *weakSelf = self;
    
    NSString *statusStr = nil;
    switch (selectOptionType) {
        case 0:
            statusStr = @"全部";
            break;
        case 1:
            statusStr = @"进行中";
            break;
        default:
            statusStr = @"已揭晓";
            break;
    }
    
    [helper getDuoBaoRecordWithUserid:[ShareManager shareInstance].userinfo.id
                               status:statusStr
                              pageNum:[NSString stringWithFormat:@"%d",pageNum]
                             limitNum:@"20"
                           success:^(NSDictionary *resultDic){
                               [weakSelf hideRefresh];
                               if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                   [weakSelf handleloadResult:resultDic];
                               }else
                               {
                                   [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                               }
                           }fail:^(NSString *decretion){
                               [weakSelf hideRefresh];
                               [Tool showPromptContent:decretion onView:self.view];
                           }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightRecordList"];
    
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
        
    }
    
    if (resourceArray && resourceArray.count > 0 )
    {
        
        for (NSDictionary *dic in resourceArray)
        {
            SelfDuoBaoRecordInfo *info = [dic objectByClass:[SelfDuoBaoRecordInfo class]];
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

- (IBAction)clickAllButtonAction:(id)sender
{
    selectOptionType = 0;
    [self updateHeadButtonView];
    [self.myTableView.mj_header beginRefreshing];
}

- (IBAction)clickJXZButtonAction:(id)sender
{
    selectOptionType = 1;
    [self updateHeadButtonView];
    [self.myTableView.mj_header beginRefreshing];
}

- (IBAction)clickYJXButtonAction:(id)sender
{
    selectOptionType = 2;
    [self updateHeadButtonView];
    [self.myTableView.mj_header beginRefreshing];
}


- (void)clickSeeNumButtonAction:(UIButton *)btn
{
    
    SelfDuoBaoRecordInfo *info = [dataSourceArray objectAtIndex:btn.tag];
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    vc.userId = [ShareManager shareInstance].userinfo.id;
    vc.goodId = info.id;
    vc.userName = [ShareManager shareInstance].userinfo.nick_name;
    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
    [self.navigationController pushViewController:vc animated:YES];
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
    SelfDuoBaoRecordInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    if ([info.status isEqualToString:@"倒计时"]) {
        return 99;
    }else if([info.status isEqualToString:@"已揭晓"]){
        return 177;
    }else{//进行中
        return 114;
    }
    
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DuoBaoRecordListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"DuoBaoRecordListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DuoBaoRecordListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    cell.processView.layer.masksToBounds =YES;
    cell.processView.layer.cornerRadius = cell.processView.frame.size.height/2;
    cell.processViewHeight.constant = 7;
    cell.processView.hidden = NO;
    
    cell.ZJButton.layer.masksToBounds =YES;
    cell.ZJButton.layer.cornerRadius = 4;
    cell.ZJButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
    cell.ZJButton.layer.borderWidth = 1.0f;
    
    SelfDuoBaoRecordInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.good_header] placeholderImage:PublicImage(@"defaultImage")];
    cell.titleLabel.text = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
    //改动第几期
//    cell.titleLabel.text = [NSString stringWithFormat:@"%@",info.good_name];
    cell.joinNum.text = [NSString stringWithFormat:@"本次参与%@人次",info.count_num];
    
    if ([info.status isEqualToString:@"倒计时"]) {
        cell.ZJButton.hidden = YES;
        cell.detailView.hidden = YES;
        cell.allNum.hidden = YES;
        cell.needNum.hidden = YES;
        cell.needNumTitle.hidden = YES;
        cell.joinNumTop.constant = 0;
        cell.processView.hidden = YES;
        cell.WarnLabel.hidden = NO;
        cell.warnLabelHeight.constant = 15;
        cell.WarnLabel.backgroundColor = [UIColor whiteColor];
        
        NSString * reviewStr = [NSString stringWithFormat:@"揭晓倒计时：<color1>请稍后，系统揭晓中...</color1>"];
        
        cell.WarnLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1];
        
        NSDictionary* style = @{@"body":[UIFont systemFontOfSize:13],
                                @"color1":[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1]};
        
        cell.WarnLabel.attributedText = [reviewStr attributedStringWithStyleBook:style];

        
    }else if([info.status isEqualToString:@"已揭晓"]){
        cell.ZJButton.hidden = YES;
        cell.detailView.hidden = NO;
        cell.processView.hidden = YES;
        cell.allNum.hidden = YES;
        cell.needNum.hidden = YES;
        cell.needNumTitle.hidden = YES;
        cell.joinNumTop.constant = 0;
        cell.WarnLabel.hidden = NO;
        cell.WarnLabel.text = @"";
        cell.WarnLabel.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        cell.warnLabelHeight.constant = 1;
        
        cell.nameLabel.text = info.nick_name;
        cell.luckNumLabel.text = info.win_num;
        cell.joinNumLabel.text = [NSString stringWithFormat:@"%@人次",info.win_fight_time];
        cell.timeLabel.text = info.lottery_time;
    
        
        
    }else{//进行中
        cell.ZJButton.hidden = NO;
        cell.detailView.hidden = YES;
        cell.joinNumTop.constant = 38;
        cell.WarnLabel.hidden = YES;
        cell.allNum.hidden = NO;
        cell.needNum.hidden = NO;
        cell.needNumTitle.hidden = NO;
        
        cell.processLabelWidth.constant = (FullScreen.size.width - 174)*([info.progress doubleValue]/100.0);
        if ([info.need_people isEqualToString:@"0"])
        {
            cell.allNum.text =@"本期0元购正在进行中...";
            cell.processView.hidden=YES;
            cell.ZJButton.hidden=YES;
           
        }else
        {
            cell.allNum.text = [NSString stringWithFormat:@"总需 %@",info.need_people];
        }
        
        
        CGSize size = [cell.allNum sizeThatFits:CGSizeMake(MAXFLOAT, 15)];
        cell.allNumLabel.constant = size.width+5;
        if ([info.need_people intValue]- [info.now_people intValue]<0)
        {
            cell.needNum.hidden=YES;
        }else
        {
        cell.needNum.text = [NSString stringWithFormat:@"剩余 %d",(int)([info.need_people intValue]- [info.now_people intValue])];
        }
    }
    cell.seeButton.tag = indexPath.row;
    [cell.seeButton addTarget:self action:@selector(clickSeeNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SelfDuoBaoRecordInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    if ([info.need_people isEqualToString:@"0"]||[info.need_people intValue]- [info.now_people intValue]<0||[info.good_name containsString:@"0元购"]) {
        SafariViewController *vc =[[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
        vc.title = @"广告详情";
        vc.urlStr =@"https://m.qmgoubao.com/0yuangou/0yuangou.html";
        
        [self.navigationController pushViewController:vc animated:YES];
         
        
    }else
    {
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    vc.goodId = info.id;
    [self.navigationController pushViewController:vc animated:YES];
}
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
