//
//  SafariViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/12.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "SafariViewController.h"
#import "RotaryGameRecordViewController.h"
#import "LoginViewController.h"
#import "ZhaomuTudiViewController.h"
#import "GoodsDetailInfoViewController.h"
#import "WQJXViewController.h"
#import "CZViewController.h"
#import "ZJRecordViewController.h"
#import "NJKWebViewProgressView.h"

@interface SafariViewController ()
{
    UIActivityIndicatorView* activityIndicator;
    NSArray *arr;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;

}

@end

@implementation SafariViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.scalesPageToFit = YES;
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
   // NSURL *url = [NSURL URLWithString:@"http://192.168.4.74:8020/sss/ios.html"];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [_webView loadRequest:request];
    arr=[[NSArray alloc]init];
    [self initVariable];
    [self rightItemView];
    //self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
   
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoshouye2:) name:@"fenxiangchenggong" object:nil];

}



-(void)gotoshouye2:(NSNotification *)sender
{

//   [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"shareOK('%@')",[NSString stringWithFormat:@"%@",[ShareManager shareInstance].userinfo.id]]];
//    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *alertJS=@"alert('test js OC')"; //准备执行的js代码
//    [context evaluateScript:alertJS];//通过oc方法调用js的alert
    NSString *jsStr = [NSString stringWithFormat:@"shareOK('%@')",[ShareManager shareInstance].userinfo.id];
    [_webView stringByEvaluatingJavaScriptFromString:jsStr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    

    
    NSURL *urlstr=[NSURL URLWithString:_urlStr];

    [_webView loadRequest:[NSURLRequest requestWithURL:urlstr]];
    _webView.scrollView.bounces = NO;
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
//    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(FullScreen.size.width/2-40, FullScreen.size.height/2-60, 80, 80)];
//    activityIndicator.backgroundColor = [UIColor clearColor];
//    activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
//    activityIndicator.layer.masksToBounds =YES;
//    activityIndicator.layer.cornerRadius = 10;
//    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//    [activityIndicator startAnimating];
//    [self.view addSubview:activityIndicator];
   
    
}
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
    [btnMoreItem setTitle:@"刷新" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0,8)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    if (_webView.canGoBack) {
        [_webView goBack];//返回前一画面
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)clickRightItemAction:(id)sender
{
//    RotaryGameRecordViewController *vc = [[RotaryGameRecordViewController alloc]initWithNibName:@"RotaryGameRecordViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    [_webView reload];
    [self initVariable];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

- (void)call{
    
    // 之后在回调js的方法Callback把内容传出去    改动
    JSValue *IOSgetID = self.jsContext[@"IOSCallbackID"];
//    JSValue *IOSgetID = self.jsContext[@"quanmingoubao"];

    //传值给web端

    NSString *userid =[ShareManager shareInstance].userinfo.id;
    
    [IOSgetID callWithArguments:@[userid]];
}

-(void)call2
{
    JSValue *IOSgetID2 = self.jsContext[@"IOSCallbackInAPP"];
    //传值给web端
    
    [IOSgetID2 callWithArguments:@[@"true"]];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
   
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"getUserId"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    self.jsContext[@"isInAPP"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
   
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    NSString *jsStr = [NSString stringWithFormat:@"IOSsendId('%@')",[ShareManager shareInstance].userinfo.id];
    [_webView stringByEvaluatingJavaScriptFromString:jsStr];
   
    NSString *jsStr2 = [NSString stringWithFormat:@"IOSgetId('%@')",[ShareManager shareInstance].userinfo.id];
    
    [_webView stringByEvaluatingJavaScriptFromString:jsStr2];
   
    
    context[@"gotoShop"] = ^() {
        NSArray *args = [JSContext currentArguments];
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        
        vc.goodId = [NSString stringWithFormat:@"%@",[args objectAtIndex:0]];
        //vc.st=1;
        NSLog(@"%@",[args objectAtIndex:0]);
        [self.navigationController pushViewController:vc animated:YES];
        
    };
     context[@"gotoAllRecord"] = ^() {
        NSArray *args = [JSContext currentArguments];
        WQJXViewController *vc =[[WQJXViewController alloc]initWithNibName:@"WQJXViewController" bundle:nil];
        
        vc.goodId = [NSString stringWithFormat:@"%@",[args objectAtIndex:0]];
        
        [self.navigationController pushViewController:vc animated:YES];
    };
    context[@"gotoPay"] = ^() {
       
        CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
        
         NSArray *args = [JSContext currentArguments];
        if ([[[args objectAtIndex:0]toString] isEqualToString:@"50"]) {
            vc.mon=3;
            [self.navigationController pushViewController:vc animated:YES];

        }
        else if ([[[args objectAtIndex:0]toString] isEqualToString:@"5"])
        {
            vc.mon=10;
            [self.navigationController pushViewController:vc animated:YES];

        }
        else if ([[[args objectAtIndex:0]toString] isEqualToString:@"10"])
        {
            vc.mon=6;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([[[args objectAtIndex:0]toString] isEqualToString:@"30"])
        {
            vc.mon=5;
            [self.navigationController pushViewController:vc animated:YES];

        }else if ([[[args objectAtIndex:0]toString] isEqualToString:@"100"])
        {
            vc.mon=2;
             [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            vc.mon=7;
            vc.chosemoney=[[args objectAtIndex:0]toString];
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    };
    context[@"gotoLogin"] = ^() {
       
        [Tool loginWithAnimated:YES viewController:nil];

    };
    context[@"gotoMyRecord"] = ^() {
        
        
        ZJRecordViewController *vc = [[ZJRecordViewController alloc]initWithNibName:@"ZJRecordViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    
    };
    
    context[@"gotoHome"]=^()
    {
         [self performSelector:@selector(re:) withObject:nil afterDelay:0];
        
    };
    
    context[@"gotoShare1"] = ^() {
        [ShareManager shareInstance].shareType = 3;
       
        if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
          
             UIView *vieww=[[UIView alloc]initWithFrame:CGRectMake(0,self.webView.frame.size.height/2, 20, 20)];
             [self.webView addSubview:vieww];

            [Tool shareMessageToOtherApp:nil
                             description:[NSString stringWithFormat:@"赶快来下载全民购宝App！我的推荐码:%@",[ShareManager shareInstance].userinfo.id]
                                titleStr:@"全民购宝App！"
                                shareUrl:[NSString stringWithFormat:@"%@%@user_id=%@",URL_ShareServer,Wap_ShareDuobao,[ShareManager shareInstance].userinfo.id]
                                fromView:vieww];
        }else
        {
            [Tool shareMessageToOtherApp:nil
                             description:[NSString stringWithFormat:@"赶快来下载全民购宝App！我的推荐码:%@",[ShareManager shareInstance].userinfo.id]
                                titleStr:@"全民购宝App！"
                                shareUrl:[NSString stringWithFormat:@"%@%@user_id=%@",URL_ShareServer,Wap_ShareDuobao,[ShareManager shareInstance].userinfo.id]
                                fromView:self.webView];
            [self webViewDidFinishLoad:_webView];
        }

    };
    
    context[@"gotoShare2"] = ^() {
     
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
           // NSLog(@"%@", jsVal.toString);
            
        }
        NSLog(@"%@",[args objectAtIndex:0]);
        NSLog(@"%@",[args objectAtIndex:1]);
        NSLog(@"%@",[args objectAtIndex:2]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ShareManager shareInstance].shareType = 3;
            if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
            {
                UIView *vieww=[[UIView alloc]initWithFrame:CGRectMake(0,self.webView.frame.size.height/2, 20, 20)];
                [self.webView addSubview:vieww];
                [Tool shareMessageToOtherApp:nil
                                 description:[[args objectAtIndex:0] toString]
                                    titleStr:[[args objectAtIndex:1] toString]
                                    shareUrl:[[args objectAtIndex:2] toString]
                                    fromView:vieww];
            }
            else
            {
                [Tool shareMessageToOtherApp:nil
                                 description:[[args objectAtIndex:0] toString]
                                    titleStr:[[args objectAtIndex:1] toString]
                                    shareUrl:[[args objectAtIndex:2] toString]
                                    fromView:self.webView];
            }
            //

        });
//
         };
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_progressView removeFromSuperview];
    [activityIndicator stopAnimating];
    NSLog(@"%@",error);
    [Tool showPromptContent:@"加载失败" onView:self.view];
}
-(void)re:(NSNotification *)change
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoshouye" object:nil];
}

@end
