//
//  GoodsDetailInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WinUserInfo : NSObject

@property (nonatomic, strong) NSString *user_ip;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *fight_time;
@property (nonatomic, strong) NSString *user_header;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *user_ip_address;
@property(nonatomic,strong)NSString *win_user_position;
@property(nonatomic,strong)NSString *LotteryRegion;
@end

@interface NextDuoBaoInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *good_period;
@end


@interface GoodsDetailInfo : NSObject

@property (nonatomic, strong) NSString *click_num;
@property (nonatomic, strong) NSString *content ;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *daojishi_message;
@property (nonatomic, strong) NSString *daojishi_time;
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *good_href;
@property (nonatomic, strong) NSString *good_id;
@property (nonatomic, strong) NSString *good_imgs;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSString *good_period;
@property (nonatomic, assign) double good_price;
@property (nonatomic, strong) NSString *  good_single_price;
@property (nonatomic, strong) NSString *goods_type_id;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *is_bask;
@property (nonatomic, strong) NSString *is_get_caipiao;
@property (nonatomic, strong) NSString *is_next;
@property (nonatomic, strong) NSString *is_show_daojishi;
@property (nonatomic, strong) NSString *lottery_num_id;
@property (nonatomic, strong) NSString *lottery_time;
@property (nonatomic, strong) NSString *need_people;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NextDuoBaoInfo *next_fight;
@property (nonatomic, strong) NSString *now_people;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *progress;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *win_num;
@property (nonatomic, strong) NSString *win_user_id;
@property (nonatomic, strong) WinUserInfo *win_user;

//最新揭晓
@property (nonatomic, strong) NSString *play_num;

//改动
@property (nonatomic, strong) NSString *productId;  //商品ID
@property (nonatomic, strong) NSString *productName;  //商品名称
@property (nonatomic, strong) NSString *photoUrl;     //图片url
@property (nonatomic, strong) NSString *productPrice;    //商品价格
@property (nonatomic, strong) NSString *productContentUrl;  //图片链接

@end
