//
//  Scrollview2.h
//  huochaicfST
//
//  Created by 余灏 on 16/5/29.
//  Copyright © 2016年 yuhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBack)(NSInteger pageIndex);


@interface Scrollview2 : UIView

@property (nonatomic, copy) CallBack block;


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles callBack:(CallBack)block;

/**
 选择对应的按钮
 */
- (void)selectButtonIndex:(NSInteger)index;

/**
 设置底部线条的实时偏移量
 */
- (void)moveTopViewLine:(CGPoint)point;
@end
