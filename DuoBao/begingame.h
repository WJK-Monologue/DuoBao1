//
//  begingame.h
//  DuoBao
//
//  Created by Macintosh on 2017/4/12.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol begingameDelegate;

@interface begingame : UIView


@property (nonatomic,assign) id<begingameDelegate>delegate;

@end

@protocol begingameDelegate <NSObject>

@end
