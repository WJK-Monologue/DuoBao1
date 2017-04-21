//
//  WinnerRecord.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/21.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "WinnerRecord.h"

@implementation WinnerRecord


+(WinnerRecord *)WinnerRecordWithDic:(NSDictionary *)dic
{
    return [[self alloc]initWithDic:dic];
}
-(WinnerRecord *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.userId = dic[@"userId"];
        self.userImg = dic[@"userImg"];
        self.userName = dic[@"userName"];
        self.userIpSite = dic[@"userIpSite"];
        self.userIp = dic[@"userIp"];
        self.winTime = dic[@"winTime"];
    }
    return self;
}

@end
