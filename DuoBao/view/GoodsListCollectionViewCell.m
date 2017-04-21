//
//  GoodsListCollectionViewCell.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "GoodsListCollectionViewCell.h"
#import "BeatViewController.h"

@implementation GoodsListCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GoodsListCollectionViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        
        //改动 首页的商品列表详情
        /*
        self.oneLab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*8, HEIGHT/667*148, WIDTH/375*50, HEIGHT/667*12)];
        self.oneLab.font = [UIFont systemFontOfSize:12];
        self.oneLab.text = @"一 人 次:";
       //[self.contentView addSubview:self.oneLab];
        
        self.onePrice = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*58, HEIGHT/667*148, WIDTH/375*30, HEIGHT/667*12)];
        self.onePrice.font = [UIFont systemFontOfSize:12];
        self.onePrice.textColor = [UIColor redColor];
        //[self.contentView addSubview:self.onePrice];
//
        self.tatalLab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*8, HEIGHT/667*165, WIDTH/375*50, HEIGHT/667*12)];
        self.tatalLab.font = [UIFont systemFontOfSize:12];
        self.tatalLab.text = @"总需人数:";
        //[self.contentView addSubview:self.tatalLab];
//
        self.numLab = [[UILabel alloc]initWithFrame:CGRectMake (WIDTH/375*58, HEIGHT/667*165, WIDTH/375*30, HEIGHT/667*12)];
        self.numLab.font = [UIFont systemFontOfSize:12];
        //[self.contentView addSubview:self.numLab];
        */
        if (WIDTH==375)
        {
            self.canyu = [UIButton buttonWithType:UIButtonTypeCustom];
            self.canyu.frame = CGRectMake(FitWIDTH*107, FitHEIGHT*165, FitWIDTH*73, FitHEIGHT*28);
            [self.canyu addTarget:self action:@selector(canyuAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.canyu setImage:[UIImage imageNamed:@"now_btn"] forState:UIControlStateNormal];
            [self addSubview:self.canyu];
        }
        else if(WIDTH==414)
        {
            self.canyu = [UIButton buttonWithType:UIButtonTypeCustom];
            self.canyu.frame = CGRectMake(FitWIDTH*107, FitHEIGHT*148, FitWIDTH*73, FitHEIGHT*28);
            [self.canyu setImage:[UIImage imageNamed:@"now_btn"] forState:UIControlStateNormal];
            [self addSubview:self.canyu];
        }
    }
    return self;
}

#pragma mark - 首页立即参与

-(void)canyuAction:(UIButton *)sender
{
    sender.userInteractionEnabled = YES;
    if (self.ABdelegate && [self.ABdelegate respondsToSelector:@selector(jumpWebVC:)]) {
        [self.ABdelegate jumpWebVC:sender];
    }
}


@end
