//
//  SafariViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/12.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "NJKWebViewProgress.h"

@protocol JSObjcDelegate <JSExport>
- (void)call;
- (void)getCall:(NSString *)callString;
-(void)call2;
@end
@interface SafariViewController : UIViewController<UIWebViewDelegate,JSObjcDelegate,NJKWebViewProgressDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *urlStr;
@property (assign, nonatomic) BOOL isRotaryGame;
@property (nonatomic, strong) JSContext *jsContext;
@end
