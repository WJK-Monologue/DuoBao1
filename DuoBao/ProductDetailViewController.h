//
//  ProductDetailViewController.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/21.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController

@property (strong, nonatomic) NSString *goodId;
@property (strong, nonatomic) NSString *goodsId;   //商品ID 评论接口
@property (strong, nonatomic) NSString *productId;  //商品ID 详情接口

@property (strong, nonatomic) NSString *peopleNum;  //人数
@property (strong, nonatomic) NSString *peoplePrice;  //人均价格
@property (strong, nonatomic) NSString *TotalPrice;  //人均价格

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic,assign)NSInteger st;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;


@property (weak, nonatomic) IBOutlet UILabel *xjLabel;

@property (weak, nonatomic) IBOutlet UIView *jiexiaoView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, retain) UIScrollView *scView;
@property (nonatomic, copy) NSDictionary *dicUser;     //用户一个

@property (nonatomic, copy) NSString *otherId;

//@property (nonatomic,copy) void (^myBlock)(NSDictionary *dic);

//-(void)handleMoreUsersBlock:(void (^)(NSDictionary *Dic))block;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendmessage;

- (IBAction)clickGoButtonAction:(id)sender;

@end
