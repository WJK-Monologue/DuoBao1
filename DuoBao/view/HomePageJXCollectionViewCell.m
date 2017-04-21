//
//  HomePageJXCollectionViewCell.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "HomePageJXCollectionViewCell.h"

@implementation HomePageJXCollectionViewCell

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
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HomePageJXCollectionViewCell" owner:self options:nil];
        
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
        if (WIDTH==375) {
            
            self.proname = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*6, FitHEIGHT*80, FitWIDTH*135, FitHEIGHT*35)];
            self.proname.text = @"产品名称";
            self.proname.numberOfLines = 0;
            self.proname.font = [UIFont systemFontOfSize:13];
            [self addSubview:self.proname];
            
            self.proprice = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*132, FitHEIGHT*100, FitWIDTH*50, FitHEIGHT*15)];
            self.proprice.text = @"价格";
            self.proprice.font = [UIFont systemFontOfSize:12];
            self.proprice.textColor = [UIColor redColor];
            [self addSubview:self.proprice];
            
            self.oneL = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*6, FitHEIGHT*130, FitWIDTH*50, FitHEIGHT*20)];
            self.oneL.font = [UIFont systemFontOfSize:13];
            self.oneL.text = @"一人次:";
            [self.contentView addSubview:self.oneL];
            
            self.onePri = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*56, FitHEIGHT*130, FitWIDTH*40, FitHEIGHT*20)];
            self.onePri.font = [UIFont systemFontOfSize:13];
            self.onePri.textColor = [UIColor redColor];
            [self.contentView addSubview:self.onePri];
            //
            self.tatalL = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*96, FitHEIGHT*130, FitWIDTH*60, FitHEIGHT*20)];
            self.tatalL.font = [UIFont systemFontOfSize:13];
            self.tatalL.text = @"总需人数:";
            [self.contentView addSubview:self.tatalL];
            //
            self.numL = [[UILabel alloc]initWithFrame:CGRectMake (FitWIDTH*156, FitHEIGHT*130, FitWIDTH*25, FitHEIGHT*20)];
            self.numL.font = [UIFont systemFontOfSize:13];
            self.numL.textColor = [UIColor redColor];
            [self.contentView addSubview:self.numL];
        }
        else if(WIDTH == 414){
            
            self.proname = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*6, FitHEIGHT*76, FitWIDTH*135, FitHEIGHT*35)];
            self.proname.text = @"产品名称";
            self.proname.numberOfLines = 0;
            self.proname.font = [UIFont systemFontOfSize:13];
            [self addSubview:self.proname];
            
            self.proprice = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*132, FitHEIGHT*91, FitWIDTH*50, FitHEIGHT*15)];
            self.proprice.text = @"价格";
            self.proprice.font = [UIFont systemFontOfSize:12];
            self.proprice.textColor = [UIColor redColor];
            [self addSubview:self.proprice];
            
            self.oneL = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*6, FitHEIGHT*120, FitWIDTH*50, FitHEIGHT*20)];
            self.oneL.font = [UIFont systemFontOfSize:13];
            self.oneL.text = @"一人次:";
            [self.contentView addSubview:self.oneL];
            
            self.onePri = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*50, FitHEIGHT*120, FitWIDTH*40, FitHEIGHT*20)];
            self.onePri.font = [UIFont systemFontOfSize:13];
            self.onePri.textColor = [UIColor redColor];
            [self.contentView addSubview:self.onePri];
            //
            self.tatalL = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*96, FitHEIGHT*120, FitWIDTH*60, FitHEIGHT*20)];
            self.tatalL.font = [UIFont systemFontOfSize:13];
            self.tatalL.text = @"总需人数:";
            [self.contentView addSubview:self.tatalL];
            //
            self.numL = [[UILabel alloc]initWithFrame:CGRectMake (FitWIDTH*156, FitHEIGHT*120, FitWIDTH*25, FitHEIGHT*20)];
            self.numL.font = [UIFont systemFontOfSize:13];
            self.numL.textColor = [UIColor redColor];
            [self.contentView addSubview:self.numL];
        }
    }
    return self;
}

@end
