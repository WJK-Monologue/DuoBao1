//
//  ThirdViewDown.m
//  DuoBao
//
//  Created by Macintosh on 2017/4/4.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "ThirdViewDown.h"

@implementation ThirdViewDown

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.gamet = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH/375*220, HEIGHT/667*30)];
        self.gamet.center = CGPointMake(WIDTH/2, HEIGHT/667*25);
        self.gamet.font = [UIFont systemFontOfSize:25];
        self.gamet.textAlignment = NSTextAlignmentCenter;
        self.gamet.text = @"本比赛绝对公平公正";
        [self addSubview:self.gamet];
        
        self.numt = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH/375*100, HEIGHT/667*30)];
        self.numt.text = [NSString stringWithFormat:@"已参团人数："];
        self.numt.center = CGPointMake(WIDTH/2, HEIGHT/667*60);
        self.numt.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.numt];
        
        self.relabt = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/0, 0, WIDTH/375*30, HEIGHT/667*30)];
        self.relabt.textColor = [UIColor redColor];
        self.relabt.center = CGPointMake(WIDTH/2+WIDTH/375*50, HEIGHT/667*60);
        self.relabt.textAlignment = NSTextAlignmentCenter;
        self.relabt.backgroundColor = [UIColor cyanColor];
        [self addSubview:self.relabt];
        
        self.regulart = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH/375*100, HEIGHT/667*20)];
        self.regulart.text = @"比赛规则";
        self.regulart.textAlignment = NSTextAlignmentCenter;
        self.regulart.center = CGPointMake(WIDTH/2, HEIGHT/667*100);
        self.regulart.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.regulart];
        
        self.lab1t = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH/375*315, HEIGHT/667*40)];
        self.lab1t.center = CGPointMake(WIDTH/2, HEIGHT/667*135);
        self.lab1t.textAlignment = NSTextAlignmentCenter;
        self.lab1t.text = @"两两对战石头剪刀布三局两胜者竞级下一轮比赛。最终获胜者赢得奖品。";
        self.lab1t.numberOfLines = 0;
        [self addSubview:self.lab1t];
        
        self.imgt = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH/375*200, HEIGHT/667*40)];
        self.imgt.center = CGPointMake(WIDTH/2, HEIGHT/667*175);
        self.imgt.image = [UIImage imageNamed:@"LV"];
        [self addSubview:self.imgt];
        
        self.lab2t = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH/375*315, HEIGHT/667*40)];
        self.lab2t.center = CGPointMake(WIDTH/2, HEIGHT/667*235);
        
        self.lab2t.textAlignment = NSTextAlignmentCenter;
        self.lab2t.text = @"100秒之内如果该商品报名人数没有达到可选择退赛或继续等待。";
        self.lab2t.numberOfLines = 0;
        [self addSubview:self.lab2t];
        
        
    }
    return self;
}



@end
