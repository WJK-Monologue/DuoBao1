//
//  chongzhiAlertView.h
//  DuoBao
//
//  Created by Macintosh on 2017/4/10.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chongzhiDelegate;

@interface chongzhiAlertView : UIView<UITextFieldDelegate>

-(id)initWithCzBtn:(UIImage *)Czbtn Cztitle:(UIImage *)Cztitle;

@property (nonatomic,assign) id<chongzhiDelegate>delegate;

@end

@protocol chongzhiDelegate <NSObject>

- (void)zhifubao:(UIButton *)sender;


@end
