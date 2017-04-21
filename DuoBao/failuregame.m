//
//  failuregame.m
//  DuoBao
//
//  Created by Macintosh on 2017/4/11.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "failuregame.h"

@implementation failuregame

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
        
        UIImageView *textimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, FitHEIGHT*11.5, WIDTH, FitHEIGHT*94)];
        textimg.image = [UIImage imageNamed:@"lose_txt"];
        [self addSubview:textimg];
        
        UIButton *sharefriend = [UIButton buttonWithType:UIButtonTypeCustom];
        sharefriend.frame = CGRectMake(FitWIDTH*130, FitHEIGHT*116, FitWIDTH*110, FitHEIGHT*39);
        [sharefriend setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
        [sharefriend addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sharefriend];
        
        UIButton *onceagain = [UIButton buttonWithType:UIButtonTypeCustom];
        onceagain.frame = CGRectMake(FitWIDTH*66.5, FitHEIGHT*175, FitWIDTH*110, FitHEIGHT*39);
        [onceagain setImage:[UIImage imageNamed:@"again_btn"] forState:UIControlStateNormal];
        [onceagain addTarget:self action:@selector(beatAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:onceagain];
        
        UIButton *rest = [UIButton buttonWithType:UIButtonTypeCustom];
        rest.frame = CGRectMake(FitWIDTH*197.5, FitHEIGHT*175, FitWIDTH*110, FitHEIGHT*39);
        [rest setImage:[UIImage imageNamed:@"xiuxi_btn"] forState:UIControlStateNormal];
        [rest addTarget:self action:@selector(restAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rest];
        
        UIImageView *shareDou = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*53.5, FitHEIGHT*236, FitWIDTH*268, FitHEIGHT*24.5)];
        shareDou.image = [UIImage imageNamed:@"share_txt"];
        [self addSubview:shareDou];
    }
    return self;
}
-(void)restAction
{
      [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoProductFail)]) {
        [self.delegate gotoProductFail];
    }
    [self removeFromSuperview];
}
-(void)beatAction
{
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onceagainFail)]) {
        [self.delegate onceagainFail];
    }
    [self removeFromSuperview];
}
-(void)shareAction
{
    [self removeFromSuperview];
}

@end
