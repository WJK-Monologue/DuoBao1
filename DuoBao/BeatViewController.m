//
//  BeatViewController.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/14.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "BeatViewController.h"

#import "FirstViewUp.h"
#import "FirstViewDown.h"
#import "SecondViewDown.h"
#import "ThirdViewDown.h"
#import "requestTool.h"
#import "SocketInteraction.h"
#import "AsyncSocket.h"
#import "requestTool.h"

@interface BeatViewController ()
{    
    FirstViewUp *firstviewup;
    FirstViewDown *firstviewdown;
    SecondViewDown *secondviewdown;
    ThirdViewDown *thirdviewdown;
    
    NSTimer *time;       //倒计时定时器
    int Daojishi;            //100秒
    BOOL stopTime ;
    
    int second;
    NSTimer *Secondtime;
    SocketInteraction *sock;
    requestTool *request;
}
@end

@implementation BeatViewController

#pragma mark - 懒加载
-(UIScrollView *)scrollUp
{
    if (!_scrollUp) {
        _scrollUp = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/2-1)];
        _scrollUp.showsHorizontalScrollIndicator = NO;
        _scrollUp.showsVerticalScrollIndicator = NO;
        _scrollUp.contentOffset = CGPointMake(0, 0);
        _scrollUp.contentSize = CGSizeMake(WIDTH*5, HEIGHT/2-1);
        _scrollUp.pagingEnabled = YES;
        _scrollUp.scrollEnabled = NO;
        
        for(int i = 0;i<5;i++)
        {
            UIView *viUp = [[UIView alloc]initWithFrame:CGRectMake(i*WIDTH, 0, WIDTH, HEIGHT/2-1)];
            viUp.tag = i+1;
            [_scrollUp addSubview:viUp];
        }
    }
    return _scrollUp;
}
-(UIScrollView *)scrollDown
{
    if (!_scrollDown) {
        _scrollDown = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HEIGHT/2, WIDTH, HEIGHT/2)];
        _scrollDown.showsHorizontalScrollIndicator = NO;
        _scrollDown.showsVerticalScrollIndicator = NO;
        _scrollDown.contentOffset = CGPointMake(0, 0);
        _scrollDown.contentSize = CGSizeMake(WIDTH*3, HEIGHT/2);
        _scrollDown.pagingEnabled = YES;
        _scrollDown.scrollEnabled = NO;
        
        for(int i = 0;i<3;i++)
        {
            UIView *viDown = [[UIView alloc]initWithFrame:CGRectMake(i*WIDTH, 0, WIDTH, HEIGHT/2)];
            viDown.tag = i+100;
            [_scrollDown addSubview:viDown];
        }
    }
    return _scrollDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sock = [[SocketInteraction alloc]init];
    request = [[requestTool alloc]init];
    stopTime = false;
    
    //添加滚动视图
    [self.view addSubview:self.scrollUp];
    [self.view addSubview:self.scrollDown];
    [self layoutView];
    
    [self Firstview];
    [self Secondview];
    [self ThirdView];
}
-(void)layoutView
{
    //中间lab
    UILabel *middel = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT/2-1, WIDTH, 1)];
    middel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:middel];
}
//归还积分
- (void)ReturnJinfeng
{
    UserInfo *info = [[UserInfo alloc]init];
    info.id = [ShareManager shareInstance].userinfo.id;
    HttpHelper *helper = [[HttpHelper alloc] init];
    [helper loadReturnJifengUserId:info.id payment:_ReturnMoney productId:_ReturnProductId number:_ReturnNum success:^(NSDictionary *resultDic) {
        NSLog(@".....%@",resultDic);
    } fail:^(NSString *description) {
        NSLog(@".....归还失败");
    }];
}

#pragma mark 第一个界面
-(void)Firstview
{
    UIView *viup1 =(UIView *)[self.scrollUp viewWithTag:1];
    firstviewup = [[FirstViewUp alloc]initWithFrame:CGRectMake(0, 0, viup1.frame.size.width, viup1.frame.size.height)];
    [viup1 addSubview:firstviewup];
    
    [firstviewup.Cqjb addTarget:self action:@selector(firstViewUp) forControlEvents:UIControlEventTouchUpInside];
    
    [firstviewup.Hypk addTarget:self action:@selector(firstViewDown) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *vi1 = [self.view viewWithTag:100];
    firstviewdown = [[FirstViewDown alloc]initWithFrame:CGRectMake(0, 0, vi1.frame.size.width, vi1.frame.size.height)];
    [vi1 addSubview:firstviewdown];
    
    //通知接收值
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receinfoAction:) name:@"msg" object:nil];
    
}
#pragma mark 第二个界面
-(void)Secondview
{
    UIView *vi2 = [self.view viewWithTag:101];
    secondviewdown = [[SecondViewDown alloc]initWithFrame:CGRectMake(0, 0, vi2.frame.size.width, vi2.frame.size.height)];
    [vi2 addSubview:secondviewdown];
    
    second = 10;
    secondviewdown.daojishiLab.text = [NSString stringWithFormat:@"%d",second];
//    Secondtime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireAction) userInfo:nil repeats:YES];
}
#pragma mark 第三个界面
-(void)ThirdView
{
    UIView *vi3 = [self.view viewWithTag:102];
    thirdviewdown = [[ThirdViewDown alloc]initWithFrame:CGRectMake(0, 0, vi3.frame.size.width, vi3.frame.size.height)];
    [vi3 addSubview:thirdviewdown];

}

#pragma  mark - 倒计时  通知接收值 FirstView
- (void)receinfoAction:(NSNotification *)daojiTime
{
    NSDictionary *dicInfo = daojiTime.userInfo;

    if (!stopTime) {
        Daojishi = [dicInfo[@"time"]intValue];
        time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        [firstviewdown.butTime  setTitle:[NSString stringWithFormat:@"%d秒",Daojishi] forState:UIControlStateNormal];
        stopTime = true;
    }
    firstviewdown.relab.text = [NSString stringWithFormat:@"%@",dicInfo[@"online_people_number"]];
    firstviewdown.totallab.text = [NSString stringWithFormat:@"/%@",_peopleNumBeat];
    
    if (dicInfo[@"last_winner_id"]!=nil) {
    
        wingamelast *winlastAlert = [[wingamelast alloc]initWithgoodDic:dicInfo];
        winlastAlert.frame = secondviewdown.frame;
        winlastAlert.delegate = self;
        [secondviewdown addSubview:winlastAlert];
        return ;
    }
    //最终失败
    if (dicInfo[@"last_loser_id"]!=nil) {
        /**/
        lostgamelast *lostAlert = [[lostgamelast alloc]init];
        lostAlert.frame = secondviewdown.frame;
        lostAlert.delegate = self;
        [secondviewdown addSubview:lostAlert];
        return;
    }

    //判断如果game_result不为空  晋级
    if (dicInfo[@"game_result"] != nil) {
        if ([dicInfo[@"game_result"] isEqualToString:@"-1"]) {

            [sock.ay disconnect];
            failuregame *failureAlett = [[failuregame alloc]init];
            failureAlett.frame = secondviewdown.frame;
            failureAlett.delegate = self;
            [secondviewdown addSubview:failureAlett];
        }
        return ;
    }
    
    thirdviewdown.relabt.text = [NSString stringWithFormat:@"%@/%@",dicInfo[@"online_people_number"],dicInfo[@"room_people_number"]];
    
     if (dicInfo[@"online_people_number"]!= nil&&dicInfo[@"room_people_number"]!=nil) {
     int online_people_number = [dicInfo[@"online_people_number"] intValue];
     int room_people_number = [dicInfo[@"room_people_number"] intValue];
     if(online_people_number == room_people_number) {
     [secondviewdown.gamewinAlert removeFromSuperview];
        secondviewdown.isappear = false;
     }
   }
}

-(void)timeFireMethod
{
    Daojishi--;
    [firstviewdown.butTime setTitle:[NSString stringWithFormat:@"%d秒",Daojishi] forState:UIControlStateNormal];

    if (Daojishi < 1) {
        [time invalidate];
        time = nil;
        [firstviewdown.butTime setTitle:@"退赛" forState:UIControlStateNormal];
        [firstviewdown.butTime addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)timeFireAction
{
    second--;
    secondviewdown.daojishiLab.text = [NSString stringWithFormat:@"%d秒",second];
    if (second==0) {
        [Secondtime invalidate];
    }
}

#pragma mark - 按钮绑定方法
-(void)firstViewUp
{
}
-(void)firstViewDown
{
}
//退赛
-(void)backAction
{
    //需要断开链接
    [sock.ay disconnect];
    [self ReturnJinfeng];
    [self dismissViewControllerAnimated:NO completion:nil];
}

//返回scrollView偏移量
- (CGPoint)ScrollViewWithContentOffSetPage:(NSInteger)page{
    return CGPointMake(([UIScreen mainScreen].bounds.size.width) * page, 0);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 休息一下
-(void)gotoHomePageWin
{
    [request haverest];
    //[self dismissViewControllerAnimated:NO completion:nil];
}
-(void)gotoProductFail
{
   [request haverest];
}
-(void)gotoHomePageLoser
{
    [request haverest];
}
#pragma mark - 再战一局
-(void)oncegainWin
{
    NSLog(@"胜利再战一局");
    [UIView animateWithDuration:0.1 animations:^{
        [self.scrollDown setContentOffset:CGPointMake(0, 0)];
    }];
    
    NSDictionary *dataDic = [UserDefault objectForKey:@"datas"];
    [request requestuserId:dataDic[@"userId"] goodId:dataDic[@"goodId"] NumPeople:dataDic[@"peopleNum"] peoplePrice:dataDic[@"peakPrice"]];
    [UserDefault removeObjectForKey:@"datas"];
    [self clearCollectionV];
}
-(void)onceagainFail
{
    NSLog(@"中途再战一局");
    [UIView animateWithDuration:0.1 animations:^{
        [self.scrollDown setContentOffset:CGPointMake(0, 0)];
    }];
    
    NSDictionary *dataDic = [UserDefault objectForKey:@"datas"];
    [request requestuserId:dataDic[@"userId"] goodId:dataDic[@"goodId"] NumPeople:dataDic[@"peopleNum"] peoplePrice:dataDic[@"peakPrice"]];
    [self clearCollectionV];
}
-(void)oncegainLoser
{
    NSLog(@"失败再战一局");
    [UIView animateWithDuration:0.1 animations:^{
        [self.scrollDown setContentOffset:CGPointMake(0, 0)];
    }];
    
    NSDictionary *dataDic = [UserDefault objectForKey:@"datas"];
    [request requestuserId:dataDic[@"userId"] goodId:dataDic[@"goodId"] NumPeople:dataDic[@"peopleNum"] peoplePrice:dataDic[@"peakPrice"]];
    [self clearCollectionV];
}

-(void)zhifubao:(UIButton *)sender
{

}

-(void)clearCollectionV
{
    secondviewdown.cellNum = 0;
    [secondviewdown.newpun removeAllObjects];
    [secondviewdown.puncheAry removeAllObjects];
    [secondviewdown.GamecollecV reloadData];
}

/**/
-(void)dealloc{
 //移除通知
 [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"释放内存");
}


@end
