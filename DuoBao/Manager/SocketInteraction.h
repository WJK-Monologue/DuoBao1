//
//  SocketInteraction.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/23.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "AsyncSocket.h"

@interface SocketInteraction : NSObject

//typedef void(^SocketDataBlock)(NSMutableArray * receiveData);

@property (nonatomic, retain) AsyncSocket *ay;

+(SocketInteraction *)shareObject;

//-(void)appendingData:(id)data newData:(SocketDataBlock)block;

- (void)ClientConnectionServerMsg:(NSString *)msg;

-(void)ConnectionServerMsg:(NSString *)msg;

@end
