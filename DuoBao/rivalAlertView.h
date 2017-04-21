//
//  myAlertView.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/16.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol rivalDelegate;

@interface rivalAlertView : UIView
{
    UIButton *Message;
    UIButton *Source;
    UIView *upView;
    UIView *lowVi;
}
-(id)initWithRight:(UIImage *)right title:(UIImage *)title Head:(UIImage *)head Name:(NSString *)name ID:(NSString *)idnum Sex:(NSString *)sex Douzi:(NSString *)douzi Jifen:(NSString *)jifen Cishu:(NSString *)cishu Money:(NSString *)money;



@property (nonatomic,assign) id<rivalDelegate>delegate;

@end

@protocol rivalDelegate <NSObject>

-(void)gotogift:(UIButton *)sender;

@end
