//
//  GoodsInfoTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *statueImage;   //进行中
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;      // 商品名字
@property (weak, nonatomic) IBOutlet UIView *processView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *processLabel;
@property (weak, nonatomic) IBOutlet UILabel *allNumLabel;      //总需0人次
@property (weak, nonatomic) IBOutlet UILabel *needNumLabel;    //剩余0
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;      //一人次＝1购宝币

@property (weak, nonatomic) IBOutlet UILabel *noJionLabel;      //你还没有参与本次
@property (weak, nonatomic) IBOutlet UILabel *selfJoinNumLabel; //参与10人次
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selfJoinWidth;
@property (weak, nonatomic) IBOutlet UIButton *lookNumButton;    //点击查看
@property (weak, nonatomic) IBOutlet UIControl *JoinNumMoreView;

@property (weak, nonatomic) IBOutlet UIView *joinNumLessView;
@property (weak, nonatomic) IBOutlet UILabel *duobaoNumLabel;

@property (weak, nonatomic) IBOutlet UIView *daojishiViw;    //系统揭晓中，请稍后...
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel; 
@property (weak, nonatomic) IBOutlet UILabel *sendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *daojieshiWarnLabel;

@property (weak, nonatomic) IBOutlet UIButton *jsxqButton;    //计算详情按钮

//改动
@property (nonatomic, retain) UIButton *sharebtn;   //分享
@property (nonatomic, retain) UILabel *sharelab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;   //价格
@property (weak, nonatomic) IBOutlet UIButton *involved;   //立即参与

@property (weak, nonatomic) IBOutlet UILabel *onecount;   //一个人次
@property (weak, nonatomic) IBOutlet UILabel *oneprice;   //一人价格
@property (weak, nonatomic) IBOutlet UILabel *totalcount;  //总人数
@property (weak, nonatomic) IBOutlet UILabel *numcount;     //人数



@end
