//
//  SelectGoodsNumViewController.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectGoodsNumViewControllerDelegate <NSObject>
@optional
- (void)selectGoodsNum:(int)num;
@end

@interface SelectGoodsNumViewController : UIViewController
@property (nonatomic, assign) id<SelectGoodsNumViewControllerDelegate> delegate;
@property (assign, nonatomic) int limitNum;
@property (assign, nonatomic) int canBuyNum;

@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *twenty;
@property (weak, nonatomic) IBOutlet UIButton *thirty;
@property (weak, nonatomic) IBOutlet UIButton *fourty;
@property (weak, nonatomic) IBOutlet UIButton *baowei;
@property (weak, nonatomic) IBOutlet UILabel *dec;

- (IBAction)clickCannelButtonAction:(id)sender;

- (IBAction)clickSureButtonAction:(id)sender;

- (IBAction)clickAddButtonAction:(id)sender;

- (IBAction)clickDownButtonAction:(id)sender;
@end
