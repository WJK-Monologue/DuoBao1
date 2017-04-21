//
//  GameCollectionViewCell.m
//  DuoBao
//
//  Created by Macintosh on 2017/4/10.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "GameCollectionViewCell.h"

@implementation GameCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgbg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FitWIDTH*142, FitHEIGHT*27)];
        self.imgbg.image = [UIImage imageNamed:@"jilu_bord.png"];
        [self.contentView addSubview:self.imgbg];
        
        //记录自己的
        self.recoardimage = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*16, FitHEIGHT*2, FitWIDTH*23, FitHEIGHT*23)];
        [self.imgbg addSubview:self.recoardimage];
        
        self.PKimage = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*55, FitHEIGHT*5, FitWIDTH*33, FitHEIGHT*20)];
        [self.imgbg addSubview:self.PKimage];
        //记录对手的
        self.rivalimage = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*103.5, FitHEIGHT*2, FitWIDTH*23, FitHEIGHT*23)];
        [self.imgbg addSubview:self.rivalimage];
        
        self.resultimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*142.5, FitHEIGHT, FitWIDTH*25, FitHEIGHT*25)];
        [self.imgbg addSubview:self.resultimg];
        
    }
    return self;
}


@end
