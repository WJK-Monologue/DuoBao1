//
//  GoodsListCollectionViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountBindingDelegate <NSObject>
- (void)jumpWebVC:(UIButton*)sender;
@end

@interface GoodsListCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<AccountBindingDelegate> ABdelegate;


@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//改动
@property (weak, nonatomic) IBOutlet UILabel *goodprice;
//@property (nonatomic,retain) UILabel *oneLab;   //一人次
@property (weak, nonatomic) IBOutlet UILabel *oneLab;
//@property (nonatomic,retain) UILabel *onePrice;  //人均价格
@property (weak, nonatomic) IBOutlet UILabel *onePrice;
//@property (nonatomic,retain) UILabel *tatalLab;  //总需人次
@property (weak, nonatomic) IBOutlet UILabel *tatalLab;
//@property (nonatomic,retain) UILabel *numLab;    //总人数
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (nonatomic,retain) UIButton *canyu;    //立即参与

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
