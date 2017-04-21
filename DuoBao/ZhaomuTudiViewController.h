//
//  ZhaomuTudiViewController.h
//  DuoBao
//
//  Created by 余灏 on 16/12/1.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhaomuTudiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *yaoqingweishu;
@property (weak, nonatomic) IBOutlet UIButton *fanlixiangqing;

@property (weak, nonatomic) IBOutlet UIButton *zhaomuguize;
@property (weak, nonatomic) IBOutlet UIView *zhaomuguizeview;

@property (weak, nonatomic) IBOutlet UILabel *huode;
@property (weak, nonatomic) IBOutlet UILabel *jiwei;
@property (weak, nonatomic) IBOutlet UIButton *fenxiang;
@property (weak, nonatomic) IBOutlet UIButton *weishenme;
@property (weak, nonatomic) IBOutlet UIButton *ruhe;
@property (weak, nonatomic) IBOutlet UIView *fanlixiangqingview;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
@interface ServiceLiInfo : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *value;

@end
