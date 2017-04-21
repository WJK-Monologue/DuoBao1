//
//  GoodsViewTableViewCell.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "GoodsViewTableViewCell.h"
#import "GoodsListCollectionViewCell.h"
#import "GoodsListInfo.h"
#import "BeatViewController.h"

@implementation GoodsViewTableViewCell
{
    GoodsListCollectionViewCell *cell;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initImageCollectView
{
    [_collectView registerClass:[GoodsListCollectionViewCell class] forCellWithReuseIdentifier:@"GoodsListCollectionViewCell"];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //NSLog(@"/////--%lu",(unsigned long)_dataSourceArray.count);
    return _dataSourceArray.count;
}

- (CGFloat)minimumInteritemSpacing {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = (GoodsListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsListCollectionViewCell" forIndexPath:indexPath];
    if(_dataSourceArray != nil){
    GoodsListInfo *info = [_dataSourceArray objectAtIndex:indexPath.row];
    //改动
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.thumbnailUrl] placeholderImage:PublicImage(@"defaultImage")];
    cell.titleLabel.text = info.productName;
    cell.goodprice.text = [NSString stringWithFormat:@"¥%@",info.productPrice];
    cell.onePrice.text = info.unitCost;
    cell.numLab.text = info.totalNum;
    }
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (collectionView.frame.size.width)/2,200);
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

//UICollectionView被选中时调用的方法   点击
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(selectGoodsInfo:)])
    {
        [self.delegate selectGoodsInfo:indexPath.row];
    }
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

-(void)dealloc
{
    //[[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
