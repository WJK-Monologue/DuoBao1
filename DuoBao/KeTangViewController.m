//
//  KeTangViewController.m
//  DuoBao
//
//  Created by 余灏 on 16/11/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "KeTangViewController.h"
#import "GoodsDetailInfoViewController.h"
#import "GoodsListInfo.h"
#define  WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface KeTangViewController ()
{
    NSMutableArray *dataSourceArray;
    NSMutableArray *arr;
    NSString *ten;
    NSString *thirty;
    NSString *fifty;
    NSString *hundr;
    NSString *threethun;
    NSString *thous;
}

@end

@implementation KeTangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataSourceArray = [[NSMutableArray alloc]init];
    arr=[[NSMutableArray alloc]init];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.title =@"购宝小课堂";
    _scrollview.contentSize = CGSizeMake(WIDTH, HEIGHT*2+700);
    
    //是否整页滚动
    _scrollview.bounces = YES;
    // 设置滚动条风格
    _scrollview.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _scrollview.showsHorizontalScrollIndicator = YES;
    // 关闭垂直方向的滚动条
    _scrollview.showsVerticalScrollIndicator = YES;
    _scrollview.delegate = self;
    [self httpSearchInfoList];
}

- (void)httpSearchInfoList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak KeTangViewController *weakSelf = self;
    NSString *str=@"话费";
    [helper searchGoodsWithSearchKey:str
                             success:^(NSDictionary *resultDic){
                            if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadSearchResult:resultDic];
                                 }else
                                 {
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                 }
                             }fail:^(NSString *decretion){
                          
                                 [Tool showPromptContent:decretion onView:self.view];
                             }];
}

- (void)handleloadSearchResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsSearchList"];
    
    
   
        for (NSDictionary *dic in resourceArray)
        {
            GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
            //改动  info的信息
            if ([info.productName containsString:@"面值10元"]) {
                ten=info.id;
            }
            if ([info.productName containsString:@"面值30元"]) {
                thirty=info.id;
            }
            if ([info.productName containsString:@"面值50元"]) {
                fifty=info.id;
            }
            if ([info.productName containsString:@"面值100元"]) {
                hundr =info.id;
            }
            if ([info.productName containsString:@"面值300元"]) {
                threethun=info.id;
            }
            if ([info.productName containsString:@"面值1000元"]) {
                thous=info.id;
            }
            
//            [dataSourceArray addObject:info];
//            [arr addObject:info.id];
        }
      
  
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)first:(id)sender
{
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    
    vc.goodId = ten;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)sec:(id)sender
{
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    
    vc.goodId = thirty;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)thir:(id)sender
{
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    
    vc.goodId = fifty;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)four:(id)sender
{
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    
    vc.goodId = hundr;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)five:(id)sender
{
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    
    vc.goodId = threethun;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)six:(id)sender
{
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    
    vc.goodId = thous;
    
    [self.navigationController pushViewController:vc animated:YES];
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
