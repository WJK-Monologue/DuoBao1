//
//  BeatViewController.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/14.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wingamelast.h"
#import "failuregame.h"
#import "lostgamelast.h"

@interface BeatViewController : UIViewController<wingamelastDelegate,failuregameDelegate,lostgamelastDelegate>

@property (nonatomic,retain) UIScrollView *scrollUp;
@property (nonatomic,retain) UIScrollView *scrollDown;

@property (nonatomic,retain) NSDictionary *chuanzhiDic;
@property (nonatomic,retain) NSString *peopleNumBeat;

@property (nonatomic,retain) NSString *ReturnMoney;
@property (nonatomic,retain) NSString *ReturnProductId;
@property (nonatomic,retain) NSString *ReturnNum;


@end
