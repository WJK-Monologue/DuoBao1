//
//  BannerInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsSerchInfo : NSObject

@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *good_name;

@end


@interface BannerInfo : NSObject

@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *is_jump;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) GoodsSerchInfo *goodInformation;
@end

