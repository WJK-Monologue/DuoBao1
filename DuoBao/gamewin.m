//
//  gamewin.m
//  DuoBao
//
//  Created by Macintosh on 2017/4/11.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "gamewin.h"

@implementation gamewin

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tankuang:) name:@"jijingtankuang" object:nil];
        
        //添加阴影效果
        self.frame = [UIScreen mainScreen].bounds;
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc]initWithEffect:effect];
        effectview.frame = [UIScreen mainScreen].bounds;
        [self addSubview:effectview];
    
        UIImageView *waitimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*114.5, FitHEIGHT*94, FitWIDTH*145, FitHEIGHT*19)];
        waitimg.image = [UIImage imageNamed:@"wait"];
        [self addSubview:waitimg];
    }
    return self;
}
-(void)tankuang:(NSNotification *)send
{
    /*  cmd = "wait_promotion";
     code = 0;
     "initial_people_number" = 4;
     "is_upper_screen" = 0;
     "online_people_number" = 2;
     "promotion_room_number" = 000212;
     "room_people_number" = 2;
     "user_id" = 1000024;*/
    if ([send.userInfo[@"room_people_number"]isEqualToString:@"4"])
    {
        UIImageView *comeinimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, FitHEIGHT*123.5, WIDTH, FitHEIGHT*100)];
        comeinimg.image = [UIImage imageNamed:@"jinji_half"];
        [self addSubview:comeinimg];
    }else if([send.userInfo[@"room_people_number"]isEqualToString:@"2"])
    {
        UIImageView *comeinimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, FitHEIGHT*123.5, WIDTH, FitHEIGHT*100)];
        comeinimg.image = [UIImage imageNamed:@"jinji_finals"];
         [self addSubview:comeinimg];
    }
}

-(void)dealloc
{
 [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
