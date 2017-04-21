//
//  GoodsListViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsListTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import "GoodsListInfo.h"
#import "ZoushiViewController.h"
@interface GoodsListViewController ()
{
    NSMutableArray *dataSourceArray;
    UIButton *rightButton;
}

@end

@implementation GoodsListViewController

-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
    [self setTabelViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    
    if (_typeName) {
        self.title = _typeName;
    }else{
        self.title = @"商品列表";
    }
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

- (void)rightItemView
{
    UIView *rightItemView;
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,100, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, rightItemView.frame.size.height)];
    [rightButton setTitle:@"全部加入清单" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0,0)];
    [rightButton addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:rightButton];
    
    rightButton.hidden = YES;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}

#pragma mark - http

- (void)httpGoodsInfoList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak GoodsListViewController *weakSelf = self;
    [helper getGoodsListOfTypeWithGoodsTypeIde:_typeId
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
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsTypeList"];
    
    if (dataSourceArray.count > 0) {
        [dataSourceArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
            [dataSourceArray addObject:info];
        }
        rightButton.hidden = NO;
    }
    else
    {
        [Tool showPromptContent:@"暂无数据" onView:self.view];
    }
    
    self.title = [NSString stringWithFormat:@"%@ (%lu)",_typeName,(unsigned long)dataSourceArray.count];
    
    [_myTableView reloadData];
    
}

- (void)httpSearchInfoList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak GoodsListViewController *weakSelf = self;
    [helper searchGoodsWithSearchKey:_typeName
                             success:^(NSDictionary *resultDic){
                                 [self hideRefresh];
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadSearchResult:resultDic];
                                 }else
                                 {
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                 }
                             }fail:^(NSString *decretion){
                                 [self hideRefresh];
                                 [Tool showPromptContent:decretion onView:self.view];
                             }];
}

- (void)handleloadSearchResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsSearchList"];
    
    if (dataSourceArray.count > 0) {
        [dataSourceArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
            [dataSourceArray addObject:info];
        }
    }
    else
    {
        [Tool showPromptContent:@"暂无数据" onView:self.view];
    }
    [_myTableView reloadData];
    
}


- (void)httpAddGoodsToShopCartWithGoodsID:(NSString *)goodIds buyNum:(NSString *)buyNum
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak GoodsListViewController *weakSelf = self;
    [helper addGoodsForShopCartWithUserId:[ShareManager shareInstance].userinfo.id
                                goods_ids:goodIds
                           goods_buy_nums:buyNum
                                  success:^(NSDictionary *resultDic){
                                      if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                          [weakSelf handleloadAddGoodsToShopCartResult:resultDic buyNum:buyNum];
                                      }else
                                      {
                                          [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                      }
                                  }fail:^(NSString *decretion){
                                      [Tool showPromptContent:@"网络出错了" onView:self.view];
                                  }];
}

- (void)handleloadAddGoodsToShopCartResult:(NSDictionary *)resultDic buyNum:(NSString *)buyNum
{
    [Tool getUserInfo];
    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
    
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
    return 102;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.processView.layer.masksToBounds =YES;
    cell.processView.layer.cornerRadius = cell.processView.frame.size.height/2;
    
    GoodsListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    //改动
    cell.titleLabel.text = info.productName;
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.thumbnailUrl] placeholderImage:PublicImage(@"defaultImage")];
    cell.titleLabel.text = info.productName;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GoodsListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
   
    if (_typ==1) {
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        
        vc.goodId = info.id;
      
        [self.navigationController pushViewController:vc animated:YES];
    
    }
   else if (_typ==2) {
        
        ZoushiViewController *zo = [[ZoushiViewController alloc]initWithNibName:@"ZoushiViewController" bundle:nil];
       // zo.product.text=info.good_name;
        zo.goodid=info.id;
        zo.goodId=info.good_id;
        [self.navigationController pushViewController:zo animated:YES];
    }
   else if (_typ==3) {
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        
        vc.goodId = info.id;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
   else
   {
       GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
       
       vc.goodId = info.id;
       
       [self.navigationController pushViewController:vc animated:YES];
   }
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isSearch) {
            [weakSelf httpSearchInfoList];
        }else{
            [weakSelf httpGoodsInfoList];
        }
        
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

@end
