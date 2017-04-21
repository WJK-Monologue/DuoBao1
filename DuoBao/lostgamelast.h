//
//  lostgamelast.h
//  DuoBao
//
//  Created by Macintosh on 2017/4/11.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol lostgamelastDelegate;

@interface lostgamelast : UIView

//-(id)initWithloserDic:(NSDictionary *)loserDic;

@property (nonatomic,assign) id<lostgamelastDelegate>delegate;

@end

@protocol lostgamelastDelegate <NSObject>

-(void)gotoHomePageLoser;
-(void)oncegainLoser;

@end
