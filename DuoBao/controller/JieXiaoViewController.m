//
//  JieXiaoViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "JieXiaoViewController.h"
#import "JieXiaoListCollectionViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import "GoodsDetailInfo.h"

@interface JieXiaoViewController ()<UINavigationControllerDelegate>
{
    int pageNum;
    NSMutableArray *dataSourceArray;
    
    NSTimer *timer;
    NSMutableArray *totalTimeArray;
}

@end

@implementation JieXiaoViewController

- (void)dealloc
{
    if (timer) {
        //关闭定时器
        [timer invalidate];
        timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachableNetworkStatusChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateJieXiaoData object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameter];
    [self setTabelViewRefresh];
    [self registerNotif];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initParameter
{
    self.title = @"最新揭晓";
    self.navigationController.delegate = self;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [_myCollectView registerClass:[JieXiaoListCollectionViewCell class] forCellWithReuseIdentifier:@"JieXiaoListCollectionViewCell"];
    
    pageNum = 1;
    dataSourceArray = [NSMutableArray array];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateJieXiaoData:)
                                                 name:kUpdateJieXiaoData
                                               object:nil];
    
}

//网络状态捕捉
- (void)checkNetworkStatus:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    if(userInfo)
    {
        [_myCollectView.mj_header beginRefreshing];
    }
}

- (void)updateJieXiaoData:(NSNotification *)notif
{
    pageNum = 1;
    [self httpGetSourceData];
}

#pragma mark - http

- (void)httpGetSourceData
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak JieXiaoViewController *weakSelf = self;
    [helper getZXJXWithPageNum:[NSString stringWithFormat:@"%d",pageNum]
                      limitNum:@"14"
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
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"willKnowFightList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            GoodsDetailInfo *info = [dic objectByClass:[GoodsDetailInfo class]];
            [dataSourceArray addObject:info];
        }
        
        if (resourceArray.count < 14) {
            [_myCollectView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myCollectView.mj_footer resetNoMoreData];
        }
        [self startCountDown];
        pageNum++;
    }else{
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
        }
    }
    [_myCollectView reloadData];
}

#pragma mark - 倒计时

//倒计时
- (void)startCountDown
{
    if (timer) {
        [timer setFireDate:[NSDate distantFuture]];
    }
    
    if (totalTimeArray.count > 0 && totalTimeArray) {
        [totalTimeArray removeAllObjects];
        for (int i = 0; i < dataSourceArray.count; i++) {
            [totalTimeArray addObject:@"n"];
        }
    }else{
        if (!totalTimeArray) {
            totalTimeArray = [NSMutableArray array];
            for (int i = 0; i < dataSourceArray.count; i++) {
                [totalTimeArray addObject:@"n"];
            }
        }
    }
    BOOL isShow = NO;
    for (int i = 0; i < dataSourceArray.count; i++) {
        GoodsDetailInfo *info = [dataSourceArray objectAtIndex:i];
        if ([info.status isEqualToString:@"倒计时"] && [info.is_show_daojishi isEqualToString:@"y"])
        {
            [totalTimeArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%lld",[info.daojishi_time longLongValue]]];
            isShow = YES;
        }
    }
    
    if (isShow) {
        if (timer) {
            [timer setFireDate:[NSDate distantPast]];
        }
        [self handleTimer];
    }
}

- (void)handleTimer
{
    if (!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                 target:self
                                               selector:@selector(handleTimer)
                                               userInfo:nil
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    }
    
    for (int i = 0; i < totalTimeArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        JieXiaoListCollectionViewCell *cell = (JieXiaoListCollectionViewCell *)[_myCollectView cellForItemAtIndexPath:indexPath];
        
        NSString *timeStr = [totalTimeArray objectAtIndex:i];
        if ([timeStr isEqualToString:@"n"]) {
            continue;
        }
        long long timeValue = [timeStr longLongValue];
        timeValue = timeValue-10;
        if (timeValue < 0) {
            timeValue = 0;
            if (timer) {
                [timer setFireDate:[NSDate distantFuture]];
            }
            [self updateCellUI:cell timerStr:@"0"];
            [totalTimeArray replaceObjectAtIndex:i withObject:@"0"];
            [_myCollectView.mj_header beginRefreshing];
            break;
        }else{
            [self updateCellUI:cell timerStr:[NSString stringWithFormat:@"%lld",timeValue]];
            [totalTimeArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%lld",timeValue]];
        }
    }
}

- (void)updateCellUI:(JieXiaoListCollectionViewCell *)cell timerStr:(NSString *)timeStr
{
    long long timeValue = [timeStr longLongValue]/1000;
    NSUInteger min  = (timeValue%(3600))/60;
    NSUInteger second = (NSUInteger)(timeValue%60);
    NSUInteger hsecond = (NSUInteger)([timeStr longLongValue]%1000)/10;
    
    if (min>9) {
        cell.hourLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)min];
    }else{
        cell.hourLabel.text = [NSString stringWithFormat:@"0%lu",(unsigned long)min];
    }
    
    if (second>9) {
        cell.minuteLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)second];
    }else{
        cell.minuteLabel.text = [NSString stringWithFormat:@"0%lu",(unsigned long)second];
    }
    
    if (hsecond>9) {
        cell.secondsLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)hsecond];
    }else{
        cell.secondsLabel.text = [NSString stringWithFormat:@"0%lu",(unsigned long)hsecond];
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JieXiaoListCollectionViewCell *cell = (JieXiaoListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"JieXiaoListCollectionViewCell" forIndexPath:indexPath];
    
    GoodsDetailInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.good_header] placeholderImage:PublicImage(@"defaultImage")];
    cell.goodsNameLabel.text = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
    
    if([info.status isEqualToString:@"已揭晓"])
    {
        cell.djsView.hidden = YES;
        cell.warnView.hidden = YES;
        cell.userName.text = info.nick_name;
        cell.luckNumLabel.text = info.win_num;
        cell.joinNumLabel.text = [NSString stringWithFormat:@"%@人次",info.play_num];
        cell.timeLabel.text = info.lottery_time;
        
    }else if([info.status isEqualToString:@"倒计时"]){
        
        if ([info.is_show_daojishi isEqualToString:@"y"])
        {
            cell.warnView.hidden = YES;
            cell.djsView.hidden = NO;
//            cell.hourLabel.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
//            cell.hourLabel.layer.borderWidth = 1.0f;
//            cell.minuteLabel.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
//            cell.minuteLabel.layer.borderWidth = 1.0f;
//            cell.secondsLabel.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
//            cell.secondsLabel.layer.borderWidth = 1.0f;
            
        }else{
            
            cell.djsView.hidden = YES;
            cell.warnView.hidden = NO;
        }
        
    }else{
        
        cell.djsView.hidden = YES;
        cell.warnView.hidden = NO;
    }
    
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (collectionView.frame.size.width)/2, 238);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    vc.goodId = info.id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UICollectionView *collectView = self.myCollectView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    collectView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetSourceData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    collectView.mj_header.automaticallyChangeAlpha = YES;
    [collectView.mj_header beginRefreshing];
    // 上拉刷新
    collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetSourceData];
        
    }];
    collectView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    
    if([_myCollectView.mj_footer isRefreshing])
    {
        [_myCollectView.mj_footer endRefreshing];
    }
    if([_myCollectView.mj_header isRefreshing])
    {
        [_myCollectView.mj_header endRefreshing];
    }
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
