//
//  DBNumViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "DBNumViewController.h"
#import "DBNumListCollectionViewCell.h"

@implementation DuoBaoNumInfo

@end

@interface DBNumViewController ()
{
    NSMutableArray *dataSourceArray;
}

@end

@implementation DBNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self loadDuoBaoNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"购宝号码";
    dataSourceArray = [NSMutableArray array];
    
    [_myCollectView registerClass:[DBNumListCollectionViewCell class] forCellWithReuseIdentifier:@"DBNumListCollectionViewCell"];
    _tiltleLabel.text = _goodName;
    
}


- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
    back.image = [UIImage imageNamed:@"nav_back.png"];
    [leftItemControl addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
    
}

#pragma mark -http

- (void)loadDuoBaoNum
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    HttpHelper *helper = [[HttpHelper alloc] init];
    __weak DBNumViewController *weakSelf = self;
    [helper loadDuoBaoLuckNumWithGoodsId:_goodId
                                 user_id:_userId
                                 success:^(NSDictionary *resultDic){
                                     [HUD hide:YES];
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                        [weakSelf handleLoadResult:resultDic];
                                    }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                                 }fail:^(NSString *decretion){
                                     [HUD hide:YES];
                                     [Tool showPromptContent:decretion onView:self.view];
                                 }];
}


- (void)handleLoadResult:(NSDictionary *)resultDic
{
    if (dataSourceArray.count > 0 ) {
        [dataSourceArray removeAllObjects];
        
    }
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightRecordList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            DuoBaoNumInfo *info = [dic objectByClass:[DuoBaoNumInfo class]];
            [dataSourceArray addObject:info];
        }
        _warnLabel.text = [NSString stringWithFormat:@"%@ 本次购宝一共参与了%lu人次，以下是获得的购宝号码",_userName,(unsigned long)dataSourceArray.count];
    }else{
       [Tool showPromptContent:@"暂无数据" onView:self.view];
    }
        
    [_myCollectView reloadData];
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBNumListCollectionViewCell *cell = (DBNumListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DBNumListCollectionViewCell" forIndexPath:indexPath];
    
    DuoBaoNumInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    cell.numLabel.text = info.fight_num;
    [Tool setFontSizeThatFits:cell.numLabel];
   
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (collectionView.frame.size.width)/4, 40);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
