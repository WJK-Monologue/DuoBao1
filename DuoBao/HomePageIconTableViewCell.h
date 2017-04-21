//
//  HomePageIconTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"

@interface HomePageIconTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;

@property (weak, nonatomic) IBOutlet UIControl *flControl;
@property (weak, nonatomic) IBOutlet UIControl *syControl;
@property (weak, nonatomic) IBOutlet UIControl *sdControl;
@property (weak, nonatomic) IBOutlet UIControl *cjwtControl;
@property (weak, nonatomic) IBOutlet CycleScrollView *bannerView;

@property (weak, nonatomic) IBOutlet UIImageView *typeicon1;
@property (weak, nonatomic) IBOutlet UILabel *typename1;

@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UIImageView *typeicon3;

@property (weak, nonatomic) IBOutlet UILabel *typename3;
@property (weak, nonatomic) IBOutlet UIImageView *typeicon4;
@property (weak, nonatomic) IBOutlet UILabel *typename4;

@end
