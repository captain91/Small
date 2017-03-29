//
//  TaxViewController.m
//  testProject
//
//  Created by 袁红霞 on 15/8/25.
//  Copyright (c) 2015年 hongxia Yuan. All rights reserved.
//

#import "TaxViewController.h"
#define sWidth [UIScreen mainScreen].bounds.size.width
#define sHeight [UIScreen mainScreen].bounds.size.height

@interface TaxViewController ()

@end

@implementation TaxViewController
{
    UITextField *taxTextField;
    UIButton *cleanBut;
    UIButton *countBut;
    UILabel *taxLabel;
    UILabel *divTaxLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人所得税计税";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.92549 green:0.92549 blue:0.92549 alpha:1];
//    self.view.backgroundColor = [UIColor colorWithRed:229.0/255 green:4.0/255 blue:4.0/255 alpha:1];
    [self createTextField];
    // Do any additional setup after loading the view.
}


#pragma mark-textField
//创建textField
-(void)createTextField{
    taxTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, 80, sWidth-40, 35)];
    taxTextField.placeholder=@"请输入税前工资";
    taxTextField.delegate=self;
    taxTextField.borderStyle=UITextBorderStyleRoundedRect;
    taxTextField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    
    //成为第一响应
    [taxTextField becomeFirstResponder];
    
    [self.view addSubview:taxTextField];
    
    divTaxLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 130, (sWidth-50)/2, 30)];
    divTaxLabel.text=@"除税工资:";
    [self.view addSubview:divTaxLabel];
    divTaxLabel.font=[UIFont systemFontOfSize:14];
//    divTaxLabel.backgroundColor=[UIColor colorWithRed:0.52549 green:0.72549 blue:0.92549 alpha:1];
    divTaxLabel.layer.cornerRadius=5;
    divTaxLabel.layer.masksToBounds=YES;
    
    taxLabel = [[UILabel alloc]initWithFrame:CGRectMake(30+(sWidth-50)/2, 130, (sWidth-50)/2, 30)];
    taxLabel.text=@"应缴税额:";
    [self.view addSubview:taxLabel];
    taxLabel.font=[UIFont systemFontOfSize:14];
//    taxLabel.backgroundColor=[UIColor colorWithRed:0.52549 green:0.72549 blue:0.92549 alpha:1];
    taxLabel.layer.cornerRadius=5;
    taxLabel.layer.masksToBounds=YES;
    
    cleanBut = [[UIButton alloc]initWithFrame:CGRectMake((sWidth-180)/2, 180, 80, 30)];
    [cleanBut setTitle:@"重算" forState:UIControlStateNormal];
    cleanBut.backgroundColor=[UIColor orangeColor];
    [cleanBut addTarget:self action:@selector(cleanRelust:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cleanBut];
    cleanBut.layer.cornerRadius=10;
    cleanBut.layer.masksToBounds=YES;
    
    countBut = [[UIButton alloc]initWithFrame:CGRectMake((sWidth -180)/2+100, 180, 80, 30)];
    [countBut setTitle:@"计算" forState:UIControlStateNormal];
    countBut.backgroundColor=[UIColor orangeColor];
    [countBut addTarget:self action:@selector(countRelust) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:countBut];
    countBut.layer.cornerRadius=10;
    cleanBut.layer.masksToBounds=YES;
}
//计算
-(void)countRelust
{
    float total;
    float taxMoney;
    float tax;
    total=[taxTextField.text floatValue];
    if (total==0) {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"不输入工资算个屁啊" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
        return;
    }
    //计税工资
    if (total<3500) {
        taxLabel.text=[NSString stringWithFormat:@"应缴税额:%.2f",total-total];
        divTaxLabel.text=[NSString stringWithFormat:@"除税工资:%.2f",total];
    }else{
        taxMoney=total-3500;
        if (taxMoney<1455) {
        
            tax = taxMoney * 0.03;
        }else if (taxMoney<4155){
        
            tax = taxMoney * 0.1 - 105;
        }else if (taxMoney<7755){
        
            tax = taxMoney * 0.2 - 555;
        }else if (taxMoney<27255){
        
            tax = taxMoney * 0.25 - 1005;
        }else if (taxMoney<41255){
        
            tax = taxMoney * 0.3 - 2775;
        }else if (taxMoney<57505){
        
            tax = taxMoney * 0.35 - 5505;
        }else{
        
            tax = taxMoney * 0.45 - 13505;
        }
    
        taxLabel.text=[NSString stringWithFormat:@"应缴税额:%.2f",tax];
        divTaxLabel.text=[NSString stringWithFormat:@"除税工资:%.2f",total - tax];
    }
}

-(void)cleanRelust:(UIButton *)btn
{
    divTaxLabel.text=@"除税工资:";
    taxLabel.text=@"应缴税额:";
    taxTextField.text=@"";
}

#pragma mark - 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self countRelust];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
