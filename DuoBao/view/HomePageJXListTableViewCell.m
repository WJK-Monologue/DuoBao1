//
//  HomePageJXListTableViewCell.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "HomePageJXListTableViewCell.h"
#import "HomePageJXCollectionViewCell.h"
#import "ProductDetailViewController.h"
#import "JieXiaoInfo.h"

@implementation HomePageJXListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTimeLabelUI
{
    
}

- (void)initImageCollectView
{
    [_collectView registerClass:[HomePageJXCollectionViewCell class] forCellWithReuseIdentifier:@"HomePageJXCollectionViewCell"];
    
}

- (void)updateTimeLabelUI:(NSString *)timeStr index:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
    HomePageJXCollectionViewCell *cell = (HomePageJXCollectionViewCell *)[_collectView cellForItemAtIndexPath:indexPath];
    
    long long timeValue = [timeStr longLongValue]/1000;
    
    NSUInteger min  = (timeValue%(3600))/60;
    NSUInteger second = (NSUInteger)(timeValue%60);
    NSUInteger hsecond = (NSUInteger)([timeStr longLongValue]%1000)/10;
    if (min>9) {
        cell.hourLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)min];
    }else{
        cell.hourLabel.text = [NSString stringWithFormat:@"0%lu",(unsigned long)min];
    }
    
    if (second>9) {
        cell.minuteLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)second];
    }else{
        cell.minuteLabel.text = [NSString stringWithFormat:@"0%lu",(unsigned long)second];
    }
    
    if (hsecond>9) {
        cell.secondLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)hsecond];
    }else{
        cell.secondLabel.text = [NSString stringWithFormat:@"0%lu",(unsigned long)hsecond];
    }
    
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (CGFloat)minimumInteritemSpacing {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageJXCollectionViewCell *cell = (HomePageJXCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageJXCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row%2==0 && indexPath.row>1) {
        cell.lineLabel.hidden = YES;
        
    }else{
        cell.lineLabel.hidden = NO;
    }
    
    cell.warnLabel.layer.masksToBounds =YES;
    cell.warnLabel.layer.cornerRadius = cell.warnLabel.frame.size.height/2;
    cell.rewardView.hidden = NO;
    
    JieXiaoInfo *info = [_dataSourceArray objectAtIndex:indexPath.row];
    
    if([info.status isEqualToString:@"已揭晓"] || !info.status)
    {
        cell.rewardView.hidden = NO;
        cell.timeView.hidden = YES;
        cell.showLabel.hidden = YES;
        
        //改动
        cell.proname.text = info.productName;
        cell.proprice.text = [NSString stringWithFormat:@"¥%@",info.productPrice];
        cell.numL.text = info.number;
        cell.onePri.text = info.unitCost;
        CGSize size = [cell.nameLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
        if (size.width < 41) {
            cell.nameLabelWidth.constant = 41;
        }else{
            double width = (FullScreen.size.width-16)/3/2;
            if (size.width/2+20 - width > 0) {
                cell.nameLabelWidth.constant = (width-20)*2;
            }else{
                cell.nameLabelWidth.constant = size.width;
            }
        }

    }else{
        if ([info.is_show_daojishi isEqualToString:@"n"]) {
            cell.rewardView.hidden = YES;
            cell.timeView.hidden = YES;
            cell.showLabel.hidden = NO;
            cell.showLabel.text = info.daojishi_message;
        }else{
            cell.rewardView.hidden = YES;
            cell.timeView.hidden = NO;
            cell.showLabel.hidden = YES;
            
            cell.hourLabel.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            cell.hourLabel.layer.borderWidth = 1.0f;
            
            cell.minuteLabel.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            cell.minuteLabel.layer.borderWidth = 1.0f;
            
            cell.secondLabel.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            cell.secondLabel.layer.borderWidth = 1.0f;
        }
    }
    
     [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.thumbnailUrl] placeholderImage:PublicImage(@"defaultImage")];
    
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //改动
    return CGSizeMake( (collectionView.frame.size.width)/2,151);
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

//UICollectionView被选中时调用的方法  改动 注释 点击瀑布流的方法 
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    //改动  跳转新商品详情页
    //ProductDetailViewController *vc = [[ProductDetailViewController alloc]initWithNibName:@"ProductDetailViewController" bundle:nil];
    //[self.navigationController pushViewController:vc animated:YES];

    //GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
   // vc.goodsId = info.productId;
    
    if([self.delegate respondsToSelector:@selector(selectJXGoodsInfo:)])
    {
        [self.delegate selectJXGoodsInfo:indexPath.row];
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

@end
