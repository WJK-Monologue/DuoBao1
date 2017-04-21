//
//  PayViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayViewControllerDelegate <NSObject>
@optional
- (void)payForBuyGoodsSuccess;
@end

@interface PayViewController : UIViewController
@property(nonatomic,strong)NSString *duoshao;
@property (assign, nonatomic) double moneyNum;
@property (strong, nonatomic) NSString *goodsIds;
@property (strong, nonatomic) NSString *goods_buy_nums;
@property (assign, nonatomic) BOOL isShopCart;
@property (weak, nonatomic) IBOutlet UILabel *duoshaonum;
@property (weak, nonatomic) IBOutlet UILabel *qitajine;

@property (nonatomic, assign) id<PayViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *bukeyong;
@property (weak, nonatomic) IBOutlet UIControl *aibei;

@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *payAllMoney;

@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@property (weak, nonatomic) IBOutlet UILabel *djbLabel;

@property (weak, nonatomic) IBOutlet UIImageView *djbImage;
@property (weak, nonatomic) IBOutlet UIImageView *zfbImage;
@property (weak, nonatomic) IBOutlet UIImageView *weixinImage;
@property (weak, nonatomic) IBOutlet UIImageView *aibeiImage;

@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIControl *weixinPayControl;

@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIControl *zhifubaocontro;
@property (weak, nonatomic) IBOutlet UILabel *aibellabel;
@property (weak, nonatomic) IBOutlet UILabel *weixinlabel;
@property (weak, nonatomic) IBOutlet UILabel *goubaolabel;
@property (weak, nonatomic) IBOutlet UILabel *zhifubaokeyong;
@property (weak, nonatomic) IBOutlet UILabel *weixinkeyong;

- (IBAction)clickGoodsNumAction:(id)sender;
- (IBAction)clickPayButtonAction:(id)sender;
- (IBAction)clickCouponsAction:(id)sender;

- (IBAction)clickDJBAction:(id)sender;
- (IBAction)clickZFBAction:(id)sender;
- (IBAction)clickWeiXinAction:(id)sender;
- (IBAction)clickAiBeiAction:(id)sender;
@end
