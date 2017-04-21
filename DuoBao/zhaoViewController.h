//
//  zhaoViewController.h
//  DuoBao
//
//  Created by 余灏 on 16/10/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhaoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *fenxiang;
@property (weak, nonatomic) IBOutlet UILabel *baifen;
@property (weak, nonatomic) IBOutlet UILabel *weishu;
@property (weak, nonatomic) IBOutlet UIButton *whyshoutu;
@property (weak, nonatomic) IBOutlet UIButton *howshoutu;

@end
@interface ServiceLiInfo : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *value;

@end
