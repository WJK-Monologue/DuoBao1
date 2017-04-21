//
//  SelectGoodsNumViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "SelectGoodsNumViewController.h"

@interface SelectGoodsNumViewController ()<UITextFieldDelegate>
{
     int selectMoney;
}

@end

@implementation SelectGoodsNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    if (_limitNum==1||_limitNum<10) {
        _dec.text=[NSString stringWithFormat:@"共需%@购宝币",_numText.text];
        
    }
    if (_limitNum==10) {
        _dec.text = [NSString stringWithFormat:@"共需%d购宝币",[_numText.text intValue]*10
                     ];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    
    
    _twenty.layer.masksToBounds =YES;
    _twenty.layer.cornerRadius = 4;
    
    _thirty.layer.masksToBounds =YES;
    _thirty.layer.cornerRadius = 4;
    
    _fourty.layer.masksToBounds =YES;
    _fourty.layer.cornerRadius = 4;
    
    _baowei.layer.masksToBounds =YES;
    _baowei.layer.cornerRadius = 4;
    
    
    _twenty.layer.borderWidth = 1.0f;
    _thirty.layer.borderWidth = 1.0f;
    _fourty.layer.borderWidth = 1.0f;
    _baowei.layer.borderWidth = 1.0f;
    
    _baowei.tag=3;
    selectMoney =0;
    
    [self updateMoneyLabelStatue];
    
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 4;
    _numText.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
    _numText.layer.borderWidth = 1.0f;
    _numText.text = [NSString stringWithFormat:@"%d",1];
}

- (void)updateMoneyLabelStatue
{
    _twenty.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    _thirty.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    _fourty.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
    _baowei.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1] CGColor];
    
 
    
    switch (selectMoney) {
        case 0:
            _twenty.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 1:
            _thirty.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 2:
            _fourty.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
        case 3:
            _baowei.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
            break;
     
    }

}


#pragma mark - action

- (IBAction)clickCannelButtonAction:(id)sender
{
    _numText.text = @"1";
    [Tool hideAllKeyboard];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)clickSureButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    if ([_numText.text intValue] > _canBuyNum)
    {
        [Tool showPromptContent:@"超出可购买数量" onView:self.view];

        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if([self.delegate respondsToSelector:@selector(selectGoodsNum:)])
        {
            [self.delegate selectGoodsNum:[_numText.text intValue]];
            NSLog(@"%d",[_numText.text intValue]);
        }
    }];
    
}

- (IBAction)clickAddButtonAction:(id)sender
{
    if ([_numText.text intValue] >= _canBuyNum)
    {
        [Tool showPromptContent:@"当前购买的数量已经是最大可购买数量了" onView:self.view];
        return;
    }
    _numText.text = [NSString stringWithFormat:@"%d",[_numText.text intValue]+1];
    _dec.text = [NSString stringWithFormat:@"共需%d购宝币",[_numText.text intValue]];
}

- (IBAction)clickDownButtonAction:(id)sender
{
    if ([_numText.text intValue]-1 <= 0) {
        _numText.text = [NSString stringWithFormat:@"%d",1];
    }else{
        _numText.text = [NSString stringWithFormat:@"%d",[_numText.text intValue]-1];
        _dec.text = [NSString stringWithFormat:@"共需%d购宝币",[_numText.text intValue]];
    }
}
- (IBAction)action:(id)sender
{
    
    
    
    UIButton *btn = (UIButton*)sender;
    
    selectMoney = (int)btn.tag;
   
    if (_limitNum==1||_limitNum<10) {
        switch (selectMoney) {
            case 0:
                _numText.text=@"20";
                
                break;
            case 1:
                _numText.text=@"30";
                
                break;
            case 2:
                _numText.text=@"40";
                break;
            case 3:
                _numText.text=[NSString stringWithFormat:@"%d",_canBuyNum];
                break;
                
        }
        _dec.text = [NSString stringWithFormat:@"共%@购宝币",_numText.text];
        
        [self updateMoneyLabelStatue];
    }
    if (_limitNum==10) {
        switch (selectMoney) {
            case 0:
                _numText.text=@"20";
                
                break;
            case 1:
                _numText.text=@"30";
                
                break;
            case 2:
                _numText.text=@"40";
                break;
            case 3:
                _numText.text=[NSString stringWithFormat:@"%d",_canBuyNum];
                break;
                
        }
        _dec.text = [NSString stringWithFormat:@"共%d购宝币",[_numText.text intValue]*10];
        
        [self updateMoneyLabelStatue];
    }
    
    
}



#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_numText.text intValue] > _canBuyNum) {
        [textField resignFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的数量已经超过最大可购买数量，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        if ([textField.text intValue] <= 0 )
        {
            textField.text = @"1";
        }
    }
    
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [_numText becomeFirstResponder];
}
@end
