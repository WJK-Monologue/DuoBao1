//
//  WinRecoardTableViewCell.h
//  DuoBao
//
//  Created by Macintosh on 2017/4/3.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WinRecoardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wintime;
@property (weak, nonatomic) IBOutlet UIImageView *winImg;
@property (weak, nonatomic) IBOutlet UILabel *winuser;
@property (weak, nonatomic) IBOutlet UILabel *winid;


@property (weak, nonatomic) IBOutlet UILabel *winIpSite;

@property (nonatomic, retain)  UILabel *winIp;
@end
