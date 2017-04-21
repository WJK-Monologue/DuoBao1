//
//  JieXiaoInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JieXiaoInfo : NSObject

@property (nonatomic, strong) NSString *productId;  //产品ID
@property (nonatomic, strong) NSString *productName;  //产品名
@property (nonatomic, strong) NSString *thumbnailUrl;  //产品url
@property (nonatomic, strong) NSString *productPrice;  //产品价格
@property (nonatomic, strong) NSString *number;  //人数
@property (nonatomic, strong) NSString *unitCost;  //产品人次价格


@property (nonatomic, strong) NSString *daojishi_message;
@property (nonatomic, strong) NSString *daojishi_time;
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *is_show_daojishi;
@property (nonatomic, strong) NSString *lottery_time;
@property (nonatomic, strong) NSString *nick_name;

@end
