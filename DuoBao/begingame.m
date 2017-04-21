//
//  begingame.m
//  DuoBao
//
//  Created by Macintosh on 2017/4/12.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "begingame.h"

@implementation begingame

-(instancetype)init
{
    self = [super init];
    if (self) {
    
        //添加阴影效果
        self.frame = [UIScreen mainScreen].bounds;
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc]initWithEffect:effect];
        effectview.frame = [UIScreen mainScreen].bounds;
        [self addSubview:effectview];
        
        UIImageView *beginimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, FitHEIGHT*140.5, WIDTH, FitHEIGHT*95)];
        beginimg.image = [UIImage imageNamed:@"down_start"];
        [self addSubview:beginimg];
    }
    return self;
}

@end
