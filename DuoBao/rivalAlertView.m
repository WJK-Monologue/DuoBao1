//
//  myAlertView.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/16.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "rivalAlertView.h"
#import "UIColor+extention.h"
#import "HttpHelper.h"
#import "UserInfo.h"

@implementation rivalAlertView
{
    NSDictionary *giftDic;
}
-(id)initWithRight:(UIImage *)right title:(UIImage *)title Head:(UIImage *)head Name:(NSString *)name ID:(NSString *)idnum Sex:(NSString *)sex Douzi:(NSString *)douzi Jifen:(NSString *)jifen Cishu:(NSString *)cishu Money:(NSString *)money;
{
    self = [super init];
    if (self) {
        
        
        //添加阴影效果
        self.frame = [UIScreen mainScreen].bounds;
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc]initWithEffect:effect];
        effectview.frame = [UIScreen mainScreen].bounds;
        [self addSubview:effectview];
        
        //背景框
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*55, HEIGHT/667*33, WIDTH-WIDTH/375*110, HEIGHT/667*234)];
        imgV.userInteractionEnabled = YES;
        imgV.image = [UIImage imageNamed:@"bord_bg"];
        [self addSubview:imgV];
        
        //自定义右按钮
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(WIDTH/375*300, HEIGHT/667*25, WIDTH/375*29, WIDTH/375*29);
        [rightBtn setImage:right forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        
        //标题
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*104, HEIGHT/667*15, WIDTH/375*50, HEIGHT/667*13)];
        img.image = title;
        [imgV addSubview:img];
        
        UIImageView *img_bg = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*22, HEIGHT/667*30, WIDTH/375*215, HEIGHT/667*7)];
        img_bg.image = [UIImage imageNamed:@"title_bg"];
        [imgV addSubview:img_bg];
        
        //基本信息
        Message = [UIButton buttonWithType:UIButtonTypeCustom];
        Message.frame = CGRectMake(WIDTH/375*22, HEIGHT/667*43, WIDTH/375*107.5, HEIGHT/667*25);
        [Message setImage:[UIImage imageNamed:@"message_tab_on"] forState:UIControlStateNormal];
        [Message addTarget:self action:@selector(MessageAction) forControlEvents:UIControlEventTouchUpInside];
        [imgV addSubview:Message];
        
        //战绩表
        Source = [UIButton buttonWithType:UIButtonTypeCustom];
        Source.frame = CGRectMake(WIDTH/375*129.5, HEIGHT/667*43, WIDTH/375*107.5, HEIGHT/667*25);
        [Source setImage:[UIImage imageNamed:@"message_tab01"] forState:UIControlStateNormal];
        [Source addTarget:self action:@selector(SourceAction) forControlEvents:UIControlEventTouchUpInside];
        [imgV addSubview:Source];
        
        //头像
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*24, HEIGHT/667*82, WIDTH/375*47, WIDTH/375*47)];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 3;
        image.image = head;
        [imgV addSubview:image];
        
        //昵称
        UIImageView *label1 = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*76, HEIGHT/667*82, WIDTH/375*22, HEIGHT/667*10)];
        label1.image = [UIImage imageNamed:@"txt_name"];
        [imgV addSubview:label1];
        
        UIImageView *imgname = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*106, HEIGHT/667*79, WIDTH/375*116, HEIGHT/667*15)];
        imgname.image = [UIImage imageNamed:@"txtbord"];
        [imgV addSubview:imgname];
        
        UILabel *namelab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*116, HEIGHT/667*79, WIDTH/375*116, HEIGHT/667*15)];
        namelab.text = name;
        namelab.font = [UIFont systemFontOfSize:8];
        namelab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [imgV addSubview:namelab];
        
        //ID
        UIImageView *label2 = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*76, HEIGHT/667*99, WIDTH/375*13, HEIGHT/667*10)];
        label2.image = [UIImage imageNamed:@"txt_ID"];
        [imgV addSubview:label2];
        
        UIImageView *imgid = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*106, HEIGHT/667*99, WIDTH/375*116, HEIGHT/667*15)];
        imgid.image = [UIImage imageNamed:@"txtbord"];
        [imgV addSubview:imgid];
        
        UILabel *labid = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*116, HEIGHT/667*99, WIDTH/375*116, HEIGHT/667*15)];
        labid.text = idnum;
        labid.font = [UIFont systemFontOfSize:8];
        labid.textColor = namelab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [imgV addSubview:labid];
        
        //猜拳豆
        UIImageView *imgdouzi = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*85, HEIGHT/667*136, WIDTH/375*48, HEIGHT/667*20)];
        imgdouzi.image = [UIImage imageNamed:@"txtbord"];
        [imgV addSubview:imgdouzi];
        
        UILabel *labdouzi = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*92, HEIGHT/667*136, WIDTH/375*48, HEIGHT/667*20)];
        labdouzi.text = douzi;
        labdouzi.font = [UIFont systemFontOfSize:13];
        labdouzi.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [imgV addSubview:labdouzi];
        
        UIImageView *caiquan = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*71, HEIGHT/667*135, WIDTH/375*21, HEIGHT/667*21)];
        caiquan.image = [UIImage imageNamed:@"cqd"];
        [imgV addSubview:caiquan];
        
        //积分
        UIImageView *imgjf = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*162, HEIGHT/667*136, WIDTH/375*48, HEIGHT/667*20)];
        imgjf.image = [UIImage imageNamed:@"txtbord"];
        [imgV addSubview:imgjf];
        
        UILabel *labjf = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*171, HEIGHT/667*136, WIDTH/375*48, HEIGHT/667*20)];
        labjf.text = jifen;
        labjf.font = [UIFont systemFontOfSize:13];
        labjf.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [imgV addSubview:labjf];
        //
        UIImageView *jf = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*148, HEIGHT/667*135, WIDTH/375*21, HEIGHT/667*21)];
        jf.image = [UIImage imageNamed:@"jf"];
        [imgV addSubview:jf];
        
        lowVi = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT/667*200, WIDTH, HEIGHT/667*58)];
        [self addSubview:lowVi];
        
        //底部图片
                NSArray *array = @[@"gift01_on",@"gift02_on",@"gift03_on",@"gift04_on",@"gift05_on",@"gift06_on"];
                for (int i=0; i<array.count; i++)
                {
                    
                    UIButton *lowbut = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/375*31+i*(WIDTH/375*(44+10)), 0, WIDTH/375*44, HEIGHT/667*44)];
                    [lowbut setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",array[i]]] forState:UIControlStateNormal];
                    [lowbut addTarget:self action:@selector(giftAction:) forControlEvents:UIControlEventTouchUpInside];
                    lowbut.tag = i;
                    [lowVi addSubview:lowbut];

                    UIImageView *imgfive = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*44+i*(WIDTH/375*(10+44)), HEIGHT/667*48, WIDTH/375*10, HEIGHT/667*10)];
                    imgfive.image = [UIImage imageNamed:@"jf"];
                    [lowVi addSubview:imgfive];

                    UILabel *labfive = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*57+i*(WIDTH/375*(10+44)), HEIGHT/667*48, WIDTH/375*8, HEIGHT/667*10)];
                    labfive.text = @"5";
                    labfive.font = [UIFont systemFontOfSize:8];
                    labfive.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
                    [lowVi addSubview:labfive];
                }
        
        //盖个视图
        upView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/375*57.5, HEIGHT/667*101, WIDTH-WIDTH/375*115, HEIGHT/667*105)];
        upView.layer.masksToBounds = YES;
        upView.layer.cornerRadius = 5;
        upView.backgroundColor = [UIColor colorWithRGBValue:0x23273a andAlpha:1.0];
        upView.alpha = 0;
        [self addSubview:upView];
        
        //连赢次数
        UIImageView *winimg = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*22, HEIGHT/667*12, WIDTH/375*208, HEIGHT/667*28)];
        winimg.image = [UIImage imageNamed:@"zj_bord"];
        [upView addSubview:winimg];
        
        UILabel *winlab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*30, HEIGHT/667*12, WIDTH/375*152, HEIGHT/667*28)];
        winlab.text = @"连赢次数";
        winlab.font = [UIFont systemFontOfSize:13];
        winlab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [upView addSubview:winlab];
        
        UIImageView *cishuimg = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*166, HEIGHT/667*16, WIDTH/375*56, HEIGHT/667*20)];
        cishuimg.image = [UIImage imageNamed:@"zj_bord01"];
        [upView addSubview:cishuimg];
        
        UILabel *cishulab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*168, HEIGHT/667*16, WIDTH/375*56, HEIGHT/667*20)];
        cishulab.text = cishu;
        cishulab.font = [UIFont systemFontOfSize:13];
        cishulab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [upView addSubview:cishulab];
        
        //获得最高商品金额
        UIImageView *mostimg = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*22, HEIGHT/667*52, WIDTH/375*208, HEIGHT/667*28)];
        mostimg.image = [UIImage imageNamed:@"zj_bord"];
        [upView addSubview:mostimg];
        
        UILabel *mostlab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*30, HEIGHT/667*52, WIDTH/375*152, HEIGHT/667*28)];
        mostlab.text = @"获得最高商品金额";
        mostlab.font = [UIFont systemFontOfSize:13];
        mostlab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [upView addSubview:mostlab];
        
        UIImageView *monryimg = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/375*166, HEIGHT/667*56, WIDTH/375*56, HEIGHT/667*20)];
        monryimg.image = [UIImage imageNamed:@"zj_bord01"];
        [upView addSubview:monryimg];
        
        UILabel *moneylab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/375*168, HEIGHT/667*56, WIDTH/375*58, HEIGHT/667*20)];
        moneylab.text = money;
        moneylab.font = [UIFont systemFontOfSize:13];
        moneylab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [upView addSubview:moneylab];
        
    }
    return self;

}

#pragma mark - 按钮的方法


-(void)MessageAction
{
    static int i;
    i = 0;
    i++;
    if (i%2==0) {
        [Message setImage:[UIImage imageNamed:@"message_tab"] forState:UIControlStateNormal];
        [Source setImage:[UIImage imageNamed:@"message_tab01_on"] forState:UIControlStateNormal];
    }
    else{
        [Message setImage:[UIImage imageNamed:@"message_tab_on"] forState:UIControlStateNormal];
        [Source setImage:[UIImage imageNamed:@"message_tab01"] forState:UIControlStateNormal];
    }
    upView.alpha = 0;
    lowVi.alpha = 1;
}
-(void)SourceAction
{
    static int j;
    j = 0;
    j++;
    if (j%2==0) {
        [Message setImage:[UIImage imageNamed:@"message_tab_on"] forState:UIControlStateNormal];
        [Source setImage:[UIImage imageNamed:@"message_tab01"] forState:UIControlStateNormal];
    }
    else
    {
        [Message setImage:[UIImage imageNamed:@"message_tab"] forState:UIControlStateNormal];
        [Source setImage:[UIImage imageNamed:@"message_tab01_on"] forState:UIControlStateNormal];
    }
    upView.alpha = 1;
    lowVi.alpha = 0;
}
//确定按钮
-(void)sureAction
{
    [self removeFromSuperview];
}

//右上角 按钮
-(void)rightclick
{
    [self removeFromSuperview];
}

-(void)giftAction:(UIButton *)giftNum
{
    NSArray *array = @[@"NO17041017175400001",@"NO17041017181600001",@"NO17041017182700001",
@"NO17041017183600001",@"NO17041017184900001",@"NO17041017174000001"];
    
    UserInfo *info = [[UserInfo alloc]init];
    info.id = [ShareManager shareInstance].userinfo.id;
    
    NSLog(@"info.id = %@",info.id);
    NSLog(@"array[giftNum.tag] = %@",array[giftNum.tag]);
    
    HttpHelper *http = [[HttpHelper alloc]init];
    [http loadGiftUserId:info.id GiftNumber:array[giftNum.tag] success:^(NSDictionary *resultDic) {
        NSLog(@"扣除礼物成功：%@",resultDic);
    } fail:^(NSString *description) {
        NSLog(@"扣除礼物失败");
    }];
     if (self.delegate && [self.delegate respondsToSelector:@selector(gotogift:)]) {
       [self.delegate gotogift:giftNum];
     }
     [self removeFromSuperview];
}

@end
