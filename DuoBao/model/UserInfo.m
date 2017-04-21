//
//  UserInfo.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+(UserInfo *)UserInfoWithDic:(NSDictionary *)dic
{
    return [[self alloc]initWithDic:dic];
}
-(UserInfo *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.id = dic[@"id"];
        self.nickName = dic[@"nickName"];
        self.userHeader = dic[@"userHeader"];
        self.userScore = dic[@"userScore"];
        self.userMoney = dic[@"userMoney"];
    }
    return self;
}

@end
