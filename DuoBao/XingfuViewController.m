//
//  XingfuViewController.m
//  DuoBao
//
//  Created by 余灏 on 16/11/10.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "XingfuViewController.h"
#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "CommonTabBar.h"
#import "MenuViewController.h"
#import "CommonTabBar.h"
#define  WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface XingfuViewController ()<MenuViewControllerDelegate,CommonTabBarDelegate>
{
    MenuViewController *menuViewController;
}
@property (nonatomic, strong,readonly) CommonTabBar *tabBar;
@end

@implementation XingfuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  
    self.title = @"信服的购宝";
    _scrollview.contentSize = CGSizeMake(WIDTH, HEIGHT*2+600);
    
    //是否整页滚动
    _scrollview.bounces = YES;
    // 设置滚动条风格
    _scrollview.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _scrollview.showsHorizontalScrollIndicator = YES;
    // 关闭垂直方向的滚动条
    _scrollview.showsVerticalScrollIndicator = YES;
    _scrollview.delegate = self;
    
 

}

-(void)tabBarController:(MenuViewController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
   
}
-(void)tabBar:(CommonTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    
}
- (IBAction)liji:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController popViewControllerAnimated:NO];
    [self.menuViewController setSelectedIndex:0];
    [self.menuViewController hidesTabBar:NO animated:YES];
}
-(void)re:(NSNotification *)change
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoshouye" object:nil];
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
