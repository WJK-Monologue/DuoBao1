//
//  judge.h
//  huochaicfST
//
//  Created by yuhao on 16/7/25.
//  Copyright © 2016年 yuhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface judge : UIView
//NSString *appStrotUrl;
//NSString *content;
@property(nonatomic,strong)NSString *appStrotUrl;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)NSInteger force;

-(void)drawView;
-(void)show;
@end
