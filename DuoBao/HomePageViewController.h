//
//  HomePageViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsViewTableViewCell.h"

@interface HomePageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)clickSearchButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fenlei;



@end
