//
//  WinRecoardTableViewCell.m
//  DuoBao
//
//  Created by Macintosh on 2017/4/3.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "WinRecoardTableViewCell.h"

@implementation WinRecoardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.winImg.layer.masksToBounds = YES;
    self.winImg.layer.cornerRadius = 20;
    
    if (WIDTH==375) {
        self.winIp = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*138, FitHEIGHT*75, FitWIDTH*120, FitHEIGHT*21)];
        self.winIp.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.winIp];
    }
    else if(WIDTH==414){
        self.winIp = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*125, FitHEIGHT*66, FitWIDTH*120, FitHEIGHT*21)];
        self.winIp.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.winIp];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
