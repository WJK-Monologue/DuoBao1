//
//  CZViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveButton;
@property (weak, nonatomic) IBOutlet UITextField *sixTextFiled;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyButtonWidth;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIButton *alipayImage;
@property (weak, nonatomic) IBOutlet UIButton *weiXinImage;
@property (weak, nonatomic) IBOutlet UIControl *weixinView;
@property (weak, nonatomic) IBOutlet UIButton *aibeiImage;
@property (weak, nonatomic) IBOutlet UIControl *alicontrol;

@property (weak, nonatomic) IBOutlet UIControl *aibeicontrol;
@property (weak, nonatomic) IBOutlet UIView *zhifubaoview;
@property (weak, nonatomic) IBOutlet UIView *weixinview;
@property (weak, nonatomic) IBOutlet UILabel *zhifubaokeyong;
@property (weak, nonatomic) IBOutlet UILabel *weixinkeyong;
@property(nonatomic,assign)NSInteger ttp;
@property(nonatomic,assign)NSInteger mon;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *chosemoney;

- (IBAction)clickALiPayButtonAction:(id)sender;
- (IBAction)clickWeiXinButtonAction:(id)sender;
- (IBAction)clickAiBeiButtonAction:(id)sender;
- (IBAction)clickMoneyButtonAction:(id)sender;
- (IBAction)clickSureButtonAction:(id)sender;
@end
