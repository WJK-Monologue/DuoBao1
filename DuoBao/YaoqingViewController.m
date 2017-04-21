//
//  YaoqingViewController.m
//  DuoBao
//
//  Created by 余灏 on 16/10/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "YaoqingViewController.h"
#import "Scrollview2.h"
#import "FriendsInfo.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
@implementation ServiceLisInfo

@end


@interface YaoqingViewController ()<UIScrollViewDelegate>
{
    NSInteger selectType;//1 一级 2 二级  3 三级
    UIButton *_yjButton;
    UIButton *_ejButton;
    UIButton *_sjButton;
    
    UILabel *_yjLine;
    UILabel *_ejLine;
    UILabel *_sjLine;
    
    NSString *allFriendsNum;
    NSString *yjFriendsNum;
    NSString *ejFriendsNum;
    NSString *sjFriendsNum;
    
    NSMutableArray *serverSourceArray;
    NSMutableArray *dataSourceArray;
    int pageNum;
    NSInteger width;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Scrollview2 *topview;
@end

@implementation YaoqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.view.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:243/255.0f alpha:1];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"招募徒弟";
    // 防止UIScrollView偏移量内嵌到导航之下
    self.automaticallyAdjustsScrollViewInsets = NO;
    
   
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height/4-50)];
    image.image=[UIImage imageNamed:@"zmtd1.jpg"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50,self.view.bounds.size.height/4-40,100,40)];
    label.text =@"成功邀请";
   
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height/4,self.view.bounds.size.width,20)];
    view2.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [self.view addSubview:view2];
    
    [self.view addSubview:label];
    [self.view addSubview:image];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSArray *topViewTitles = @[@"招募规则",@"返利详情"];
    
    _topview = [[Scrollview2 alloc]initWithFrame:CGRectMake(0,200,self.view.bounds.size.width,40) titles:topViewTitles callBack:^(NSInteger pageIndex) {
        
        // 点击头部按钮时的回调
        [_scrollView setContentOffset:CGPointMake(pageIndex * self.view.bounds.size.width, 0) animated:YES];
    }];
    NSLog(@"屏幕宽度是===============%f",SCREEN_WIDTH);
        self.topview.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_topview];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topview.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_topview.frame))];
    
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * topViewTitles.count, 40);
    [self.view addSubview:_scrollView];
    
    NSArray *vcNames = @[@"zhaoViewController",@"fanliViewController"];
    for (int i = 0; i < topViewTitles.count; i++)
    {
        UIViewController *vc = [[NSClassFromString(vcNames[i%2]) alloc] init];
        
        // 1. 往父视图控制器中添加vc
        [self addChildViewController:vc];
        
        // 2. 将vc的view的x坐标偏移
        vc.view.frame = CGRectMake(_scrollView.bounds.size.width * i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        
        // 3. vc.view添加到scrollView上
        [_scrollView addSubview:vc.view];
    }
   // __unsafe_unretained __typeof(self) weakSelf = self;
    [self httpGetFriendsList];
    [self httpBaseData];
   
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    [_topview selectButtonIndex:index];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_topview moveTopViewLine:scrollView.contentOffset];
}
- (void)httpBaseData
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak YaoqingViewController *weakSelf = self;
    [helper getInviteFriendsInfoWithUserId:[ShareManager shareInstance].userinfo.id
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
    allFriendsNum = [NSString stringWithFormat:@"%@位",[[resultDic objectForKey:@"data"] objectForKey:@"friends_all"]];
    yjFriendsNum = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"friends_level_one"]];
    ejFriendsNum = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"friends_level_two"]];
    sjFriendsNum = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"friends_level_three"]];
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"serviceList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            ServiceLisInfo *info = [dic objectByClass:[ServiceLisInfo class]];
            [serverSourceArray addObject:info];
        }
    }
    //_num.text = [NSString stringWithFormat:@"%@",allFriendsNum];
     UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(140,self.view.bounds.size.height/4-25,100,40)];
    label2.text = [NSString stringWithFormat:@"%@",allFriendsNum];
    label2.font =[UIFont systemFontOfSize:23];
    label2.textColor = [UIColor redColor];
    [self.view addSubview:label2];
}

- (void)httpGetFriendsList
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak YaoqingViewController *weakSelf = self;
    
    [helper getFriendsByLevelWithUserId:[ShareManager shareInstance].userinfo.id
                                  level:[NSString stringWithFormat:@"%ld",(long)selectType]
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
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
        
    }
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"friendsList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            FriendsInfo *info = [dic objectByClass:[FriendsInfo class]];
            [dataSourceArray addObject:info];
        }
        
//        if (resourceArray.count < 30) {
//            [_myTableView.mj_footer endRefreshingWithNoMoreData];
//        }else{
//            [_myTableView.mj_footer resetNoMoreData];
//        }
        
        pageNum++;
    }
    
   // [_myTableView reloadData];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
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
