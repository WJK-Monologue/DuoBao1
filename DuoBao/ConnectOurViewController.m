//
//  ConnectOurViewController.m
//  YCSH
//
//  Created by linqsh on 15/12/17.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import "ConnectOurViewController.h"
#import "SafariViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface ConnectOurViewController ()<UIWebViewDelegate>
{
}

@end

@implementation ConnectOurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)initVariable
{
    self.title = @"联系我们";
    
    _bgWidth.constant = FullScreen.size.width;
    
    _textView.layer.masksToBounds =YES;
    _textView.layer.cornerRadius = 8;
    _textView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _textView.layer.borderWidth = .1f;
    
    _commitButton.layer.masksToBounds =YES;
    _commitButton.layer.cornerRadius = 6;
    
    if ( [ShareManager shareInstance].serverPhoneNum.length > 0 &&  ![[ShareManager shareInstance].serverPhoneNum isEqualToString:@"<null>"]) {
        _phoneLabel.text =  [ShareManager shareInstance].serverPhoneNum;
    }else{
        _phoneLabel.text =  @"";
        _phoneWarnLabel.hidden = YES;
        _phoneButton.hidden = YES;
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

#pragma mark - http

- (void)httpAddFeedBook
{
    NSString *userIdStr = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userIdStr = [ShareManager shareInstance].userinfo.id;
    }else{
        userIdStr = @"";
    }
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"提交中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ConnectOurViewController *weakSelf = self;
    [helper putFeedBackWithUserId:userIdStr
                          content:_textView.text
                          success:^(NSDictionary *resultDic){
                              [HUD hide:YES];
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                  [weakSelf handleloadResult];
                              }else
                              {
                                  [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                              }
                          }fail:^(NSString *decretion){
                              [HUD hide:YES];
                              [Tool showPromptContent:@"网络出错了" onView:self.view];
                          }];
}

- (void)handleloadResult
{
    [Tool showPromptContent:@"提交成功" onView:self.view];
    [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
}

#pragma mark - Action

- (void)clickLeftItemAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickPhoneButton:(id)sender
{
    [[ShareManager shareInstance] dialWithPhoneNumber:[ShareManager shareInstance].serverPhoneNum inView:self.view];
}
- (IBAction)zaixianqq:(id)sender
{
   
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
    {
        //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
        NSString *QQ = @"800800821";
        //调用QQ客户端,发起QQ临时会话
        NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=crm&uin=%@&version=1&src_type=web",QQ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
    
    

}
- (IBAction)guanfang1:(id)sender
{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"188502010",@"7b17aa27446e6d9819cc25fede664729c039141dfac9ab95832875d8e7aab23e"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [[UIApplication sharedApplication] openURL:url];
    

}

- (IBAction)guanfang2:(id)sender
{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"189837971",@"25bd97da34c1deec147c45bc451f9856079e359bd05692c9b70f222497eb80e9"];
    NSURL *url = [NSURL URLWithString:urlStr];
   
    [[UIApplication sharedApplication] openURL:url];
    

}
- (IBAction)weixin:(id)sender
{
    
}



- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"189837971",@"25bd97da34c1deec147c45bc451f9856079e359bd05692c9b70f222497eb80e9"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}





- (BOOL)jonGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"188502010",@"7b17aa27446e6d9819cc25fede664729c039141dfac9ab95832875d8e7aab23e"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}







- (IBAction)fuzhi:(id)sender
{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    
    
    [pab setString:self.phoneLabel.text];
    
    if (pab == nil) {
      [Tool showPromptContent:@"复制成功" onView:self.view];
        
    }else
    {
       [Tool showPromptContent:@"已复制至剪切版" onView:self.view];
    }
}
- (IBAction)fuzhiqq:(id)sender
{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    
    
    [pab setString:self.zaixianqq.text];
    
    if (pab == nil) {
        [Tool showPromptContent:@"复制成功" onView:self.view];
        
    }else
    {
        [Tool showPromptContent:@"已复制至剪切版" onView:self.view];
    }

}

- (IBAction)fuzhiqun1:(id)sender
{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    
    
    [pab setString:self.guanfang1qun.text];
    
    if (pab == nil) {
        [Tool showPromptContent:@"复制成功" onView:self.view];
        
    }else
    {
        [Tool showPromptContent:@"已复制至剪切版" onView:self.view];
    }
}
- (IBAction)fuzhiqun2:(id)sender
{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    
    
    [pab setString:self.guanfang2qun.text];
    
    if (pab == nil) {
        [Tool showPromptContent:@"复制成功" onView:self.view];
        
    }else
    {
        [Tool showPromptContent:@"已复制至剪切版" onView:self.view];
    }

}

- (IBAction)fuzhiweixin:(id)sender
{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    
    
    [pab setString:self.weixin.text];
    
    if (pab == nil) {
        [Tool showPromptContent:@"复制成功" onView:self.view];
        
    }else
    {
        [Tool showPromptContent:@"已复制至剪切版" onView:self.view];
    }
    

}





- (IBAction)clickCommitButton:(id)sender
{
    [Tool hideAllKeyboard];
    if (_textView.text.length < 1 || [_textView.text isEqualToString:@"请写下您的宝贵意见"]) {
        [Tool showPromptContent:@"请写下您的反馈意见" onView:self.view];
        return;
    }
    if(![Tool islogin])
    {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }

    [self httpAddFeedBook];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请写下您的宝贵意见"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <= 0) {
        textView.text = @"请写下您的宝贵意见";
        textView.textColor = [UIColor lightGrayColor];
    }
}

@end
