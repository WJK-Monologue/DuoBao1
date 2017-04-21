//
//  MenuViewController.m
//  BusinessCloud
//
//  Created by Hcat on 13-10-12.
//  Copyright (c) 2013年 Hcat. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "UserCenterViewController.h"
#import "CouponsListInfo.h"
#define kTabBarHeight 49.0f
#define MAIN_WIDTH [[UIScreen mainScreen] bounds].size.width

static MenuViewController *menuViewController;

@implementation UIViewController (MenuViewControllerSupport)

- (MenuViewController *)menuViewController
{
    return menuViewController;
}

@end


@interface MenuViewController (){
    UIView *_containerView;
    UIView *_transitionView;
    UIView *maskView;
    CouponsListInfo *couinfo;
    NSMutableArray *dataSourceArray;
}

@property (nonatomic,strong,readwrite) CommonTabBar *tabBar;

- (void)displayViewAtIndex:(NSUInteger)index;

@end


@implementation MenuViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popCurrentViewController" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _tabBar = nil;
    _tabBar.delegate = nil;
    _viewControllers = nil;
}

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr
{
    self = [super init];
    if (self != nil)
    {
        CGRect containerViewFrame = [[UIScreen mainScreen] bounds];
        
        if (IOS7_OR_LATER) {
            _containerView = [[UIView alloc] initWithFrame:CGRectMake(containerViewFrame.origin.x,
                                                                      containerViewFrame.origin.y,
                                                                      containerViewFrame.size.width,
                                                                      containerViewFrame.size.height)];
        }else{
            _containerView = [[UIView alloc] initWithFrame:CGRectMake(containerViewFrame.origin.x,
                                                                      containerViewFrame.origin.y,
                                                                      containerViewFrame.size.width,
                                                                      containerViewFrame.size.height - 20)];
        }
        
        _containerView.backgroundColor = [UIColor clearColor];
        
        _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, _containerView.frame.size.height - kTabBarHeight)];
        _transitionView.backgroundColor = [UIColor clearColor];
        
        maskView = [[UIView alloc] initWithFrame:containerViewFrame];
        maskView.backgroundColor = [UIColor whiteColor];
        
        
        _viewControllers = vcs;
        
        self.tabBar = [[CommonTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - kTabBarHeight, MAIN_WIDTH, kTabBarHeight)
                                              buttonItems:arr
                                         CommonTabBarType:CommonTabBarTypeTitleAndImage
                                              isAnimation:YES];
        
        self.tabBar.delegate = (id<CommonTabBarDelegate>)self;
        self.tabBar.titlesFont = [UIFont systemFontOfSize:11];
        self.tabBar.titleColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
        self.tabBar.titleSelectColor = [UIColor colorWithRed:230.0/255.0 green:47.0/255.0 blue:48.0/255.0 alpha:1];;
        self.tabBar.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        
        [self.tabBar setSelectedItemTopBackgroundColor:[UIColor clearColor]];
        
        [self.tabBar drawItems];
        //设置autoresizing 属性
        [self.tabBar setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        
        menuViewController = self;
        
        self.animateDriect = 0;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [_containerView addSubview:_transitionView];
    [_containerView addSubview:_tabBar];
    self.view = _containerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
 

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chan:) name:@"shuaxinhongdian" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(denglu:) name:@"dengluhongdian" object:nil];
}

-(void)denglu:(NSNotification *)deng
{
    [self httpGetShopCartList];
}

-(void)chan:(NSNotification *)shuaxin
{
    [menuViewController.tabBar hideTabBadgeWithIndex:3];
}
- (void)setTabBarTransparent:(BOOL)yesOrNo {
    if (yesOrNo == YES) {
        _transitionView.frame = _containerView.bounds;
    }else {
        _transitionView.frame = CGRectMake(0, 0, MAIN_WIDTH, _containerView.frame.size.height - kTabBarHeight);
    }
}

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
{
    if (yesOrNO == YES && self.tabBar.frame.origin.y == self.view.frame.size.height)
    {
        return;
    }
    else if (yesOrNO == NO && self.tabBar.frame.origin.y == self.view.frame.size.height - kTabBarHeight)
    {
        return;
    }
    
    if (animated == YES) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        
        if (yesOrNO == YES) {
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                           self.tabBar.frame.origin.y + kTabBarHeight,
                                           self.tabBar.frame.size.width,
                                           self.tabBar.frame.size.height);
        }else {
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                           self.tabBar.frame.origin.y - kTabBarHeight,
                                           self.tabBar.frame.size.width,
                                           self.tabBar.frame.size.height);
        }
        [UIView commitAnimations];
        
    } else {
        if (yesOrNO == YES) {
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                           self.tabBar.frame.origin.y + kTabBarHeight,
                                           self.tabBar.frame.size.width,
                                           self.tabBar.frame.size.height);
        } else {
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                           self.tabBar.frame.origin.y - kTabBarHeight,
                                           self.tabBar.frame.size.width,
                                           self.tabBar.frame.size.height);
        }
    }
}

- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [self.tabBar setSelectedIndex:index];
}

- (void)displayViewAtIndex:(NSUInteger)index
{
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)] &&
        ![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]]) {
        
        return;
    }
    
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0) {
        return;
    }
    
    _selectedIndex = index;
    UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
    selectedVC.view.frame = _transitionView.frame;
    
    if ([maskView isDescendantOfView:_transitionView]) {
        [_transitionView addSubview:maskView];
    }
    
    [_transitionView addSubview:maskView];
    
    if ([selectedVC.view isDescendantOfView:_transitionView])
    {
        [_transitionView bringSubviewToFront:maskView];
        [_transitionView bringSubviewToFront:selectedVC.view];
    }
    else
    {
        [_transitionView addSubview:selectedVC.view];
    }
    
    
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [_delegate tabBarController:self didSelectViewController:selectedVC];
    }
}

#pragma mark - commonTabBarDelegate

- (void)tabBar:(CommonTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    if (self.selectedIndex != index) {
        [self displayViewAtIndex:index];
    }
   
    
  
    NSLog(@"你点击了第几个item＝＝＝＝＝＝＝%ld",(long)index);
    [self performSelector:@selector(changing:) withObject:nil afterDelay:0];
    if ([Tool islogin]) {
         [self httpGetShopCartList];
         [self httpCouponsList];
        
    }
    if (index==4) {
       // [self httpCouponsList2];
    }
   
   
}
-(void)changing:(NSNotification *)changer
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tongzhishuaxin" object:nil];
}


- (void)httpGetShopCartList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak MenuViewController *weakSelf = self;
    [helper getShopCartListWithUserId:[ShareManager shareInstance].userinfo.id
                              success:^(NSDictionary *resultDic){
                                  if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                      [weakSelf handleloadResult1:resultDic];
                                  }else
                                  {
                                      
                                  }
                              }fail:^(NSString *decretion){
                                  
                              }];
}

-(void)handleloadResult1:(NSDictionary *)resultDic
{
    
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"shopCartList"];
    NSLog(@"购物车＝＝＝＝＝＝＝＝＝＝＝＝%lu",(unsigned long)resourceArray.count);
    
    if (resourceArray.count>0) {
        [menuViewController.tabBar showTabBadgeWithIndex:3];
    }
    else if (![Tool islogin])
    {
        [menuViewController.tabBar hideTabBadgeWithIndex:3];
    }
    else
    {
        [menuViewController.tabBar hideTabBadgeWithIndex:3];
    }
}
- (void)httpCouponsList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak MenuViewController *weakSelf = self;
    
    NSString *typeStr = @"1";
    int pageNum =1;
    
    [helper getCouponsListWithUserId:[ShareManager shareInstance].userinfo.id
                                type:typeStr
                             pageNum:[NSString stringWithFormat:@"%d",pageNum]
                            limitNum:@"30"
                             success:^(NSDictionary *resultDic){
                                 
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadFriendsListResult:resultDic];
                                 }else
                                 {
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                 }
                             }fail:^(NSString *decretion){
                                 
                                 [Tool showPromptContent:decretion onView:self.view];
                             }];
}
- (void)handleloadFriendsListResult:(NSDictionary *)resultDic
{
    
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"ticketList"];
   
    NSLog(@"红包数量＝＝＝＝＝＝＝＝＝＝＝%lu",(unsigned long)resourceArray.count);
    NSInteger NumHongbao =(unsigned long)resourceArray.count;
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.hongbaoshu=[NSString stringWithFormat:@"%ld",(long)NumHongbao];
    NSLog(@"全局红包数量是＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝%@",appDelegate.hongbaoshu);
    
}



@end
