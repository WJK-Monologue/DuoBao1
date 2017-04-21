//
//  UIView+Additions.h
//  Couture
//
//  Created by Apple on 14-11-16.
//  Copyright (c) 2014年 Kaymin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

@property(assign, nonatomic) CGFloat centerX;
@property(assign, nonatomic) CGFloat centerY;

@property(assign, nonatomic) CGFloat top;
@property(assign, nonatomic) CGFloat left;
@property(assign, nonatomic) CGFloat bottom;
@property(assign, nonatomic) CGFloat right;

@property(assign, nonatomic) CGFloat width;
@property(assign, nonatomic) CGFloat height;

@property(assign, nonatomic) CGPoint origin;
@property(assign, nonatomic) CGSize size;



- (void)removeAllSubviews;

@end
