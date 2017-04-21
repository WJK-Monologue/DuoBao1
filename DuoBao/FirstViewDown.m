//
//  FirstViewDown.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/15.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "FirstViewDown.h"
#import "requestTool.h"
#import "UIColor+extention.h"

@implementation FirstViewDown

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"down_bg01.png"]];
        
        self.game = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FitWIDTH*269, FitHEIGHT*28)];
        self.game.center = CGPointMake(WIDTH/2, FitHEIGHT*25);
        self.game.image = [UIImage imageNamed:@"rule_rp"];
        [self addSubview:self.game];
        
        self.border = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FitWIDTH*136, FitHEIGHT*45)];
        self.border.image = [UIImage imageNamed:@"btn01"];
        self.border.center = CGPointMake(WIDTH/2, FitHEIGHT*73.5);
        [self addSubview:self.border];
        
        self.num = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*11.5, FitHEIGHT*10.5, FitWIDTH*80, FitHEIGHT*25)];
        self.num.text = [NSString stringWithFormat:@"已参团人数："];
        self.num.font = [UIFont systemFontOfSize:13];
        self.num.textColor = [UIColor colorWithRGBValue:0*67350 andAlpha:1.0];
        [self.border addSubview:self.num];
        
        self.relab = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*87, FitHEIGHT*10.5, FitWIDTH*12, FitHEIGHT*25)];
        self.relab.textColor = [UIColor redColor];
        self.relab.textAlignment = NSTextAlignmentRight;
        self.relab.font = [UIFont systemFontOfSize:20];
        [self.border addSubview:self.relab];
        
        self.totallab = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*99, FitHEIGHT*10.5, FitWIDTH*25, FitHEIGHT*25)];
        self.totallab.textColor = [UIColor colorWithRGBValue:0*67350 andAlpha:1.0];
        self.totallab.textAlignment = NSTextAlignmentLeft;
        self.totallab.font = [UIFont systemFontOfSize:20];
        [self.border addSubview:self.totallab];
        
        self.rule_bord = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*15, FitHEIGHT*125, FitWIDTH*345, FitHEIGHT*205)];
        self.rule_bord.image = [UIImage imageNamed:@"rule_bord"];
        [self addSubview:self.rule_bord];
        
        self.rule_title = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*106, FitHEIGHT*107, FitWIDTH*162.5, FitHEIGHT*39)];
        self.rule_title.image = [UIImage imageNamed:@"rule_title"];
        [self addSubview:self.rule_title];
        
        self.lab1 = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*22, FitHEIGHT*25, WIDTH/375*302, HEIGHT/667*40)];
        self.lab1.textAlignment = NSTextAlignmentCenter;
        self.lab1.text = @"两两对战石头剪刀布三局两胜者竞级下一轮比赛。最终获胜者赢得奖品。";
        self.lab1.font = [UIFont systemFontOfSize:14];
        self.lab1.textColor = [UIColor whiteColor];
        self.lab1.numberOfLines = 0;
        [self.rule_bord addSubview:self.lab1];
        
        self.img = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*49, FitHEIGHT*70, FitWIDTH*254, FitHEIGHT*33)];
        self.img.image = [UIImage imageNamed:@"rule_jinji"];
        [self.rule_bord addSubview:self.img];
        
        self.lab2 = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*43, FitHEIGHT*112, FitWIDTH*259, HEIGHT/667*40)];
        self.lab2.textAlignment = NSTextAlignmentCenter;
        self.lab2.text = @"100秒之内如果该商品报名人数没有达到可选择退赛或继续等待。";
        self.lab2.font = [UIFont systemFontOfSize:14];
        self.lab2.textColor = [UIColor whiteColor];
        self.lab2.numberOfLines = 0;
        [self.rule_bord addSubview:self.lab2];
        
        self.timeimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*117.5, FitHEIGHT*151, FitWIDTH*110, FitHEIGHT*39)];
        self.timeimg.image = [UIImage imageNamed:@"btn01"];
        [self.rule_bord addSubview:self.timeimg];
        
        self.butTime = [UIButton buttonWithType:UIButtonTypeCustom];
        self.butTime.frame = CGRectMake(FitWIDTH*165, FitHEIGHT*288, FitWIDTH*50, FitHEIGHT*20);
        self.butTime.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.butTime setTitleColor:[UIColor colorWithRGBValue:0*67350 andAlpha:1.0] forState:UIControlStateNormal];
        [self addSubview:self.butTime];
            
    }
    return self;
}

@end
