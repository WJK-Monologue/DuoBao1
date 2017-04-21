//
//  requestTool.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/16.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface requestTool : NSObject

@property (nonatomic,copy) void (^BlockDic)(NSDictionary *dic);
//- (void)loadUserResult;
//- (void)handleUserResult:(NSDictionary *)resultDic;

//@property (nonatomic,retain) NSDictionary *userDic;

@property (nonatomic, retain) NSString *reveId;

- (void)handleUserResultBlock:(void(^)(NSDictionary *Dic))block;

//-(void)handleOtherResultBlock:(void (^)(NSDictionary *Dic))Otherblock;

//-(void)handleMoreUsersBlock:(void (^)(NSDictionary *Dic))block;

//再战一局
-(void)requestuserId:(NSString *)userId goodId:(NSString *)goodId NumPeople:(NSString *)NumPeople peoplePrice:(NSString *)peoplePrice;
//休息一下
-(void)haverest;

//字符串转Json
- (void) strChangeJsonStr:(NSString *)str;

@end
