//
//  ListTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidth; //表名
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;    //建议在wifi下查看
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;  // 图片




@end
