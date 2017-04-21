//
//  UserInfo.h
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, assign) BOOL islogin;   //是否登录

@property (nonatomic, strong) NSString *app_login_id;
@property (nonatomic, strong) NSString *weixin_login_id;
@property (nonatomic, strong) NSString *qq_login_id;

@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *is_open;// y;
@property (nonatomic, strong) NSString *is_robot;//n;
@property (nonatomic, strong) NSString *jpush_id;
@property (nonatomic, strong) NSString *level_name;
@property (nonatomic, strong) NSString *login_id;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *payment_id;
@property (nonatomic, strong) NSString *payment_name;
@property (nonatomic, strong) NSString *recommend_user_id;//推荐人id
@property (nonatomic, strong) NSString *share_img;
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSString *user_header;
@property (nonatomic, strong) NSString *user_ip;
@property (nonatomic, strong) NSString *user_ip_address;
@property (nonatomic, strong) NSString *user_is_sign;// n;
@property (nonatomic, assign) double user_money;
@property (nonatomic, assign) double user_money_all;
@property (nonatomic, assign) NSInteger user_score;
@property (nonatomic, assign) NSInteger user_score_all;
@property (nonatomic, strong) NSString *user_tel;
@property (nonatomic, strong) NSString *win_time;

@property (nonatomic, assign) NSInteger shoppCartNum;

@property (nonatomic, strong) NSString *nickName;    //用户呢称
@property (nonatomic, strong) NSString *userHeader;   //用户头像
@property (nonatomic, strong) NSString *userScore;    //可用积分
@property (nonatomic, strong) NSString *userMoney;     //可用夺宝币

+(UserInfo *)UserInfoWithDic:(NSDictionary *)dic;
-(UserInfo *)initWithDic:(NSDictionary *)dic;

@end
