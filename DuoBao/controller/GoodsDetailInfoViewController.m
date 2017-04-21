//
//  GoodsDetailInfoViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "GoodsDetailInfoViewController.h"
#import "BannerTableViewCell.h"
#import "SafariViewController.h"
#import "GoodsInfoTableViewCell.h"
#import "ListTableViewCell.h"
#import "RecordTableViewCell.h"
#import "GoodsInfoJieXiaoTableViewCell.h"
#import "ShaiDanViewController.h"
#import "WQJXViewController.h"
#import "UserViewController.h"
#import "DBNumViewController.h"
#import "GoodsDetailInfo.h"
#import "DuoBaoRecordInfo.h"
#import "SelectGoodsNumViewController.h"
#import "PayViewController.h"
#import "QingDanViewController.h"
#import "UMMobClick/MobClick.h"

//改动
#import "BeatViewController.h"
#import "Comment.h"
#import "CommentTableViewCell.h"
#import "SocketInteraction.h"

@interface GoodsDetailInfoViewController ()<SelectGoodsNumViewControllerDelegate,PayViewControllerDelegate>
{
    int pageNum;
    NSMutableArray *recordDataArray;   //记录数组
    NSMutableArray *commentDataArray;   //评论数组
    GoodsDetailInfo *_goodsDetailInfo;
    NSString *duobaoBeginTime;
    NSMutableArray *myJoinNumArray;
    
    NSInteger _isJieXiao;//0 进行中 1 倒计时 2 已揭晓
    NSArray *bannerArray;
    
    NSTimer *timer;
    long long totalTime;
    NSString *versionStr;
    
    UIButton *combut;
    UIButton *regardbut;
}

@end

@implementation GoodsDetailInfoViewController


- (void)dealloc {
    if (timer) {
        //关闭定时器
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self httpGetProductDetailInfo];
    
    [self initVariable];
    [self leftNavigationItem];
    [self setTabelViewRefresh];
    
//    [self loadCommentResult];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [_myTableView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"商品详情";
    pageNum = 1;
    recordDataArray = [NSMutableArray array];
    commentDataArray = [NSMutableArray array];
    
    self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 0.01f)];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 0.01f)];
    
    _joinBotton.layer.masksToBounds =YES;
    _joinBotton.layer.cornerRadius = _joinBotton.frame.size.height/2;
    
    _addButton.layer.masksToBounds =YES;
    _addButton.layer.cornerRadius = _addButton.frame.size.height/2;
    _addButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] CGColor];
    _addButton.layer.borderWidth = 1.0f;
    
    _buttonWidth.constant = (FullScreen.size.width-80)/2;
    _isJieXiao = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![Tool islogin]) {
        
        _shopCartNumLabel.hidden = YES;
        return;
    }else{
        [self getUserInfoOfShopCartNum];
//        [self httpGetProductDetailInfo]
    }
    
}

- (void)updateGoodsNumLabel
{
    if ([ShareManager shareInstance].userinfo.shoppCartNum <= 0 || ![ShareManager shareInstance].userinfo.islogin||_st==1) {
        _shopCartNumLabel.hidden = YES;
    }
    else{
        
        _shopCartNumLabel.hidden = NO;
        _shopCartNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[ShareManager shareInstance].userinfo.shoppCartNum];
        NSLog(@"%ld",(long)[ShareManager shareInstance].userinfo.shoppCartNum);
        [Tool setFontSizeThatFits:_shopCartNumLabel];
        _shopCartNumLabel.layer.masksToBounds =YES;
        _shopCartNumLabel.layer.cornerRadius = _shopCartNumLabel.frame.size.height/2;
    }
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

#pragma mark - Http
//新增  改动
- (void)httpGetProductDetailInfo
{
    //获取商品详情
    //NSString *userIdStr = nil;
    NSString *userIdStr = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userIdStr = [ShareManager shareInstance].userinfo.id;
    }
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak GoodsDetailInfoViewController *weakSelf = self;
    [helper loadProductsDetailInfoWithId:_productId
                                   success:^(NSDictionary *resultDic){
                                       if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                           [weakSelf handleProductResult:resultDic];
                                       }else
                                       {
                                           [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                       }
                                   }fail:^(NSString *decretion){
                                       [Tool showPromptContent:@"网络出错了" onView:self.view];
                                   }];
}
- (void)handleProductResult:(NSDictionary *)dic
{
    _goodsDetailInfo = [[dic objectForKey:@"data"] objectByClass:[GoodsDetailInfo class]];
    NSLog(@"_goodsDetailInfo = %@",_goodsDetailInfo);

     bannerArray = [_goodsDetailInfo.photoUrl componentsSeparatedByString:@","];
    [_myTableView reloadData];
}
- (void)loadCommentResult
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak GoodsDetailInfoViewController *weakSelf = self;
    [helper loadCommentWithGoodsId:_goodsId
                            pageNum:@"10"
                            limitNum:[NSString stringWithFormat:@"%d",pageNum]
                            success:^(NSDictionary *resultDic){
//                                    [self hideRefresh];
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                        [weakSelf handleCommentResult:resultDic];
                                    }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                                }fail:^(NSString *decretion){
                                    [self hideRefresh];
                                    [Tool showPromptContent:decretion onView:self.view];
                                }];
}

- (void)handleCommentResult:(NSDictionary *)resultDic
{
    if (commentDataArray.count > 0) {
        [commentDataArray removeAllObjects];
    }
    //取数据
    NSLog(@"resultDic = %@",resultDic);
    
//    NSArray *ary = [resultDic objectForKey:@"data"];
//  
//    for (NSDictionary *dic in ary)
//    {
//        Comment *info = [[dic objectForKey:@"data"] objectByClass:[Comment class]];
//        [commentDataArray addObject:info];
//    }

//    NSLog(@"%@",info);
   
    
//    [commentDataArray addObject:info];
    [_myTableView reloadData];
}
//以上改动
- (void)loadDuoBaoRecord
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak GoodsDetailInfoViewController *weakSelf = self;
    [helper loadDuoBaoRecordWithGoodsId:_goodId
                                pageNum:[NSString stringWithFormat:@"%d",pageNum]
     //改动。20-10
                               limitNum:@"10"
                                success:^(NSDictionary *resultDic){
                                    [self hideRefresh];
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                        [weakSelf handleLoadRecordResult:resultDic];
                                    }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                                }fail:^(NSString *decretion){
                                    [self hideRefresh];
                                    [Tool showPromptContent:decretion onView:self.view];
                                }];
}

- (void)handleLoadRecordResult:(NSDictionary *)resultDic
{
    if (recordDataArray.count > 0 && pageNum == 1) {
        [recordDataArray removeAllObjects];
    }
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightRecordList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            DuoBaoRecordInfo *info = [dic objectByClass:[DuoBaoRecordInfo class]];
            [recordDataArray addObject:info];
        }
        if (resourceArray.count < 20) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        pageNum++;
    }else{
        if (pageNum == 1) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    [_myTableView reloadData];
}

- (void)httpAddGoodsToShopCartWithGoodsID:(NSString *)goodIds buyNum:(NSString *)buyNum
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak GoodsDetailInfoViewController *weakSelf = self;
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
    [self getUserInfoOfShopCartNum];
    
    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
}

- (void)getUserInfoOfShopCartNum
{
    __weak GoodsDetailInfoViewController *weakSelf = self;
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          success:^(NSDictionary *resultDic){
                              if ([[resultDic objectForKey:@"result_code"] integerValue] == 0)
                              {
                                  UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
                                  [ShareManager shareInstance].userinfo = info;
                                  [Tool saveUserInfoToDB:YES];
                                  [weakSelf updateGoodsNumLabel];
                              }
                          }fail:^(NSString *decretion){
                              
                          }];
}
#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickJoinButtonAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    SelectGoodsNumViewController *vc = [[SelectGoodsNumViewController alloc]initWithNibName:@"SelectGoodsNumViewController" bundle:nil];
    
    vc.limitNum = [_goodsDetailInfo.good_single_price intValue];
    vc.delegate = self;
    vc.canBuyNum =  [_goodsDetailInfo.need_people intValue]-[_goodsDetailInfo.now_people intValue];
    self.definesPresentationContext = YES; //self is presenting view controller
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明全靠这句了
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)clickAddButtonButtonAction:(id)sender
{
    if (![Tool islogin])
    {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    [MobClick event:@"__add_cart" attributes:@{@"item":_goodsDetailInfo.good_name,@"amount":_goodsDetailInfo.good_single_price}];
    [self httpAddGoodsToShopCartWithGoodsID:_goodsDetailInfo.good_id buyNum:@"1"];
}

- (IBAction)clickJShopCartButtonAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    QingDanViewController *vc = [[QingDanViewController alloc]initWithNibName:@"QingDanViewController" bundle:nil];
    vc.isPush = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)clickGoButtonAction:(id)sender
{
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    vc.goodId = _goodsDetailInfo.next_fight.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickUserPhotoAction:(UITapGestureRecognizer*)tap
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    UIImageView *imageview = (UIImageView *)tap.self.view;
    NSString *userIdStr = nil;
    if (imageview.tag == -1) {
        userIdStr = _goodsDetailInfo.win_user_id;
    }else{
        DuoBaoRecordInfo *info = [recordDataArray objectAtIndex:imageview.tag];
        userIdStr = info.user_id;
    }
    
    if ([userIdStr isEqualToString:[ShareManager shareInstance].userinfo.id]) {
        return;
    }
    
    if (_st==1) {
        UserViewController *vc = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        vc.userId = userIdStr;
        vc.st=1;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
        UserViewController *vc = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        vc.userId = userIdStr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (void)clickRewardSeeNumButtonAction:(id)sender
{
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    //改动
    vc.goodId = _goodsDetailInfo.id;
    vc.userId = _goodsDetailInfo.win_user_id;
    vc.userName = _goodsDetailInfo.win_user.nick_name;
    vc.goodName = [NSString stringWithFormat:@"%@",_goodsDetailInfo.good_name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickSeeNumButtonAction:(UIButton *)btn
{
    DuoBaoRecordInfo *info = [recordDataArray objectAtIndex:btn.tag];
    
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    vc.goodId = _goodsDetailInfo.id;
    vc.userId = info.user_id;
    vc.userName = info.nick_name;
    vc.goodName = [NSString stringWithFormat:@"%@",_goodsDetailInfo.good_name];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)clickSeeMySelfNumButtonAction:(UIButton *)btn
{
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    vc.goodId = _goodsDetailInfo.id;
    vc.userId = [ShareManager shareInstance].userinfo.id;
    vc.userName = @"您";
    vc.goodName = [NSString stringWithFormat:@"%@",_goodsDetailInfo.good_name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickJSJGButtonAction:(id)sender
{
    SafariViewController *vc =[[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"计算详情";
    vc.urlStr = [NSString stringWithFormat:@"%@%@goods_fight_id=%@",URL_Server,Wap_JSXQ,_goodsDetailInfo.id];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 倒计时
//倒计时
- (void)startCountDown
{
    if (timer) {
        [timer setFireDate:[NSDate distantPast]];
    }
    [self handleTimer];
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
    totalTime = totalTime-10;

    long long timeValue = totalTime /1000;
    NSUInteger min  = (timeValue%(3600))/60;
    NSUInteger second = (NSUInteger)(timeValue%60);
    NSUInteger hsecond = (NSUInteger)(totalTime%1000)/10;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    GoodsInfoTableViewCell *cell = (GoodsInfoTableViewCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    
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
        cell.sendsLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)hsecond];
    }else{
        cell.sendsLabel.text = [NSString stringWithFormat:@"0%lu",(unsigned long)hsecond];
    }
    
    if (totalTime <= 0) {
        totalTime = 0;
        if (timer) {
            //关闭定时器
            [timer setFireDate:[NSDate distantFuture]];
        }
        [self httpGetProductDetailInfo];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        case 3:
            //改动
            return commentDataArray.count;
//            return 0;
            break;
        default:
            return 0;
            break;
    }
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return FullScreen.size.width*0.6;
            break;
        case 1:
        {
            if (_isJieXiao == 2) {
                return 250;
            }
            else{
                return 175;
            }
        }
            break;
        case 2:
            return 44;
            break;
        case 3:
            return 95;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return 8;
            break;
        case 3:
            return 47;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section < 3) {
        return nil;
    }
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 50);
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width , 40)];
    contentView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:contentView];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 39, FullScreen.size.width, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    [contentView addSubview:lineview];
    //改动 自己添加的代码
    combut = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, WIDTH/2-8, 40)];
    [combut setImage:[UIImage imageNamed:@"ping_on"] forState:UIControlStateNormal];
    [combut addTarget:self action:@selector(combutAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:combut];
    
    regardbut = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2-8, 40)];
    [regardbut setImage:[UIImage imageNamed:@"jilu"] forState:UIControlStateNormal];
    [regardbut addTarget:self action:@selector(regardbutAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:regardbut];
    return bgView;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BannerTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"BannerTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BannerTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.bannerView.delegate = self;
            cell.bannerView.dataSource = self;
            cell.bannerView.autoScrollAble = YES;
            cell.bannerView.direction = CycleDirectionLandscape;
            objc_setAssociatedObject(cell.bannerView, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.bannerView reloadData];
        return cell;
        
    }else if (indexPath.section == 1)
    {
        if (_isJieXiao == 2) {
            GoodsInfoJieXiaoTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsInfoJieXiaoTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsInfoJieXiaoTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
            }
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.detailButton.layer.masksToBounds =YES;
            cell.detailButton.layer.cornerRadius = cell.detailButton.frame.size.height/2;
            cell.detailButton.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
            cell.detailButton.layer.borderWidth = 1.0f;
            [cell.detailButton addTarget:self action:@selector(clickJSJGButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.photoImage.tag = -1;
            cell.photoImage.layer.masksToBounds =YES;
            cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
            cell.photoImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserPhotoAction:)];
            [cell.photoImage addGestureRecognizer:tap];
            
            [cell.rewardControl addTarget:self action:@selector(clickRewardSeeNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.statueImage.image = PublicImage(@"cont_yixiexiao");
            if (_goodsDetailInfo) {
                //改动 去掉 期数
//                cell.titleLabel.text = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
//                 NSLog(@"%@",_goodsDetailInfo.productName);
                cell.titleLabel.text = _goodsDetailInfo.productName;
                
                [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:_goodsDetailInfo.win_user.user_header] placeholderImage:PublicImage(@"default_head")];
                cell.nameLabel.text = _goodsDetailInfo.win_user.nick_name;
                CGSize size = [cell.nameLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
                cell.namelabelWidth.constant = size.width+2;
                cell.addressLabel.text = _goodsDetailInfo.win_user.user_ip_address;
                cell.numIDLabel.text = [NSString stringWithFormat:@"%@(唯一不变标识)",_goodsDetailInfo.win_user_id];
                cell.joinNumLabel.text = [NSString stringWithFormat:@"%@人次",_goodsDetailInfo.win_user.fight_time];
                cell.timeLabel.text =_goodsDetailInfo.lottery_time;
                cell.xyhmLabel.text = _goodsDetailInfo.win_num;
            }
            
            if (myJoinNumArray.count > 0) {
                cell.noJionLabel.hidden = YES;
                
                if (myJoinNumArray.count > 1) {
                    cell.JoinNumMoreView.hidden = NO;
                    cell.joinNumLessView.hidden = YES;
                    cell.selfJoinNumLabel.text = [NSString stringWithFormat:@"本次参与%lu人次",(unsigned long)myJoinNumArray.count];
                    CGSize size = [cell.selfJoinNumLabel sizeThatFits:CGSizeMake(MAXFLOAT, 45)];
                    cell.selfJoinWidth.constant = size.width;
                    [cell.JoinNumMoreView addTarget:self action:@selector(clickSeeMySelfNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    cell.JoinNumMoreView.hidden = YES;
                    cell.joinNumLessView.hidden = NO;
                    NSDictionary *dic = [myJoinNumArray objectAtIndex:0];
                    cell.duobaoNumLabel.text = [dic objectForKey:@"fight_num"];
                }
                
            }else{
                cell.noJionLabel.hidden = NO;
                cell.JoinNumMoreView.hidden = YES;
                cell.joinNumLessView.hidden = YES;
            }
            return cell;
            
        }else{
            GoodsInfoTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsInfoTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsInfoTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.processView.layer.masksToBounds =YES;
            cell.processView.layer.cornerRadius = cell.processView.frame.size.height/2;
            //改动。跳转界面按钮
            [cell.involved addTarget:self action:@selector(regularAction) forControlEvents:UIControlEventTouchUpInside];
            
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_goodsDetailInfo) {
//                cell.titleLabel.text = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
                //改动 去掉 期数  数据布局
                NSLog(@"_goodsDetailInfo.productName = %@",_goodsDetailInfo.productName);

                cell.titleLabel.text = _goodsDetailInfo.productName;
                
                cell.priceLab.text = _goodsDetailInfo.productPrice;
                //进行中
                if (_isJieXiao == 0) {
                    cell.processLabel.constant = (FullScreen.size.width-16)*([_goodsDetailInfo.progress doubleValue]/100.0);
                    cell.statueImage.image = PublicImage(@"cont_ing");
                    cell.daojishiViw.hidden = YES;
                    cell.allNumLabel.text = [NSString stringWithFormat:@"总需 %@人次",_goodsDetailInfo.need_people];
                    NSString *numStr = [NSString stringWithFormat:@"%d",[_goodsDetailInfo.need_people intValue]-[_goodsDetailInfo.now_people intValue]];
                    if ([numStr intValue]<0) {
                        cell.needNumLabel.hidden=YES;
                    }else{
                        cell.needNumLabel.text = [NSString stringWithFormat:@"还需 %@",numStr];
                    }
                    
                }else{
                    //倒计时
                    cell.processLabel.constant = FullScreen.size.width-16;
                    cell.statueImage.image = PublicImage(@"cont_count");
                    cell.daojishiViw.hidden = NO;
                    if ([_goodsDetailInfo.is_show_daojishi isEqualToString:@"n"]) {
                        cell.daojieshiWarnLabel.hidden = NO;
                        cell.daojieshiWarnLabel.text = _goodsDetailInfo.daojishi_message;
                    }else{
                        cell.daojieshiWarnLabel.hidden = YES;
                        cell.hourLabel.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
                        cell.hourLabel.layer.borderWidth = 1.0f;
                        cell.minuteLabel.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
                        cell.minuteLabel.layer.borderWidth = 1.0f;
                        cell.sendsLabel.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
                        cell.sendsLabel.layer.borderWidth = 1.0f;
                    }
                    
                    //是否看是计算详情
                    if ([versionStr isEqualToString:@"cheat"]) {
                        cell.jsxqButton.hidden = YES;
                    }else{
                        cell.jsxqButton.hidden = NO;
                        cell.jsxqButton.layer.masksToBounds =YES;
                        cell.jsxqButton.layer.cornerRadius = cell.jsxqButton.frame.size.height/2;
                        cell.jsxqButton.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
                        cell.jsxqButton.layer.borderWidth = 1.0f;
                        [cell.jsxqButton addTarget:self action:@selector(clickJSJGButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                
                if (myJoinNumArray.count > 0) {
                    cell.noJionLabel.hidden = YES;
                    
                    if (myJoinNumArray.count > 1) {
                        cell.JoinNumMoreView.hidden = NO;
                        cell.joinNumLessView.hidden = YES;
                        cell.selfJoinNumLabel.text = [NSString stringWithFormat:@"本次参与%lu人次",(unsigned long)myJoinNumArray.count];
                        CGSize size = [cell.selfJoinNumLabel sizeThatFits:CGSizeMake(MAXFLOAT, 45)];
                        cell.selfJoinWidth.constant = size.width;
                        [cell.JoinNumMoreView addTarget:self action:@selector(clickSeeMySelfNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    }else{
                        cell.JoinNumMoreView.hidden = YES;
                        cell.joinNumLessView.hidden = NO;
                        NSDictionary *dic = [myJoinNumArray objectAtIndex:0];
                        cell.duobaoNumLabel.text = [dic objectForKey:@"fight_num"];
                    }
                    
                }else{
                    cell.noJionLabel.hidden = NO;
                    cell.JoinNumMoreView.hidden = YES;
                    cell.joinNumLessView.hidden = YES;
                }
            }
            return cell;
        }
        
    }
    else if (indexPath.section == 2)
    {
        ListTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (indexPath.row == 0) {
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabelWidth.constant = 0;
            cell.titleLabel.hidden = YES;
            cell.rightImage.hidden = YES;
            cell.detailLabel.hidden = NO;
           
        
            cell.detailLabel.text = @"声明：所有商品抽奖活动与苹果公司（apple inc.）无关\n我已阅读《猜拳竞宝声明》";
            cell.detailLabel.numberOfLines = 0;
            cell.detailLabel.textColor = [UIColor colorWithRed:240.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
            cell.detailLabel.font = [UIFont systemFontOfSize:13];
            cell.detailLabel.textAlignment = NSTextAlignmentCenter;
            [Tool setFontSizeThatFits:cell.detailLabel];
            return cell;
            
        }else{
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.titleLabelWidth.constant = 90;
            cell.titleLabel.hidden = NO;
            cell.rightImage.hidden = NO;
            cell.detailLabel.hidden = YES;
            if(indexPath.row == 1)
            {
                cell.titleLabel.text = @"图文详情";
                cell.detailLabel.hidden = NO;
                cell.detailLabel.text = @"建议Wi-Fi下查看";
                cell.detailLabel.textColor = [UIColor lightGrayColor];
                cell.detailLabel.font = [UIFont systemFontOfSize:12];
                cell.detailLabel.textAlignment = NSTextAlignmentRight;
                
            }
//            else if(indexPath.row == 2)
//            {
//                // 改动    往期揭晓
//                cell.titleLabel.text = @"往期揭晓";}
            else{
                cell.titleLabel.text = @"晒单分享";
            }
            return cell;
        }
        
    }else{
        //数据布局
       CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
        if (cell == nil)
    {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentTableViewCell"];
    }
        Comment *info = [commentDataArray objectAtIndex:indexPath.row];
        cell.img.image = [UIImage imageNamed:info.commentImg];
        cell.usenamelab.text = info.userName;
        cell.commenttimelab.text = info.commentTime;
        cell.commentlab.text = info.commentContent;
//        RecordTableViewCell *cell = nil;
//        cell = [tableView dequeueReusableCellWithIdentifier:@"RecordTableViewCell"];
//        if (cell == nil)
//        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:nil options:nil];
//            cell = [nib objectAtIndex:0];
//        }
//        //设点点击选择的颜色(无)
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.photoImage.tag = indexPath.row;
//        cell.photoImage.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserPhotoAction:)];
//        [cell.photoImage addGestureRecognizer:tap];
//        cell.seeNumButton.tag = indexPath.row;
//        [cell.seeNumButton addTarget:self action:@selector(clickSeeNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//
//        DuoBaoRecordInfo *info = [recordDataArray objectAtIndex:indexPath.row];
//        
//        cell.photoImage.layer.masksToBounds =YES;
//        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
//        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.user_header] placeholderImage:PublicImage(@"default_head")];
//        
//        cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@ ip:%@)",info.nick_name,info.user_ip_address,info.user_ip];
//        cell.joinNameLabel.text = [NSString stringWithFormat:@"参与%@人次  %@",info.count_num,info.fight_time_all];
//        
//        if ([info.count_num intValue] > 1) {
//            cell.seeNumButton.hidden = NO;
//            cell.luckNumLabel.hidden = YES;
//        }else{
//            cell.seeNumButton.hidden = YES;
//            cell.luckNumLabel.hidden = NO;
//            cell.luckNumLabel.text = [NSString stringWithFormat:@"幸运号码：%@",info.fight_num];
//        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 1:
            {
                SafariViewController *vc =[[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
                vc.title = @"图文详情";
//                vc.urlStr = _goodsDetailInfo.good_href;
//                vc.urlStr = _goodsDetailInfo.productContentUrl;
                vc.urlStr = @"http://www.baidu.com";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                //改动    注释掉往期揭晓
//            case 2:
//            {
//                if (_st==1) {
//                    WQJXViewController *vc =[[WQJXViewController alloc]initWithNibName:@"WQJXViewController" bundle:nil];
//                    vc.goodId = _goodsDetailInfo.good_id;
//                    vc.st=1;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }else
//                {
//                    WQJXViewController *vc =[[WQJXViewController alloc]initWithNibName:@"WQJXViewController" bundle:nil];
//                    vc.goodId = _goodsDetailInfo.good_id;
//                    
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                
//            }
//                break;
            case 2:
            {
                ShaiDanViewController *vc = [[ShaiDanViewController alloc]initWithNibName:@"ShaiDanViewController" bundle:nil];
                vc.goodId = _goodsDetailInfo.id;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        //改动
        [weakSelf httpGetProductDetailInfo];
        [weakSelf loadCommentResult];
//        [weakSelf loadDuoBaoRecord];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    //    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadCommentResult];
//        [weakSelf loadDuoBaoRecord];
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    if([_myTableView.mj_header isRefreshing])
    {
        [_myTableView.mj_header endRefreshing];
    }
    if([_myTableView.mj_footer isRefreshing])
    {
        [_myTableView.mj_footer endRefreshing];
    }
}

#pragma mark - CycleScrollViewDataSource
- (UIView *)cycleScrollView:(CycleScrollView *)cycleScrollView viewAtPage:(NSInteger)page
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    NSString *url = _goodsDetailInfo.photoUrl;
//    NSLog(@"url = %@",url);
    if (bannerArray.count == 2) {
        url = [bannerArray objectAtIndex:page%2];
    }else{
        url = [bannerArray objectAtIndex:page];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    cycleScrollView.backgroundColor = [UIColor whiteColor];
    
    return imageView;
}

- (NSInteger)numberOfViewsInCycleScrollView:(CycleScrollView *)cycleScrollView
{
    BannerTableViewCell *cell = objc_getAssociatedObject(cycleScrollView, "cell");
    cell.pageController.numberOfPages = bannerArray.count;
    
    if (bannerArray.count == 2) {
        return  4;
    }else{
        return bannerArray.count;
    }
}

- (void)cycleScrollView:(CycleScrollView *)cycleScrollView didScrollView:(int)index
{
    BannerTableViewCell *cell = objc_getAssociatedObject(cycleScrollView, "cell");
    if (bannerArray.count == 2) {
        cell.pageController.currentPage = index%2;
    }else{
        cell.pageController.currentPage = index;
    }
}

- (CGRect)frameOfCycleScrollView:(CycleScrollView *)cycleScrollView
{
    return CGRectMake(0, 0, FullScreen.size.width,FullScreen.size.width*0.6);
}

#pragma mark - SelectGoodsNumViewControllerDelegate
- (void)selectGoodsNum:(int)num
{
    PayViewController *vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
    vc.moneyNum = num * [_goodsDetailInfo.good_single_price doubleValue];
    vc.goodsIds = _goodsDetailInfo.id;
    vc.isShopCart = NO;
    vc.goods_buy_nums = [NSString stringWithFormat:@"%d",num];
    vc.delegate = self;
    vc.duoshao=@"1";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -  PayViewControllerDelegate
- (void)payForBuyGoodsSuccess
{
    //改动
    [self httpGetProductDetailInfo];
    [self loadCommentResult];
//    [self loadDuoBaoRecord];
}
#pragma mark - 按钮跳转方法   改动
-(void)regularAction
{
    BeatViewController *beatVC = [[BeatViewController alloc]init];
    [self presentViewController:beatVC animated:YES completion:nil];
    
}
-(void)combutAction
{
    static int i;
    i = 0;
    i++;
    if (i%2==1) {
        
        [combut setImage:[UIImage imageNamed:@"ping_on"] forState:UIControlStateNormal];
        [regardbut setImage:[UIImage imageNamed:@"jilu"] forState:UIControlStateNormal];
    }
}
-(void)regardbutAction
{
    static int j;
    j = 0;
    j++;
    if (j%2==1) {
        
        [combut setImage:[UIImage imageNamed:@"ping"] forState:UIControlStateNormal];
        [regardbut setImage:[UIImage imageNamed:@"jilu_on"] forState:UIControlStateNormal];
    }
}



@end
