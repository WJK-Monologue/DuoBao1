//
//  FirstViewUp.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/15.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "FirstViewUp.h"

@implementation FirstViewUp

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"up_bg_ios.png"]];
        
        self.Cqjb = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.Cqjb setImage:[UIImage imageNamed:@"room_icon"] forState:UIControlStateNormal];
        self.Cqjb.frame = CGRectMake(FitWIDTH*12, FitHEIGHT*74.5, FitWIDTH*163, FitHEIGHT*196);
        [self addSubview:self.Cqjb];
        
        
        self.Hypk = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.Hypk setImage:[UIImage imageNamed:@"room_icon01"] forState:UIControlStateNormal];
        self.Hypk.frame = CGRectMake(FitWIDTH*200, FitHEIGHT*74.5, FitWIDTH*163, FitHEIGHT*196);
        [self addSubview:self.Hypk];
        
    }
    return self;
}

@end
