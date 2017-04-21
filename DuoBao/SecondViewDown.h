//
//  SecondViewDown.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/15.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myAlertView.h"
#import "rivalAlertView.h"
#import "chongzhiAlertView.h"
#import "failuregame.h"
#import "gamewin.h"
#import "wingamelast.h"
#import "lostgamelast.h"
#import "begingame.h"

@interface SecondViewDown : UIView<UITableViewDelegate,UITableViewDataSource,myDelegate,rivalDelegate,chongzhiDelegate,gamewinDelegate,begingameDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,retain)NSMutableArray *puncheAry;
@property (nonatomic,retain)NSMutableArray *newpun;
@property (nonatomic,assign)NSInteger cellNum;

@property (nonatomic,assign) BOOL isappear;  //是否显示
@property (nonatomic,retain) UILabel *leftname;   //用户名
@property (nonatomic,retain) UILabel *rightname;

@property (nonatomic,retain) UIButton *leftuse;   //头像
@property (nonatomic,retain) UIButton *rightuse;
@property (nonatomic,retain) UIImageView *leftborder;
@property (nonatomic,retain) UIImageView *rightborder;


@property (nonatomic,retain) UIImageView *leftimg;  //💰
@property (nonatomic,retain) UIImageView *rightimg;

@property (nonatomic,retain) UIImageView *leftS;    //S
@property (nonatomic,retain) UIImageView *rightS;

@property (nonatomic,retain) UILabel *leftmoney;    //lab
@property (nonatomic,retain) UILabel *rightmoney;
@property (nonatomic,retain) UILabel *leftjf;
@property (nonatomic,retain) UILabel *rightjf;

@property (nonatomic,retain) UIImageView *bord;

@property (nonatomic,retain) UIImageView *leftup;    //边框
@property (nonatomic,retain) UIImageView *rightup;
@property (nonatomic,retain) UIImageView *leftdown;
@property (nonatomic,retain) UIImageView *rightdown;

@property (nonatomic,retain) UIImageView *CZkuang;   //充值框
@property (nonatomic,retain) UIButton *chongzhi;   //充值

@property (nonatomic,retain) UILabel *daojishiLab;  //倒计时lab

@property (nonatomic,retain) UIButton *change;      //随机变化
@property (nonatomic,retain) UIButton *stonebut;     //石头
@property (nonatomic,retain) UIButton *scissorsbut;  //剪刀
@property (nonatomic,retain) UIButton *clothbut;     //布

@property (nonatomic,retain) UIButton *gamerecord;
@property (nonatomic,retain) UIButton *chatmessage;

@property (nonatomic,retain) UIImageView *sorceimg;
@property (nonatomic,retain) UILabel *scorelab;   //比分值

@property (nonatomic,retain) UICollectionView *GamecollecV;     //比赛记录表
@property (nonatomic,retain) UITableView *ChattableV;       //聊天信息
@property (nonatomic,retain) UICollectionView *FacecollecV; //表情瀑布流
@property (nonatomic,retain) UIButton *face;
@property (nonatomic,retain) UIButton *chat;

@property (nonatomic,retain) UIImageView *promotionImg;  //晋级

@property (nonatomic, retain) NSDictionary *userDic;     //单用户
@property (nonatomic, retain) NSDictionary *allUserDicl;  //多用户

@property (nonatomic, retain) gamewin *gamewinAlert;

@end
