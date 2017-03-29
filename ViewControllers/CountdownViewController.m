//
//  CountdownViewController.m
//  SmallFeature
//
//  Created by Sun on 16/1/25.
//  Copyright © 2016年 ssb. All rights reserved.
//
#import "CountdownViewController.h"

#define GETCODEBUTTON_W 100

#define PHONETEXTFILED_W    VIEW_WIDTH - GETCODEBUTTON_W - 40
@interface CountdownViewController ()

@end

@implementation CountdownViewController{

    UITextField *phoneNumberField;
    
    UITextField *phoneCodeField;
    
    UIButton *getCodeBtn;
    
    int secondsCountdown;
    
    NSTimer *countdownTimer;
    
    
    UILabel *shakeTimesL;
    
    int shakeTimes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationItem];
    
    [self showTheShakeTimes];
    
    //手机验证码
    [self showPhoneVerificationCode];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - customNavigationItem
- (void)customNavigationItem{
    
    self.navigationItem.title = @"计时牌";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加摇一摇
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    
}
- (void)showTheShakeTimes{
    shakeTimes = 0;
    
    shakeTimesL = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, VIEW_WIDTH - 40, 30)];
    
    shakeTimesL.textAlignment = 1;
    
    shakeTimesL.text = @"摇动次数为:0次";
    
    CALayer *labelLayer = [shakeTimesL layer];
    
    labelLayer.borderWidth = 0.5;
    
    labelLayer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    shakeTimesL.layer.masksToBounds = YES;
    
    shakeTimesL.layer.cornerRadius = 5;
    
    [self.view addSubview:shakeTimesL];
    
    
    UIButton *cleanBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 190, VIEW_WIDTH - 160, 30)];
    
    [cleanBtn setTitle:@"次数清零" forState:UIControlStateNormal];
    
    [cleanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [cleanBtn addTarget:self action:@selector(cleanTimes:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnLayer = [cleanBtn layer];
    
    btnLayer.borderWidth = 0.5;
    
    btnLayer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    cleanBtn.layer.masksToBounds = YES;
    
    cleanBtn.layer.cornerRadius = 5;
    
    
    [self.view addSubview:cleanBtn];
}

-(void)cleanTimes:(UIButton *)btn{
    shakeTimes = 0;
    shakeTimesL.text = @"摇动次数为:0次";
}
#pragma mark -摇一摇的方法
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
  
    NSLog(@"began");
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{

    NSLog(@"cancel");
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    if (event.subtype == UIEventSubtypeMotionShake) {
       
        NSLog(@"end");
        
        shakeTimes++;
        
        shakeTimesL.text = [NSString stringWithFormat:@"摇动次数为:%d次",shakeTimes];
    }
}
#pragma mark - 手机验证码
//手机验证码
- (void)showPhoneVerificationCode{

    phoneNumberField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5,PHONETEXTFILED_W , 30)];
    
    phoneNumberField.placeholder = @"请输入手机号";
    
    phoneNumberField.borderStyle = UITextBorderStyleRoundedRect;
    
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:phoneNumberField];
    
    [phoneNumberField becomeFirstResponder];
    
    
    phoneCodeField = [[UITextField alloc]initWithFrame:CGRectMake(50, 40, VIEW_WIDTH - 100, 30)];
    
    phoneCodeField.placeholder = @"请输入验证码";
    
    phoneCodeField.borderStyle = UITextBorderStyleRoundedRect;
    
    phoneCodeField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:phoneCodeField];
    
    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake((VIEW_WIDTH - 80)/2, 80, 80, 30)];
    
    [submitBtn setTitle:@"提交注册" forState:UIControlStateNormal];
    
    [submitBtn setTitleColor:[UIColor colorWithRed:60.0/255 green:130.0/255 blue:255.0/255 alpha:1] forState:UIControlStateNormal];
    
    [submitBtn addTarget:self action:@selector(submitCode:) forControlEvents:UIControlEventTouchUpInside];
    
    submitBtn.layer.borderWidth = 0.5;
    
    submitBtn.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    submitBtn.layer.masksToBounds = YES;
    
    submitBtn.layer.cornerRadius = 5;
    
    [self.view addSubview:submitBtn];
    
    
 
    getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(PHONETEXTFILED_W + 20,5,GETCODEBUTTON_W,30)];
    
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [getCodeBtn setTitleColor:[UIColor colorWithRed:60.0/255 green:130.0/255 blue:255.0/255 alpha:1] forState:UIControlStateNormal];
    
    [getCodeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *layer = [getCodeBtn layer];
    
    layer.borderWidth = 0.5;
    
    layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    getCodeBtn.layer.masksToBounds = YES;
    
    getCodeBtn.layer.cornerRadius = 5;
    
//    getCodeBtn.backgroundColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1];
  
    [self.view addSubview:getCodeBtn];
    
    
    //创建定时器
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdownAction) userInfo:nil repeats:YES];
    
    [countdownTimer setFireDate:[NSDate distantFuture]];
    
    [[NSRunLoop mainRunLoop]addTimer:countdownTimer forMode:NSDefaultRunLoopMode];
    
}

- (void)getCodeAction:(UIButton *)codeBtn{
    
    //先判断手机号对不对
    if ([self valiMobile:phoneNumberField.text] == NO) {
        
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的电话号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alt show];
        
        return;
    }
    
    [phoneNumberField resignFirstResponder];
    
    secondsCountdown = 60;
    
    codeBtn.enabled = NO;
    
    //启动定时器
    NSLog(@"启动定时器");
    [countdownTimer setFireDate:[NSDate distantPast]];
    
    //调用SMSSDK
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumberField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"获取验证码成功");
        }else{
            NSLog(@"错误信息:%@",error);
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取验证码失败，明天重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alt show];
        }
    }];
    
    [phoneCodeField becomeFirstResponder];
}
//提交验证码，调用函数
-(void)submitCode:(UIButton *)subBtn{

    if (phoneCodeField.text.length <= 0) {
        return;
    }
    [SMSSDK commitVerificationCode:phoneCodeField.text phoneNumber:phoneNumberField.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            NSLog(@"验证成功");
            
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证成功，注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alt show];
        }else{
            NSLog(@"验证错误信息：%@",error);
            
            secondsCountdown = 1;
            
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码不正确,请重新获取" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alt show];
        }
    }];
}
//定时器事件
- (void)countdownAction{
    
    secondsCountdown--;
    
    [getCodeBtn setTitle:[NSString stringWithFormat:@"%ds后重获",secondsCountdown] forState:UIControlStateNormal];
    
    if (secondsCountdown == 0) {
        //关闭定时器
        [countdownTimer setFireDate:[NSDate distantFuture]];
        
        //getcodeBtn可编辑
        getCodeBtn.enabled = YES;
        
        [getCodeBtn setTitle:@"重新获得" forState:UIControlStateNormal];
    }
}

//判断手机号
- (BOOL)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
//        return @"手机号长度只能是11位";
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
//            return @"请输入正确的电话号码";
            return NO;
        }
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITextField *textFile in self.view.subviews) {
        
        if (textFile.isFirstResponder) {
            
            [textFile resignFirstResponder];
        }
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [countdownTimer invalidate];
}
@end
