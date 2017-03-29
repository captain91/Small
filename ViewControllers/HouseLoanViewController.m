//
//  HouseLoanViewController.m
//  SmallFeature
//
//  Created by Sun on 16/4/5.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "HouseLoanViewController.h"
#import "WebViewController.h"
@interface HouseLoanViewController ()

@end

@implementation HouseLoanViewController{

    UIScrollView *bgView;
    float monthRate;
    NSInteger months;
    float money;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"房贷计算器";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"网页" style:UIBarButtonItemStyleDone target:self action:@selector(pushWeb)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"计算器" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [self createTextFiled];
    
}

-(void)pushWeb{
    WebViewController *web = [WebViewController new];
    
    [self.navigationController pushViewController:web animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建textfiled
-(void)createTextFiled{
    
    bgView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    bgView.contentSize = CGSizeMake(VIEW_WIDTH, VIEW_HEIGHT + 1);
    
    [self.view addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirstRTextField)];
    bgView.userInteractionEnabled = YES;
    
    [bgView addGestureRecognizer:tap];
    
    NSArray *titleA = [NSArray arrayWithObjects:@"贷款金额:",@"贷款年限:",@"年  利  率:",nil];
    
    NSArray *titleC = [NSArray arrayWithObjects:@"请输入金额",@"请输入年限",@"请输入年利率", nil];
    
    NSArray *titleB = [NSArray arrayWithObjects:@"万",@"年",@"%", nil];
    
    for (int i = 0 ; i < titleA.count ; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 10 + i * 35, 80, 30)];
        
        label.text = titleA[i];
        
        label.textAlignment = 1;
        
//        label.backgroundColor = [UIColor redColor];
        
        [bgView addSubview:label];
        
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(130, 10 + i * 35, VIEW_WIDTH - 200, 30)];
        
        textF.borderStyle = UITextBorderStyleRoundedRect;
        
        textF.placeholder = titleC[i];
        
        textF.textAlignment = NSTextAlignmentRight;
        
        textF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        textF.tag = 100 + i;
        
        textF.delegate = self;
        
        if (i==0) {
            [textF becomeFirstResponder];
        }
        
        [bgView addSubview:textF];
        
        UILabel *litlab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH - 70, 10 + i * 35, 20, 30)];
        
        litlab.text = titleB[i];
        
        litlab.textAlignment = 1;
        
//        litlab.backgroundColor = [UIColor greenColor];
        
        [bgView addSubview:litlab];
    }
    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(80, 140, 80, 30)];
    
    [submit setTitle:@"计    算" forState:UIControlStateNormal];
    
    [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    submit.layer.borderWidth = 0.5;
    
    submit.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    submit.layer.masksToBounds = YES;
    
    submit.layer.cornerRadius = 5;
    
    [submit addTarget:self action:@selector(countResult) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:submit];
    
    
    UIButton *resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH - 160, 140, 80, 30)];
    
    [resetBtn setTitle:@"重    置" forState:UIControlStateNormal];
    
    [resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    resetBtn.layer.borderWidth = 0.5;
    
    resetBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    resetBtn.layer.masksToBounds = YES;
    
    resetBtn.layer.cornerRadius = 5;
    
    [resetBtn addTarget:self action:@selector(cleanAll:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:resetBtn];
    
    
    //显示结果
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 150, 30)];
    label1.text = @"每月等额还款:";
    label1.textColor = [UIColor brownColor];
    [bgView addSubview:label1];
    NSArray *arrayA = [NSArray arrayWithObjects:@"贷款总额:",@"还款月数:",@"每月还款:",@"总  利  息:",@"本息合计:",nil];
    
    for (int i = 0; i<arrayA.count; i++) {
        
        UILabel *labelA = [[UILabel alloc]initWithFrame:CGRectMake(20, 210 + i * 30, 100, 25)];
        
        labelA.text = arrayA[i];
        
        labelA.textAlignment = 1;
        
        [bgView addSubview:labelA];
        
        UILabel *labelC = [[UILabel alloc]initWithFrame:CGRectMake(120, 210 + i * 30, 150, 25)];
        
        labelC.text = @"";
        
        labelC.tag = 800 + i;
        
        labelC.layer.borderWidth = 0.5;
        labelC.layer.borderColor = [UIColor lightGrayColor].CGColor;
        labelC.layer.masksToBounds = YES;
        labelC.layer.cornerRadius = 5;
        
        labelC.textColor = [UIColor redColor];
        
        labelC.textAlignment = 1;
        
        [bgView addSubview:labelC];
        
    }
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 370, 150, 30)];
    label2.text = @"每月递减还款:";
    label2.textColor = [UIColor brownColor];
    [bgView addSubview:label2];
    
    for (int i = 0; i<arrayA.count; i++) {
        
        UILabel *labelB = [[UILabel alloc]initWithFrame:CGRectMake(20, 400 + i * 30, 100, 25)];
        
        labelB.text = arrayA[i];
        
        labelB.textAlignment = 1;
        
        [bgView addSubview:labelB];
        
        UILabel *labelD = [[UILabel alloc]initWithFrame:CGRectMake(120, 400 + i * 30, 150, 25)];
        
        labelD.text = @"";
        
        labelD.tag = 900 + i;
        
        labelD.layer.borderWidth = 0.5;
        labelD.layer.borderColor = [UIColor lightGrayColor].CGColor;
        labelD.layer.masksToBounds = YES;
        labelD.layer.cornerRadius = 5;

        
        labelD.textColor = [UIColor redColor];
        
        labelD.textAlignment = 1;
        
        [bgView addSubview:labelD];
        
        if (i == 1) {
            UILabel *labelF = [[UILabel alloc]initWithFrame:CGRectMake(270, 400 + i * 30, 80, 25)];
            labelF.text = @"每月递减";
            labelF.textAlignment = 1;
            [bgView addSubview:labelF];
        }
        if (i == 2) {
            UILabel *labelF = [[UILabel alloc]initWithFrame:CGRectMake(270, 400 + i * 30, 80, 25)];
            labelF.text = @"";
            labelF.textAlignment = 1;
            labelF.textColor = [UIColor redColor];
            labelF.tag = 1000;
            [bgView addSubview:labelF];
        }

    }

    
}

-(void)countResult{

    //贷款本金
    money = [(UITextField *)[bgView viewWithTag:100] text].floatValue * 10000;
    
    //贷款月数
    months = [(UITextField *)[bgView viewWithTag:101] text].integerValue * 12;
    
    //月利率
    monthRate = [(UITextField *)[bgView viewWithTag:102] text].floatValue / 1200;
    
    if (money==0) {
        [self showTheMessage:@"请输入贷款金额"];
        return;
    }else if (months==0) {
        [self showTheMessage:@"请输入贷款年限"];
        return;
    }else if (monthRate==0) {
        [self showTheMessage:@"请输入年利率"];
        return;
    }
    
    [self resignFirstRTextField];
    
    //等额还款
    //每月还款
    float moneyMonth =(money * monthRate * powf(1+monthRate, months))/(powf(1+monthRate, months)-1);
    
    //总利息
    float allRate = months * moneyMonth - money;
    
    //本息和
    float allMoney = allRate + money;
    
    NSArray *resultR = [NSArray arrayWithObjects:[self fTon:money],[self iTon:months],[self fTon:moneyMonth],[self fTon:allRate],[self fTon:allMoney], nil];
    
    for (int i = 0 ; i < resultR.count; i++) {
        UILabel *label = (UILabel *)[bgView viewWithTag:i + 800];
        
        label.text = [NSString stringWithFormat:@"%.2lf", [[resultR objectAtIndex:i] floatValue]];
        if (i == 1) {
            label.text = [NSString stringWithFormat:@"%ld",[[resultR objectAtIndex:i]integerValue]];
        }
    }
    
    
    //等本金还款
    float moneyMonth1 = (money/months) + (money - 0)*monthRate;
    //总利息
    float allRate1 = ((money/months + money * monthRate)+ money/months * (1 + monthRate))/2*months - money;
    //本金和
    float allMoney1 = allRate1 + money;
    
    //每月递减金额
    float monthM = money/months * monthRate;
    
    NSArray *resultR1 = [NSArray arrayWithObjects:[self fTon:money],[self iTon:months],[self fTon:moneyMonth1],[self fTon:allRate1],[self fTon:allMoney1], nil];
    
    for (int i = 0 ; i < resultR.count; i++) {
        UILabel *label = (UILabel *)[bgView viewWithTag:i + 900];
        
        label.text = [NSString stringWithFormat:@"%.2lf", [[resultR1 objectAtIndex:i] floatValue]];
        if (i == 1) {
            label.text = [NSString stringWithFormat:@"%ld",[[resultR1 objectAtIndex:i]integerValue]];
        }
    }
    //每月递减金额
    UILabel *labelF = (UILabel *)[bgView viewWithTag:1000];
    labelF.text = [NSString stringWithFormat:@"%.2lf元",monthM];
    
    NSLog(@"计算,每月还款：%.2lf , %.2lf",moneyMonth1 ,allRate1);
}

- (void)cleanAll:(UIButton *)restBtn{
    
    //全部设置为空
    for (int i = 0; i< 3; i++) {
        
        UITextField *textf = (UITextField *)[bgView viewWithTag:100 + i];
        
        textf.text = @"";
    }
    
    
    for (int i = 0 ; i < 5; i++) {
        
        UILabel *label = (UILabel *)[bgView viewWithTag:i + 800];
        
        label.text = @"";
    }
    
    
    for (int i = 0 ; i < 5; i++) {
        
        UILabel *label = (UILabel *)[bgView viewWithTag:i + 900];
        
        label.text = @"";
    }
    
    NSLog(@"重置");
}

-(void)showTheMessage:(NSString *)message{

    UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alt show];
}
//float转NSNumber存入数组
-(NSNumber *)fTon:(float )value{
    
    return [NSNumber numberWithFloat:value];
}
-(NSNumber *)iTon:(NSInteger)value{
    return [NSNumber numberWithInteger:value];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    UITextField *textf1 = (UITextField *)[bgView viewWithTag:100];
    UITextField *textf2 = (UITextField *)[bgView viewWithTag:101];
    UITextField *textf3 = (UITextField *)[bgView viewWithTag:102];
    if (textf1.isFirstResponder) {
        [textf2 becomeFirstResponder];
    }else if(textf2.isFirstResponder){
        [textf3 becomeFirstResponder];
    }else{
        [textf3 resignFirstResponder];
        [self countResult];
    }
    return YES;
}

-(void)resignFirstRTextField{
    for (int i = 0; i< 3; i++) {
        UITextField *textf = (UITextField *)[bgView viewWithTag:100 + i];
        [textf resignFirstResponder];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

}

@end
