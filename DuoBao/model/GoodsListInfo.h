//
//  GoodsListInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsListInfo : NSObject

//改动  商品路径名称
@property (nonatomic, strong) NSString *thumbnailUrl;  //图片路径
@property (nonatomic, strong) NSString *productName;   //商品名
@property (nonatomic, strong) NSString *productPrice;   //商品价格
@property (nonatomic, strong) NSString *productId;     //商品ID
@property (nonatomic, strong) NSString *totalNum;
@property (nonatomic, strong) NSString *unitCost;       //计算价格


@property (nonatomic, strong) NSString *productContent;


@property (nonatomic, strong) NSString *good_id;

@property (nonatomic, strong) NSString *good_period;
@property (nonatomic, strong) NSString *id;
@property (strong, nonatomic) NSString *progress;
@property (strong, nonatomic) NSString *good_single_price;
@property (assign, nonatomic) NSInteger now_people;
@property (assign, nonatomic) NSInteger need_people;
@end
