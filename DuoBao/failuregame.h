//
//  failuregame.h
//  DuoBao
//
//  Created by Macintosh on 2017/4/11.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol failuregameDelegate;
@interface failuregame : UIView

@property (nonatomic,assign) id<failuregameDelegate>delegate;

@end

@protocol failuregameDelegate <NSObject>

-(void)gotoProductFail;
-(void)onceagainFail;

@end
