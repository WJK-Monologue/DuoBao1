//
//  PayViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "PayViewController.h"
#import "CouponsViewController.h"
#import "ShopCartInfo.h"
#import "BuyGoodsListViewController.h"
#import "CouponsListInfo.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "SelectCouponsViewController.h"
#import "PayResultViewController.h"
#import <IapppayKit/IapppayOrderUtils.h>
#import <IapppayKit/IapppayKit.h>
#import "ZengQianInfo.h"
#import "CZViewController.h"
#import "UMMobClick/MobClick.h"
@interface PayViewController ()<SelectCouponsViewControllerDelegate,PayResultViewControllerDelegate,IapppayKitPayRetDelegate>
{
    PayTypeOption payType;
    NSMutableArray * goodsSourceArray;
    NSMutableArray * couponsSourceArray;
    NSMutableArray *dataRese;
    NSString *couponsId;
    NSString *wxmoneynum;
    NSString *zhifubaonum;
    double payMoney;
    NSString *orid;
    NSString *goodna;
    NSString *goodpr;
}

@end

@implementation PayViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeiXinPayNotif object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaySuccessInSafari object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self getTypePay];
    _duoshaonum.text=[NSString stringWithFormat:@"%@件",_duoshao];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self leftNavigationItem];
    [self httpGetPayDetail];
    [self registerNotif];
    
}

-(void)getTypePay
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    NSString *userId = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userId = [ShareManager shareInstance].userinfo.id;
    }
    
    
    [helper GetPayType:[ShareManager shareInstance].userinfo.id success:^(NSDictionary *resultDic) {
        NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"payTypeList"];
        if (resourceArray && resourceArray.count > 0 )
        {
            for (NSDictionary *dic in resourceArray)
            {
                ZengQianInfo *info = [dic objectByClass:[ZengQianInfo class]];
                [dataRese addObject:info];
                
                if ([info.type_name isEqualToString:@"微信"]) {
                    _weixinkeyong.text = [NSString stringWithFormat:@"(微信仅支持%@元或以上支付)",info.number];
                    wxmoneynum=info.number;
                }
                if ([info.type_name isEqualToString:@"支付宝"]) {
                    _zhifubaokeyong.text =  [NSString stringWithFormat:@"(支付宝仅支持%@元或以上支付)",info.number];
                    zhifubaonum=info.number;
                }
                
                if ([info.type_name isEqualToString:@"微信"]&&[info.type_status isEqual:@"0"]) {
                    _weixinPayControl.hidden=YES;
                    _aibellabel.hidden=YES;
                    payType = PayTypeOption_ALiPay;
                    _aibei.frame = CGRectMake(self.aibei.frame.origin.x,self.aibei.frame.origin.y-43,self.aibei.frame.size.width, self.aibei.frame.size.height);
                    _payButton.frame =CGRectMake(self.payButton.frame.origin.x, self.payButton.frame.origin.y-43, self.payButton.frame.size.width, self.payButton.frame.size.height);
                }
                if ([info.type_name isEqualToString:@"爱贝"]&&[info.type_status isEqual:@"0"]) {
                    payType = PayTypeOption_ALiPay;
                    _aibei.hidden=YES;
                    _payButton.frame =CGRectMake(self.payButton.frame.origin.x, self.payButton.frame.origin.y-43, self.payButton.frame.size.width, self.payButton.frame.size.height);
                    
                }
                if ([info.type_name isEqualToString:@"支付宝"]&&[info.type_status isEqual:@"0"]) {
                    payType = PayTypeOption_WeiXin;
                    _zhifubaocontro.hidden=YES;
                    _weixinPayControl.frame = CGRectMake(self.weixinPayControl.frame.origin.x,self.weixinPayControl.frame.origin.y-43,self.weixinPayControl.frame.size.width, self.weixinPayControl.frame.size.height);
                    _aibei.frame = CGRectMake(self.aibei.frame.origin.x,self.aibei.frame.origin.y-43,self.aibei.frame.size.width, self.aibei.frame.size.height);
                      _payButton.frame =CGRectMake(self.payButton.frame.origin.x, self.payButton.frame.origin.y-43, self.payButton.frame.size.width, self.payButton.frame.size.height);
                    _weixinlabel.hidden=YES;
                    _goubaolabel.hidden=YES;
                }
                
            }
            
        }
        
        
    } fail:^(NSString *description) {
        
    }];
    
    
}




- (void)initVariable
{
    self.title = @"订单支付";
    _payButton.layer.masksToBounds =YES;
    _payButton.layer.cornerRadius = 4;
    _allMoneyLabel.text = [NSString stringWithFormat:@"%.0f购宝币",_moneyNum];
    _qitajine.text=[NSString stringWithFormat:@"%.0f购宝币",_moneyNum];
     payMoney = _moneyNum;
    _payAllMoney.text = [NSString stringWithFormat:@"%.0f购宝币",payMoney];
   
    _djbLabel.text = [NSString stringWithFormat:@"购宝币支付（账户余额: %.0f 购宝币）",[ShareManager shareInstance].userinfo.user_money];
    
    payType = PayTypeOption_ALiPay;
    
    goodsSourceArray = [NSMutableArray array];
    couponsSourceArray  = [NSMutableArray array];
    
    [self updateHeadButtonStatue];
    
    
    
    if ([[ShareManager shareInstance].isShowThird isEqualToString:@"y"]) {
        _payView.hidden = NO;
    }else{
        _payView.hidden = YES;
    }

//    if ((_aibei.hidden=YES)) {
//        _bukeyong.hidden=NO;
//    }
    
    [[IapppayKit sharedInstance] setAppId:mOrderUtilsAppId mACID:mOrderUtilsChannel];
}

- (void)updateHeadButtonStatue
{
    _djbImage.image = PublicImage(@"cont_noslected");
    _zfbImage.image = PublicImage(@"cont_noslected");
    _weixinImage.image = PublicImage(@"cont_noslected");
    _aibeiImage.image = PublicImage(@"cont_noslected");
    switch (payType) {
        case PayTypeOption_DJB:
            _djbImage.image = PublicImage(@"cont_slected");
            break;
        case PayTypeOption_ALiPay:
            _zfbImage.image = PublicImage(@"cont_slected");
            break;
        case PayTypeOption_WeiXin:
            _weixinImage.image = PublicImage(@"cont_slected");
            break;
        default:
            _aibeiImage.image = PublicImage(@"cont_slected");
            break;
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

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickGoodsNumAction:(id)sender
{
    BuyGoodsListViewController *vc = [[BuyGoodsListViewController alloc]initWithNibName:@"BuyGoodsListViewController" bundle:nil];
    vc.dataSourceArray = goodsSourceArray;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clickPayButtonAction:(id)sender
{
    
    
    if ([[ShareManager shareInstance].isShowThird isEqualToString:@"y"])//app内支付
    {
        if (payType == PayTypeOption_DJB) {
            [self httpDJBPay];
        }else {
            if (couponsId.length > 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"第三方支付，不支持红包使用哦！是否继续支付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }
            
            [self httpGetPayOrderInfo];
            
        }
    }
    else{
        NSString *isShopCart = @"n";
        if (isShopCart) {
            isShopCart = @"y";
        }
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_fight_ids=%@&goods_buy_nums=%@&is_shop_cart=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id,_goodsIds,_goods_buy_nums,isShopCart];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }
    
   
    
      [self performSelector:@selector(changing:) withObject:nil afterDelay:0];
    
}
-(void)changing:(NSNotification *)changer
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tongzhishuaxin" object:nil];
}


- (IBAction)clickDJBAction:(id)sender
{
    payType = PayTypeOption_DJB;
    [self updateHeadButtonStatue];
}
- (IBAction)clickZFBAction:(id)sender
{
    payType = PayTypeOption_ALiPay;
    [self updateHeadButtonStatue];
}
- (IBAction)clickWeiXinAction:(id)sender
{
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi])
    {
        [Tool showPromptContent:@"您未安装微信客户端" onView:self.view];
    }else{
        payType = PayTypeOption_WeiXin;
        [self updateHeadButtonStatue];
    }
}

- (IBAction)clickAiBeiAction:(id)sender
{
    payType = PayTypeOption_AiBei;
    [self updateHeadButtonStatue];
}

- (IBAction)clickCouponsAction:(id)sender
{
    if(couponsSourceArray.count < 1)
    {
        return;
    }
    SelectCouponsViewController *vc = [[SelectCouponsViewController alloc]initWithNibName:@"SelectCouponsViewController" bundle:nil];
    vc.dataSourceArray = couponsSourceArray;
    vc.couponsId = couponsId;
    vc.delegate = self;
    self.definesPresentationContext = YES;
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明全靠这句了
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:vc animated:YES completion:nil];
}


#pragma mark - http

//获取支付详情
- (void)httpGetPayDetail
{
    NSString *shopCatStr = nil;
    if (_isShopCart) {
        shopCatStr = @"y";
    }else{
        shopCatStr = @"n";
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak PayViewController *weakSelf = self;
    [helper getPayDetailInfoWithUserId:[ShareManager shareInstance].userinfo.id
                       goods_fight_ids:_goodsIds
                        goods_buy_nums:_goods_buy_nums
                          is_shop_cart:shopCatStr
                               success:^(NSDictionary *resultDic){
                                 [HUD hide:YES];
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                                 {
                                     [weakSelf handleloadGetPayDetailResult:resultDic];
                                 }else{
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                 }
                                 
                               }fail:^(NSString *decretion){
                                 [HUD hide:YES];
                                 [Tool showPromptContent:@"网络出错了" onView:self.view];
                             }];
}

- (void)handleloadGetPayDetailResult:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goods_fight_buy_List"];
    if (resourceArray && resourceArray.count > 0 )
    {
        if (goodsSourceArray.count > 0) {
            [goodsSourceArray removeAllObjects];
        }
        for (NSDictionary *dic in resourceArray)
        {
            ShopCartInfo *info = [dic objectByClass:[ShopCartInfo class]];
            [goodsSourceArray addObject:info];
        }
    }
    
    resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"ticketList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        if (couponsSourceArray.count > 0) {
            [couponsSourceArray removeAllObjects];
        }
        for (NSDictionary *dic in resourceArray)
        {
            CouponsListInfo *info = [dic objectByClass:[CouponsListInfo class]];
            [couponsSourceArray addObject:info];
        }
        _couponLabel.text = @"点击选取";
    }
}

//支付
- (void)httpDJBPay
{
    NSString *payStr = nil;
    switch (payType) {
        case PayTypeOption_DJB:
            payStr = @"money";
            break;
        case PayTypeOption_ALiPay:
           
            payStr = @"zhifubao";
            break;
        case PayTypeOption_WeiXin:
           
            payStr = @"weixin";
            break;
        default:
            payStr = @"aibeipay";
            break;
    }
    
    NSString *shopCatStr = nil;
    if (_isShopCart) {
        shopCatStr = @"y";
    }else{
        shopCatStr = @"n";
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *couponIdstr = nil;
    if(payType != PayTypeOption_DJB)
    {
        HUD.labelText = @"加载中...";
    }else{
        HUD.labelText = @"支付中...";
        couponIdstr = couponsId;
    }
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak PayViewController *weakSelf = self;
    [helper payOfbuyGoodsWithPayType:payStr
                     goods_fight_ids:_goodsIds
                      goods_buy_nums:_goods_buy_nums
                        is_shop_cart:shopCatStr
                             user_id:[ShareManager shareInstance].userinfo.id
                      ticket_send_id:couponIdstr
                       success:^(NSDictionary *resultDic){
                            [HUD hide:YES];
                            if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                            {
                                [weakSelf handleloadResult:[resultDic objectForKey:@"data"]];
                            }else{
                                [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                            }
                           
                        }fail:^(NSString *decretion){
                            [HUD hide:YES];
                            [Tool showPromptContent:@"网络出错了" onView:self.view];
                        }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
//    [Tool getUserInfo];
    if([self.delegate respondsToSelector:@selector(payForBuyGoodsSuccess)])
    {
        [self.delegate payForBuyGoodsSuccess];
    }
    
    if (_isShopCart) {
        [ShareManager shareInstance].userinfo.shoppCartNum = 0;
        [Tool saveUserInfoToDB:YES];
    }else{
        [Tool getUserInfo];
    }
    
    if(payType == PayTypeOption_DJB)
    {
        [ShareManager shareInstance].userinfo.user_money  = [ShareManager shareInstance].userinfo.user_money - _moneyNum;
        _djbLabel.text = [NSString stringWithFormat:@"购宝币支付（账户余额: %.0f 购宝币）",[ShareManager shareInstance].userinfo.user_money];
    }
    
    NSMutableArray *goodsListArray = [NSMutableArray array];
    NSArray *resourceArray = [resultDic objectForKey:@"goods_fight_buy_List"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            ShopCartInfo *info = [dic objectByClass:[ShopCartInfo class]];
            goodna=info.good_name;
            goodpr=[NSString stringWithFormat:@"%ld",(long)info.good_single_price];
            [goodsListArray addObject:info];
        }
    }
    //进入支付结果页面
    PayResultViewController *vc = [[PayResultViewController alloc]initWithNibName:@"PayResultViewController" bundle:nil];
    vc.goodsListArray = goodsListArray;
    vc.allMoney = _moneyNum;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.delegate = self;
    [self presentViewController:nav animated:YES completion:^{
//        [self.navigationController popViewControllerAnimated:YES];
    }];
}


//获取订单号
- (void)httpGetPayOrderInfo
{
    if (payType==PayTypeOption_WeiXin&& _moneyNum <[wxmoneynum intValue]) {
        [Tool showPromptContent:[NSString stringWithFormat:@"微信仅支持%@元或以上支付！",wxmoneynum] onView:self.view];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
            vc.ttp=1;
            [self.navigationController pushViewController:vc animated:YES];
        });
      
        return;
    }
    
    if (payType==PayTypeOption_ALiPay&&_moneyNum<[zhifubaonum intValue]) {
        [Tool showPromptContent:[NSString stringWithFormat:@"支付宝仅支持%@元或以上支付",zhifubaonum] onView:self.view];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
            vc.ttp=2;
            [self.navigationController pushViewController:vc animated:YES];
        });
        return;
    }
   
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
   
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak PayViewController *weakSelf = self;
    [helper getOrderNoWithUserId:[ShareManager shareInstance].userinfo.id
                       total_fee:[NSString stringWithFormat:@"%.0f",_moneyNum]
                 goods_fight_ids:_goodsIds
                  goods_buy_nums:_goods_buy_nums
                      order_type:@"订单"
                       all_price:[NSString stringWithFormat:@"%.0f",_moneyNum]
                         success:^(NSDictionary *resultDic){
                               [HUD hide:YES];
                               if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                               {
                                   [weakSelf handleloadGetPayOrderInfoResult:resultDic];
                               }else{
                                   [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                               }
                               
                           }fail:^(NSString *decretion){
                               [HUD hide:YES];
                               [Tool showPromptContent:@"网络出错了" onView:self.view];
                           }];
}

- (void)handleloadGetPayOrderInfoResult:(NSDictionary *)resultDic
{
    
    NSString *orderNo = [resultDic objectForKey:@"data"];
    
    orid=orderNo;
   
    if (orderNo && orderNo.length > 0) {
        if(payType == PayTypeOption_ALiPay){
            
            [self payForAlipayWithOrderInfo:orderNo];
        }else if(payType == PayTypeOption_WeiXin){
            [self httpGetWeiXinPayInfo:orderNo];
        }else{
            [self httpGetIPayInfo:orderNo];
        }
    }else{
        [Tool showPromptContent:@"获取订单号失败" onView:self.view];
    }
    
}

//获取微信支付参数
- (void)httpGetWeiXinPayInfo:(NSString *)orderNo
{
   
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak PayViewController *weakSelf = self;
    [helper getWeiXinPayInfoWithOrderNo:orderNo
                              total_fee:[NSString stringWithFormat:@"%.0f",_moneyNum*100]
                       spbill_create_ip:@"127.0.0.1"
                                   body:@"订单支付"
                                 detail:@"订单支付"
                                success:^(NSDictionary *resultDic){
                                    [HUD hide:YES];
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                                    {
                                        [weakSelf handleloadGetWeiXinPayInfoResult:resultDic];
                                    }else{
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                             
                                }fail:^(NSString *decretion){
                                    [HUD hide:YES];
                                    [Tool showPromptContent:@"网络出错了" onView:self.view];
                                }];
}

- (void)handleloadGetWeiXinPayInfoResult:(NSDictionary *)resultDic
{
    [self jumpToWeiXinPay:resultDic];
}

#pragma mark - Alipay

/**
 *  支付宝支付
 *
 *  @param orderId         支付宝订单信息
 */
- (void)payForAlipayWithOrderInfo:(NSString *)orderNo
{
    /*=============需要填写商户app申请的=============*/
    NSString *partner = AliPayId;
    NSString *seller = AliPayAccount;
    NSString *privateKey = AliPayPrivateKey;
    /*============================================*/
    /*
     *生成订单信息及签名
     */

    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderNo; //订单ID（由商家自行制定）
    order.productName = @"订单支付";
    order.productDescription = @"订单支付"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",_moneyNum]; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@%@",URL_Server,URL_AllipayNotify];//回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = APPScheme;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        __weak PayViewController *weakSelf = self;
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *resultStatue = (NSString *)[resultDic objectForKey:@"resultStatus"];
            
            NSDictionary *resultInfo = [NSDictionary dictionaryWithObjectsAndKeys:resultStatue, @"resCode", nil];
            [weakSelf handlePayResultNotification:resultInfo];
        }];
    }
}

/**
 *  处理支付结果
 */
- (void)handlePayResultNotification:(NSDictionary *)userInfo
{
    NSString *message = nil;
    NSString *resultCode = (NSString*)[userInfo objectForKey:@"resCode"];
    if ([resultCode isEqualToString:@"00"] ||[resultCode isEqualToString:@"9000"]) {
        if([self.delegate respondsToSelector:@selector(payForBuyGoodsSuccess)])
        {
            [self.delegate payForBuyGoodsSuccess];
        }
        [self httpDJBPay];
       
    }
    else if ([resultCode isEqualToString:@"01"] || [resultCode isEqualToString:@"4000"])
    {
        message = @"很遗憾，您此次支付失败，请您重新支付！";
        [Tool showPromptContent:message onView:self.view];
        
        
    }else if([resultCode isEqualToString:@"02"] || [resultCode isEqualToString:@"6001"]){
        message = @"您已取消了支付操作！";
        [Tool showPromptContent:message onView:self.view];
       // [self handleUMevent];
        
    }else if([resultCode isEqualToString:@"8000"]){
        message =  @"正在处理中,请稍候查看！";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alter show];
        
        
    }else if([resultCode isEqualToString:@"6002"]){
        message = @"网络连接出错，请您重新支付！";
     
        [Tool showPromptContent:message onView:self.view];
        
    }
    
}


-(void)handleUMevent
{
    
    
}

-(void)handleUMevent2
{

}

#pragma mark - weixinPAy

- (void)jumpToWeiXinPay:(NSDictionary *)resultDic {
    
    NSDictionary *dict = [resultDic objectForKey:@"data"];
    UInt32 timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *signStr = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=Sign=WXPay&partnerid=%@&prepayid=%@&timestamp=%d&key=%@",WeiXinID,[dict objectForKey:@"nonce_str"],WeiXinPiD,[dict objectForKey:@"prepay_id"],timestamp,WeiXinAppKey];
    NSString *sign = [Tool encodeUsingMD5ByString:signStr letterCaseOption:UpperLetter];
    
    //调起微信支付
    PayReq* req    = [[PayReq alloc] init];
    req.partnerId  = WeiXinPiD;
    req.nonceStr   = [dict objectForKey:@"nonce_str"];
    req.timeStamp  = timestamp;
    req.prepayId   = [dict objectForKey:@"prepay_id"];
    req.package    = @"Sign=WXPay";
    req.sign       = sign;
    [WXApi sendReq:req];
    
}

#pragma mark - 获取爱贝支付参数

//获取爱贝
- (void)httpGetIPayInfo:(NSString *)orderNo
{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak PayViewController *weakSelf = self;
    [helper getIPayInfoWithOrderNo:orderNo
                           success:^(NSDictionary *resultDic){
                               [HUD hide:YES];
                               if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                               {
                                   [weakSelf handleloadGetIPayInfoResult:resultDic];
                               }else{
                                   [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                               }
                               
                           }fail:^(NSString *decretion){
                               [HUD hide:YES];
                               [Tool showPromptContent:@"网络出错了" onView:self.view];
                           }];
}

- (void)handleloadGetIPayInfoResult:(NSDictionary *)resultDic
{
    NSLog(@"%@",resultDic);
    
    NSString *trandsId = [[resultDic objectForKey:@"data"] objectForKey:@"transid"];
    
    IapppayOrderUtils *orderInfo = [[IapppayOrderUtils alloc] init];
    orderInfo.appId = mOrderUtilsAppId;
    
    NSString *orderStr = [orderInfo getTrandIdDataWith:trandsId];
    
    [[IapppayKit sharedInstance] makePayForTrandInfo:orderStr payDelegate:self];
}

#pragma mark - IapppayKitPayRetDelegate
- (void)iapppayKitRetPayStatusCode:(IapppayKitPayRetCodeType)statusCode
                        resultInfo:(NSDictionary *)resultInfo
{
    NSLog(@"statusCode : %d, resultInfo : %@", (int)statusCode, resultInfo);
    
    if (statusCode == IAPPPAY_PAYRETCODE_SUCCESS)
    {
        if([self.delegate respondsToSelector:@selector(payForBuyGoodsSuccess)])
        {
            [self.delegate payForBuyGoodsSuccess];
        }
        [self httpDJBPay];
        [self handleUMevent2];
        
    }
    else if (statusCode == IAPPPAY_PAYRETCODE_FAILED)
    {
        //支付失败
        NSString *message = @"支付失败";
        [Tool showPromptContent:message onView:self.view];
        [self handleUMevent];
    }
    else
    {
        //支付取消
        [Tool showPromptContent:@"您已取消支付" onView:self.view];
        [self handleUMevent];
    }
}


#pragma mark - notif Action
- (void)registerNotif
{
    /**
     *  微信回调监听
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotif:)
                                                 name:kWeiXinPayNotif
                                               object:nil];
    
    /**
     *  safari
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivepSafariOpenNotif:)
                                                 name:kPaySuccessInSafari
                                               object:nil];
}

- (void)receiveNotif:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    if(userInfo)
    {
        int code = [[userInfo objectForKey:@"statue"] intValue];
        NSString *message = nil;
        switch(code){
            case 0:
            {
                if([self.delegate respondsToSelector:@selector(payForBuyGoodsSuccess)])
                {
                    [self.delegate payForBuyGoodsSuccess];
                }
                [self httpDJBPay];
                [self handleUMevent2];
            }
                break;
            case -2:
            {
                message = @"您已取消了支付操作！";
                [Tool showPromptContent:message onView:self.view];
                [self handleUMevent];
                
            }
                break;
            default:
            {
                message = @"很遗憾，您此次支付失败，请您重新支付！";
                [Tool showPromptContent:message onView:self.view];
                [self handleUMevent];
            }
                break;
        }
    }
}

- (void)receivepSafariOpenNotif:(NSNotification *)notif
{
    if([self.delegate respondsToSelector:@selector(payForBuyGoodsSuccess)])
    {
        [self.delegate payForBuyGoodsSuccess];
    }
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"付款成功了，在个人中心里可查看您的购宝记录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aler show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self clickLeftItemAction:nil];
    
}

#pragma mark - SelectCouponsViewControllerDelegate 

- (void)selectCouponsWithID:(NSString *)couponsIdStr couponsName:(NSString *)couponsName value:(double)value
{
    couponsId = couponsIdStr;
    
    if (!couponsId) {
        _couponLabel.text = @"点击选取";
        payMoney = _moneyNum;
        _payAllMoney.text = [NSString stringWithFormat:@"%.0f购宝币",payMoney];
    }
    else{
        _couponLabel.text = couponsName;
        payMoney = _moneyNum - value;
        if (payMoney <= 0) {
            payMoney = 0;
        }
        _payAllMoney.text = [NSString stringWithFormat:@"%.0f购宝币",payMoney];
    }
}

#pragma mark -  PayResultViewControllerDelegate <NSObject>

- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
