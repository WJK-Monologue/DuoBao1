//
//  gamewin.h
//  DuoBao
//
//  Created by Macintosh on 2017/4/11.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol gamewinDelegate;

@interface gamewin : UIView

@property (nonatomic,assign) id<gamewinDelegate>delegate;

@end

@protocol gamewinDelegate <NSObject>

@end
