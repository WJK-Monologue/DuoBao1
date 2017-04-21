//
//  ZoushiViewController.m
//  DuoBao
//
//  Created by 余灏 on 16/11/4.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ZoushiViewController.h"
#import "GoodsDetailInfo.h"
#import <CoreText/CoreText.h>

#import "ZoushiInfo.h"
#import "DuoBaoRecordInfo.h"
#import "zoushiTableViewCell.h"
#import "PayViewController.h"
#import "UIView+Extension.h"
#import "UIColor+Hex.h"
#import "DVLineChartView.h"
#import "ZDProgressView.h"
#import "zoushiview.h"
#import "DBNumViewController.h"
#import "ZFChart.h"
#import "CanyuViewController.h"
#define  WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ZoushiViewController ()<UITableViewDelegate,UITableViewDataSource,ZFGenericChartDataSource, ZFLineChartDelegate,PayViewControllerDelegate,DVLineChartViewDelegate>

{
    GoodsDetailInfo *_goodsDetailInfo;
    DuoBaoRecordInfo *recordinfo;
   NSMutableArray *dataSourceArray;
    NSMutableArray *dataSourceArray2;
    NSMutableArray *recordDataArray;
    NSString *goid;
     int pageNum;
    NSMutableArray *arr;
    NSMutableArray *arr1;
    NSMutableArray *arr5;
    NSMutableArray *arr6;
    NSMutableArray *arr2;
    NSMutableArray *arr3;
    NSMutableArray *arr4;
    UITableView *tableivew;
    NSString *ggid;
    NSString *shengxia;
    zoushiview *zou;
    UIView *backview;
    NSDictionary *diczou;
    NSArray *arr7;
    NSArray *arr8;
    NSString *progress;
    NSString *limit;
    NSString *needpeople;
    NSString *totalqishu;
    UIButton *button;
    NSString *nickname;
    NSString *zongxuyao;
}
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *dataSource;

@property (nonatomic,strong) ZDProgressView *zdProgressView;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic, strong) ZFLineChart * lineChart;

@property (nonatomic, assign) CGFloat height;

@end

@implementation ZoushiViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [self httpGetGoodsDetailInfo];
    [self httpGetSourceData];
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = @"走势图";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //[[NSMutableArray alloc]initWithCapacity:10];
    arr= [[NSMutableArray alloc]init];
    
    arr1=[[NSMutableArray alloc]init];
    arr5=[[NSMutableArray alloc]initWithCapacity:0];
    arr2=[[NSMutableArray alloc]init];
    arr3=[[NSMutableArray alloc]init];
    arr4 =[[NSMutableArray alloc]init];
    arr6=[[NSMutableArray alloc]init];
    diczou =[[NSDictionary alloc]init];
    

    
    
   // [self loadview];
    dataSourceArray = [NSMutableArray array];
    dataSourceArray2=[NSMutableArray array];
    recordDataArray=[NSMutableArray array];
    
    
   // [self loadDuoBaoRecord];
    //_scrollview.frame = CGRectMake(0,64, WIDTH, HEIGHT-);
    _scrollview.contentSize = CGSizeMake(WIDTH, HEIGHT+330);
//    _scrollview.showsVerticalScrollIndicator = FALSE;
//    scrollView.showsHorizontalScrollIndicator = FALSE;
    //是否整页滚动
    _scrollview.bounces = YES;
    // 设置滚动条风格
    _scrollview.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _scrollview.showsHorizontalScrollIndicator = NO;
    // 关闭垂直方向的滚动条
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.delegate = self;
   
    
    //是否整页滚动
   
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,615,WIDTH/7+1,20)];
    label.text = @"期数";
    label.backgroundColor = [UIColor orangeColor];
    label.textColor =[UIColor whiteColor];
    [label setFont:[UIFont systemFontOfSize:10]];
   
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/7+2, 615, WIDTH/6+42, 20)];
    label1.text = @"中奖人";
    label1.textAlignment=NSTextAlignmentCenter;
    label1.backgroundColor = [UIColor orangeColor];
    label1.textColor =[UIColor whiteColor];
    [label1 setFont:[UIFont systemFontOfSize:10]];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/7+WIDTH/6+45, 615, WIDTH/6, 20)];
    label2.text = @"中奖号码";
    label2.textAlignment=NSTextAlignmentCenter;
    label2.backgroundColor = [UIColor orangeColor];
    label2.textColor =[UIColor whiteColor];
    [label2 setFont:[UIFont systemFontOfSize:10]];
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/7+WIDTH/6+WIDTH/6+46, 615, WIDTH/6, 20)];
    label3.text = @"位次";
    label3.textAlignment=NSTextAlignmentCenter;
    label3.backgroundColor = [UIColor orangeColor];
    label3.textColor =[UIColor whiteColor];
    [label3 setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/7+WIDTH/6+WIDTH/6+WIDTH/6+47, 615, WIDTH/6-19, 20)];
    label4.text = @"买入次";
    label4.textAlignment=NSTextAlignmentCenter;
    label4.backgroundColor = [UIColor orangeColor];
    label4.textColor =[UIColor whiteColor];
    [label4 setFont:[UIFont systemFontOfSize:10]];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/7+WIDTH/6+WIDTH/6+WIDTH/6+10+WIDTH/8+34, 615, WIDTH/6-20, 20)];
    label5.textAlignment=NSTextAlignmentCenter;
    label5.text = @"区间段";
    label5.backgroundColor = [UIColor orangeColor];
    label5.textColor =[UIColor whiteColor];
    [label5 setFont:[UIFont systemFontOfSize:10 ]];
    
   
    
    
    [self.scrollview addSubview:label5];
    [self.scrollview addSubview:label4];
    [self.scrollview addSubview:label3];
    [self.scrollview addSubview:label2];
    [self.scrollview addSubview:label1];
    [self.scrollview addSubview:label];
    
    _num.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
    _num.layer.borderWidth = 1.0f;
    _num.text = [NSString stringWithFormat:@"%d",1];
    _stopbu.backgroundColor = [UIColor grayColor];
    _num2.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
    _num2.layer.borderWidth = 1.0f;
   
    

    
    
    _stopbu.enabled= NO;
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 20)];
    [self.slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
  //  [self.view addSubview:self.slider];
    
    self.zdProgressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(0,215,WIDTH, 20)];
    self.zdProgressView.progress = 0;
    self.zdProgressView.text = @"头        |          前          |        中        |         后       |          尾";
    self.zdProgressView.textFont=[UIFont systemFontOfSize:11];
    self.zdProgressView.noColor = [UIColor whiteColor];
    self.zdProgressView.prsColor = self.view.tintColor;
    [self.scrollview addSubview:self.zdProgressView];
//    float flot;
//    flot=(float)89/(float)100;
//    //_slider.value=flot;
//     self.zdProgressView.progress = flot;
    
   
}



- (void)slider:(UISlider *)slider
{
    float flot;
    flot=(float)[progress intValue]/(float)100;
    slider.value=flot;
    self.zdProgressView.progress = flot;
    NSLog(@"==============%.2f",flot);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr5.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    zoushiTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"zoushiTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"zoushiTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    //_goodsDetailInfo = [dataSourceArray objectAtIndex:indexPath.row];
   
    cell.qishu.text = [arr1 objectAtIndex:indexPath.row];
    cell.zhongjiangren.text = [arr6 objectAtIndex:indexPath.row];
    cell.zhongjiannum.text = [arr2 objectAtIndex:indexPath.row];
    cell.mairuci.text = [arr3 objectAtIndex:indexPath.row];
    cell.weici.text = [arr objectAtIndex:indexPath.row];
    cell.qujianduan.text = [arr5 objectAtIndex:indexPath.row];
     
    
   
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (void)httpGetGoodsDetailInfo
{
    NSString *userIdStr = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userIdStr = [ShareManager shareInstance].userinfo.id;
    }
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ZoushiViewController *weakSelf = self;
    [helper loadGoodsDetailInfoWithGoodsId:_goodid
                                    userId:userIdStr
                                   success:^(NSDictionary *resultDic){
                                       if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                           [weakSelf handleloadResult:resultDic];
                                       }else
                                       {
                                           [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                       }
                                       
                                   }fail:^(NSString *decretion){
                                       [Tool showPromptContent:@"网络出错了" onView:self.view];
                                   }];
    
    
   
}
- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    
    
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    //商品信息
    _goodsDetailInfo = [[dic objectForKey:@"goodsFightMap"] objectByClass:[GoodsDetailInfo class]];
   
    
    
    nickname=_goodsDetailInfo.id;
    totalqishu=_goodsDetailInfo.good_period;
    zongxuyao =_goodsDetailInfo.need_people;
    

    _qishu.text = [NSString stringWithFormat:@"%d期",[_goodsDetailInfo.good_period intValue]];
    
    if ([_goodsDetailInfo.good_period intValue]<20) {
            _num2.text=[NSString stringWithFormat:@"%d",[_goodsDetailInfo.good_period intValue]];
        }else{
            _num2.text = [NSString stringWithFormat:@"%d",20];
        }
    
    progress=_goodsDetailInfo.progress;
    float flot;
    flot=(float)[progress intValue]/(float)100;
    _slider.value=flot;
    self.zdProgressView.progress = flot;
    NSLog(@"==============%.2f",flot);
    ggid=_goodsDetailInfo.id;
    NSLog(@"走势页面的id＝＝＝＝＝%@",ggid);
    _proname.text= _goodsDetailInfo.good_name;
    
    [_image sd_setImageWithURL:[NSURL URLWithString:_goodsDetailInfo.good_header] placeholderImage:PublicImage(@"defaultImage")];

    
    UIColor* colord = [UIColor colorWithRed:252/255.0f green:139/255.0f blue:54/255.0f alpha:1];
    
    NSDictionary* style1 = @{@"body":[UIFont fontWithName:@"HelveticaNeue" size:12.0],  @"red": colord};
    
    NSString * textvalue=[NSString stringWithFormat:@"总需:<body><red>%@</red></body>人次" ,_goodsDetailInfo.need_people ];
     NSString * textvalue2=[NSString stringWithFormat:@"总需:<body><red>%@</red></body>人次" ,_goodsDetailInfo.need_people ];
     NSString * textvalue3=[NSString stringWithFormat:@"剩余:<body><red>%d</red></body>人次" ,[_goodsDetailInfo.need_people intValue]-[_goodsDetailInfo.now_people intValue]];
    NSString * textvalue4=[NSString stringWithFormat:@"已售:<body><red>%d</red></body>人次" ,[_goodsDetailInfo.now_people intValue]];
    shengxia = [NSString stringWithFormat:@"%d",[_goodsDetailInfo.need_people intValue]-[_goodsDetailInfo.now_people intValue]];
    NSLog(@"%d",[shengxia intValue]);
    _total.attributedText = [textvalue attributedStringWithStyleBook:style1];
    
    _canbuy= [NSString stringWithFormat:@"%d",[_goodsDetailInfo.need_people intValue]-[_goodsDetailInfo.now_people intValue]];
   
    _shengyu.attributedText =[textvalue3 attributedStringWithStyleBook:style1];
    _zongxu.attributedText =[textvalue2 attributedStringWithStyleBook:style1];
    _yishou.attributedText=[textvalue4 attributedStringWithStyleBook:style1];
    
}
- (IBAction)add:(id)sender
{
    
    if ([_num.text intValue] > [shengxia intValue])
    {
        
        [Tool showPromptContent:@"当前购买的数量已经是最大可购买数量了" onView:self.view];
        return;
    }
    _num.text = [NSString stringWithFormat:@"%d",[_num.text intValue]+1];
}
- (IBAction)down:(id)sender
{
    if ([_num.text intValue]-1 <= 0) {
        _num.text = [NSString stringWithFormat:@"%d",1];
    }else{
        _num.text = [NSString stringWithFormat:@"%d",[_num.text intValue]-1];
    }
}
- (IBAction)add2:(id)sender
{
//    _dijiqi.text
    

    NSLog(@"%@",totalqishu);
    
    
    
    if ([_num2.text intValue] >= [totalqishu intValue])
    {
        
        [Tool showPromptContent:@"超出监控期数" onView:self.view];
        return;
    }
     _num2.text = [NSString stringWithFormat:@"%d",[_num2.text intValue]+1];
}
- (IBAction)down2:(id)sender
{
    if ([_num2.text intValue]-1 <= 0) {
        _num2.text = [NSString stringWithFormat:@"%d",1];
    }else{
        _num2.text = [NSString stringWithFormat:@"%d",[_num2.text intValue]-1];
    }

}
- (IBAction)wodeduobao:(id)sender
{
   
//    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
//    vc.goodId = _goodsDetailInfo.id;
//    vc.userId = [ShareManager shareInstance].userinfo.id;
//    vc.userName = _goodsDetailInfo.win_user.nick_name;
//    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    vc.goodId = nickname;
    vc.userId = [ShareManager shareInstance].userinfo.id;
    vc.userName = [ShareManager shareInstance].userinfo.nick_name;
    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
- (IBAction)canyujilu:(id)sender
{
    CanyuViewController *vc = [[CanyuViewController alloc]initWithNibName:@"CanyuViewController" bundle:nil];
    vc.goodId = _goodsDetailInfo.id;
//    vc.userId = _goodsDetailInfo.win_user_id;
//    vc.userName = _goodsDetailInfo.win_user.nick_name;
//    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
    [self.navigationController pushViewController:vc animated:YES];
}

//获取总数据
- (void)httpGetSourceData
{
    pageNum=1;
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak ZoushiViewController *weakSelf = self;
  
    [helper getOldDuoBaoDataWithGoodsId:_goodId
                                pageNum:[NSString stringWithFormat:@"%d",pageNum]
                               limitNum:@"30"
                                success:^(NSDictionary *resultDic){
                                    
                                    [weakSelf handleloadResult2:resultDic];
                                  

                                }fail:^(NSString *decretion){
                                   
                                    [Tool showPromptContent:decretion onView:self.view];
                                }];
}

- (void)handleloadResult2:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsFightHistoryList"];
   
        for (diczou in resourceArray)
        {
           // ZoushiInfo *info2=[dic objectByClass:[GoodsDetailInfo class]];
            _goodsDetailInfo = [diczou objectByClass:[GoodsDetailInfo class]];
            [dataSourceArray addObject:_goodsDetailInfo];
           
            _goodsDetailInfo=[dataSourceArray objectAtIndex:0];

            _dijiqi.text = [NSString stringWithFormat:@"第%@期:",_goodsDetailInfo.good_period];
//
//            totalqishu=_goodsDetailInfo.good_period;

      
            UIColor* colord = [UIColor colorWithRed:252/255.0f green:139/255.0f blue:54/255.0f alpha:1];
            
            NSDictionary* style1 = @{@"body":[UIFont fontWithName:@"HelveticaNeue" size:12.0],  @"red": colord};
            
            NSString * textvalue=[NSString stringWithFormat:@"%@购买了<body><red>%@</red></body>人次" ,_goodsDetailInfo.win_user.nick_name,_goodsDetailInfo.win_user.fight_time];
            if (_goodsDetailInfo.win_user.nick_name==nil&&_goodsDetailInfo.win_user.fight_time==nil) {
                _name.text=@"即将揭晓，正在计算中...";
            }else{
            
            _name.attributedText = [textvalue attributedStringWithStyleBook:style1];
            }
          
            
        }
   
}

-(void)getNet
{
  
     pageNum=1;
     HttpHelper *helper = [[HttpHelper alloc] init];
     __weak ZoushiViewController *weakSelf = self;
    [helper getZoushi:_goodId pageNum:[NSString stringWithFormat:@"%d",pageNum] limitNum:_num2.text success:^(NSDictionary *resultDic) {
        
       
            [weakSelf handleloadResult4:resultDic];
    
        
   
    } fail:^(NSString *description){
        
        
    }];


}
- (void)handleloadResult4:(NSDictionary *)resultDic
{
   
      NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsFightHistoryList"];
   
    // ZoushiInfo *info2=[dic objectByClass:[GoodsDetailInfo class]];
   
    for (NSDictionary *Dic in resourceArray)
    {
      
       _goodsDetailInfo = [Dic objectByClass:[GoodsDetailInfo class]];
       
        if (_goodsDetailInfo.win_user.win_user_position!=NULL){
           [arr addObject:_goodsDetailInfo.win_user.win_user_position];
          
        }else
        {
            [arr addObject:@"0"];
        }
       
        if (_goodsDetailInfo.good_period!=NULL) {
           [arr1 addObject:_goodsDetailInfo.good_period];
        }else
        {
            [arr addObject:@"0"];
        }
      
        if (_goodsDetailInfo.win_user.LotteryRegion!=NULL) {
           [arr5 addObject:_goodsDetailInfo.win_user.LotteryRegion];
        }else
        {
            [arr5 addObject:@"揭晓中..."];
        }
       
        if (_goodsDetailInfo.win_user.nick_name!=NULL) {
            [arr6 addObject:_goodsDetailInfo.win_user.nick_name];
        }else
        {
            [arr6 addObject:@"揭晓中..."];
        }
      
        if (_goodsDetailInfo.win_num!=NULL) {
            [arr2 addObject:_goodsDetailInfo.win_num];
        }else
        {
            [arr2 addObject:@"揭晓中..."];
        }
       
        if (_goodsDetailInfo.win_user.fight_time!=NULL) {
            [arr3 addObject:_goodsDetailInfo.win_user.fight_time];
        }else
        {
            [arr3 addObject:@"揭晓中..."];
        }
        
        [arr4 addObject:_goodsDetailInfo.good_period];
        
        [dataSourceArray2 addObject:_goodsDetailInfo];
        
    }
    arr = (NSMutableArray *)[[arr reverseObjectEnumerator] allObjects];
    arr1 = (NSMutableArray *)[[arr1 reverseObjectEnumerator] allObjects];
    arr2 = (NSMutableArray *)[[arr2 reverseObjectEnumerator] allObjects];
    arr3 = (NSMutableArray *)[[arr3 reverseObjectEnumerator] allObjects];
    arr4 = (NSMutableArray *)[[arr4 reverseObjectEnumerator] allObjects];
    arr5 = (NSMutableArray *)[[arr5 reverseObjectEnumerator] allObjects];
    arr6 = (NSMutableArray *)[[arr6 reverseObjectEnumerator] allObjects];
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(-10,300, WIDTH, 300)];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
   
    self.lineChart.unit = @"人次";
    
    // self.lineChart.topicLabel.textColor = ZFPurple;
    self.lineChart.alpha=0.7;
       self.lineChart.isResetAxisLineMinValue = YES;
       self.lineChart.isResetAxisLineMaxValue = YES;
//    self.lineChart.axisLineNameColor=[UIColor redColor];
//    self.lineChart.axisLineValueColor=[UIColor redColor];
    
    //    slf.lineChart.isAnimated = NO;
    //    self.lineChart.valueLabelPattern = kPopoverLabelPatternBlank;
    self.lineChart.isShowXLineSeparate = YES;
    self.lineChart.isShowYLineSeparate = YES;
    self.lineChart.linePatternType = kLinePatternTypeForSharp;
    //    self.lineChart.isShowAxisLineValue = NO;
    //    lineChart.valueCenterToCircleCenterPadding = 0;
    [self.scrollview addSubview:self.lineChart];
    UIImageView *imageview1 = [[UIImageView alloc]init];
    imageview1.image = [UIImage imageNamed:@"zhushou(1)"];
    [imageview1 setCenter:CGPointMake(self.lineChart.frame.size.width / 2, self.lineChart.frame.size.height / 2)];
    imageview1.alpha=0.7;
    [self.lineChart strokePath];
    [self.lineChart addSubview:imageview1];

   
                                                tableivew= [[UITableView alloc]initWithFrame:CGRectMake(0, 640, WIDTH, 320)];
                                                tableivew.delegate=self;
                                                tableivew.dataSource=self;
                                                tableivew.separatorStyle = UITableViewCellSelectionStyleNone;
                                                [self.scrollview addSubview:tableivew];
}


- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    
    
    return arr;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return arr1;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFRed];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
   
    NSLog(@"%@",zongxuyao);
    return [zongxuyao intValue];
}

- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
    return 0;
}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 5;
}

#pragma mark - ZFLineChartDelegate

- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
    return 15.f;
}

- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart{
    return 15.f;
}

- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart{
    return 7.f;
}

- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart{
    return 2.f;
}

- (NSArray *)valuePositionInLineChart:(ZFLineChart *)lineChart{
    return @[@(kChartValuePositionOnTop)];
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex circle:(ZFCircle *)circle popoverLabel:(ZFPopoverLabel *)popoverLabel{
   
//    
    if (circleIndex) {
        NSLog(@"第%ld个", (long)circleIndex);
        
        
        zou = [[[NSBundle mainBundle] loadNibNamed:@"zoushiview" owner:self options:nil] lastObject];
        zou.qihao.text= [NSString stringWithFormat:@"第%@期",[arr1 objectAtIndex:circleIndex]];
        zou.huojiangren.text = [arr6 objectAtIndex:circleIndex];
        zou.xinyunhaoma.text = [arr2 objectAtIndex:circleIndex];
        zou.mairuweizhi.text = [arr objectAtIndex:circleIndex];
        zou.mairucishu.text = [arr3 objectAtIndex:circleIndex];
        zou.qujian.text = [arr5 objectAtIndex:circleIndex];
        zou.layer.masksToBounds = YES;
        zou.layer.cornerRadius = 6.0;
        zou.layer.borderWidth = 1.0;
        zou.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        CGRect tmpFrame = [[UIScreen mainScreen] bounds];
        //设置自定义视图的中点为屏幕的中点
        [zou setCenter:CGPointMake(tmpFrame.size.width / 2, tmpFrame.size.height / 2)];
        
        backview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        
        backview.backgroundColor = [UIColor blackColor];
        backview.alpha = 0.7;
        button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backview];
        [self.view addSubview:zou];
        [backview addSubview:button];
        
        
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
//        [self.view addGestureRecognizer:singleTap];
        
    }
//
       //[circle strokePath];

}



- (IBAction)start:(id)sender
{
    if ([_num2.text intValue] > [totalqishu intValue])
    {
        
        [Tool showPromptContent:@"超出监控期数" onView:self.view];
        return;
    }
    
    _start.backgroundColor = [UIColor grayColor];
    _stopbu.backgroundColor = [UIColor redColor];
    _start.enabled=NO;
    [Tool showPromptContent:[NSString stringWithFormat:@"正在获取近%@期数据...",_num2.text] onView:self.view];
    _stopbu.enabled=YES;
  

            [self getNet];

}
-(void)testTimer
{
    
}


- (IBAction)stop:(id)sender
{
    [Tool showPromptContent:@"监控已停止..." onView:self.view];
    _start.backgroundColor=[UIColor redColor];
    _stopbu.backgroundColor = [UIColor grayColor];
    _stopbu.enabled=NO;
    _start.enabled=YES;
    [self.lineChart removeFromSuperview];
    [tableivew removeFromSuperview];
    [arr5 removeAllObjects];
    [arr1 removeAllObjects];
    [arr removeAllObjects];
}
- (IBAction)xiadan:(id)sender
{
    
    if ([_num.text intValue] > [shengxia intValue])
    {
        NSLog(@"%d",[_num.text intValue]);
         NSLog(@"%d",[_shengyu.text intValue]);
        [Tool showPromptContent:@"当前购买的数量已经是最大可购买数量了" onView:self.view];
        return;
    }
    
    PayViewController *vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
    vc.moneyNum = [_num.text intValue] * [_goodsDetailInfo.good_single_price doubleValue];
    vc.goodsIds = ggid;
    vc.isShopCart = NO;
    vc.goods_buy_nums = [NSString stringWithFormat:@"%@",_num.text];
    vc.delegate = self;
    vc.duoshao=@"1";
    
//    vc.moneyNum = num * [_goodsDetailInfo.good_single_price doubleValue];
//    vc.goodsIds = _goodsDetailInfo.id;
//    vc.isShopCart = NO;
//    vc.goods_buy_nums = [NSString stringWithFormat:@"%d",num];
//    vc.delegate = self;
//    vc.duoshao=@"1";
    
    NSLog(@"数量乘以单价＝＝＝＝%f",[_num.text intValue] * [_goodsDetailInfo.good_single_price doubleValue]);
    NSLog(@"购买id＝＝＝%@",ggid);
    NSLog(@"购买数量＝＝＝%@",_num.text);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)lineChartView:(DVLineChartView *)lineChartView DidClickPointAtIndex:(NSInteger)index
{
    
}
-(void)action:(UIButton*)btn
{
    [zou removeFromSuperview];
    [backview removeFromSuperview];
    [button removeFromSuperview];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
