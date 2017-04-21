//
//  ZengQianViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ZengQianViewController.h"
#import "ZengQianListTableViewCell.h"
#import "ArticleDetailViewController.h"
#import "ZengQianInfo.h"
#import "SearchGoodsViewController.h"
#import "XingfuViewController.h"
#import "KeTangViewController.h"
#import "CZViewController.h"
#import "ShouChongViewController.h"
#import "ShaiDanViewController.h"
#import "SafariViewController.h"
#import "WkwebViewController.h"
static NSInteger zuobiaoy;
@interface ZengQianViewController ()<UINavigationControllerDelegate>
{
    ButtonViewSelectOption selectOptionType;
    int pageNum;
    NSMutableArray *dataSourceArray;
    UIActivityIndicatorView* activityIndicator;
}

@end

@implementation ZengQianViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachableNetworkStatusChange object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameter];
    [self updateHeadButtonView];
    [self setTabelViewRefresh];
    [self registerNotif];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initParameter
{
    self.title = @"发现";
    self.navigationController.delegate = self;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.headViewWitdth.constant = FullScreen.size.width/4;
    
    selectOptionType = SelectOption_Recommend;
    pageNum = 1;
    dataSourceArray = [NSMutableArray array];
    
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(FullScreen.size.width/2-40, FullScreen.size.height/2-60, 80, 80)];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    activityIndicator.layer.masksToBounds =YES;
    activityIndicator.layer.cornerRadius = 10;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//    activityIndicator.hidden = YES;
    [self.view addSubview:activityIndicator];
    _webView.scrollView.bounces = NO;
}



#pragma mark Action

- (IBAction)clickRecommedButtonAction:(id)sender
{
    selectOptionType = SelectOption_Recommend;
    [self updateHeadButtonView];
    
}
- (IBAction)clickZXButtonAction:(id)sender
{
    selectOptionType = SelectOption_ZX;
    [self updateHeadButtonView];
}
- (IBAction)clickHotButtonAction:(id)sender
{
    selectOptionType = SelectOption_Hot;
    [self updateHeadButtonView];
}
- (IBAction)clickHelpButtonAction:(id)sender
{
    selectOptionType = SelectOption_Help;
    [self updateHeadButtonView];
}

- (void)updateHeadButtonView
{
    [_recommendButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_zxButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_hotButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_helpButton setTitleColor:[UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    _recommendLine.hidden = YES;
    _zxLine.hidden = YES;
    _hotLine.hidden = YES;
    _helpLine.hidden = YES;
    
    _myTabelView.hidden = NO;
    _webView.hidden = YES;
    
    if (activityIndicator.isAnimating) {
        [activityIndicator stopAnimating];
    }
    
    switch (selectOptionType) {
        case SelectOption_Recommend:
        {
            
            [_recommendButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
            _recommendLine.hidden = NO;
        }
            break;
        case SelectOption_ZX:
        {
            [_zxButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
            _zxLine.hidden = NO;
        }
            break;
        case SelectOption_Hot:
        {
            [_hotButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
            _hotLine.hidden = NO;
        }
            break;
        default:
        {
            [_helpButton setTitleColor:[UIColor colorWithRed:230.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] forState:UIControlStateNormal];
            _helpLine.hidden = NO;
            
            NSString *url = [NSString stringWithFormat:@"%@%@",URL_Server,Wap_HelpUrl];
            url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            NSLog(@"url == %@",request);
            [_webView loadRequest:request];
            _myTabelView.hidden = YES;
            _webView.hidden = NO;
            return;
            
        }
            break;
    }
    
    [self.myTabelView.mj_header beginRefreshing];
    
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
}

//网络状态捕捉
- (void)checkNetworkStatus:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    if(userInfo)
    {
        [_myTabelView.mj_header beginRefreshing];
    }
}

#pragma mark - http

- (void)httpGetShareList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ZengQianViewController *weakSelf = self;
    
    NSString *userId = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userId = [ShareManager shareInstance].userinfo.id;
    }
    
    [helper getShareListWithUserId:userId
                           pageTab:[NSString stringWithFormat:@"%d",selectOptionType]
                           PageNum:[NSString stringWithFormat:@"%d",pageNum]
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
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
        
    }
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"findList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            ZengQianInfo *info = [dic objectByClass:[ZengQianInfo class]];
            if ([info.isShow isEqualToString:@"y"]) {
              [dataSourceArray addObject:info];

            }
        }

        if (resourceArray.count < 20) {
            [_myTabelView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTabelView.mj_footer resetNoMoreData];
        }
       
        pageNum++;
    }else{
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
        }
    }
    [_myTabelView reloadData];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else
    {
        return 10;
    }
}



//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else{
    
    return dataSourceArray.count;
    }
}



//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZengQianListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ZengQianListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ZengQianListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    //设点点击选择的颜色(无)
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        cell.titleLabel.text = @"哈哈,我中奖啦!大家快来玩呀!";
        cell.timeLabel.text = @"晒单分享";
      //  cell.celllabel.frame = CGRectMake(cell.celllabel.frame.origin.x,cell.celllabel.frame.origin.y+5,cell.celllabel.frame.size.width, cell.celllabel.frame.size.height+10);
        
        cell.photoImage.image = [UIImage imageNamed:@"faxian_shaidan"];
    }
    if (indexPath.section==1) {
        ZengQianInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
       
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.img] placeholderImage:PublicImage(@"defaultImage")];
        cell.titleLabel.text = info.desc;
        cell.timeLabel.text = info.title;
  
            UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 30, 15)];
            imageView.image=[UIImage imageNamed:@"faxian_hot"];
        
       [cell.imageview addSubview:imageView];
            UIImageView *imageView2 =[[UIImageView alloc]initWithFrame:CGRectMake(33, 2, 30, 15)];
            imageView2.image=[UIImage imageNamed:@"faxian_new"];
        
       [cell.imageview addSubview:imageView2];

            UIImageView *imageView3 =[[UIImageView alloc]initWithFrame:CGRectMake(63, 2, 30, 15)];
            imageView3.image=[UIImage imageNamed:@"faxian_zhuangxiang"];
            [cell.imageview addSubview:imageView3];
        
        if ([info.isHot isEqualToString:@"y"]) {
            
            imageView.hidden=NO;
        
        }else
        {
            imageView.hidden=YES;
            imageView2.frame = CGRectMake(imageView2.frame.origin.x-30,imageView2.frame.origin.y,imageView2.frame.size.width, imageView2.frame.size.height);
            imageView3.frame = CGRectMake(imageView3.frame.origin.x-30,imageView3.frame.origin.y, imageView3.frame.size.width, imageView3.frame.size.height);
            
        }
        if ([info.isNew isEqualToString:@"y"]) {
           
            imageView2.hidden=NO;
        
        }else
        {
            imageView2.hidden=YES;

            imageView3.frame = CGRectMake(imageView3.frame.origin.x-30,imageView3.frame.origin.y, imageView3.frame.size.width, imageView3.frame.size.height);
            
        }
        if ([info.isZhuangxiang isEqualToString:@"y"]) {
            imageView3.hidden=NO;
        
        }else
        {
            imageView3.hidden=YES;

        }
    }
//    cell.rewardLabel.text = [NSString stringWithFormat:@"%@积分+%@积分阅读",info.share_score,info.other_read_score];
    
    return cell;
}
-(void)addViewImage:(NSString*)Name DateNumber:(NSString*)dateNumber
{
    ZengQianListTableViewCell *cell = nil;
           NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ZengQianListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    
    int m =3;
    for (int i=0; i<3; i++) {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(zuobiaoy, 2, 20, 20)];
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",m]];
        [cell.imageview addSubview:imageView];
        imageView.tag=100;
        NSLog(@"%@",Name);
        zuobiaoy+=20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     ZengQianInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    NSLog(@"%@",info.title);
    
    NSLog(@"%lu",(unsigned long)[info.url length]);
//    NSLog(@"%d",[self isStringEmpty:info.url]==true);
    if ([info.url length]==6) {
        if ([info.title containsString:@"走势"]&&indexPath.section==1) {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            SearchGoodsViewController *vc = [[SearchGoodsViewController alloc]initWithNibName:@"SearchGoodsViewController" bundle:nil];
            vc.tp=2;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if ([info.title containsString:@"信服"]&&indexPath.section==1) {
            XingfuViewController *vc = [[XingfuViewController alloc]initWithNibName:@"XingfuViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([info.title containsString:@"购宝小课堂"]&&indexPath.section==1) {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            KeTangViewController*ke = [[KeTangViewController alloc]initWithNibName:@"KeTangViewController" bundle:nil];
            [self.navigationController pushViewController:ke animated:YES];
        }
        if ([info.title containsString:@"首冲"]&&indexPath.section==1) {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            ShouChongViewController *vc = [[ShouChongViewController alloc]initWithNibName:@"ShouChongViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
    
    if ([info.url length]!=6&&indexPath.section==1) {

        if (![Tool islogin]) {
            [Tool loginWithAnimated:YES viewController:nil];
            return;
        }
        SafariViewController *vc =[[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
        vc.title=info.title;
        vc.urlStr =info.url;
        [self.navigationController pushViewController:vc animated:YES];
    
    }

   
    if (indexPath.section==0) {
        if (![Tool islogin]) {
            [Tool loginWithAnimated:YES viewController:nil];
            return;
        }
        ShaiDanViewController *vc = [[ShaiDanViewController alloc]initWithNibName:@"ShaiDanViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
    
   
}
- (BOOL ) stringIsEmpty:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    }else{
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTabelView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetShareList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetShareList];
        
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    
    if([_myTabelView.mj_footer isRefreshing])
    {
        [_myTabelView.mj_footer endRefreshing];
    }
    if([_myTabelView.mj_header isRefreshing])
    {
        [_myTabelView.mj_header endRefreshing];
    }
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    [Tool showPromptContent:@"网页加载失败" onView:self.view];
    
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([viewController isEqual:self])
    {
        [self.menuViewController hidesTabBar:NO animated:NO];
        self.menuViewController.tabBarTransparent = NO;
        
    }
    else
    {
        
        [self.menuViewController hidesTabBar:YES animated:YES];
        self.menuViewController.tabBarTransparent = YES;
        
    }
}

@end
