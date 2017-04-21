//
//  ProductDetailViewController.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/21.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "ProductDetailViewController.h"
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
#import "uuid.h"
#import "BeatViewController.h"
#import "Comment.h"
#import "CommentTableViewCell.h"
#import "WinnerRecord.h"
#import "SocketInteraction.h"
#import "requestTool.h"
#import "FirstViewDown.h"
#import "WinRecoardTableViewCell.h"
#import "RegularViewController.h"
#import "CZViewController.h"

@interface ProductDetailViewController ()<SelectGoodsNumViewControllerDelegate,PayViewControllerDelegate>
{
    int pageNumWin;
    int pageNumCom;
    NSMutableArray *recordDataArray;   //记录数组
    NSMutableArray *commentDataArray;   //评论数组
    GoodsDetailInfo *_goodsDetailInfo;
    
    NSInteger _isJieXiao;//0 进行中 1 倒计时 2 已揭晓
    NSArray *bannerArray;
    
    UIButton *combut;
    UIButton *regardbut;
    
    CommentTableViewCell *Commentcell;
    WinRecoardTableViewCell *Wincell;
    BeatViewController *beatVC;
    requestTool *request;
    
    NSInteger game_type;  //0 PK赛   1晋级赛   2好友大乱斗
    BOOL is_upper_screen;  //true 上屏。  false。 下屏
    BOOL isWin;
    NSDictionary *PayDic;
}

@end

@implementation ProductDetailViewController

#pragma mark - 懒加载
- (UIScrollView *)scView
{
    if (!_scView) {
        _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/2-1)];
        _scView.showsHorizontalScrollIndicator = YES;
        _scView.showsVerticalScrollIndicator = NO;
        _scView.contentOffset = CGPointMake(0, 0);
        _scView.contentSize = CGSizeMake(WIDTH*2, HEIGHT/2-1);
        _scView.pagingEnabled = YES;
    }
    return _scView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVariable];
    [self leftNavigationItem];
    [self setTabelViewRefresh];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [_myTableView.mj_header beginRefreshing];
    
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    isWin = false;
    
    self.title = @"商品详情";
    pageNumWin = 1;
    pageNumCom = 1;
    recordDataArray = [NSMutableArray array];
    commentDataArray = [NSMutableArray array];
    
    self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 0.01f)];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 0.01f)];
    
    _isJieXiao = 0;
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
    NSString *userIdStr = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userIdStr = [ShareManager shareInstance].userinfo.id;
    }
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ProductDetailViewController *weakSelf = self;
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
    bannerArray = [_goodsDetailInfo.photoUrl componentsSeparatedByString:@","];
    [_myTableView reloadData];
}
//评论
- (void)loadCommentResult
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ProductDetailViewController *weakSelf = self;
    [helper loadCommentWithGoodsId:_goodsId
                           pageNum:[NSString
                                    stringWithFormat:@"%d",pageNumCom]
                          limitNum:@"10"
                           success:^(NSDictionary *resultDic){
                            [self hideRefresh];
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
    NSArray *ary = [resultDic objectForKey:@"data"];
    for (NSDictionary *dic in ary)
    {
        Comment *comModel = [Comment CommentWithDic:dic];
        [commentDataArray addObject:comModel];
    }
    if (commentDataArray.count < 20) {
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_myTableView.mj_footer resetNoMoreData];
    }
    pageNumCom ++;
    [_myTableView reloadData];
}
//中奖纪录
- (void)loadWinnerRecoardResult
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ProductDetailViewController *weakSelf = self;
    [helper loadWinnerRecoardWithGoodsId:_goodsId
                                 pageNum:[NSString
                                          stringWithFormat:@"%d",pageNumWin]
                                limitNum:@"10"
                           success:^(NSDictionary *resultDic){
                               if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                   [weakSelf handleWinnerRecoardResult:resultDic];
                               }else
                               {
                                   [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                               }
                           }fail:^(NSString *decretion){
                               [self hideRefresh];
                               [Tool showPromptContent:decretion onView:self.view];
                           }];
}
- (void)handleWinnerRecoardResult:(NSDictionary *)resultDic
{
    if (recordDataArray.count > 0) {
        [recordDataArray removeAllObjects];
    }
    //取数据
    NSLog(@"中奖纪录 resultDic = %@",resultDic);
    
    NSArray *ary = [resultDic objectForKey:@"data"];
    for (NSDictionary *dic in ary)
    {
        WinnerRecord *winrecordModel = [WinnerRecord WinnerRecordWithDic:dic];
        [recordDataArray addObject:winrecordModel];
    }
    if (recordDataArray.count < 20) {
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_myTableView.mj_footer resetNoMoreData];
    }
    pageNumWin ++;
    [_myTableView reloadData];
}
//获取用户信息
- (void)getUserInfo
{
    UserInfo *info = [[UserInfo alloc]init];
    HttpHelper *helper = [[HttpHelper alloc] init];
    info.id = [ShareManager shareInstance].userinfo.id;
    [helper loadUserDetailUserId:info.id
                         success:^(NSDictionary *resultDic){
                             if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                 //用户详情
                                 self.dicUser = resultDic;
                                 //NSLog(@"商品详情页用户信息 = %@",self.dicUser);
                             }
                         }fail:^(NSString *decretion){
                             NSLog(@"数据请求失败");
                         }];
}
//获取多个用户详情
- (void)getMoreUsersInfo
{
    UserInfo *info = [[UserInfo alloc]init];
    HttpHelper *helper = [[HttpHelper alloc] init];
    info.id = [ShareManager shareInstance].userinfo.id;
    //__weak ProductDetailViewController *weakSelf = self;
    NSString *ids = [NSString stringWithFormat:@"%@,%@",info.id,self.otherId];
    NSLog(@"ids = %@",ids);
    [helper loadMoreUserDetailUsersId:ids success:^(NSDictionary *resultDic) {
        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
            //用户详情
            [[NSNotificationCenter defaultCenter]postNotificationName:@"rece" object:nil userInfo:resultDic];
        }
    }fail:^(NSString *decretion){
        NSLog(@"数据请求失败");
    }];
}
//猜拳支付
- (void)loadPay
{
    UserInfo *info = [[UserInfo alloc]init];
    info.id = [ShareManager shareInstance].userinfo.id;
   
        HttpHelper *helper = [[HttpHelper alloc] init];
        [helper loadPayUserId:info.id payType:@"1" payment:_peoplePrice productId:_goodsId number:_peopleNum success:^(NSDictionary *resultDic) {
            NSLog(@".....%@",resultDic);
            PayDic = resultDic;
        } fail:^(NSString *description) {
            NSLog(@".....支付失败");
        }];
}
//用户评论
-(void)userComment
{
    UserInfo *info = [[UserInfo alloc]init];
    info.id = [ShareManager shareInstance].userinfo.id;

    HttpHelper *helper = [[HttpHelper alloc] init];
    NSLog(@"1-%@.2-%@.3-%@",info.id,_goodsId,_textField.text);
    [helper loadUserCommentUserId:info.id goodsId:_goodsId commentContent:_textField.text success:^(NSDictionary *resultDic) {
        NSLog(@"评论成功 %@",resultDic);
    } fail:^(NSString *description) {
        NSLog(@"评论失败");
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
            if (isWin==false) {
                return commentDataArray.count;
            }
            else{
                return recordDataArray.count;
            }
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
            if (WIDTH == 375) {
                return FullScreen.size.width*0.35;
            }
            return FullScreen.size.width*0.45;
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

    //改动 自己添加的代码
    if(isWin == false){
    combut = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, WIDTH/2-8, 40)];
    [combut setImage:[UIImage imageNamed:@"ping_on"] forState:UIControlStateNormal];
    [combut addTarget:self action:@selector(combutAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:combut];
    
    regardbut = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2-8, 40)];
    [regardbut setImage:[UIImage imageNamed:@"jilu"] forState:UIControlStateNormal];
    [regardbut addTarget:self action:@selector(regardbutAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:regardbut];
    }else{
        combut = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, WIDTH/2-8, 40)];
        [combut setImage:[UIImage imageNamed:@"ping"] forState:UIControlStateNormal];
        [combut addTarget:self action:@selector(combutAction) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:combut];
        
        regardbut = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2-8, 40)];
        [regardbut setImage:[UIImage imageNamed:@"jilu_on"] forState:UIControlStateNormal];
        [regardbut addTarget:self action:@selector(regardbutAction) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:regardbut];

    }
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
                //改动 去掉 期数  数据布局
                cell.titleLabel.text = _goodsDetailInfo.productName;
                cell.priceLab.text = [NSString stringWithFormat:@"¥%@",_TotalPrice];
                cell.numcount.text = _peopleNum;
                cell.oneprice.text = _peoplePrice;
                //cell.oneprice.text = _goodsDetailInfo.photoUrl;
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
            
            NSString *str = @" 声明：所有商品抽奖活动与苹果公司（apple inc.）无关   我已阅读《猜拳竞宝声明》";
            //NSString *str1 = @" 我已阅读《猜拳竞宝声明》";
            NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
            attachment.image = [UIImage imageNamed:@"icon-bord"];
            UIFont * font = [UIFont systemFontOfSize:8];
            attachment.bounds = CGRectMake(0, 0, font.lineHeight, font.lineHeight);
            NSAttributedString * AttributStr = [NSAttributedString attributedStringWithAttachment:attachment];
            NSMutableAttributedString * mAttributStr = [[NSMutableAttributedString alloc]initWithString:str];
             [mAttributStr insertAttributedString:AttributStr atIndex:33];
            
            cell.detailLabel.attributedText = mAttributStr;
            
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
            else{
                cell.titleLabel.text = @"晒单分享";
            }
            return cell;
        }
    }else{
        /**/
        if (isWin==false) {
            //数据布局
            Commentcell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
            if (Commentcell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil];
                Commentcell = [nib objectAtIndex:0];
            }
            Comment *info = [commentDataArray objectAtIndex:indexPath.row];
            [Commentcell.img sd_setImageWithURL:[NSURL URLWithString:info.userImg]placeholderImage:PublicImage(@"defaultImage")];
            Commentcell.usenamelab.text = info.userName;
            Commentcell.commenttimelab.text = info.commentTime;
            Commentcell.commentlab.text = info.commentContent;
            return Commentcell;
        }
        else
        {
            Wincell = [tableView dequeueReusableCellWithIdentifier:@"WinRecoardTableViewCell"];
            if (Wincell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WinRecoardTableViewCell" owner:nil options:nil];
                Wincell = [nib objectAtIndex:0];
            }
            if (recordDataArray.count>0) {
                WinnerRecord *info = [recordDataArray objectAtIndex:indexPath.row];
                [Wincell.winImg sd_setImageWithURL:[NSURL URLWithString:info.userImg] placeholderImage:PublicImage(@"defaultImage")];
                Wincell.wintime.text = info.winTime;
                Wincell.winuser.text = info.userName;
                Wincell.winid.text = [NSString stringWithFormat:@"%@",info.userId];
                Wincell.winIp.text = info.userIp;
                Wincell.winIpSite.text = info.userIpSite;
                return Wincell;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2)
    {
        switch (indexPath.row) {
                case 0:
            {
                RegularViewController *vc = [[RegularViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                SafariViewController *vc =[[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
                vc.title = @"图文详情";
                vc.urlStr = _goodsDetailInfo.productContentUrl;
                //vc.urlStr = @"http://www.baidu.com";productContent
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                ShaiDanViewController *vc = [[ShaiDanViewController alloc]initWithNibName:@"ShaiDanViewController" bundle:nil];
                //vc.goodId = _goodsDetailInfo.id;
                vc.goodId = _goodsId;
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
        pageNumWin = 1;
        pageNumCom = 1;
        //改动
        [weakSelf httpGetProductDetailInfo];
        [weakSelf loadCommentResult];
        [weakSelf loadWinnerRecoardResult];
        [weakSelf loadPay];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    //    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadCommentResult];
        [weakSelf loadWinnerRecoardResult];
        [weakSelf loadPay];
    }];
    pageNumWin = 1;
    pageNumCom = 1;
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
    if (WIDTH == 375) {
        return CGRectMake(0, 0, FullScreen.size.width,FullScreen.size.width*0.35);
    }
        return CGRectMake(0, 0, FullScreen.size.width,FullScreen.size.width*0.45);
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
    [self loadWinnerRecoardResult];
    [self loadPay];
}
#pragma mark - 按钮跳转方法   改动
-(void)regularAction
{
    if ([PayDic[@"status"]isEqualToString:@"93"]) {
        CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        //判断是否登录
        if ([Tool islogin]) {
            //-----
            NSDictionary *usedic = [self.dicUser objectForKey:@"data"];
            
            NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:usedic[@"id"],@"userId",_goodsId,@"goodId",_peopleNum,@"peopleNum",self.dicUser[@"peakPrice"],@"perPrice", nil];
            [UserDefault setObject:dataDic forKey:@"datas"];
            [UserDefault synchronize];
            
            NSString *str1 = usedic[@"id"];
            NSString *str2 = _goodsId;
            NSString *struuid = [uuid getUUID];
            NSString *str = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"cmd\":\"login\",\"game_type\":\"1\",\"room_people_number\":\"%@\",\"goods_id\":\"%@\",\"is_upper_screen\":\"false\",\"device_code\":\"%@\"}",str1,_peopleNum,str2,struuid];
            
            //传给服务器
            SocketInteraction *sock = [[SocketInteraction alloc]init];
            NSLog(@"socke的内存地址%@",sock);
            [sock ClientConnectionServerMsg:str];
            //通知接收值
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAction:) name:@"msg" object:nil];
            
            beatVC = [[BeatViewController alloc]init];
            beatVC.peopleNumBeat = _peopleNum;
            beatVC.ReturnNum = _peopleNum;
            beatVC.ReturnMoney = _peoplePrice;
            beatVC.ReturnProductId = _goodsId;
            [self presentViewController:beatVC animated:YES completion:nil];
        }
        else
        {
            [Tool loginWithAnimated:YES viewController:nil];
            return;
        }
    }}

-(void)receiveAction:(NSNotification *)sender
{
    NSDictionary *dic = sender.userInfo;
    //NSLog(@"通知出来的值：%@",dic);
    NSString *cmd = dic[@"cmd"];
/**/
    NSString *user_id = dic[@"user_id"];
    NSArray *usersDic = dic[@"users"];
    for (NSDictionary *small in usersDic)
    {
        if(![small[@"user_id"]isEqualToString:user_id])
        {
            self.otherId = small[@"user_id"];
        }
    }
    if ([cmd isEqualToString:@"pk_play"])
    {
        //获取多用户信息
        [self getMoreUsersInfo];
        
        [UIView animateWithDuration:0.3 animations:^{
            [beatVC.scrollDown setContentOffset:CGPointMake(WIDTH, 0)];
        }];
    }
}

-(void)combutAction
{
    isWin = false;
    Commentcell.alpha = 1;
    Wincell.alpha = 0;
    [_myTableView reloadData];
    //_textField.alpha = 1;
    //_sendmessage.alpha = 1;
}
-(void)regardbutAction
{
    isWin = true;
    Commentcell.alpha = 0;
    Wincell.alpha = 1;
    [_myTableView reloadData];
    //_textField.alpha = 0;
    //_sendmessage.alpha = 0;
}

- (IBAction)sendmessage:(UIButton *)sender
{
    [self userComment];
    _textField.text = @"";
    _textField.placeholder = @"写评论";
}

/**/
- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"rece" object:nil];
}

@end
