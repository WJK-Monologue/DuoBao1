//
//  chongzhiAlertView.m
//  DuoBao
//
//  Created by Macintosh on 2017/4/10.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "chongzhiAlertView.h"
#import "UIColor+extention.h"

@implementation chongzhiAlertView
{
    NSArray *btnAry;
    NSMutableArray *muAry;
    UITextField *textMoney;
}
-(id)initWithCzBtn:(UIImage *)Czbtn Cztitle:(UIImage *)Cztitle
{
    self = [super init];
    if (self) {
        
        muAry = [NSMutableArray array];
        
        //添加阴影效果
        self.frame = [UIScreen mainScreen].bounds;
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc]initWithEffect:effect];
        effectview.frame = [UIScreen mainScreen].bounds;
        [self addSubview:effectview];
       //背景框
        UIImageView *Czbgimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*48, FitHEIGHT*63, WIDTH-FitWIDTH*96, FitHEIGHT*213)];
        Czbgimg.userInteractionEnabled = YES;
        Czbgimg.image = [UIImage imageNamed:@"cz_bg.png"];
        [self addSubview:Czbgimg];
        //关闭
        UIButton *Czright = [UIButton buttonWithType:UIButtonTypeCustom];
        Czright.frame = CGRectMake(FitWIDTH*302, FitHEIGHT*55, FitWIDTH*29, FitWIDTH*29);
        [Czright setImage:Czbtn forState:UIControlStateNormal];
        [Czright addTarget:self action:@selector(Czright) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:Czright];
        //标题
        UIImageView *Cztitleimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*5, FitHEIGHT*7.5, WIDTH-FitWIDTH*106, FitHEIGHT*34)];
        Cztitleimg.image = Cztitle;
        [Czbgimg addSubview:Cztitleimg];
        
        UIImageView *CzMoney = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*17, FitHEIGHT*49, FitWIDTH*78, FitHEIGHT*13.5)];
        CzMoney.image = [UIImage imageNamed:@"cz_txt01.png"];
        [Czbgimg addSubview:CzMoney];
        
        btnAry = @[@"5",@"10",@"30",@"50",@"100"];
        for (int i=0; i<5; i++) {
            UIButton *btnMoney = [[UIButton alloc]initWithFrame:CGRectMake(FitWIDTH*17+i%3*FitWIDTH*(26+64), FitHEIGHT*69+i/3*FitHEIGHT*(22+8), FitWIDTH*64, FitHEIGHT*22)];
            [btnMoney setBackgroundImage:[UIImage imageNamed:@"numb_bord"] forState:UIControlStateNormal];
             [btnMoney setBackgroundImage:[UIImage imageNamed:@"numb_bord_on"] forState:UIControlStateSelected];
            [btnMoney setTitle:[NSString stringWithFormat:@"%@",btnAry[i]] forState:UIControlStateNormal];
            [btnMoney setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnMoney.tag = i+1;
            btnMoney.selected = NO;
            if (btnMoney.tag == 1) {
                btnMoney.selected = YES;
            }
            [btnMoney addTarget:self action:@selector(selsctMoney:) forControlEvents:UIControlEventTouchUpInside];
            [Czbgimg addSubview:btnMoney];
            [muAry addObject:btnMoney];
        }
        
        textMoney = [[UITextField alloc]initWithFrame:CGRectMake(FitWIDTH*17+5%3*FitWIDTH*(26+64), FitHEIGHT*69+5/3*FitHEIGHT*(22+8), FitWIDTH*64, FitHEIGHT*22)];
        textMoney.borderStyle = UITextBorderStyleNone;
        textMoney.background = [UIImage imageNamed:@"numb_bord.png"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:@"其他金额" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:93/255.0 green:106/255.0 blue:157/255.0 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        textMoney.textAlignment = NSTextAlignmentCenter;
        textMoney.attributedPlaceholder = attrString;
        textMoney.textColor = [UIColor whiteColor];
        textMoney.keyboardType = UIKeyboardTypeNumberPad;
        [Czbgimg addSubview:textMoney];
        
        UIImageView *selectImg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*17, FitHEIGHT*127, FitWIDTH*73.5, FitHEIGHT*13.5)];
        selectImg.image = [UIImage imageNamed:@"cz_txt02.png"];
        [Czbgimg addSubview:selectImg];
        
        UIButton *zhifubao = [UIButton buttonWithType:UIButtonTypeCustom];
        zhifubao.frame = CGRectMake(FitWIDTH*20.5, FitHEIGHT*148.5, FitWIDTH*110, FitHEIGHT*39);
        [zhifubao setImage:[UIImage imageNamed:@"pay_btn.png"] forState:UIControlStateNormal];
        [zhifubao addTarget:self action:@selector(zhifubaoAction:) forControlEvents:UIControlEventTouchUpInside];
        [Czbgimg addSubview:zhifubao];
        
        UIButton *weixin = [UIButton buttonWithType:UIButtonTypeCustom];
        weixin.frame = CGRectMake(FitWIDTH*150.5, FitHEIGHT*148.5, FitWIDTH*110, FitHEIGHT*39);
        [weixin setImage:[UIImage imageNamed:@"pay_wx_btn.png"] forState:UIControlStateNormal];
        [weixin addTarget:self action:@selector(weixinAction) forControlEvents:UIControlEventTouchUpInside];
        [Czbgimg addSubview:weixin];
        
        UIImageView *instructions = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*65, FitHEIGHT*195, FitWIDTH*147.5, FitHEIGHT*9)];
        instructions.image = [UIImage imageNamed:@"cz_tips.png"];
        [Czbgimg addSubview:instructions];
    }
    return self;
}

//右上角 按钮
-(void)Czright
{
    [self removeFromSuperview];
}
-(void)selsctMoney:(UIButton *)sender
{
    for(UIButton *selectBtn in muAry)
    {
        selectBtn.selected=NO;
    }
    sender.selected=YES;
}

//充值支付宝,微信
-(void)zhifubaoAction:(UIButton *)send
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(zhifubao:)]) {
        [self.delegate zhifubao:send];
}
    NSLog(@"支付宝");
}
-(void)weixinAction
{
    NSLog(@"微信");
}


@end
