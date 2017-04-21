//
//  ZoushiViewController.h
//  DuoBao
//
//  Created by 余灏 on 16/11/4.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoushiViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *proname;

@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property(nonatomic,strong) NSString *goodid;
@property (weak, nonatomic) IBOutlet UIButton *addbutton;
@property (weak, nonatomic) IBOutlet UIButton *downbutton;
@property (weak, nonatomic) IBOutlet UITextField *num;
@property (nonatomic,strong)NSString *canbuy;
@property (weak, nonatomic) IBOutlet UILabel *yishou;
@property(nonatomic,strong)NSString *goodId;
@property (weak, nonatomic) IBOutlet UILabel *shengyu;
@property (weak, nonatomic) IBOutlet UILabel *zongxu;
@property (weak, nonatomic) IBOutlet UILabel *dijiqi;
@property (weak, nonatomic) IBOutlet UILabel *qishu;
@property (weak, nonatomic) IBOutlet UIView *uiview;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *start;
@property (weak, nonatomic) IBOutlet UIButton *stopbu;
@property (weak, nonatomic) IBOutlet UIButton *xiadanbu;
@property (weak, nonatomic) IBOutlet UITextField *num2;
@property (weak, nonatomic) IBOutlet UIButton *addjiankong;
@property (weak, nonatomic) IBOutlet UIButton *rejiankong;
@property (weak, nonatomic) IBOutlet UIImageView *beijin;

@end
