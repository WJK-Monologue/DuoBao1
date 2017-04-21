//
//  Comment.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/21.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

//@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *goodsId;
//@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *commentTime;
@property (nonatomic, strong) NSString *userImg;
@property (nonatomic, strong) NSString *commentImg;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *commentContent;

+(Comment *)CommentWithDic:(NSDictionary *)dic;
-(Comment *)initWithDic:(NSDictionary *)dic;

@end
