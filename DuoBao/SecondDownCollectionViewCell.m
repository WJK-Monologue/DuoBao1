//
//  SecondDownCollectionViewCell.m
//  DuoBao
//
//  Created by Macintosh on 2017/4/1.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "SecondDownCollectionViewCell.h"

@implementation SecondDownCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.faceImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 3, 30, 30)];
        [self.contentView addSubview:self.faceImg];
    }
    return  self;
}

@end
