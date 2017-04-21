//
//  judge.m
//  huochaicfST
//
//  Created by yuhao on 16/7/25.
//  Copyright © 2016年 yuhao. All rights reserved.
//

#import "judge.h"
#define WIDTH (self.frame.size.width)
#define HEIGHT (self.frame.size.height)
@implementation judge

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        [self drawView];
    }
    return self;
}

-(void)drawView
{
    self.frame = CGRectMake(0,30,500,500);
    self.backgroundColor=[UIColor clearColor];
    UIView *view2= [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT/2-1, 300, 1)];
    view2.backgroundColor =[UIColor grayColor];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(80,10,340,340)];
    [image setImage:[UIImage imageNamed:@"weihu(3)"]];
    
  //  UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2-150,HEIGHT/2+70,120,40)];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/5-50,HEIGHT/2-120,240,300)];
    label.text = [ _content  stringByReplacingOccurrencesOfString:@"" withString:@""];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;

   
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-120,20, 300,300)];

    [button2 addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
  //  button2.backgroundColor =[UIColor blueColor];

    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2-200,150, 70, 30)];
   // button3.backgroundColor =[UIColor blueColor];
    [button3 addTarget:self action:@selector(qq:) forControlEvents:UIControlEventTouchUpInside];

    image.userInteractionEnabled = YES;
    self.userInteractionEnabled=YES;
    [image addSubview:button3];

    [image addSubview:label];
    [self addSubview:image];
    [self addSubview:button2];
    
}
-(void)remove:(UIButton *)sender
{
    //_appStrotUrl=@"https://appsto.re/cn/Mka6eb.i";
//    [self removeFromSuperview];
//    [self performSelector:@selector(re:) withObject:nil afterDelay:0];
      //  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appStrotUrl]];
    exit(0);
}
-(void)qq:(UIButton *)sender
{
    //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
    NSString *QQ = @"800800821";
    //调用QQ客户端,发起QQ临时会话
    NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=crm&uin=%@&version=1&src_type=web",QQ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)Updat:(UIButton *)sender
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appStrotUrl]];
//    exit(0);
}

-(void)move:(UIButton*)sender
{
//    [self removeFromSuperview];
//    [self performSelector:@selector(re:) withObject:nil afterDelay:0];
//exit(0);
}
-(void)re:(NSNotification *)change
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removefrom" object:nil];
}

@end
