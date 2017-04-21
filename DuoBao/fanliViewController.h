//
//  fanliViewController.h
//  DuoBao
//
//  Created by 余灏 on 16/10/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fanliViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
@interface ServiceInfo : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *value;
@end
