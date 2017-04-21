//
//  WkwebViewController.m
//  DuoBao
//
//  Created by 余灏 on 16/12/20.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "WkwebViewController.h"
#import <WebKit/WebKit.h>
@interface WkwebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property(nonatomic, strong)WKWebView *webView;
@end

@implementation WkwebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:@"gotoLogin"];
    [userContentController addScriptMessageHandler:self name:@"getluckNum"];
    
    configuration.userContentController = userContentController;
    
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 18.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    //loadFileURL方法通常用于加载服务器的HTML页面或者JS，而loadHTMLString通常用于加载本地HTML或者JS

    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlstr]]];
    self.webView.UIDelegate = self;
    
    [self.view addSubview:self.webView];
  
   
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //JS调用OC方法
    
    //message.boby就是JS里传过来的参数
    NSLog(@"body:%@",message.body);
    
    if ([message.name isEqualToString:@"gotoLogin"]) {
       
        NSLog(@"denglu");
      
        
    } else if ([message.name isEqualToString:@"gotologin2"]) {
        
       
    }
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.webView evaluateJavaScript:@"getluckNum('18870707070')" completionHandler:nil];
    [self.webView evaluateJavaScript:@"IOSsetId('18870707070')" completionHandler:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
