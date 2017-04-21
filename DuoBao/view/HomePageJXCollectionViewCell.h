//
//  HomePageJXCollectionViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageJXCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImage; //图片
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UIView *rewardView;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;    //中奖
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;    //姓名
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidth;

@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;


@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@property (nonatomic,retain) UILabel *proname;
@property (nonatomic,retain) UILabel *proprice;
@property (nonatomic,retain) UILabel *oneL;   //一人次
@property (nonatomic,retain) UILabel *onePri;  //人均价格
@property (nonatomic,retain) UILabel *tatalL;  //总需人次
@property (nonatomic,retain) UILabel *numL;    //总人数


@end
