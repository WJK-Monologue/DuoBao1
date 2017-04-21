//
//  Scrollview2.m
//  huochaicfST
//
//  Created by 余灏 on 16/5/29.
//  Copyright © 2016年 yuhao. All rights reserved.
//

#import "Scrollview2.h"
#define kBtnTag 777

#define kBtnCount 5

#define kBtnSpace 5 // 按钮的超出部分

@implementation Scrollview2
{
    UIScrollView *_scrollView;
    UIView *_topLine;
    
    // 记录当前选择的按钮
    NSInteger _index;
    
    // 记录titles count
    NSInteger _titlesCount;
    
    CGFloat _btnWidth;

}
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles callBack:(CallBack)block
{
    if (self = [super initWithFrame:frame])
    {
        //cell.contentView.backgroundColor = kColorRGB(0xedecf3);
        
        
        _titlesCount = titles.count;
        
        self.block = block;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
        
        [self addSubview:_scrollView];
        
        // 计算按钮的宽度
        if (titles.count <= kBtnCount) {
            _btnWidth = self.bounds.size.width / titles.count;
        } else {
            _btnWidth = self.bounds.size.width / kBtnCount + kBtnSpace;
        }
        
        _scrollView.contentSize = CGSizeMake(titles.count * _btnWidth, _scrollView.bounds.size.height);
        
        for (int i = 0; i < titles.count; i++)
        {
            UIButton *btn = [self createBtn:CGRectMake(_btnWidth * i, 0, _btnWidth, self.bounds.size.height) title:titles[i]];
            [_scrollView addSubview:btn];
            
            btn.tag = kBtnTag + i;
            
            if (i == 0) {
                btn.selected = YES;
                
                _index = 0;
                
                // 线条
                _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-2, _btnWidth, 2)];
                _topLine.backgroundColor = [UIColor orangeColor];
                [_scrollView addSubview:_topLine];
            }
        }
    }
    return self;
}
//209 182 74
- (UIButton *)createBtn:(CGRect)frame title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:209/255.0f green:182/255.0f blue:74/255.0f alpha:1] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)btnClick:(UIButton *)sender
{
    if (sender.selected) return;
    
    sender.selected = YES;
    
    UIButton *oldBtn = (UIButton *)[_scrollView viewWithTag:kBtnTag + _index];
    
    oldBtn.selected = NO;
    
    // 记录新的下标
    _index = sender.tag - kBtnTag;
    
    // 回调
    if (self.block) {
        self.block(_index);
    }
}

/**
 选择对应的按钮
 */
- (void)selectButtonIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[_scrollView viewWithTag:kBtnTag + index];
    
    if (btn.selected) return;
    
    btn.selected = YES;
    
    // 将之前的变为不选中
    UIButton *oldBtn = (UIButton *)[_scrollView viewWithTag:kBtnTag + _index];
    
    oldBtn.selected = NO;
    
    // 记录
    _index = index;
    
}

/**
 设置底部线条的实时偏移量
 */
- (void)moveTopViewLine:(CGPoint)point
{
    CGRect rect = _topLine.frame;
    
    if (_titlesCount <= kBtnCount)
    {
        rect.origin.x = point.x / _titlesCount;
    }
    else
    {
        // 计算超过kBtnCount个数按钮的线条偏移量
        rect.origin.x = (point.x / kBtnCount) + (point.x / self.bounds.size.width * kBtnSpace);
        
        // 修改scrollView的偏移量
        [self moveScrollViewContentOffset:rect];
    }
    
    _topLine.frame = rect;
}

/**
 改变scrollView的偏移量，显示在可见区域
 */
- (void)moveScrollViewContentOffset:(CGRect)frame
{
    [_scrollView scrollRectToVisible:CGRectMake(frame.origin.x, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height) animated:YES];
}

@end

