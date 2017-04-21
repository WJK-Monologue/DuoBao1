//
//  WPTappableLabel.h
//  WPAttributedMarkupDemo
//
//  Created by Nigel Grange on 20/10/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CopyLabel.h"
@interface WPTappableLabel : CopyLabel

@property (nonatomic, readwrite, copy) void (^onTap) (CGPoint);

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
