//
//  CouponsViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CouponsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *ksyButton;
@property (weak, nonatomic) IBOutlet UIButton *dieButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;

@property (weak, nonatomic) IBOutlet UILabel *ksyLine;

@property (weak, nonatomic) IBOutlet UILabel *dieLine;
@property(nonatomic,assign)NSInteger status;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)clickKSYButtonAction:(id)sender;
- (IBAction)clickDieButtonAction:(id)sender;
@end
