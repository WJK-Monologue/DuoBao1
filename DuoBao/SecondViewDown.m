//
//  SecondViewDown.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/15.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "HttpHelper.h"
#import "result.h"
#import "GifView.h"

#import "SecondViewDown.h"
#import "SecondDown.h"
#import "GameCollectionViewCell.h"
#import "SecondDownCollectionViewCell.h"
#import "UserInfo.h"
#import "requestTool.h"
#import "UserInfo.h"
#import "ProductDetailViewController.h"
#import "SocketInteraction.h"

@implementation SecondViewDown
{
    rivalAlertView *rival;
    GameCollectionViewCell *cell;
    SecondDown *sec;
    requestTool *tool;
    NSDictionary *backDic;     //接收服务器返回的数据
    SocketInteraction *sock;
    NSString *duishouId;        //对手ID
    NSDictionary *duishouDic;   //对手信息
    
    //NSInteger _cellNum;    //单元格格数
    int pun;       //出拳   0 石头  2 剪刀  1 布
    
    //NSMutableArray *puncheAry;
    
    
    UIImageView *leftImg;
    UIImageView *rightImg;
    
    int mySource;
    int youSource;
    NSArray *textArray;  //存放聊天信息
    NSArray *faceAry;    //存放表情
    NSString *room;    //存房间
    NSString *mainroom;  //存主房间
    begingame *beginAlert;
    NSArray *giftAry;
    int second;
    NSTimer *Secondtime;
    BOOL issendmessage;
    BOOL isclickface;
}

#pragma mark - 懒加载
-(UICollectionView *)GamecollecV
{
    if (!_GamecollecV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(FitWIDTH*185, FitHEIGHT*27);
        
        _GamecollecV = [[UICollectionView alloc]initWithFrame:CGRectMake(FitWIDTH*162, FitHEIGHT*151, FitWIDTH*185, FitHEIGHT*130)collectionViewLayout:layout];
        _GamecollecV.tag = 10;
        _GamecollecV.delegate = self;
        _GamecollecV.dataSource = self;
        _GamecollecV.backgroundColor = [UIColor clearColor];
        [_GamecollecV registerClass:[GameCollectionViewCell class] forCellWithReuseIdentifier:@"RecoardCollecV"];
    }
    return _GamecollecV;
}
-(UITableView *)ChattableV
{
    if (!_ChattableV) {
        _ChattableV = [[UITableView alloc]initWithFrame:CGRectMake(FitWIDTH*162.5, FitHEIGHT*165, FitWIDTH*184, FitHEIGHT*120) style:UITableViewStylePlain];
        _ChattableV.delegate = self;
        _ChattableV.dataSource = self;
        _ChattableV.layer.borderWidth = 1;
        _ChattableV.alpha = 0;
        _ChattableV.layer.borderWidth = 0;
        //去分割线
        _ChattableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ChattableV.backgroundColor = [UIColor clearColor];
    }
    return _ChattableV;
}

-(UICollectionView *)FacecollecV
{
    if (!_FacecollecV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 1;
        //水平
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(FitWIDTH*184/6, FitHEIGHT*28);
        _FacecollecV = [[UICollectionView alloc]initWithFrame:CGRectMake(FitWIDTH*162.5, FitHEIGHT*165, FitWIDTH*184, FitHEIGHT*120) collectionViewLayout:layout];
        _FacecollecV.dataSource = self;
        _FacecollecV.delegate = self;
        _FacecollecV.tag = 20;
        _FacecollecV.alpha = 0;
        _FacecollecV.backgroundColor = [UIColor clearColor];
        [_FacecollecV registerClass:[SecondDownCollectionViewCell class] forCellWithReuseIdentifier:@"collecV"];
    }
    return _FacecollecV;
}

#pragma mark - 获取对手信息
-(void)getData
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    
    NSString *useid = backDic[@"user_id"];
    NSArray *usersDic = backDic[@"users"];
    for (NSDictionary *small in usersDic)
    {
        if(![small[@"user_id"]isEqualToString:useid])
        {
            duishouId = small[@"user_id"];
        }
    }
    [helper loadUserDetailUserId:duishouId
                         success:^(NSDictionary *resultDic){
                             if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                 //对手详情
                                 duishouDic = resultDic;
                             }
                         }fail:^(NSString *decretion){
                             NSLog(@"数据请求失败");
                         }];
}

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        second = 10;
        isclickface = NO;
        issendmessage = NO;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"down_bg01.png"]];
        _cellNum = 0;   //初始化局数为0
        self.rightname.text = @"";
        self.rightjf.text = @"";
        self.rightmoney.text = @"";
        [self initData];
        
        _isappear = false;
        giftAry = @[@"gift01_on",@"gift02_on",@"gift03_on",@"gift04_on",@"gift05_on",@"gift06_on"];
        faceAry = @[@"cqjb_1",@"cqjb_2",@"cqjb_3",@"cqjb_4",@"cqjb_5",@"cqjb_6",@"cqjb_7",@"cqjb_8",@"cqjb_9",@"cqjb_10",@"cqjb_11",@"cqjb_12",@"cqjb_13",@"cqjb_14",@"cqjb_15",@"cqjb_16",@"cqjb_17",@"cqjb_18",@"cqjb_19",@"cqjb_20"];
        
        //边框
        self.leftup = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*70, FitHEIGHT*24.5, FitWIDTH*75, FitHEIGHT*17)];
        self.leftup.image = [UIImage imageNamed:@"bord"];
        [self addSubview:self.leftup];
        
        self.leftdown = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*70, FitHEIGHT*50, FitWIDTH*75, FitHEIGHT*17)];
        self.leftdown.image = [UIImage imageNamed:@"bord"];
        [self addSubview:self.leftdown];
        
        self.rightup = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*230, FitHEIGHT*24.5, FitWIDTH*75, FitHEIGHT*17)];
        self.rightup.image = [UIImage imageNamed:@"bord"];
        [self addSubview:self.rightup];
        
        self.rightdown = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*230, FitHEIGHT*50, FitWIDTH*75, FitHEIGHT*17)];
        self.rightdown.image = [UIImage imageNamed:@"bord"];
        [self addSubview:self.rightdown];
        
        //钱包
        self.leftimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*62, FitHEIGHT*22, FitWIDTH*21, FitWIDTH*21)];
        self.leftimg.image = [UIImage imageNamed:@"cqd"];
        [self addSubview:self.leftimg];
        
        self.rightimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*292, FitHEIGHT*22, FitWIDTH*21, FitWIDTH*21)];
        self.rightimg.image = [UIImage imageNamed:@"cqd"];
        [self addSubview:self.rightimg];
        
        //S积分
        self.leftS = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*62, FitHEIGHT*47, FitWIDTH*21, FitWIDTH*21)];
        self.leftS.image = [UIImage imageNamed:@"jf"];
        [self addSubview:self.leftS];
        
        self.rightS = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*292, FitHEIGHT*47, FitWIDTH*21, FitWIDTH*21)];
        self.rightS.image = [UIImage imageNamed:@"jf"];
        [self addSubview:self.rightS];
        
        //充值框
        self.CZkuang = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*157, FitHEIGHT*20, FitWIDTH*59, FitHEIGHT*47)];
        self.CZkuang.image = [UIImage imageNamed:@"time_bord"];
        [self addSubview:self.CZkuang];
        
        //倒计时
        self.daojishiLab = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*159, FitHEIGHT*25.5, FitWIDTH*54, FitHEIGHT*15)];
        self.daojishiLab.text = [NSString stringWithFormat:@"%d",second];
        self.daojishiLab.font = [UIFont systemFontOfSize:15];
        self.daojishiLab.textColor = [UIColor whiteColor];
        self.daojishiLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.daojishiLab];
        //Secondtime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireAction) userInfo:nil repeats:YES];
        
        //充值
        self.chongzhi = [UIButton buttonWithType:UIButtonTypeCustom];
        self.chongzhi.frame = CGRectMake(FitWIDTH*159, FitHEIGHT*47, FitWIDTH*54, FitHEIGHT*16.5);
        [self.chongzhi setImage:[UIImage imageNamed:@"Recharge.png"] forState:UIControlStateNormal];
        [self.chongzhi addTarget:self action:@selector(chongzhiAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.chongzhi];
        
        //变化
        self.change = [UIButton buttonWithType:UIButtonTypeCustom];
        self.change.frame = CGRectMake(FitWIDTH*17, FitHEIGHT*178, FitWIDTH*42, FitHEIGHT*40);
        [self.change setImage:[UIImage imageNamed:@"suiji"] forState:UIControlStateNormal];
        [self.change addTarget:self action:@selector(beatAction:) forControlEvents:UIControlEventTouchUpInside];
        self.change.tag = 400;
        [self addSubview:self.change];
        
        //剪刀
        self.scissorsbut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.scissorsbut.frame = CGRectMake(FitWIDTH*39, FitHEIGHT*117, FitWIDTH*42, FitHEIGHT*40);
        [self.scissorsbut setImage:[UIImage imageNamed:@"jiandao"] forState:UIControlStateNormal];
        self.scissorsbut.tag = 100;
        [self.scissorsbut addTarget:self action:@selector(beatAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.scissorsbut];
        
        //石头
        self.stonebut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stonebut.frame = CGRectMake(FitWIDTH*81, FitHEIGHT*178, FitWIDTH*42, FitHEIGHT*40);
        [self.stonebut setImage:[UIImage imageNamed:@"shitou"] forState:UIControlStateNormal];
        self.stonebut.tag = 200;
        [self.stonebut addTarget:self action:@selector(beatAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.stonebut];
        
        //布
        self.clothbut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clothbut.frame = CGRectMake(FitWIDTH*39, FitHEIGHT*243, FitWIDTH*42, FitHEIGHT*40);
        [self.clothbut setImage:[UIImage imageNamed:@"bu"] forState:UIControlStateNormal];
        self.clothbut.tag = 300;
        [self.clothbut addTarget:self action:@selector(beatAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.clothbut];
        
        //边框
        self.bord = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*150, FitHEIGHT*115, FitWIDTH*208, FitHEIGHT*177)];
        self.bord.image = [UIImage imageNamed:@"kuang"];
        [self addSubview:self.bord];
        
        self.sorceimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*229, FitHEIGHT*129, FitWIDTH*51, FitHEIGHT*17)];
        self.sorceimg.image = [UIImage imageNamed:@"score"];
        [self addSubview:self.sorceimg];
        
        //比值
        self.scorelab = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*10, FitHEIGHT, FitWIDTH*32, FitWIDTH*15)];
        self.scorelab.textAlignment = NSTextAlignmentCenter;
        self.scorelab.font = [UIFont systemFontOfSize:10];
        self.scorelab.text = @"0:0";
        [self.sorceimg addSubview:self.scorelab];
        
        self.gamerecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.gamerecord.frame = CGRectMake(FitWIDTH*158, FitHEIGHT*102, FitWIDTH*95, FitHEIGHT*27);
        [self.gamerecord setImage:[UIImage imageNamed:@"menu01_on"] forState:UIControlStateNormal];
        [self.gamerecord addTarget:self action:@selector(gamerecordAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.gamerecord];
        
        self.chatmessage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.chatmessage.frame = CGRectMake(FitWIDTH*253, FitHEIGHT*102, FitWIDTH*95, FitHEIGHT*27);
        [self.chatmessage setImage:[UIImage imageNamed:@"menu02"] forState:UIControlStateNormal];
        [self.chatmessage addTarget:self action:@selector(chatmessageAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.chatmessage];
        //表情和聊天
        self.face = [UIButton buttonWithType:UIButtonTypeCustom];
        self.face.frame = CGRectMake(FitWIDTH*158, FitHEIGHT*139, FitWIDTH*93, FitHEIGHT*21);
        self.face.alpha = 0;
        [self.face setImage:[UIImage imageNamed:@"face_on"] forState:UIControlStateNormal];
        [self.face addTarget:self action:@selector(faceAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.face];
        
        self.chat = [UIButton buttonWithType:UIButtonTypeCustom];
        self.chat.frame = CGRectMake(FitWIDTH*251, FitHEIGHT*139, FitWIDTH*93, FitHEIGHT*21);
        self.chat.alpha = 0;
        [self.chat setImage:[UIImage imageNamed:@"talk"] forState:UIControlStateNormal];
        [self.chat addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.chat];
        
        textArray = @[@"来呀，互相伤害呀",@"呵呵",@"你这样以后没朋友",@"我等到花儿都谢了",@"不要走，决战到天亮"];
        self.promotionImg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*185, FitHEIGHT*301, FitWIDTH*137, FitHEIGHT*25)];
        self.promotionImg.image = [UIImage imageNamed:@"jinji_false"];
        [self addSubview:self.promotionImg];
        
        //添加比赛表
        [self addSubview:self.GamecollecV];
        [self addSubview:self.ChattableV];
        [self addSubview:self.FacecollecV];
        
        sock = [[SocketInteraction alloc]init];
        //通知。  多人的信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(muchPeople:) name:@"rece" object:nil];
        //服务器返回的信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backTo:) name:@"msg" object:nil];
        //开始比赛动画
        beginAlert = [[begingame alloc]init];
        beginAlert.frame = self.frame;
        beginAlert.delegate = self;
        [self addSubview:beginAlert];
        
       // self.GamecollecV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //[_puncheAry removeAllObjects];
            //[self getData];
        //}];
    }
    return self;
}

-(void)muchPeople:(NSNotification *)send
{
    _allUserDicl = send.userInfo;
    NSArray *ary = _allUserDicl[@"data"];
    NSDictionary *leftDic = ary[0];
    NSDictionary *rightDic = ary[1];
    
    if (_isappear == false) {
    self.rightjf.text = @"";
    self.rightmoney.text = @"";
    self.rightname.text = @"";
    self.rightimg.image = [UIImage imageNamed:@""];

    //用户名
    self.leftname = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*13, FitHEIGHT*9, FitWIDTH*40, FitHEIGHT*9)];
    self.leftname.font = [UIFont systemFontOfSize:9];
    self.leftname.text = leftDic[@"nickName"];
    self.leftname.textColor = [UIColor whiteColor];
    [self addSubview:self.leftname];
    
    self.rightname = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*326, FitHEIGHT*9, FitWIDTH*40, FitHEIGHT*9)];
    self.rightname.font = [UIFont systemFontOfSize:9];
    self.rightname.text = rightDic[@"nickName"];
    self.rightname.textColor = [UIColor whiteColor];
    [self addSubview:self.rightname];
    
    self.leftborder = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*7, FitHEIGHT*23, FitWIDTH*47, FitWIDTH*47)];
    self.leftborder.userInteractionEnabled = YES;
    self.leftborder.image = [UIImage imageNamed:@"head_bord"];
    [self addSubview:self.leftborder];
    
    self.rightborder = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*321, FitHEIGHT*23, FitWIDTH*47, FitWIDTH*47)];
    self.rightborder.userInteractionEnabled = YES;
    self.rightborder.image = [UIImage imageNamed:@"head_bord"];
    [self addSubview:self.rightborder];
    
    //左边头像
    self.leftuse = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftuse.frame = CGRectMake(FitWIDTH, FitHEIGHT, FitWIDTH*45, FitWIDTH*45);
    self.leftuse.layer.masksToBounds = YES;
    self.leftuse.layer.cornerRadius = 5;
    //url转图片
    NSString *fileURL = [NSString stringWithFormat:@"%@",leftDic[@"userHeader"]];
    NSData *dateImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    [self.leftuse setImage:[UIImage imageWithData:dateImg] forState:UIControlStateNormal];
    [self.leftuse addTarget:self action:@selector(leftuseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftborder addSubview:self.leftuse];
    
    //右边头像
    self.rightuse = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightuse.frame = CGRectMake(FitWIDTH, FitHEIGHT, FitWIDTH*45, FitWIDTH*45);
    self.rightuse.layer.masksToBounds = YES;
    self.rightuse.layer.cornerRadius = 5;
    //url转图片
    NSString *rightFile = [NSString stringWithFormat:@"%@",rightDic[@"userHeader"]];
    NSData *rightData = [NSData dataWithContentsOfURL:[NSURL URLWithString:rightFile]];
    [self.rightuse setImage:[UIImage imageWithData:rightData] forState:UIControlStateNormal];
    [self.rightuse addTarget:self action:@selector(rightuseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightborder addSubview:self.rightuse];
    
    //lab
    self.leftmoney = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*83, FitHEIGHT*29, FitWIDTH*45, FitHEIGHT*12)];
    self.leftmoney.font = [UIFont systemFontOfSize:10];
    self.leftmoney.text = [NSString stringWithFormat:@"%@",leftDic[@"userMoney"]];
    self.leftmoney.textColor = [UIColor whiteColor];
    [self addSubview:self.leftmoney];
        
    self.leftjf = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*83, FitHEIGHT*53, FitWIDTH*45, FitHEIGHT*12)];
    self.leftjf.font = [UIFont systemFontOfSize:10];
    self.leftjf.text = [NSString stringWithFormat:@"%@",leftDic[@"userScore"]];
    self.leftjf.textColor = [UIColor whiteColor];
    [self addSubview:self.leftjf];
    
        
    self.rightmoney = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*240, FitHEIGHT*29, FitWIDTH*45, FitHEIGHT*12)];
    self.rightmoney.font = [UIFont systemFontOfSize:10];
    self.rightmoney.text = [NSString stringWithFormat:@"%@",rightDic[@"userMoney"]];
    self.rightmoney.textColor = [UIColor whiteColor];
    [self addSubview:self.rightmoney];
    
    self.rightjf = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*240, FitHEIGHT*53, FitWIDTH*45, FitHEIGHT*12)];
    self.rightjf.font = [UIFont systemFontOfSize:10];
    self.rightjf.text = [NSString stringWithFormat:@"%@",rightDic[@"userScore"]];
    self.rightjf.textColor = [UIColor whiteColor];
    [self addSubview:self.rightjf];

        _isappear = true;
    }
    //获取对手信息
    [self getData];
}

#pragma mark 回调通知
-(void)backTo:(NSNotification *)sends
{
    backDic = sends.userInfo;
    NSLog(@"backDic = %@",backDic);

    if ([backDic[@"cmd"]isEqualToString:@"pk_play"]) {
        //延时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [beginAlert removeFromSuperview];
        });
        
        [self detalWithData];
    }
    if ([backDic[@"cmd"]isEqualToString:@"wait_promotion"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"jijingtankuang" object:nil userInfo:backDic];
    }
    
    else if([backDic[@"cmd"]isEqualToString:@"chat"]&&[backDic[@"type"]isEqualToString:@"voice"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:textArray[[backDic[@"message"]intValue]] message:@"" delegate:self cancelButtonTitle:@""otherButtonTitles:@"",nil];
        alert.alertViewStyle=UIAlertViewStyleDefault;
        [alert show];
    }else if([backDic[@"cmd"]isEqualToString:@"chat"]&&[backDic[@"type"]isEqualToString:@"photo"])
    {
        if ([backDic[@"sender"]isEqualToString:backDic[@"user_id"]])
        {
        GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake(FitWIDTH, FitHEIGHT, FitWIDTH*45, FitWIDTH*45) filePath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",faceAry[[backDic[@"message"]intValue]]] ofType:@"gif"]];
        [self.leftborder addSubview:gifView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [gifView removeFromSuperview];
            });
      }else{
            GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake(FitWIDTH, FitHEIGHT, FitWIDTH*45, FitWIDTH*45) filePath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",faceAry[[backDic[@"message"]intValue]]] ofType:@"gif"]];
            [self.rightborder addSubview:gifView];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [gifView removeFromSuperview];
          });
        }
    }
    if([backDic[@"cmd"]isEqualToString:@"chat"]&&[backDic[@"type"]isEqualToString:@"gift"]) {
        if ([backDic[@"sender"]isEqualToString:backDic[@"user_id"]]) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*7, FitHEIGHT*23, FitWIDTH*47, FitWIDTH*47)];
            img.image = [UIImage imageNamed:giftAry[[backDic[@"message"]intValue]]];
            [self addSubview:img];
            [UIView beginAnimations:@"礼物特效" context:(__bridge void *)(img)];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:2];
            [UIView setAnimationRepeatCount:0];
            img.frame = CGRectMake(FitWIDTH*321, FitHEIGHT*23, FitWIDTH*47, FitWIDTH*47);
            [UIView commitAnimations];
        }
        else
        {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*321, FitHEIGHT*23, FitWIDTH*47, FitWIDTH*47)];
            img.image = [UIImage imageNamed:giftAry[[backDic[@"message"]intValue]]];
            [self addSubview:img];
            [UIView beginAnimations:@"礼物特效" context:(__bridge void *)(img)];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:2];
            [UIView setAnimationRepeatCount:0];
            img.frame = CGRectMake(FitWIDTH*7, FitHEIGHT*23, FitWIDTH*47, FitWIDTH*47);
            [UIView commitAnimations];
        }
    }
}

#pragma mark - 剪刀石头布
-(void)beatAction:(UIButton *)btn
{
    if (btn.tag == 100) {
        pun = 2;
    }else if(btn.tag == 200){
        pun = 0;
    }else if(btn.tag == 300){
        pun = 1;
    }else if(btn.tag == 400){
        pun = arc4random()%3;
    }
    
    if (issendmessage == NO) {
        
        NSString *str1 = backDic[@"user_id"];
        
        if (backDic[@"pk_room"][@"room_number"]!=nil&&([room isEqualToString:@""]||![room isEqualToString:backDic[@"pk_room"][@"room_number"]])) {
            room = backDic[@"pk_room"][@"room_number"];
        }
        if(backDic[@"promotion_room_number"]!=nil&&([mainroom isEqualToString:@""]||![mainroom isEqualToString:backDic[@"promotion_room_number"]])){
        }
        NSString *str = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"cmd\":\"pk_play\",\"game_type\":\"1\",\"punches\":\"%d\",\"promotion_room_number\":\"%@\",\"pk_room_number\":\"%@\",\"is_upper_screen\":\"false\"}",str1,pun,mainroom,room];
        
        [sock ConnectionServerMsg:str];
        issendmessage = YES;
    }
}

#pragma mark - 左右头像弹框
-(void)leftuseAction
{
    tool = [[requestTool alloc]init];
    [tool handleUserResultBlock:^(NSDictionary *Dic) {
        
        self.userDic = Dic;
        NSDictionary *dic1 = [self.userDic objectForKey:@"data"];
        
        NSString *fileURL = [NSString stringWithFormat:@"%@",dic1[@"userHeader"]];
        NSData *dateImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
        [self.leftuse setImage:[UIImage imageWithData:dateImg] forState:UIControlStateNormal];
        
        myAlertView *alert = [[myAlertView alloc]initWithRightBtn:[UIImage imageNamed:@"close"] Mytitle:[UIImage imageNamed:@"title"] Head:[UIImage imageWithData:dateImg] Name:[NSString stringWithFormat:@"%@",dic1[@"nickName"]] ID:[NSString stringWithFormat:@"%@",dic1[@"id"]] Sex:@"1" Douzi:[NSString stringWithFormat:@"%@",dic1[@"userMoney"]] Jifen:[NSString stringWithFormat:@"%@",dic1[@"userScore"]] Cishu:[NSString stringWithFormat:@"%@",dic1[@"parlayTime"]] Money:[NSString stringWithFormat:@"%@",dic1[@"peakPrice"]]];
        
        alert.frame = self.frame;
        
        alert.delegate = self;
        [self addSubview:alert];
    }];
}

-(void)rightuseAction
{
    NSDictionary *dic2 = [duishouDic objectForKey:@"data"];
    NSString *fileURL2 = [NSString stringWithFormat:@"%@",dic2[@"userHeader"]];
    NSData *dateImg2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL2]];
    [self.rightuse setImage:[UIImage imageWithData:dateImg2] forState:UIControlStateNormal];
    rival = [[rivalAlertView alloc]initWithRight:[UIImage imageNamed:@"close"] title:[UIImage imageNamed:@"title"] Head:[UIImage imageWithData:dateImg2] Name:[NSString stringWithFormat:@"%@",dic2[@"nickName"]] ID:[NSString stringWithFormat:@"%@",dic2[@"id"]] Sex:@"1" Douzi:[NSString stringWithFormat:@"%@",dic2[@"userMoney"]] Jifen:[NSString stringWithFormat:@"%@",dic2[@"userScore"]] Cishu:[NSString stringWithFormat:@"%@",dic2[@"parlayTime"]] Money:[NSString stringWithFormat:@"%@",dic2[@"peakPrice"]]];
    
    rival.frame = self.frame;
    rival.delegate = self;
    [self addSubview:rival];
}
#pragma mark -协议方法 送礼
-(void)gotogift:(UIButton *)sender
{
    NSString *userid = backDic[@"user_id"];
    
    NSString *giftStr = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"cmd\":\"chat\",\"room_number\":\"%@\",\"message\":\"%ld\",\"type\":\"gift\",\"is_upper_screen\":\"false\"}",userid,room,(long)sender.tag];
    [sock ConnectionServerMsg:giftStr];
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIImageView *img = (__bridge UIImageView *)(context);
    if([animationID isEqualToString:@"礼物特效"])
    {
        [img removeFromSuperview];
    }
}
#pragma mark - 记录表方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FitHEIGHT*120/5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *chatcell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    if(!chatcell)
    {
        chatcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ChatCell"];
        chatcell.textLabel.text = [NSString stringWithFormat:@"%@", textArray[indexPath.row]];
        chatcell.textLabel.font = [UIFont systemFontOfSize:12];
        chatcell.textLabel.textColor = [UIColor whiteColor];
        chatcell.backgroundColor = [UIColor clearColor];
    }
    return chatcell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *userid = backDic[@"user_id"];
    NSString *roomnumber = backDic[@"pk_room"][@"room_number"];
    if(room==nil){
        room = roomnumber;
    }
    NSString *str = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"cmd\":\"chat\",\"room_number\":\"%@\",\"message\":\"%ld\",\"type\":\"voice\",\"is_upper_screen\":\"false\"}",userid,room,(long)indexPath.row];
    [sock ConnectionServerMsg:str];
}

#pragma  mark - 封装石头剪刀布逻辑
- (void)detalWithData
{
    [UserDefault setObject:_allUserDicl forKey:@"winDic"];
    [UserDefault synchronize];
    if(youSource > mySource +2||mySource > youSource +2)
    {
        [self guanbiUser];
    }
    //判断如果game_result不为空  晋级
    if (backDic[@"game_result"] != nil) {
        [self guanbiUser];
        if ([backDic[@"game_result"] isEqualToString:@"1"])
        {
            [self initData];
            [self openUser];
            _gamewinAlert= [[gamewin alloc]init];
            _gamewinAlert.frame = self.frame;
            _gamewinAlert.delegate = self;
            [self addSubview:_gamewinAlert];
            
        }
        return ;
    }
    
    if (backDic[@"no_punches"] != nil||backDic[@"game_record"][@"1"][0][@"inning_result"] != nil)
    {
        NSMutableDictionary *pucheDic = [[NSMutableDictionary alloc]init];
        NSString *str = backDic[@"no_punches"];
        NSDictionary *dicImage = @{@"2":@"jl_icon01",@"0":@"jl_icon",@"1":@"jl_icon02"};
        
        if (str != nil && [str isEqualToString:@"false"]) {
            
            //左边出拳  右边没出空
            NSString *leftPun = [NSString stringWithFormat:@"%d",pun];
            [pucheDic setObject:[UIImage imageNamed:dicImage[leftPun]] forKey:@"left"];
            //关闭交互性
            [self guanbiUser];
            _puncheAry[[backDic[@"inning"] intValue]-1] = pucheDic;
        }
        else if(str != nil && [str isEqualToString:@"true"]){
            //右边在闪，右边出 左边没出
            [pucheDic setObject:@"" forKey:@"right"];
            [pucheDic setObject:@"gif" forKey:@"type"];
            _puncheAry[[backDic[@"inning"] intValue]-1] = pucheDic;
        }
        else
        {
            //结果出来
            [self openUser];
            NSString *user_id = backDic[@"user_id"];
            NSMutableDictionary *game_record = backDic[@"game_record"];
            if (_puncheAry != nil){
                [_puncheAry removeAllObjects];
            }
            else{
                _puncheAry = [NSMutableArray array];
            }
            mySource = 0;
            youSource = 0;
            for (NSString *key in game_record){
                NSMutableArray *dic = [game_record objectForKey:key] ;
                pucheDic = [NSMutableDictionary dictionary];
                for (NSDictionary *small in dic) {
                    if([small[@"user_id"]isEqualToString:user_id])
                    {
                        //更新左边
                        NSString *leftresult = small[@"punches"];
                        [pucheDic setObject:[UIImage imageNamed:dicImage[leftresult]] forKey:@"left"];
                        if ([small[@"inning_result"]isEqualToString:@"1"]) {
                            mySource ++;
                            second = 10;
                        [pucheDic setObject:[UIImage imageNamed:@"win"] forKey:@"results"];
                        }else if([small[@"inning_result"]isEqualToString:@"0"])
                        {
                          [pucheDic setObject:[UIImage imageNamed:@"pingju"] forKey:@"results"];
                            second = 10;
                        }else if([small[@"inning_result"]isEqualToString:@"-1"])
                        {
                          [pucheDic setObject:[UIImage imageNamed:@"lose"] forKey:@"results"];
                            second = 10;
                        }
                    }
                    else
                    {
                        //更新右边
                        NSString *rightresult = small[@"punches"];
                        [pucheDic setObject:[UIImage imageNamed:dicImage[rightresult]] forKey:@"right"];
                        [pucheDic setObject:@"image" forKey:@"type"];
                        if ([small[@"inning_result"]isEqualToString:@"1"]) {
                            youSource++;
                        }
                    }
                }
                [_puncheAry addObject:pucheDic];
            }
            self.scorelab.text = [NSString stringWithFormat:@"%d:%d",mySource,youSource];
        }
        _cellNum = _puncheAry.count;
        _newpun = [NSMutableArray array];
        for(int i = _puncheAry.count-1;i>=0;i--)
        {
            NSDictionary *dic = _puncheAry[i];
            [_newpun addObject:dic];
        }
        [self.GamecollecV reloadData];
    }
}

- (void)initData
{
    youSource = 0;
    mySource = 0;
    self.scorelab.text = [NSString stringWithFormat:@"%d:%d",mySource,youSource];
    
    if (_puncheAry != nil){
        [_puncheAry removeAllObjects];
    }
    else{
        _puncheAry = [NSMutableArray array];
    }
    if (_newpun != nil){
        [_newpun removeAllObjects];
    }
    else{
        _newpun = [NSMutableArray array];
    }
    _cellNum = 0;
    [self.GamecollecV reloadData];
}

- (void)guanbiUser
{
    issendmessage = YES;
    [self.change setImage:[UIImage imageNamed:@"suiji_gray"] forState:UIControlStateNormal];
    [self.stonebut setImage:[UIImage imageNamed:@"shitou_on"] forState:UIControlStateNormal];
    [self.scissorsbut setImage:[UIImage imageNamed:@"jiandao_on"] forState:UIControlStateNormal];
    [self.clothbut setImage:[UIImage imageNamed:@"bu_on"] forState:UIControlStateNormal];
}

- (void)openUser
{
    issendmessage = NO;
    [self.change setImage:[UIImage imageNamed:@"suiji"] forState:UIControlStateNormal];
    [self.stonebut setImage:[UIImage imageNamed:@"shitou"] forState:UIControlStateNormal];
    [self.scissorsbut setImage:[UIImage imageNamed:@"jiandao"] forState:UIControlStateNormal];
    [self.clothbut setImage:[UIImage imageNamed:@"bu"] forState:UIControlStateNormal];
}
#pragma mark 倒计时
-(void)timeFireAction
{
    second--;
    self.daojishiLab.text = [NSString stringWithFormat:@"%d秒",second];
    if (second==0||self.stonebut.userInteractionEnabled==NO||self.scissorsbut.userInteractionEnabled==NO||self.clothbut.userInteractionEnabled==NO) {
        [Secondtime invalidate];
    }
}

#pragma  mark - 纪录瀑布流的方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag==10) {
        return _cellNum;
    }
    return faceAry.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag==10) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecoardCollecV" forIndexPath:indexPath];
        
        cell.PKimage.image = [UIImage imageNamed:@"pk"];
        cell.recoardimage.image = _newpun[indexPath.row][@"left"];
        cell.resultimg.image = _newpun[indexPath.row][@"results"];
        if ([_newpun[indexPath.row][@"type"]isEqualToString:@"gif"])
        {
            NSArray *ary = @[@"jl_icon",@"jl_icon01",@"jl_icon02"];
            NSMutableArray *imgArray = [NSMutableArray array];
            for (int i=0; i<ary.count; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",ary[i]]];
                [imgArray addObject:image];
            }
            cell.rivalimage.animationImages = imgArray;
            cell.rivalimage.animationDuration = 0.5;
            cell.rivalimage.animationRepeatCount = 0;
            [cell.rivalimage startAnimating];
        }else{
            cell.rivalimage.image = _newpun[indexPath.row][@"right"];
        }
        return cell;
    }
    else
    {
        SecondDownCollectionViewCell *collecCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collecV" forIndexPath:indexPath];
        
        collecCell.faceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",faceAry[indexPath.row]]];
        return collecCell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isclickface==YES) {
        if (collectionView.tag == 20) {
            NSString *userid = backDic[@"user_id"];
            NSString *roomnumber = backDic[@"pk_room"][@"room_number"];
            if (room==nil) {
                room = roomnumber;
            }
            NSString *str = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"cmd\":\"chat\",\"room_number\":\"%@\",\"message\":\"%ld\",\"type\":\"photo\",\"is_upper_screen\":\"false\"}",userid,room,(long)indexPath.row];
            [sock ConnectionServerMsg:str];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                isclickface = NO;
            });
        }
    }
}

#pragma mark - 按钮的方法
-(void)gamerecordAction
{
    static int i;
    i = 0;
    i++;
    if (i%2==1) {
        [self.gamerecord setImage:[UIImage imageNamed:@"menu01_on"] forState:UIControlStateNormal];
        [self.chatmessage setImage:[UIImage imageNamed:@"menu02"] forState:UIControlStateNormal];
    }
    else
    {
        [self.gamerecord setImage:[UIImage imageNamed:@"menu01"] forState:UIControlStateNormal];
        [self.chatmessage setImage:[UIImage imageNamed:@"menu02_on"] forState:UIControlStateNormal];
    }
    self.chatmessage.userInteractionEnabled = YES;
    self.sorceimg.alpha = 1;
    self.chat.alpha = 0;
    self.face.alpha = 0;
    self.GamecollecV.alpha = 1;
    self.FacecollecV.alpha = 0;
    self.ChattableV.alpha = 0;
}
-(void)chatmessageAction
{
    static int j;
    j = 0;
    j++;
    if (j%2==1) {
        [self.gamerecord setImage:[UIImage imageNamed:@"menu01"] forState:UIControlStateNormal];
        [self.chatmessage setImage:[UIImage imageNamed:@"menu02_on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.gamerecord setImage:[UIImage imageNamed:@"menu01_on"] forState:UIControlStateNormal];
        [self.chatmessage setImage:[UIImage imageNamed:@"menu02"] forState:UIControlStateNormal];
    }
    self.sorceimg.alpha = 0;
    self.chat.alpha = 1;
    self.face.alpha = 1;
    self.GamecollecV.alpha = 0;
    self.FacecollecV.alpha = 1;
}
-(void)faceAction
{
    static int i;
    i = 0;
    i++;
    if (i%2==1) {
        [self.face setImage:[UIImage imageNamed:@"face_on"] forState:UIControlStateNormal];
        [self.chat setImage:[UIImage imageNamed:@"talk"] forState:UIControlStateNormal];
    }
    else
    {
        [self.face setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [self.chat setImage:[UIImage imageNamed:@"talk_on"] forState:UIControlStateNormal];
    }
    self.chatmessage.userInteractionEnabled = YES;
    self.ChattableV.alpha = 0;
    self.FacecollecV.alpha = 1;
}
-(void)chatAction
{
    static int i;
    i = 0;
    i++;
    if (i%2==1) {
        [self.face setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [self.chat setImage:[UIImage imageNamed:@"talk_on"] forState:UIControlStateNormal];    }
    else
    {
        [self.face setImage:[UIImage imageNamed:@"face_on"] forState:UIControlStateNormal];
        [self.chat setImage:[UIImage imageNamed:@"talk"] forState:UIControlStateNormal];
    }
    self.chatmessage.userInteractionEnabled = NO;
    self.ChattableV.alpha = 1;
    self.FacecollecV.alpha = 0;
}
-(void)chongzhiAction
{
    chongzhiAlertView *alert = [[chongzhiAlertView alloc]initWithCzBtn:[UIImage imageNamed:@"close.png"] Cztitle:[UIImage imageNamed:@"cz_title.png"]];
    alert.frame = self.frame;
    alert.delegate = self;
    [self addSubview:alert];
}

//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"msg" object:nil];
}
@end
