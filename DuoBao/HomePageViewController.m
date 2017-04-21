//
//  HomePageViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "HomePageViewController.h"
#import "BannerTableViewCell.h"
#import <objc/runtime.h>
#import "SafariViewController.h"
#import "SearchGoodsViewController.h"
#import "HomePageIconTableViewCell.h"
#import "HomePageJXListTableViewCell.h"
#import "GoodsViewTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import "ClassifyViewController.h"
#import "GoodsListViewController.h"
#import "ShaiDanViewController.h"
#import "SafariViewController.h"
#import "BannerInfo.h"
#import "radioInfo.h"
#import "JieXiaoInfo.h"
#import "GoodsListInfo.h"
#import "GoodsTypeInfo.h"
#import "YaoqingViewController.h"
#import "TaskViewController.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "NewRegist.h"
#import "ZhaomuTudiViewController.h"
#import "XingfuViewController.h"
#import "KeTangViewController.h"
#import "ShouChongViewController.h"
#import "CZViewController.h"
#import "ArticleDetailViewController.h"

#import "BeatViewController.h"
#import "GoodsListCollectionViewCell.h"
#import "Comment.h"
#import "ProductDetailViewController.h"
#import "requestTool.h"

@interface HomePageViewController ()<UINavigationControllerDelegate,UISearchBarDelegate,GoodsViewTableViewCellDelegate,HomePageJXListTableViewCellDelegate,AccountBindingDelegate>
{
    UIControl *rqControl;
    UIControl *zxControl;
    UIControl *jdControl;
    UIControl *zxrcControl;
    
    UILabel *rqLine;
    UILabel *zxLine;
    UILabel *jdLine;
    UILabel *zxrcLine;
    
    UILabel *zxLabel;
    UILabel *zxscLabel;
    UILabel *jdLabel;
    UILabel *rqLabel;
    
    UIImageView *jdImage;
    UIImageView *zxrcImage;
    
    HomePageSelectOption slectType;  //选择类型。比如8人赛，4人赛
    
    int pageNum;  //获取数据参数
    
    BOOL isBannerTwo;
    
    NSMutableArray *bannerArray;
    NSMutableArray *radioArray;  //广播
    NSMutableArray *jiexiaoArray;  //揭晓
    NSMutableArray *arr1;
    NSMutableArray *namearr;     //这里面存的是招募徒弟，任务大厅，信服。。。
    NSMutableArray *imagearr;     //对应namearr的图片
    NSMutableArray *idarr;
    NSMutableArray *remarkarr;
    GoodsTypeInfo *typeInfo;
    
    NSMutableArray *goodsDataSourceArray;
    
    NSTimer *timer;
    
    BOOL isClickButton;
    NSString *changeNum;
    GoodsListCollectionViewCell *goodscell;
}

@end

@implementation HomePageViewController

- (void)dealloc
{
    if (timer) {
        //关闭定时器
        [timer invalidate];
        timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachableNetworkStatusChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateHomePageData object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameter];
    [self setTabelViewRefresh];
    [self registerNotif];
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changing:) name:@"tongzhishuaxin" object:nil];
    goodscell.ABdelegate = self;
    static NSString *st = @"8";
    changeNum = st;
}
-(void)changing:(NSNotification *)shuaxin
{
    //购物车
    [self httpGetShopCartList];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self httpGetShopCartList];
    [self httpShowData];
    //改动，新增
    [self httpShowHotProduct];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initParameter
{
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    _searchButton.layer.masksToBounds =YES;
    _searchButton.layer.cornerRadius = 5;
    [_searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    pageNum = 1;
    slectType = SelectOption_RQ;
    
    bannerArray = [NSMutableArray array];
    radioArray = [NSMutableArray array];
    jiexiaoArray = [NSMutableArray array];
    goodsDataSourceArray= [NSMutableArray array];
    namearr=[NSMutableArray array];
    imagearr=[NSMutableArray array];
    idarr=[NSMutableArray array];
    remarkarr=[NSMutableArray array];
    arr1=[NSMutableArray array];
    
}

- (void)updateSelectStatue
{
    rqLine.hidden = YES;
    zxLine.hidden = YES;
    jdLine.hidden = YES;
    zxrcLine.hidden = YES;
    zxLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    zxscLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    jdLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    rqLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    
    switch (slectType) {
        case SelectOption_RQ:
        {
            rqLine.hidden = NO;
            rqLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
        }
            break;
        case SelectOption_ZX1:
        {
            zxLine.hidden = NO;
            zxLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
        }
            break;
        case SelectOption_JD:
        {
            jdLine.hidden = NO;
            jdLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
        }
            break;
        case SelectOption_DuplicateJD:
        {
            jdLine.hidden = NO;
            jdLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
        }
            break;
        case SelectOption_ZXRC:
        {
            zxrcLine.hidden = NO;
            zxscLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
        }
            break;
        case SelectOption_DuplicateZXRC:
        {
            zxrcLine.hidden = NO;
            zxscLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
        }
            break;
            
        default:
            break;
    }
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
                                            selector:@selector(updateHomePageData)
                                                name:kUpdateHomePageData
                                              object:nil];
}

//网络状态捕捉
- (void)checkNetworkStatus:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    if(userInfo)
    {
        //是否屏蔽支付接口
        [Tool httpGetIsShowThridView];
        [_myTableView.mj_header beginRefreshing];
    }
}

- (void)updateHomePageData
{
    NSLog(@"updateHomePageData");
    //是否屏蔽支付接口
    [Tool httpGetIsShowThridView];
    [self httpShowData];
    pageNum = 1;
    [self httpGetGoodsList:@"0"];
    
    [self httpShowHotProduct];
}

#pragma mark - Action

- (IBAction)clickSearchButtonAction:(id)sender
{
    SearchGoodsViewController *vc = [[SearchGoodsViewController alloc]initWithNibName:@"SearchGoodsViewController" bundle:nil];
    vc.tp =1;
    // 改动跳搜索界面 。 隐藏。删除了XIB的图片
//    [self.navigationController pushViewController:vc animated:YES];
}

//响应单击方法－跳转广告页面
- (void)tapBanner:(UITapGestureRecognizer *) tap
{
    BannerTableViewCell *cell = objc_getAssociatedObject(tap, "cell");
    if (cell.pageController.currentPage >= bannerArray.count ) {
        return;
    }
    BannerInfo *info = [bannerArray objectAtIndex:cell.pageController.currentPage];

   // NSLog(@"%@",info.goodInformation);
    if([info.is_jump isEqualToString:@"y"])
    {
        
        if (info.goodInformation!=nil) {
            GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
            
            vc.goodId = info.goodInformation.id;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            SafariViewController *vc =[[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = @"广告详情";
            vc.urlStr = info.url;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)clickRQButtonAction:(id)sender
{
    NSLog(@"8-clickRQButtonAction");
    changeNum = @"8";
    isClickButton = YES;
    slectType = SelectOption_RQ;
    [self updateSelectStatue];
    pageNum = 1;
    [self httpGetGoodsList:changeNum];
}
- (void)clickZXButtonAction:(id)sender
{
    NSLog(@"4-clickRQButtonAction");
    changeNum = @"4";
    isClickButton = YES;
    slectType = SelectOption_ZX1;
    [self updateSelectStatue];
    pageNum = 1;
    [self httpGetGoodsList:changeNum];
}
- (void)clickJDButtonAction:(id)sender
{
    NSLog(@"2-clickRQButtonAction");
    changeNum = @"2";
    isClickButton = YES;
    if (slectType == SelectOption_JD) {
        slectType = SelectOption_DuplicateJD;
    }else{
        slectType = SelectOption_JD;
    }
    [self updateSelectStatue];
    pageNum = 1;
    [self httpGetGoodsList:changeNum];
}
- (void)clickZXRCButtonAction:(id)sender
{
    NSLog(@"1-clickRQButtonAction");
    isClickButton = YES;
    if (slectType == SelectOption_ZXRC) {
        slectType = SelectOption_DuplicateZXRC;
    }else{
        slectType = SelectOption_ZXRC;
    }
    
    [self updateSelectStatue];
    pageNum = 1;
    [self httpGetGoodsList:@"0"];
}

- (void)clickIconButtonAction:(id)sender
{
    UIControl *control = (UIControl *)sender;
    switch (control.tag) {
        case 100:
        {
            [self judgego:@"0"];
            
        }
            break;
        case 200:
        {
            [self judgego:@"1"];
            
        }
            break;
        case 300:
        {
            [self judgego:@"2"];
        }
            break;
            
        default:
        {
            [self judgego:@"3"];
            
        }
            break;
    }
}

-(void)judgego:(NSString*)num
{
    
    if ([[idarr objectAtIndex:[num intValue]]intValue] >100000)
    {
        GoodsListViewController *vc = [[GoodsListViewController alloc]initWithNibName:@"GoodsListViewController" bundle:nil];
        vc.typeId = [idarr objectAtIndex:[num intValue]];
        vc.typ=3;
        vc.typeName = [namearr objectAtIndex:[num intValue]];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    else if ([[remarkarr objectAtIndex:[num intValue]] containsString:@"http:"])
    {
        
        SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
        vc.urlStr = [remarkarr objectAtIndex:[num intValue]];
       // NSLog(@"%@",[remarkarr objectAtIndex:[num intValue]]);
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    else{
        if([[namearr objectAtIndex:[num intValue]] containsString:@"任务大厅"] )
        {
            TaskViewController *vc = [[TaskViewController alloc]initWithNibName:@"TaskViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else if ([[namearr objectAtIndex:[num intValue]] containsString:@"晒单"])
        {
            
            ShaiDanViewController *vc = [[ShaiDanViewController alloc]initWithNibName:@"ShaiDanViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([[namearr objectAtIndex:[num intValue]] containsString:@"分类"])
        {
            //ClassifyViewController *vc = [[ClassifyViewController alloc]initWithNibName:@"ClassifyViewController" bundle:nil];
            //改动 注释 分类浏览  删除了XIB的图标
            //[self.navigationController pushViewController:vc animated:YES];
            
        }
        else if ([[namearr objectAtIndex:[num intValue]] containsString:@"招募徒弟"])
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([[namearr objectAtIndex:[num intValue]] containsString:@"走势"])
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            SearchGoodsViewController *vc = [[SearchGoodsViewController alloc]initWithNibName:@"SearchGoodsViewController" bundle:nil];
            vc.tp=2;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else if ([[namearr objectAtIndex:[num intValue]] containsString:@"信服"])
        {
            XingfuViewController *vc = [[XingfuViewController alloc]initWithNibName:@"XingfuViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[namearr objectAtIndex:[num intValue]] containsString:@"购宝小课堂"])
        {
            KeTangViewController*ke = [[KeTangViewController alloc]initWithNibName:@"KeTangViewController" bundle:nil];
            [self.navigationController pushViewController:ke animated:YES];
        }
        else if ([[namearr objectAtIndex:[num intValue]] containsString:@"首冲"])
        {
            ShouChongViewController *vc = [[ShouChongViewController alloc]initWithNibName:@"ShouChongViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([[namearr objectAtIndex:[num intValue]] containsString:@"充值"])
        {
            CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

// 改动 将更多的跳转功能注释
- (void)clickMoreButtonAction:(id)sender
{
//    [self.menuViewController.tabBar setSelectedIndex:1];
}

#pragma mark - http

- (void)httpShowData
{
    //获取首页数据
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak HomePageViewController *weakSelf = self;
    [helper getHttpWithUrlStr:URL_GetHomePageData
                      success:^(NSDictionary *resultDic){
                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                              [weakSelf handleloadResult:resultDic];
                          }
                      }fail:^(NSString *decretion){
                          [Tool showPromptContent:@"网络出错了" onView:self.view];
                      }];
}
//新增
- (void)httpShowHotProduct
{
    //获取热门商品数据
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak HomePageViewController *weakSelf = self;
    [helper getHttpWithUrlStr:URL_GetHotProduct
                      success:^(NSDictionary *resultDic){
                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                              [weakSelf handle:resultDic];
                          }
                      }fail:^(NSString *decretion){
                          [Tool showPromptContent:@"网络出错了" onView:self.view];
                      }];
}
- (void)handle:(NSDictionary *)dic
{
    NSArray *ary = [dic objectForKey:@"data"];
    
    if (ary && ary.count > 0) {
        if (jiexiaoArray.count > 0) {
            [jiexiaoArray removeAllObjects];
        }
        for (NSDictionary *dic in ary)
        {
            JieXiaoInfo *info = [dic objectByClass:[JieXiaoInfo class]];
            [jiexiaoArray addObject:info];
        }
    }
}


- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    
    //广告
    NSArray *array = [dic objectForKey:@"advertisementList"];
    if (array && array.count > 0) {
        if (bannerArray.count > 0) {
            [bannerArray removeAllObjects];
        }
        for (NSDictionary *dic in array)
        {
            BannerInfo *info = [dic objectByClass:[BannerInfo class]];
            [bannerArray addObject:info];
        }
        
        if (bannerArray.count == 2) {
            isBannerTwo = YES;
            [bannerArray addObject:[bannerArray objectAtIndex:0]];
            [bannerArray addObject:[bannerArray objectAtIndex:1]];
        }
    }
    //广播
    NSArray *array1 = [dic objectForKey:@"radiolist"];
    if (array1 && array1.count > 0) {
        if (radioArray.count > 0) {
            [radioArray removeAllObjects];
        }
        for (NSDictionary *dic in array1)
        {
            
            RadioInfo *info = [dic objectByClass:[RadioInfo class]];
            
            [radioArray addObject:info];
            
        }
    }
    
    NSArray *array3 = [dic objectForKey:@"goodsTypeList"];
    if (array3 && array3.count > 0) {
        for (NSDictionary *Dic in array3)
        {
            typeInfo = [Dic objectByClass:[GoodsTypeInfo class]];
            
            [namearr addObject:typeInfo.goods_type_name];
            [imagearr addObject:typeInfo.goods_type_header];
            if (typeInfo.remark!=NULL) {
                [remarkarr addObject:typeInfo.remark];
            }
            if (typeInfo.id!=NULL) {
                [idarr addObject:typeInfo.id];
            }
        }
    }
   
    [_myTableView reloadData];
}

- (void)httpGetGoodsList:(NSString *)changenum
{
    NSString *typeStr = nil;
    NSString *descStr = nil;
    /*
     * order_by_name: 排序字段名称[now_people(人气),create_time(最新),progress(进度),need_people(总需人次)
     * order_by_rule: 排序规则[desc,asc]
     */
    switch (slectType) {
        case SelectOption_RQ:
        {
            typeStr = @"now_people";
            descStr = @"desc";
        }
            break;
        case SelectOption_ZX1:
        {
            typeStr = @"create_time";
            descStr = @"desc";
        }
            break;
        case SelectOption_JD:
        {
            typeStr = @"progress";
            descStr = @"desc";
        }
            break;
        case SelectOption_DuplicateJD:
        {
            typeStr = @"progress";
            descStr = @"asc";
        }
            break;
        case SelectOption_ZXRC:
        {
            typeStr = @"need_people";
            descStr = @"desc";
            
        }
            break;
        case SelectOption_DuplicateZXRC:
        {
            typeStr = @"need_people";
            descStr = @"asc";
        }
            break;
            
        default:
            break;
    }
    //标记，获取首页商品数据
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak HomePageViewController *weakSelf = self;
    [helper getGoodsListWithpageNum:[NSString
                                     stringWithFormat:@"%d",pageNum]
                                     limitNum:@"10"
                                     number:changeNum
                                  success:^(NSDictionary *resultDic){
                        
                                      [self hideRefresh];
                                      if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                          [weakSelf handleGetGoodsListLoadResult:resultDic and:changeNum];
                                      }
                                  }fail:^(NSString *decretion){
                                      [self hideRefresh];
                                      [Tool showPromptContent:decretion onView:self.view];
                                  }];
}
- (void)handleGetGoodsListLoadResult:(NSDictionary *)resultDic and:(NSString *)changenum
{
    if (goodsDataSourceArray.count > 0 && pageNum == 1) {
        [goodsDataSourceArray removeAllObjects];
    }
    //改动  数据获取重点
    NSArray *resourceArray = [resultDic objectForKey:@"data"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSMutableDictionary *dic in resourceArray)
        {
            GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
            info.totalNum = changenum;
            [goodsDataSourceArray addObject:info];
        }
        if (resourceArray.count < 10) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        pageNum++;
    }
     [_myTableView reloadData];
    if (isClickButton) {
        isClickButton = NO;
    }
}

- (void)httpAddGoodsToShopCartWithGoodsID:(NSString *)goodIds buyNum:(NSString *)buyNum
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak HomePageViewController *weakSelf = self;
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

- (void)handleTimer
{
            [self httpShowData];
            //改动
            [self httpShowHotProduct];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        if (jiexiaoArray.count < 1) {
            return 0;
        }else{
            return 1;
        }
    }
    return 1;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return FullScreen.size.width*0.45;
            break;
        case 1:
            return 134;
            break;
        case 2:
        {
            //只创建一个cell用作测量高度
            static HomePageJXListTableViewCell *cell = nil;
            if (!cell)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageJXListTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                [cell initImageCollectView];
                cell.collectView.delegate = cell;
                cell.collectView.dataSource = cell;
            }
            
            [self loadCellContent:cell indexPath:indexPath];
            return [self getCellHeight:cell];
        }
            break;
        default:
        {
            //只创建一个cell用作测量高度
            static GoodsViewTableViewCell *cell = nil;
            if (!cell)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsViewTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                [cell initImageCollectView];
                cell.collectView.delegate = cell;
                cell.collectView.dataSource = cell;
            }
            [self loadGoodsCellContent:cell indexPath:indexPath];
            return [self getGoodsCellHeight:cell];
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section > 2)
    {
        return 40;
        
    }else{
        
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section < 3) {
        
        return nil;
    }
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 40);
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 39, FullScreen.size.width, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    [bgView addSubview:lineview];
    
    //人气
    rqControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, FullScreen.size.width/4, frame.size.height)];
    [rqControl addTarget:self action:@selector(clickRQButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rqLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    rqLabel.text = @"8人赛";
    rqLabel.center = rqControl.center;
    rqLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    rqLabel.textAlignment = NSTextAlignmentCenter;
    rqLabel.font = [UIFont systemFontOfSize:12];
    [rqControl addSubview:rqLabel];
    rqLine = [[UILabel alloc]initWithFrame:CGRectMake(8, rqControl.height-3, rqControl.width-16, 3)];
    rqLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    [rqControl addSubview:rqLine];
    [bgView addSubview:rqControl];
    
    //最新
    zxControl = [[UIControl alloc]initWithFrame:CGRectMake(FullScreen.size.width/4, 0, FullScreen.size.width/4, frame.size.height)];
    [zxControl addTarget:self action:@selector(clickZXButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    zxLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    zxLabel.text = @"4人赛";
    zxLabel.center = CGPointMake(zxControl.width/2, zxControl.height/2);
    zxLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    zxLabel.textAlignment = NSTextAlignmentCenter;
    zxLabel.font = [UIFont systemFontOfSize:12];
    [zxControl addSubview:zxLabel];
    zxLine = [[UILabel alloc]initWithFrame:CGRectMake(8, rqControl.height-3, rqControl.width-16, 3)];
    zxLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    [zxControl addSubview:zxLine];
    [bgView addSubview:zxControl];
    
    //进度
    jdControl = [[UIControl alloc]initWithFrame:CGRectMake(FullScreen.size.width/4*2, 0, FullScreen.size.width/4, frame.size.height)];
    [jdControl addTarget:self action:@selector(clickJDButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    jdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    jdLabel.text = @"2人赛";
    jdLabel.center = CGPointMake(jdControl.width/2-2, jdControl.height/2);
    jdLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    jdLabel.textAlignment = NSTextAlignmentCenter;
    jdLabel.font = [UIFont systemFontOfSize:12];
    [jdControl addSubview:jdLabel];
    
    jdLine = [[UILabel alloc]initWithFrame:CGRectMake(8, rqControl.height-3, rqControl.width-16, 3)];
    jdLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    [jdControl addSubview:jdLine];
    [bgView addSubview:jdControl];
    
    //总需人次
    zxrcControl = [[UIControl alloc]initWithFrame:CGRectMake(FullScreen.size.width/4*3, 0, FullScreen.size.width/4, frame.size.height)];
    [zxrcControl addTarget:self action:@selector(clickZXRCButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    zxscLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    zxscLabel.text = @"排位赛";
    zxscLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    zxscLabel.center = CGPointMake(zxrcControl.width/2-5, zxrcControl.height/2);
    zxscLabel.textAlignment = NSTextAlignmentCenter;
    zxscLabel.font = [UIFont systemFontOfSize:12];
    [zxrcControl addSubview:zxscLabel];
    
    zxrcLine = [[UILabel alloc]initWithFrame:CGRectMake(8, rqControl.height-3, rqControl.width-16, 3)];
    zxrcLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    [zxrcControl addSubview:zxrcLine];
    [bgView addSubview:zxrcControl];
    
    [self updateSelectStatue];
    
    return bgView;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            BannerTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"BannerTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BannerTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                
                cell.bannerView.delegate = self;
                cell.bannerView.dataSource = self;
                cell.bannerView.autoScrollAble = YES;
                cell.bannerView.tag = 100;
                cell.bannerView.direction = CycleDirectionLandscape;
                objc_setAssociatedObject(cell.bannerView, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner:)];
                tap.numberOfTapsRequired = 1;
                objc_setAssociatedObject(tap, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
                [cell.bannerView addGestureRecognizer:tap];
            }
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.bannerView reloadData];
            return cell;
            
        }
            break;
        case 1:
        {
            HomePageIconTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageIconTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageIconTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                
                cell.bannerView.delegate = self;
                cell.bannerView.dataSource = self;
                cell.bannerView.autoScrollAble = YES;
                cell.bannerView.tag = 200;
                cell.bannerView.direction = CycleDirectionPortait;
                objc_setAssociatedObject(cell.bannerView, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
                
            }
            if (typeInfo) {
                cell.iconWidth.constant = (FullScreen.size.width -24-24)/4;
                
                cell.flControl.tag = 100;
                cell.typeicon1.layer.masksToBounds =YES;
                cell.typeicon1.layer.cornerRadius = cell.typeicon1.frame.size.height/2;
                [cell.typeicon1 sd_setImageWithURL:[NSURL URLWithString:[imagearr objectAtIndex:0]] placeholderImage:PublicImage(@"icon01")];
                cell.typename1.text = @"快速充值";
                //NSLog(@"%@",[namearr objectAtIndex:0]);
                [cell.flControl addTarget:self action:@selector(clickIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.syControl.tag = 200;
                [cell.syControl addTarget:self action:@selector(clickIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.typeIcon.layer.masksToBounds =YES;
                cell.typeIcon.layer.cornerRadius = cell.typeIcon.frame.size.height/2;
                
                [cell.typeIcon sd_setImageWithURL:[NSURL URLWithString:[imagearr objectAtIndex:1]] placeholderImage:PublicImage(@"icon02")];
                cell.typeName.text = @"分享有礼";
                
                cell.sdControl.tag = 300;
                
                cell.typeicon3.layer.masksToBounds =YES;
                cell.typeicon3.layer.cornerRadius = cell.typeicon3.frame.size.height/2;
                
                [cell.typeicon3 sd_setImageWithURL:[NSURL URLWithString:[imagearr objectAtIndex:2]] placeholderImage:PublicImage(@"icon03")];
                cell.typename3.text = @"我要赚钱";
                [cell.sdControl addTarget:self action:@selector(clickIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.cjwtControl.tag = 400;
                cell.typeicon4.layer.masksToBounds =YES;
                cell.typeicon4.layer.cornerRadius = cell.typeicon4.frame.size.height/2;
                [cell.typeicon4 sd_setImageWithURL:[NSURL URLWithString:[imagearr objectAtIndex:3]] placeholderImage:PublicImage(@"icon04")];
                [cell.cjwtControl addTarget:self action:@selector(clickIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.typename4.text = @"玩法说明";
                //设点点击选择的颜色(无)
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.bannerView reloadData];
            }
            
            return cell;
        }
            break;
        case 2:
        {
            HomePageJXListTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageJXListTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageJXListTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                
                [cell initImageCollectView];
                cell.delegate = self;
                cell.collectView.delegate = cell;
                cell.collectView.dataSource = cell;
                
            }
            [cell.moreButton addTarget:self action:@selector(clickMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self loadCellContent:cell indexPath:indexPath];
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
        {
            GoodsViewTableViewCell*cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsViewTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsViewTableViewCell" owner:nil options:nil];
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
            break;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)loadCellContent:(HomePageJXListTableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    cell.dataSourceArray = jiexiaoArray;
    [cell.collectView reloadData];
}

- (CGFloat)getCellHeight:(HomePageJXListTableViewCell*)cell
{
    [cell layoutIfNeeded];
    [cell updateConstraintsIfNeeded];
    CGFloat height = cell.collectView.contentSize.height;
    return height+53;
}

- (void)loadGoodsCellContent:(GoodsViewTableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    cell.dataSourceArray = goodsDataSourceArray;
    [cell updateConstraintsIfNeeded];
    [cell.collectView reloadData];
}

- (CGFloat)getGoodsCellHeight:(GoodsViewTableViewCell*)cell
{
    [cell layoutIfNeeded];
    [cell updateConstraintsIfNeeded];
    CGFloat height = cell.collectView.contentSize.height;
    return height;
}

#pragma mark - tableview 上下拉刷新
- (void)setTabelViewRefresh
{
    if (isClickButton == false ) {
        __unsafe_unretained UITableView *tableView = self.myTableView;
        __unsafe_unretained __typeof(self) weakSelf = self;
        // 下拉刷新
        tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //NSLog(@"setTabelViewRefresh");
            pageNum = 1;
            [weakSelf httpShowData];
            //改动
            [weakSelf httpShowHotProduct];
            [weakSelf httpGetGoodsList:@"0"];
        }];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.automaticallyChangeAlpha = YES;
        [tableView.mj_header beginRefreshing];
        // 上拉刷新
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //NSLog(@"setTabelViewRefresh");
            [weakSelf httpGetGoodsList:@"0"];
        }];
        tableView.mj_footer.automaticallyHidden = YES;
    }
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

#pragma mark - CycleScrollViewDataSource

- (UIView *)cycleScrollView:(CycleScrollView *)cycleScrollView viewAtPage:(NSInteger)page
{
    if (cycleScrollView.tag == 100) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = YES;
        BannerInfo *bannerInfo = [bannerArray objectAtIndex:page];
        NSString *url = [NSString stringWithFormat:@"%@",bannerInfo.header];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        return imageView;
    }else{
        UILabel *warnLabel = [[UILabel alloc] init];
        RadioInfo *info = [radioArray objectAtIndex:page];
        
        NSString * reviewStr = [NSString stringWithFormat:@"恭喜<color1>“%@”</color1>获取第%@期，%@",info.nick_name,info.good_period,info.good_name];
        
        warnLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
        
        NSDictionary* style = @{@"body":[UIFont systemFontOfSize:13],
                                @"color1":[UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:128.0/255.0 alpha:1]};
        
        warnLabel.attributedText = [reviewStr attributedStringWithStyleBook:style];
        
        warnLabel.font = [UIFont systemFontOfSize:13];
        return warnLabel;
        
    }
}

- (NSInteger)numberOfViewsInCycleScrollView:(CycleScrollView *)cycleScrollView
{
    if (cycleScrollView.tag == 100) {
        BannerTableViewCell *cell = objc_getAssociatedObject(cycleScrollView, "cell");
        if (isBannerTwo) {
            cell.pageController.numberOfPages = 2;
        }else{
            cell.pageController.numberOfPages = bannerArray.count;
        }
        return  bannerArray.count;
    }else{
        return radioArray.count;
    }
}

- (void)cycleScrollView:(CycleScrollView *)cycleScrollView didScrollView:(int)index
{
    if (cycleScrollView.tag == 100) {
        
        BannerTableViewCell *cell = objc_getAssociatedObject(cycleScrollView, "cell");
        if (isBannerTwo)
        {
            cell.pageController.currentPage = index%2;
            
        }else{
            cell.pageController.currentPage = index;
        }
    }
}

- (CGRect)frameOfCycleScrollView:(CycleScrollView *)cycleScrollView
{
    if (cycleScrollView.tag == 100) {
        return CGRectMake(0, 0, FullScreen.size.width,FullScreen.size.width*0.45);
    }else{
        return CGRectMake(0, 0, FullScreen.size.width-46,20);
    }
}
#pragma mark - GoodsViewTableViewCellDelegate
- (void)selectGoodsInfo:(NSInteger)index
{
    //Model 建模
    GoodsListInfo *info = [goodsDataSourceArray objectAtIndex:index];

    //改动  跳转新商品详情页
    ProductDetailViewController *vc = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
    vc.TotalPrice = info.productPrice;
    vc.goodId = info.productId;
    vc.productId = info.productId;
    vc.goodsId = info.productId;
    vc.peopleNum = info.totalNum;
    vc.peoplePrice = info.unitCost;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -HomePageJXListTableViewCellDelegate
//新手推荐点击方法
- (void)selectJXGoodsInfo:(NSInteger)index
{
    JieXiaoInfo *info = [jiexiaoArray objectAtIndex:index];
    
    ProductDetailViewController *vc = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
    vc.goodId = info.productId;
    vc.productId = info.productId;
    vc.goodsId = info.productId;
    vc.TotalPrice = info.productPrice;
    vc.peopleNum = info.number;
    vc.peoplePrice = info.unitCost;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 协议方法
- (void)jumpWebVC:(UIButton*)sender
{
    BeatViewController *beatVC = [[BeatViewController alloc]init];
    [self presentViewController:beatVC animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isEqual:self])
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.menuViewController hidesTabBar:NO animated:NO];
        self.menuViewController.tabBarTransparent = NO;
    }
    else
    {
        if ([[viewController class] isEqual:[SearchGoodsViewController class]])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }else{
            [self.navigationController setNavigationBarHidden:NO ];
        }
        
        [self.menuViewController hidesTabBar:YES animated:YES];
        self.menuViewController.tabBarTransparent = YES;
    }
}

- (void)httpGetShopCartList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak HomePageViewController *weakSelf = self;
    [helper getShopCartListWithUserId:[ShareManager shareInstance].userinfo.id
                              success:^(NSDictionary *resultDic){
                                  [self hideRefresh];
                                  if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                      [weakSelf handleloadResult1:resultDic];
                                  }else
                                  {
                                      [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                  }
                              }fail:^(NSString *decretion){
                                  [self hideRefresh];
                                  [Tool showPromptContent:decretion onView:self.view];
                              }];
}

-(void)handleloadResult1:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"shopCartList"];
   // NSLog(@"购物车＝＝＝＝＝＝＝＝＝＝＝＝%lu",(unsigned long)resourceArray.count);
    NSInteger NumHongbao =(unsigned long)resourceArray.count;
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.shangyici=[NSString stringWithFormat:@"%ld",(long)NumHongbao];
    
}

@end
