//
//  ShaiDanViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShaiDanViewController : UIViewController
@property (strong, nonatomic) NSString *goodId;
@property (strong, nonatomic) NSString *userId;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end
