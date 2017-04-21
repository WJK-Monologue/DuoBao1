//
//  AppDelegate.h
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)NSString *hongbaoshu;

@property(nonatomic,strong)NSString *shangyici;
@property(nonatomic,strong)NSString *zheyici;
@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *openid;
@property (strong, nonatomic) NSString *nickname; // 用户昵称
@property (strong, nonatomic) NSString *headimgurl; // 用户头像地址
@property(strong,nonatomic)NSString *versionNow;

@end

