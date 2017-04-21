//
//  ShouChongViewController.m
//  DuoBao
//
//  Created by 余灏 on 16/11/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ShouChongViewController.h"
#import "CZViewController.h"
#import "WQJXViewController.h"
#define  WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ShouChongViewController ()

@end

@implementation ShouChongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.title =@"充值有礼";
    _scrollview.contentSize = CGSizeMake(WIDTH, HEIGHT*2);
    
    //是否整页滚动
    _scrollview.bounces = YES;
    // 设置滚动条风格
    _scrollview.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _scrollview.showsHorizontalScrollIndicator = YES;
    // 关闭垂直方向的滚动条
    _scrollview.showsVerticalScrollIndicator = YES;
    _scrollview.delegate = self;
}
- (IBAction)cz:(id)sender
{


}

- (IBAction)twohud:(id)sender
{
    CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
    vc.mon=1;
    [self.navigationController pushViewController:vc animated:YES];
  
}

- (IBAction)onehud:(id)sender
{
    CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
    vc.mon=2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)fif:(id)sender
{
    CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
    vc.mon=3;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)twty:(id)sender
{
    CZViewController *vc = [[CZViewController alloc]initWithNibName:@"CZViewController" bundle:nil];
    vc.mon=4;
    [self.navigationController pushViewController:vc animated:YES];
}





- (IBAction)fenxiang:(id)sender
{
    [ShareManager shareInstance].shareType = 1;
  
  
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
        [Tool shareMessageToOtherApp:nil
                         description:[NSString stringWithFormat:@"赶快来下载全民购宝App！我的推荐码:%@",[ShareManager shareInstance].userinfo.id]
                            titleStr:@"全民购宝App！"
                            shareUrl:[NSString stringWithFormat:@"%@%@user_id=%@",URL_ShareServer,Wap_ShareDuobao,[ShareManager shareInstance].userinfo.id]
                            fromView:sender];
    }else
    {
        [Tool shareMessageToOtherApp:nil
                         description:[NSString stringWithFormat:@"赶快来下载全民购宝App！我的推荐码:%@",[ShareManager shareInstance].userinfo.id]
                            titleStr:@"全民购宝App！"
                            shareUrl:[NSString stringWithFormat:@"%@%@user_id=%@",URL_ShareServer,Wap_ShareDuobao,[ShareManager shareInstance].userinfo.id]
                            fromView:self.view];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
