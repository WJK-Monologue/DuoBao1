//
//  lostgamelast.m
//  DuoBao
//
//  Created by Macintosh on 2017/4/11.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "lostgamelast.h"

@implementation lostgamelast

-(id)init
{
    self = [super init];
    if (self) {
        
        NSDictionary *loserDic = [UserDefault objectForKey:@"winDic"];

        //添加阴影效果
        self.frame = [UIScreen mainScreen].bounds;
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc]initWithEffect:effect];
        effectview.frame = [UIScreen mainScreen].bounds;
        [self addSubview:effectview];
        
        NSArray *Loserary = loserDic[@"data"];
        NSDictionary *LoserleftDic = Loserary[0];
        NSDictionary *LoserrightDic = Loserary[1];
        
        UILabel *onelab = [[UILabel alloc]init];
        onelab.center = CGPointMake(self.width/2, FitHEIGHT*28);
        onelab.bounds = CGRectMake(0, 0, FitWIDTH*335, FitHEIGHT*17);
        onelab.text = @"很遗憾你在决赛中输了，就差那么一点点！";
        onelab.textColor = [UIColor whiteColor];
        [self addSubview:onelab];
        
        UIImageView *bgimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, FitHEIGHT*72, WIDTH, FitHEIGHT*100)];
        bgimg.image = [UIImage imageNamed:@"obyo_bg"];
        [self addSubview:bgimg];
        
        UIImageView *pkimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*154, FitHEIGHT*19, FitWIDTH*66, FitHEIGHT*66)];
        pkimg.image = [UIImage imageNamed:@"win_pk"];
        [bgimg addSubview:pkimg];
        
        //左边
        UILabel *leftuser = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*62, FitHEIGHT*19, FitWIDTH*40, FitHEIGHT*9)];
        leftuser.text = LoserleftDic[@"nickName"];
        leftuser.textColor = [UIColor whiteColor];
        leftuser.font = [UIFont systemFontOfSize:9];
        [bgimg addSubview:leftuser];
        
        UIImageView *leftborder = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*58, FitHEIGHT*33.5, FitWIDTH*47, FitHEIGHT*47)];
        leftborder.image = [UIImage imageNamed:@"head_bord"];
        [bgimg addSubview:leftborder];
        
        
        UIImageView *leftTX = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH, FitHEIGHT, FitWIDTH*45, FitHEIGHT*45)];
        [leftTX sd_setImageWithURL:[NSURL URLWithString:LoserleftDic[@"userHeader"]]];
        leftTX.layer.masksToBounds = YES;
        leftTX.layer.cornerRadius = 5;
        [leftborder addSubview:leftTX];
        
        //右边
        UILabel *rightuser = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*274, FitHEIGHT*19, FitWIDTH*40, FitHEIGHT*9)];
        rightuser.text = LoserrightDic[@"nickName"];
        rightuser.textColor = [UIColor whiteColor];
        rightuser.font = [UIFont systemFontOfSize:9];
        [bgimg addSubview:rightuser];
        
        UIImageView *rightborder = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*269.5, FitHEIGHT*33.5, FitWIDTH*47, FitHEIGHT*47)];
        rightborder.image = [UIImage imageNamed:@"head_bord"];
        [bgimg addSubview:rightborder];
        
        UIImageView *rightTX = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH, FitHEIGHT, FitWIDTH*45, FitHEIGHT*45)];
        [rightTX sd_setImageWithURL:[NSURL URLWithString:LoserrightDic[@"userHeader"]]];
        rightTX.layer.masksToBounds = YES;
        rightTX.layer.cornerRadius = 5;
        [rightborder addSubview:rightTX];
        
        //3按钮
        UIButton *sharefriend = [UIButton buttonWithType:UIButtonTypeCustom];
        sharefriend.frame = CGRectMake(FitWIDTH*132, FitHEIGHT*188, FitWIDTH*110, FitHEIGHT*39);
        [sharefriend setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
        [sharefriend addTarget:self action:@selector(sharessAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sharefriend];
        
        UIButton *onceagain = [UIButton buttonWithType:UIButtonTypeCustom];
        onceagain.frame = CGRectMake(FitWIDTH*65, FitHEIGHT*240, FitWIDTH*110, FitHEIGHT*39);
        [onceagain setImage:[UIImage imageNamed:@"again_btn"] forState:UIControlStateNormal];
        [onceagain addTarget:self action:@selector(beatssAction) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:onceagain];
        
        UIButton *rest = [UIButton buttonWithType:UIButtonTypeCustom];
        rest.frame = CGRectMake(FitWIDTH*198.5, FitHEIGHT*240, FitWIDTH*110, FitHEIGHT*39);
        [rest setImage:[UIImage imageNamed:@"xiuxi_btn"] forState:UIControlStateNormal];
        [rest addTarget:self action:@selector(restssAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rest];
        
        UIImageView *shareDou = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*53, FitHEIGHT*292, FitWIDTH*268, FitHEIGHT*24.5)];
        shareDou.image = [UIImage imageNamed:@"share_txt"];
        [self addSubview:shareDou];
    }
    return self;
}

-(void)restssAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoHomePageLoser)]) {
        [self.delegate gotoHomePageLoser];
    }

    [self removeFromSuperview];
}
-(void)beatssAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(oncegainLoser)]) {
        [self.delegate oncegainLoser];
    }

    [self removeFromSuperview];
}
-(void)sharessAction
{
    [self removeFromSuperview];
}

@end
