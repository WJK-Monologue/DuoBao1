//
//  haoyoupkViewController.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/10.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "haoyoupkViewController.h"

@interface haoyoupkViewController ()<UINavigationControllerDelegate>

@end

@implementation haoyoupkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initParameter];
}
-(void)initParameter
{
    self.title = @"好友PK";
    self.navigationController.delegate = self;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    //2个按钮
    UIButton *Creatroom = [UIButton buttonWithType:UIButtonTypeCustom];
    [Creatroom setImage:[UIImage imageNamed:@"cqjb"] forState:UIControlStateNormal];
    Creatroom.center = CGPointMake(WIDTH/2, HEIGHT/667*160);
    Creatroom.bounds = CGRectMake(0, 0, WIDTH/375*120, HEIGHT/667*160);
    [Creatroom addTarget:self action:@selector(cqjb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Creatroom];
    
    UIButton *creat = [UIButton buttonWithType:UIButtonTypeCustom];
    [creat setTitle:@"创建房间" forState:UIControlStateNormal];
    [creat setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    creat.center = CGPointMake(WIDTH/2,HEIGHT/667*265);
    creat.bounds = CGRectMake(0, 0, WIDTH/375*120, HEIGHT/667*20);
    [creat addTarget:self action:@selector(cqjb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creat];
    
    UIButton *Gotoroom = [UIButton buttonWithType:UIButtonTypeCustom];
    [Gotoroom setImage:[UIImage imageNamed:@"hyPK"] forState:UIControlStateNormal];
    Gotoroom.center = CGPointMake(WIDTH/2,HEIGHT/667*465);
    Gotoroom.bounds = CGRectMake(0, 0, WIDTH/375*120, HEIGHT/667*160);
    [Gotoroom addTarget:self action:@selector(hyPK) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Gotoroom];
    
    UIButton *go = [UIButton buttonWithType:UIButtonTypeCustom];
    [go setTitle:@"进入房间" forState:UIControlStateNormal];
    [go setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    go.center = CGPointMake(WIDTH/2,HEIGHT/667*570);
    go.bounds = CGRectMake(0, 0, WIDTH/375*120, HEIGHT/667*20);
    [go addTarget:self action:@selector(hyPK) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:go];

}
#pragma mark - 按钮绑定方法
-(void)cqjb
{

}
-(void)hyPK
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
