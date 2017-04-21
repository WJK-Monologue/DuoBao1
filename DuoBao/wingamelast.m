//
//  wingamelast.m
//  DuoBao
//
//  Created by Macintosh on 2017/4/11.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "wingamelast.h"
#import "requestTool.h"

@implementation wingamelast
{
    requestTool *tool;
    NSDictionary *allUser;
}

-(id)initWithgoodDic:(NSDictionary *)goodDic
{
    self = [super init];
    if (self) {
        
        NSDictionary *winDic = [UserDefault objectForKey:@"winDic"];
        NSLog(@"goodDic = %@",winDic);
        
        //添加阴影效果
        self.frame = [UIScreen mainScreen].bounds;
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc]initWithEffect:effect];
        effectview.frame = [UIScreen mainScreen].bounds;
        [self addSubview:effectview];
        
        UIImageView *bgimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, FitHEIGHT*72, WIDTH, FitHEIGHT*100)];
        bgimg.image = [UIImage imageNamed:@"obyo_bg"];
        [self addSubview:bgimg];
        
        UIImageView *pkimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*154, FitHEIGHT*19, FitWIDTH*66, FitHEIGHT*66)];
        pkimg.image = [UIImage imageNamed:@"win_pk"];
        [bgimg addSubview:pkimg];
        
        NSArray *winary = winDic[@"data"];
        NSDictionary *WinleftDic = winary[0];
        NSDictionary *WinrightDic = winary[1];
        
        //左边
        UILabel *leftuser = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*62, FitHEIGHT*19, FitWIDTH*40, FitHEIGHT*9)];
        leftuser.text = WinleftDic[@"nickName"];
        leftuser.font = [UIFont systemFontOfSize:9];
        leftuser.textColor = [UIColor whiteColor];
        [bgimg addSubview:leftuser];
    
        UIImageView *leftborder = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*58, FitHEIGHT*33.5, FitWIDTH*47, FitHEIGHT*47)];
        leftborder.image = [UIImage imageNamed:@"head_bord"];
        [bgimg addSubview:leftborder];
        
        UIImageView *leftTX = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH, FitHEIGHT, FitWIDTH*45, FitHEIGHT*45)];
        [leftTX sd_setImageWithURL:[NSURL URLWithString:WinleftDic[@"userHeader"]]];
        leftTX.layer.masksToBounds = YES;
        leftTX.layer.cornerRadius = 5;
        [leftborder addSubview:leftTX];
        
        //右边
        UILabel *rightuser = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*274, FitHEIGHT*19, FitWIDTH*40, FitHEIGHT*9)];
        rightuser.text = WinrightDic[@"nickName"];;
        rightuser.font = [UIFont systemFontOfSize:9];
        rightuser.textColor = [UIColor whiteColor];
        [bgimg addSubview:rightuser];
        
        UIImageView *rightborder = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*269.5, FitHEIGHT*33.5, FitWIDTH*47, FitHEIGHT*47)];
        rightborder.image = [UIImage imageNamed:@"head_bord"];
        [bgimg addSubview:rightborder];
        
        UIImageView *rightTX = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH, FitHEIGHT, FitWIDTH*45, FitHEIGHT*45)];
        [rightTX sd_setImageWithURL:[NSURL URLWithString:WinrightDic[@"userHeader"]]];
        rightTX.layer.masksToBounds = YES;
        rightTX.layer.cornerRadius = 5;
        [rightborder addSubview:rightTX];

        UILabel *onelab = [[UILabel alloc]init];//117.5
        onelab.center = CGPointMake(self.width/2, FitHEIGHT*19);
        onelab.bounds = CGRectMake(0, 0,FitWIDTH*250, FitHEIGHT*16);
        onelab.text = [NSString stringWithFormat:@"恭喜你获得了%@",goodDic[@"goods_name"]];
        onelab.textColor = [UIColor whiteColor];
        [self addSubview:onelab];
        
        UILabel *twolab = [[UILabel alloc]init];//85
        twolab.bounds = CGRectMake(0, 0,  FitWIDTH*220, FitHEIGHT*16);
        twolab.center = CGPointMake(self.width/2, FitHEIGHT*46);
        twolab.text = @"请稍后到中奖纪录中领取！";
        twolab.textColor = [UIColor whiteColor];
        [self addSubview:twolab];
        
        UIImageView *leftimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*39, FitHEIGHT*159, FitWIDTH*83.5, FitHEIGHT*22)];
        //leftimg.image = [UIImage imageNamed:@"refight"];
        [self addSubview:leftimg];
        
        UIImageView *rightimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*251.5, FitHEIGHT*159, FitWIDTH*83.5, FitHEIGHT*22)];
        //rightimg.image = [UIImage imageNamed:@"leave"];
        [self addSubview:rightimg];
        
        //3按钮
        UIButton *sharefriend = [UIButton buttonWithType:UIButtonTypeCustom];
        sharefriend.frame = CGRectMake(FitWIDTH*132, FitHEIGHT*188, FitWIDTH*110, FitHEIGHT*39);
        [sharefriend setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
        [sharefriend addTarget:self action:@selector(sharesAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sharefriend];
        
        UIButton *onceagain = [UIButton buttonWithType:UIButtonTypeCustom];
        onceagain.frame = CGRectMake(FitWIDTH*65, FitHEIGHT*240, FitWIDTH*110, FitHEIGHT*39);
        [onceagain setImage:[UIImage imageNamed:@"again_btn"] forState:UIControlStateNormal];
        [onceagain addTarget:self action:@selector(beatsAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:onceagain];
        
        UIButton *rest = [UIButton buttonWithType:UIButtonTypeCustom];
        rest.frame = CGRectMake(FitWIDTH*198.5, FitHEIGHT*240, FitWIDTH*110, FitHEIGHT*39);
        [rest setImage:[UIImage imageNamed:@"xiuxi_btn"] forState:UIControlStateNormal];
        [rest addTarget:self action:@selector(restsAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rest];
        
        UIImageView *shareDou = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*53, FitHEIGHT*292, FitWIDTH*268, FitHEIGHT*24.5)];
        shareDou.image = [UIImage imageNamed:@"share_txt"];
        [self addSubview:shareDou];
    }
    return self;
}


-(void)restsAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoHomePageWin)]) {
        [self.delegate gotoHomePageWin];
    }
    [self removeFromSuperview];
}
-(void)beatsAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(oncegainWin)]) {
        [self.delegate oncegainWin];
    }
    [self removeFromSuperview];
}
-(void)sharesAction
{
    [self removeFromSuperview];
}

@end
