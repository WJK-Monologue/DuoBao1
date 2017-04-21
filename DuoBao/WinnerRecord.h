//
//  WinnerRecord.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/21.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WinnerRecord : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userImg;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userIpSite;
@property (nonatomic, strong) NSString *userIp;
@property (nonatomic, strong) NSString *winTime;

+(WinnerRecord *)WinnerRecordWithDic:(NSDictionary *)dic;
-(WinnerRecord *)initWithDic:(NSDictionary *)dic;

@end
