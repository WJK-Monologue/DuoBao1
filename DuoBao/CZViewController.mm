//
//  CZViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CZViewController.h"
#import "CZRecordListViewController.h"
#import "CZResultViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import <IapppayKit/IapppayOrderUtils.h>
#import <IapppayKit/IapppayKit.h>
#import "ZengQianInfo.h"
@interface CZViewController ()<UITextFieldDelegate,IapppayKitPayRetDelegate>
{
    int selectMoney;
    int selectPayType;//0支付宝 1 微信 2爱贝
    double czMoney;
    int type;
    int ts;
    NSString *tyname;
    NSString *tystatus;
    NSMutableArray *dataRese;
    NSString *wxmoneynum;
    NSString *zhifubaonum;
    
}

@end

@implementation CZViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeiXinPayNotif object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
    [self registerNotif];
    [self updatePayTypeUI];
    [self getTypePay];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"充值";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _bgViewWidth.constant = FullScreen.size.width;
    
    _photoImage.clipsToBounds = YES;
    
    _oneButton.layer.masksToBounds =YES;
    _oneButton.layer.cornerRadius = 4;
    
    _twoButton.layer.masksToBounds =YES;
    _twoButton.layer.cornerRadius = 4;
    
    _threeButton.layer.masksToBounds =YES;
    _threeButton.layer.cornerRadius = 4;
    
    _fourButton.layer.masksToBounds =YES;
    _fourButton.layer.cornerRadius = 4;
    
    _fiveButton.layer.masksToBounds =YES;
    _fiveButton.layer.cornerRadius = 4;
    
    _sixTextFiled.layer.masksToBounds =YES;
    _sixTextFiled.layer.cornerRadius = 4;

    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 6;
    
    _oneButton.layer.borderWidth = 1.0f;
    _twoButton.layer.borderWidth = 1.0f;
    _threeButton.layer.borderWidth = 1.0f;
    _fourButton.layer.borderWidth = 1.0f;
     _fiveButton.layer.borderWidth = 1.0f;
    _sixTextFiled.layer.borderWidth = 1.0f;
    
    _moneyButtonWidth.constant = (FullScreen.size.width - 40)/3;
    
    //selectMoney=0;
    
    if (_mon==1) {
        
        _sixTextFiled.text=@"200";
        selectMoney=5;
    }
    else if (_mon==2)
    {
        selectMoney=4;
    }else if (_mon==3)
    {
        selectMoney=3;
    }else if (_mon==4)
    {
        _sixTextFiled.text=@"20";
        selectMoney=5;
    }else if (_mon==5)
    {
        selectMoney=2;
    }else if (_mon==6)
    {
        selectMoney=1;
    }else if (_mon==7)
    {
        
        _sixTextFiled.text=_chosemoney;
        selectMoney=5;
    }
    else
    {
        selectMoney=0;
    }
    
    if (_ttp==1) {
        selectPayType=1;
    }
    if (_ttp==2) {
        selectPayType=0;
    }
    [self updateMoneyLabelStatue];
    
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi])
    {
        _weixinView.hidden=YES;
        _zhifubaoview.hidden=YES;
        _aibeicontrol.frame =CGRectMake(self.aibeicontrol.frame.origin.x, self.aibeicontrol.frame.origin.y-41,self.aibeicontrol.frame.size.width,self.aibeicontrol.frame.size.height);
        _sureButton.frame = CGRectMake(self.sureButton.frame.origin.x, self.sureButton.frame.origin.y-41,self.sureButton.frame.size.width, self.sureButton.frame.size.height);
        _weixinView.enabled=NO;

    }
    else{
       //_aibeiViewTop.constant = 45;
        _weixinView.hidden = NO;
    }
}

- (void)updatePayTypeUI
{
    [_weiXinImage setImage:[UIImage imageNamed:@"cont_noslected.png"] forState:UIControlStateNormal];
    [_alipayImage setImage:[UIImage imageNamed:@"cont_noslected.png"] forState:UIControlStateNormal];
    [_aibeiImage setImage:[UIImage imageNamed:@"cont_noslected.png"] forState:UIControlStateNormal];
    
    if (selectPayType == 0) {
        [_alipayImage setImage:[UIImage imageNamed:@"cont_slected.png"] forState:UIControlStateNormal];
    }else if (selectPayType == 1)
    {
        [_weiXinImage setImage:[UIImage imageNamed:@"cont_slected.png"] forState:UIControlStateNormal];
    }else{
        [_aibeiImage setImage:[UIImage imageNamed:@"cont_slected.png"] forState:UIControlStateNormal];
    }
}

- (void)updateMoneyLabelStatue
{
    _oneButton.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];

    _twoButton.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    _threeButton.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    _fourButton.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    _fiveButton.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
   
    _sixTextFiled.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    
    switch (selectMoney) {
        case 0:
            _oneButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 1:
            _twoButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 2:
            _threeButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 3:
            _fourButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 4:
            _fiveButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        default:
            _sixTextFiled.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
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

- (void)rightItemView
{
    UIView *rightItemView;
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,70, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"充值记录" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,0)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}

//支付成功页面
- (void)presentCZSuccessVC
{
    [ShareManager shareInstance].userinfo.user_money = [ShareManager shareInstance].userinfo.user_money + czMoney;
    //进度支付结果页面
    CZResultViewController *vc = [[CZResultViewController alloc]initWithNibName:@"CZResultViewController" bundle:nil];
    vc.allMoney = czMoney;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -http

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
                   _weixinView.hidden=YES;
                   _zhifubaoview.hidden=YES;
                   _aibeicontrol.frame =CGRectMake(self.aibeicontrol.frame.origin.x, self.aibeicontrol.frame.origin.y-41,self.aibeicontrol.frame.size.width,self.aibeicontrol.frame.size.height);
                   _sureButton.frame = CGRectMake(self.sureButton.frame.origin.x, self.sureButton.frame.origin.y-41,self.sureButton.frame.size.width, self.sureButton.frame.size.height);
                   _weixinView.enabled=NO;
                }
               if ([info.type_name isEqualToString:@"爱贝"]&&[info.type_status isEqual:@"0"]) {
                  _aibeicontrol.hidden= YES;
                   _sureButton.frame = CGRectMake(self.sureButton.frame.origin.x, self.sureButton.frame.origin.y-41,self.sureButton.frame.size.width, self.sureButton.frame.size.height);
                   _weixinview.hidden=YES;
                   
               }
               if ([info.type_name isEqualToString:@"支付宝"]&&[info.type_status isEqual:@"0"]) {
                   _alicontrol.hidden=YES;
                   _weixinView.frame = CGRectMake(self.weixinView.frame.origin.x, self.weixinView.frame.origin.y-41,self.weixinView.frame.size.width, self.weixinView.frame.size.height);
                   _aibeicontrol.frame =  CGRectMake(self.aibeicontrol.frame.origin.x, self.aibeicontrol.frame.origin.y-41, self.aibeicontrol.frame.size.width, self.aibeicontrol.frame.size.height);
                   _sureButton.frame = CGRectMake(self.sureButton.frame.origin.x, self.sureButton.frame.origin.y-41, self.sureButton.frame.size.width,self.sureButton.frame.size.height);
                   _alicontrol.enabled=NO;
                   ts=1;
               }
           }
       }
   } fail:^(NSString *description) {
   }];
}

//获取订单号
- (void)httpGetPayOrderInfo
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak CZViewController *weakSelf = self;
    [helper getOrderNoWithUserId:[ShareManager shareInstance].userinfo.id
                       total_fee:[NSString stringWithFormat:@"%.0f",czMoney]
                 goods_fight_ids:nil
                  goods_buy_nums:nil
                      order_type:@"充值"
                       all_price:[NSString stringWithFormat:@"%.0f",czMoney]
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
    
    if (orderNo && orderNo.length > 0) {
        if(selectPayType == 0){
            
            [self payForAlipayWithOrderInfo:orderNo];
        }else if(selectPayType == 1){
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
    __weak CZViewController *weakSelf = self;
    [helper getWeiXinPayInfoWithOrderNo:orderNo
                              total_fee:[NSString stringWithFormat:@"%.0f",czMoney*100]
                       spbill_create_ip:@"127.0.0.1"
                                   body:@"充值支付"
                                 detail:@"充值支付"
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
    order.productName = @"充值支付"; //商品标题
    order.productDescription = @"充值支付"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",czMoney]; //商品价格
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
        __weak CZViewController *weakSelf = self;
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
       
        [self presentCZSuccessVC];
    }
    else if ([resultCode isEqualToString:@"01"] || [resultCode isEqualToString:@"4000"])
    {
        message = @"很遗憾，您此次支付失败，请您重新支付！";
        [Tool showPromptContent:message onView:self.view];
        
    }else if([resultCode isEqualToString:@"02"] || [resultCode isEqualToString:@"6001"]){
        message = @"您已取消了支付操作！";
        [Tool showPromptContent:message onView:self.view];
        
    }else if([resultCode isEqualToString:@"8000"]){
        message =  @"正在处理中,请稍候查看！";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alter show];
        
        
    }else if([resultCode isEqualToString:@"6002"]){
        message = @"网络连接出错，请您重新支付！";
        [Tool showPromptContent:message onView:self.view];
        
    }
    
}

#pragma mark - weixinPAy

- (void)jumpToWeiXinPay:(NSDictionary *)resultDic {
    
    NSDictionary *dict = [resultDic objectForKey:@"data"];
    NSLog(@"----微信支付%@",dict);
    UInt32 timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *signStr = [NSString stringWithFormat:@"1-appid=%@&noncestr=%@&package=Sign=WXPay&partnerid=%@&prepayid=%@&timestamp=%d&key=%@",WeiXinID,[dict objectForKey:@"nonce_str"],WeiXinPiD,[dict objectForKey:@"prepay_id"],(unsigned int)timestamp,WeiXinAppKey];
    NSString *sign = [Tool encodeUsingMD5ByString:signStr letterCaseOption:UpperLetter];
    
    //调起微信支付
    PayReq* req    = [[PayReq alloc] init];
    req.partnerId  = [dict objectForKey:@"mch_id"];
    req.nonceStr   = [dict objectForKey:@"nonce_str"];
    req.timeStamp  = timestamp;
    req.prepayId   = [dict objectForKey:@"prepay_id"];
    req.package    = @"Sign=WXPay";
    req.sign       = sign;
    [WXApi sendReq:req];
    NSLog(@"2-appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign);
    NSLog(@"%@",signStr);
}

- (void)registerNotif
{
    /**
     *  微信回调监听
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotif:)
                                                 name:kWeiXinPayNotif
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
                [self presentCZSuccessVC];
            }
                break;
            case -2:
            {
                message = @"您已取消了支付操作！";
                [Tool showPromptContent:message onView:self.view];
            }
                break;
            default:
            {
                message = @"很遗憾，您此次支付失败，请您重新支付！";
                [Tool showPromptContent:message onView:self.view];
            }
                break;
        }
    }
}

#pragma mark - 获取爱贝支付参数

//获取爱贝支付参数
- (void)httpGetIPayInfo:(NSString *)orderNo
{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak CZViewController *weakSelf = self;
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
        [Tool showPromptContent:@"充值成功啦" onView:self.view];
        [self performSelector:@selector(presentCZSuccessVC) withObject:nil afterDelay:1.5];
        
        
    }
    else if (statusCode == IAPPPAY_PAYRETCODE_FAILED)
    {
        //支付失败
        NSString *message = @"支付失败";
        [Tool showPromptContent:message onView:self.view];
    }
    else
    {
        //支付取消
        [Tool showPromptContent:@"您已取消支付" onView:self.view];
    }
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightItemAction:(id)sender
{
    CZRecordListViewController *vc = [[CZRecordListViewController alloc]initWithNibName:@"CZRecordListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickMoneyButtonAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    selectMoney = (int)btn.tag;
    [self updateMoneyLabelStatue];
}

- (IBAction)clickALiPayButtonAction:(id)sender
{
    
    selectPayType = 0;
    [self updatePayTypeUI];
    
}

- (IBAction)clickWeiXinButtonAction:(id)sender
{
    selectPayType = 1;
    [self updatePayTypeUI];
}



- (IBAction)clickAiBeiButtonAction:(id)sender
{
    selectPayType = 2;
    [self updatePayTypeUI];
}

- (IBAction)clickSureButtonAction:(id)sender
{

    if (ts ==1) {
      
        return;
    }
   
    
    NSLog(@"%d",selectPayType);
    NSLog(@"%f",czMoney);
    NSLog(@"%d",selectMoney);
    
    if (selectPayType==0&&[_sixTextFiled.text integerValue]<[zhifubaonum intValue]&&!([_sixTextFiled.text integerValue]==0)) {
     
         [Tool showPromptContent:[NSString stringWithFormat:@"支付宝仅支持%@元或以上支付!",zhifubaonum] onView:self.view];
        NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
        return;
    }
    if (selectPayType==1&&[_sixTextFiled.text integerValue]<[wxmoneynum intValue]&&!([_sixTextFiled.text integerValue]==0)) {
         [Tool showPromptContent:[NSString stringWithFormat:@"微信仅支持%@元或以上支付!",wxmoneynum] onView:self.view];
        NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
        return;
    }
    switch (selectMoney) {
        case 0:
            czMoney = 5.0;
            _weixinView.hidden=NO;
            if (selectPayType==0&&czMoney<[zhifubaonum intValue]) {
                [Tool showPromptContent:[NSString stringWithFormat:@"支付宝仅支持%@元或以上支付!",zhifubaonum] onView:self.view];
                NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
                return;
            }
            if (selectPayType==1&&czMoney<[wxmoneynum intValue]) {
                [Tool showPromptContent:[NSString stringWithFormat:@"微信仅支持%@元或以上支付!",wxmoneynum] onView:self.view];
                NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
                return;
            }
            
            break;
        case 1:
            czMoney = 10.0;
            _weixinView.hidden=NO;
            if (selectPayType==0&&czMoney<[zhifubaonum intValue]) {
                [Tool showPromptContent:[NSString stringWithFormat:@"支付宝仅支持%@元或以上支付!",zhifubaonum] onView:self.view];
                NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
                return;
            }
            if (selectPayType==1&&czMoney<[wxmoneynum intValue]) {
                [Tool showPromptContent:[NSString stringWithFormat:@"微信仅支持%@元或以上支付!",wxmoneynum] onView:self.view];
                NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
                return;
            }
            break;
        case 2:
            czMoney = 30.0;
            _weixinView.hidden=NO;
            if (selectPayType==0&&czMoney<[zhifubaonum intValue]) {
                [Tool showPromptContent:[NSString stringWithFormat:@"支付宝仅支持%@元或以上支付!",zhifubaonum] onView:self.view];
                NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
                return;
            }
            if (selectPayType==1&&czMoney<[wxmoneynum intValue]) {
                [Tool showPromptContent:[NSString stringWithFormat:@"微信仅支持%@元或以上支付!",wxmoneynum] onView:self.view];
                NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
                return;
            }
            break;
        case 3:
            czMoney = 50.0;
            _weixinView.hidden=NO;
            if (selectPayType==0&&czMoney<[zhifubaonum intValue]) {
                [Tool showPromptContent:[NSString stringWithFormat:@"支付宝仅支持%@元或以上支付!",zhifubaonum] onView:self.view];
                NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
                return;
            }
            if (selectPayType==1&&czMoney<[wxmoneynum intValue]) {
                [Tool showPromptContent:[NSString stringWithFormat:@"微信仅支持%@元或以上支付!",wxmoneynum] onView:self.view];
                NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
                return;
            }
            break;
        case 4:
            czMoney = 100.0;
            _weixinView.hidden=NO;
            if (selectPayType==0&&czMoney<[zhifubaonum intValue]) {
                [Tool showPromptContent:[NSString stringWithFormat:@"支付宝仅支持%@元或以上支付!",zhifubaonum] onView:self.view];
                NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
                return;
            }
            if (selectPayType==1&&czMoney<[wxmoneynum intValue]) {
                [Tool showPromptContent:[NSString stringWithFormat:@"微信仅支持%@元或以上支付!",wxmoneynum] onView:self.view];
                NSLog(@"===========%ld",[_sixTextFiled.text integerValue]);
                return;
            }
            break;
        default:
        {
            if (_sixTextFiled.text.length < 1)
            {
                [Tool showPromptContent:@"请输入充值金额" onView:self.view];
                return;
            }
            else{
                czMoney = [_sixTextFiled.text doubleValue];
                _weixinView.hidden=NO;
            }
        }
            break;
    }
    
    [self httpGetPayOrderInfo];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    selectMoney = 6;
    [self updateMoneyLabelStatue];
    
    return YES;
}

@end
