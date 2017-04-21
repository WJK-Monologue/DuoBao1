//
//  myAlertView.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/16.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "myAlertView.h"
#import "UIColor+extention.h"

@implementation myAlertView

-(id)initWithRightBtn:(UIImage *)rightbtn Mytitle:(UIImage *)mytitle Head:(UIImage *)head Name:(NSString *)name ID:(NSString *)idnum Sex:(NSString *)sex Douzi:(NSString *)douzi Jifen:(NSString *)jifen Cishu:(NSString *)cishu Money:(NSString *)money;
{
    self = [super init];
    if (self) {
        
        //添加阴影效果
        self.frame = [UIScreen mainScreen].bounds;
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc]initWithEffect:effect];
        effectview.frame = [UIScreen mainScreen].bounds;
        [self addSubview:effectview];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*55, FitHEIGHT*33, WIDTH-FitWIDTH*110, FitHEIGHT*177)];
        imgV.userInteractionEnabled = YES;
        imgV.image = [UIImage imageNamed:@"bord_bg"];
        [self addSubview:imgV];
        
        //自定义右按钮
        UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
        right.frame = CGRectMake(FitWIDTH*300, FitHEIGHT*25, FitWIDTH*29, FitWIDTH*29);
        [right setImage:rightbtn forState:UIControlStateNormal];
        [right addTarget:self action:@selector(rightclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:right];
        
        //标题
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*104, FitHEIGHT*15, FitWIDTH*50, FitHEIGHT*13)];
        img.image = mytitle;
        [imgV addSubview:img];
        
        UIImageView *img_bg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*22, FitHEIGHT*30, FitWIDTH*215, FitHEIGHT*7)];
        img_bg.image = [UIImage imageNamed:@"title_bg"];
        [imgV addSubview:img_bg];
        
        //基本信息
        Message = [UIButton buttonWithType:UIButtonTypeCustom];
        Message.frame = CGRectMake(FitWIDTH*22, FitHEIGHT*43, FitWIDTH*107.5, FitHEIGHT*25);
        [Message setImage:[UIImage imageNamed:@"message_tab_on"] forState:UIControlStateNormal];
        [Message addTarget:self action:@selector(MessageAction) forControlEvents:UIControlEventTouchUpInside];
        [imgV addSubview:Message];
        
        //战绩表
        Source = [UIButton buttonWithType:UIButtonTypeCustom];
        Source.frame = CGRectMake(FitWIDTH*129.5, FitHEIGHT*43, FitWIDTH*107.5, FitHEIGHT*25);
        [Source setImage:[UIImage imageNamed:@"message_tab01"] forState:UIControlStateNormal];
        [Source addTarget:self action:@selector(SourceAction) forControlEvents:UIControlEventTouchUpInside];
        [imgV addSubview:Source];
        
        //头像
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*24, FitHEIGHT*82, FitWIDTH*47, FitWIDTH*47)];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 3;
        image.image = head;
        [imgV addSubview:image];
        
        //昵称
        UIImageView *label1 = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*76, FitHEIGHT*82, FitWIDTH*22, FitHEIGHT*10)];
        label1.image = [UIImage imageNamed:@"txt_name"];
        [imgV addSubview:label1];
        
        UIImageView *imgname = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*106, FitHEIGHT*79, FitWIDTH*116, FitHEIGHT*15)];
        imgname.image = [UIImage imageNamed:@"txtbord"];
        [imgV addSubview:imgname];
        
        UILabel *namelab = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*116, FitHEIGHT*79, FitWIDTH*116, FitHEIGHT*15)];
        namelab.text = name;
        namelab.font = [UIFont systemFontOfSize:8];
        namelab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [imgV addSubview:namelab];
        
        //ID
        UIImageView *label2 = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*76, FitHEIGHT*99, FitWIDTH*13, FitHEIGHT*10)];
        label2.image = [UIImage imageNamed:@"txt_ID"];
        [imgV addSubview:label2];
        
        UIImageView *imgid = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*106, FitHEIGHT*99, FitWIDTH*116, FitHEIGHT*15)];
        imgid.image = [UIImage imageNamed:@"txtbord"];
        [imgV addSubview:imgid];
        
        UILabel *labid = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*116, FitHEIGHT*99, FitWIDTH*116, FitHEIGHT*15)];
        labid.text = idnum;
        labid.font = [UIFont systemFontOfSize:8];
        labid.textColor = namelab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [imgV addSubview:labid];
        
        //猜拳豆
        UIImageView *imgdouzi = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*85, FitHEIGHT*136, FitWIDTH*48, FitHEIGHT*20)];
        imgdouzi.image = [UIImage imageNamed:@"txtbord"];
        [imgV addSubview:imgdouzi];
        
        UILabel *labdouzi = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*92, FitHEIGHT*136, FitWIDTH*48, FitHEIGHT*20)];
        labdouzi.text = douzi;
        labdouzi.font = [UIFont systemFontOfSize:13];
        labdouzi.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [imgV addSubview:labdouzi];
        
        UIImageView *caiquan = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*71, FitHEIGHT*135, FitWIDTH*21, FitHEIGHT*21)];
        caiquan.image = [UIImage imageNamed:@"cqd"];
        [imgV addSubview:caiquan];
        
        //积分
        UIImageView *imgjf = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*162, FitHEIGHT*136, FitWIDTH*48, FitHEIGHT*20)];
        imgjf.image = [UIImage imageNamed:@"txtbord"];
        [imgV addSubview:imgjf];
        
        UILabel *labjf = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*171, FitHEIGHT*136, FitWIDTH*48, FitHEIGHT*20)];
        labjf.text = jifen;
        labjf.font = [UIFont systemFontOfSize:13];
        labjf.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [imgV addSubview:labjf];
//
        UIImageView *jf = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*148, FitHEIGHT*135, FitWIDTH*21, FitHEIGHT*21)];
        jf.image = [UIImage imageNamed:@"jf"];
        [imgV addSubview:jf];
        
        //底部图片
//        NSArray *array = @[@"gift01_on",@"gift02_on",@"gift03_on",@"gift04_on",@"gift05_on",@"gift06_on"];
//        for (int i=0; i<array.count; i++)
//        {
//            UIImageView *lowimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*28+i*(FitWIDTH*(44+9)), FitHEIGHT*222, FitWIDTH*44, FitHEIGHT*44)];
//            lowimg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",array[i]]];
//            [imgV addSubview:lowimg];
//        }
        
        //盖个视图
        upView = [[UIView alloc]initWithFrame:CGRectMake(FitWIDTH*57.5, FitHEIGHT*101, WIDTH-FitWIDTH*115, FitHEIGHT*105)];
        upView.layer.masksToBounds = YES;
        upView.layer.cornerRadius = 5;
        upView.backgroundColor = [UIColor colorWithRGBValue:0x23273a andAlpha:1.0];
        upView.alpha = 0;
        [self addSubview:upView];
        
        //连赢次数
        UIImageView *winimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*22, FitHEIGHT*12, FitWIDTH*208, FitHEIGHT*28)];
        winimg.image = [UIImage imageNamed:@"zj_bord"];
        [upView addSubview:winimg];
        
        UILabel *winlab = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*30, FitHEIGHT*12, FitWIDTH*152, FitHEIGHT*28)];
        winlab.text = @"连赢次数";
        winlab.font = [UIFont systemFontOfSize:13];
        winlab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [upView addSubview:winlab];
        
        UIImageView *cishuimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*166, FitHEIGHT*16, FitWIDTH*56, FitHEIGHT*20)];
        cishuimg.image = [UIImage imageNamed:@"zj_bord01"];
        [upView addSubview:cishuimg];
        
        UILabel *cishulab = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*168, FitHEIGHT*16, FitWIDTH*56, FitHEIGHT*20)];
        cishulab.text = cishu;
        cishulab.font = [UIFont systemFontOfSize:13];
        cishulab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [upView addSubview:cishulab];
        
        //获得最高商品金额
        UIImageView *mostimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*22, FitHEIGHT*52, FitWIDTH*208, FitHEIGHT*28)];
        mostimg.image = [UIImage imageNamed:@"zj_bord"];
        [upView addSubview:mostimg];
        
        UILabel *mostlab = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*30, FitHEIGHT*52, FitWIDTH*152, FitHEIGHT*28)];
        mostlab.text = @"获得最高商品金额";
        mostlab.font = [UIFont systemFontOfSize:13];
        mostlab.textColor = [UIColor colorWithRGBValue:0xb0b5ca andAlpha:1.0];
        [upView addSubview:mostlab];
        
        UIImageView *monryimg = [[UIImageView alloc]initWithFrame:CGRectMake(FitWIDTH*166, FitHEIGHT*56, FitWIDTH*56, FitHEIGHT*20)];
        monryimg.image = [UIImage imageNamed:@"zj_bord01"];
        [upView addSubview:monryimg];
        
        UILabel *moneylab = [[UILabel alloc]initWithFrame:CGRectMake(FitWIDTH*168, FitHEIGHT*56, FitWIDTH*58, FitHEIGHT*20)];
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


@end
