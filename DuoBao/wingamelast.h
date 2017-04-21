//
//  wingamelast.h
//  DuoBao
//
//  Created by Macintosh on 2017/4/11.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol wingamelastDelegate;

@interface wingamelast : UIView

@property (nonatomic,assign) id<wingamelastDelegate>delegate;

-(id)initWithgoodDic:(NSDictionary *)goodDic;

@end

@protocol wingamelastDelegate <NSObject>

-(void)gotoHomePageWin;
-(void)oncegainWin;

@end
