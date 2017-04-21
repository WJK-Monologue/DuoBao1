//
//  KeyChainStore.h
//  uuid
//
//  Created by Macintosh on 2017/4/11.
//  Copyright © 2017年 Jiacong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
@end
