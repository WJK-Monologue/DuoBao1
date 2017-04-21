//
//  Comment.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/21.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "Comment.h"

@implementation Comment

+(Comment *)CommentWithDic:(NSDictionary *)dic
{
    return  [[self alloc]initWithDic:dic];
}

-(Comment *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.goodsId = dic[@"goodsId"];
        self.commentTime = dic[@"commentTime"];
        self.userImg = dic[@"userImg"];
        self.commentImg = dic[@"commentImg"];
        self.userName = dic[@"userName"];
        self.commentContent = dic[@"commentContent"];
    }
    return self;
}


@end
