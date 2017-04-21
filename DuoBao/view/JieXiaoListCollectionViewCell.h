//
//  JieXiaoListCollectionViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/13.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JieXiaoListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *warnView;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *luckNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *djsView;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;

@end
