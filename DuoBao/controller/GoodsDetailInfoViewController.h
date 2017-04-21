//
//  GoodsDetailInfoViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailInfoViewController : UIViewController

@property (strong, nonatomic) NSString *goodId;
@property (strong, nonatomic) NSString *goodsId;   //商品ID 评论接口
@property (strong, nonatomic) NSString *productId;  //商品ID 详情接口

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *joinBotton;    //立即参与
@property (weak, nonatomic) IBOutlet UIButton *addButton;   // 加入清单
@property (weak, nonatomic) IBOutlet UIButton *shopCartButton;   //购物车
@property (weak, nonatomic) IBOutlet UILabel *shopCartNumLabel;  //购物车数量
@property(nonatomic,assign)NSInteger st;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;

- (IBAction)clickJoinButtonAction:(id)sender;
- (IBAction)clickAddButtonButtonAction:(id)sender;
- (IBAction)clickJShopCartButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *xjLabel;

@property (weak, nonatomic) IBOutlet UIView *jiexiaoView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (IBAction)clickGoButtonAction:(id)sender;


@end
