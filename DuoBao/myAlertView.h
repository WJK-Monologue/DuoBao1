//
//  myAlertView.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/16.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myDelegate;

@interface myAlertView : UIView
{
    UIButton *Message;
    UIButton *Source;
    UIView *upView;
}
-(id)initWithRightBtn:(UIImage *)rightbtn Mytitle:(UIImage *)mytitle Head:(UIImage *)head Name:(NSString *)name ID:(NSString *)idnum Sex:(NSString *)sex Douzi:(NSString *)douzi Jifen:(NSString *)jifen Cishu:(NSString *)cishu Money:(NSString *)money;

@property (nonatomic,assign) id<myDelegate>delegate;

@end

@protocol myDelegate <NSObject>


@end
