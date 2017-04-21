//
//  FirstViewDown.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/15.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewDown : UIView

@property (nonatomic,retain) UIImageView *game;   //本比赛绝对公平公正
@property (nonatomic,retain) UIImageView *border; //边框

@property (nonatomic,retain) UILabel *num;    //已报名人数：
@property (nonatomic,retain) UILabel *regular;  //比赛规则

@property (nonatomic,retain) UILabel *relab;  //报名人数
@property (nonatomic,retain) UILabel *totallab;  // 总人数

@property (nonatomic,retain) UIImageView *rule_bord; //规则框
@property (nonatomic,retain) UIImageView *rule_title; //比赛规则

@property (nonatomic,retain) UILabel *lab1;
@property (nonatomic,retain) UIImageView *img;
@property (nonatomic,retain) UILabel *lab2;
@property (nonatomic,retain) UIImageView *timeimg;

@property (nonatomic,retain) UIButton *butTime;  //倒计时100秒


@end
