//
//  SocketInteraction.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/23.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "SocketInteraction.h"

static SocketInteraction * sock = nil;

@implementation SocketInteraction
{
    //保存二级制文件数据
    //NSMutableData *_currentData;
    //保存有用的字符串数据
    //NSMutableArray *_lastMessages;
}

+(SocketInteraction *)shareObject;
{
    static dispatch_once_t onceToken;
    //dispatch_once检测onceToken这个指针地址有没有被调用
    dispatch_once(&onceToken, ^{
        
        //这句代码.在这里只调用一次
        sock = [[SocketInteraction alloc]init];
        
    });
    return sock;
}

+(instancetype)alloc
{
    @synchronized (self) {
        if(!sock)
        {
            //执行父类的方法分配内存,内存只允许分配一次:
            sock = [super alloc];
        }
        return sock;
    }
}

-(void)ClientConnectionServerMsg:(NSString *)msg
{
    self.ay = [[AsyncSocket alloc]initWithDelegate:self];
    [self.ay connectToHost:URL_IP onPort:8888 error:nil];
    
    [self.ay writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10.0f tag:101];
    [self.ay readDataWithTimeout:-1 tag:0];
}

-(void)ConnectionServerMsg:(NSString *)msg
{
    NSLog(@"向服务器发送");
    [self.ay writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10.0f tag:101];
    [self.ay readDataWithTimeout:-1 tag:0];
}

#pragma mark --AsyncSocketDelegate--
//不断获取
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    /*  一直发送请求
     [self.ay writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]
     withTimeout:10.0f
     tag:101];
     [self.ay readDataWithTimeout:-1 tag:0];
     */
    NSLog(@"data=%@",data);
    //  接收
    /*NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *reStr = [[NSString alloc]initWithData:data encoding:enc];
    NSData *jsonData = [reStr dataUsingEncoding:enc];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:enc];
    NSData *Data = [str dataUsingEncoding:NSUTF8StringEncoding];*/
    
    //NSError *err;
    //NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:Data options:NSJSONReadingMutableContainers error:&err];
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"msg" object:nil userInfo:dic];
    //NSLog(@"===dic=%@",dic);
    NSString  *msg =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"msg = %@",msg);
    
    if(![msg isEqualToString:@"(null)"]&&![msg isEqualToString:@""])
    {
        //处理粘包
        NSArray *strArray = [msg componentsSeparatedByString:@"\n"];
        for (NSString *sendmessage in strArray) {
            NSString *str = sendmessage;
            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSLog(@"str=%@",str);
            
            //字符串转字典
            if (![str isEqualToString:@""]) {
                NSData *dataChange = [[NSData alloc]initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:dataChange options:NSJSONReadingMutableContainers error:nil];
                //改用通知
                [[NSNotificationCenter defaultCenter]postNotificationName:@"msg" object:nil userInfo:resultDic];
                [self.ay readDataWithTimeout:-1 tag:0];
            }
        }
    }
}
//当socket完成写数据请求的时候
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [self.ay readDataWithTimeout:-1 tag:0];
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"didConnectToHost   %@------%d",host,port);
    [self.ay readDataWithTimeout:-1 tag:0];
}
//当socket读取数据并且没有完成。
//如果使用readToData:或者是 readToLength方法将会发生。
//它在进度条更新的时候可能被使用。
-(void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"Received bytes: %lu",(unsigned long)partialLength);
}
-(void) onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"%@,%@",sock,err);
}

//----------------------
/*
-(instancetype)init{
    if (self = [super init]) {
        _currentData = [[NSMutableData alloc] init];
    }
    return self;
}

-(void)appendingData:(id)data newData:(SocketDataBlock)block
{
    //1、拼接二进制数据
    [_currentData appendData:data];
    //2、转化成字符串
    NSString *string = [[NSString alloc] initWithData:_currentData encoding:NSUTF8StringEncoding];
    NSLog(@"socket 收到的数据data = %@",string);
    
    //3、分割字符串
    NSArray *stringArr = [string componentsSeparatedByString:@"\n"];
    NSMutableArray *usefulStringArr = [NSMutableArray new];
    
    int count = 0;
    //4、获取有用的字符串
    for (NSString *str in stringArr) {
        if ([str hasPrefix:@"{"] && [str hasSuffix:@"}"]) {
            [usefulStringArr addObject:str];
        //}else if (!IsStringEmpty(str)){
             }else {
            NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
            _currentData = [strData mutableCopy];
            count ++;
        }
    }
    
    if (count == 0) {
        _currentData = [[NSMutableData alloc] init];
    }
    
    block(usefulStringArr);
}*/
@end
