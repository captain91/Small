//
//  ApplePayViewController.m
//  SmallFeature
//
//  Created by Sun on 16/2/19.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "ApplePayViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ApplePayViewController ()

@end

@implementation ApplePayViewController{

    BOOL isLightOn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"🍎 Pay";
    // Do any additional setup after loading the view.
    
//    [self canPay];
    
    [self createApplePayButton];
    
    [self addLEDButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createApplePayButton{

    UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, VIEW_WIDTH - 100, 80)];
    
    [payBtn setBackgroundImage:[UIImage imageNamed:@"ApplePayBTN_64pt__whiteLine_textLogo_"] forState:UIControlStateNormal];
    
    [payBtn setTitleColor:[UIColor colorWithRed:60.0/255 green:130.0/255 blue:255.0/255 alpha:1] forState:UIControlStateNormal];
    
    [payBtn addTarget:self action:@selector(payButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:payBtn];
}

-(void)payButton:(UIButton *)btn{
    
    UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"很遗憾啊，现在还测试不了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alt show];


//    if ([PKPaymentAuthorizationViewController canMakePayments]) {
//        
//        NSLog(@"can make payments");
//        
//        PKPaymentRequest *request = [[PKPaymentRequest alloc]init];
//        
//        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"widget1" amount:[NSDecimalNumber  decimalNumberWithString:@"0.99"]];
//        
//        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"widget2" amount:[NSDecimalNumber  decimalNumberWithString:@"1.99"]];
//        
//        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"total money" amount:[NSDecimalNumber  decimalNumberWithString:@"2.99"]];
//        
//        request.paymentSummaryItems = @[widget1, widget2, total];
//        
//        request.countryCode = @"US";
//        
//        request.currencyCode = @"USD";
//        
//        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
//        
//        request.merchantCapabilities = PKMerchantCapabilityEMV;
//        
//        request.merchantIdentifier = @"merchant.com.example.sun";
//        
//        PKPaymentAuthorizationViewController *paymentPan = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
//        
//        paymentPan.delegate = self;
//        
//        if(!paymentPan){
//            
//            NSLog(@"have some problem！");
//        }
//        
//        [self presentViewController:paymentPan animated:YES completion:nil];
//    }else{
//        
//        NSLog(@"This device cannot make payments");
//    }

}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion{
    
    NSLog(@"Payment was authorized:%@",payment);
    
    BOOL asyncSuccessful = FALSE;
    
    if (asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        NSLog(@"Payment was successful");
    }else{
        completion(PKPaymentAuthorizationStatusFailure);
        
        NSLog(@"Payment was failure");
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    
    NSLog(@"Finishing payment view controller");
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void)canPay{
    
    if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay]]) {
        NSLog(@"支持使用apple pay");
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"很遗憾啊，现在还测试不了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alt show];
    }
}

//手电筒控制
- (void)addLEDButton{
    
    UIButton *ledBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH/3, VIEW_HEIGHT * 0.3, VIEW_WIDTH/3, 30)];
    
    [ledBtn setTitle:@"点击打开" forState:UIControlStateNormal];
    
    [ledBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    ledBtn.layer.borderWidth = 0.5;
    
    ledBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    ledBtn.layer.masksToBounds = YES;
    
    ledBtn.layer.cornerRadius = 5;
    
    [ledBtn addTarget:self action:@selector(turnLED:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ledBtn];
    
}
-(void)canUse{
    
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch]) {
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alt show];
        return;
    }
    
//    AVCaptureDeviceInput *input =[[AVCaptureDeviceInput alloc]init];
//    
//    if ([device hasTorch] && [device hasFlash]){
//        
//        [input.device lockForConfiguration:nil];
//        input.device.torchMode = AVCaptureTorchModeOn;
//        [input.device unlockForConfiguration];
//    }
}
-(void)turnLED:(UIButton *)ledBtn{
    
    [self canUse];
    
    if (!isLightOn) {
        [self turnOn];
        
        [ledBtn setTitle:@"点击关闭" forState:UIControlStateNormal];
        
        isLightOn = YES;
    }else{
        [self turnOff];
        
        [ledBtn setTitle:@"点击打开" forState:UIControlStateNormal];
        
        isLightOn = NO;
    }
}
-(void)turnOn{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch]) {
        
        [device lockForConfiguration:nil];
        
        [device setTorchMode:AVCaptureTorchModeOn];
        
        [device unlockForConfiguration];
    }
}

-(void)turnOff{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch]) {
        
        [device lockForConfiguration:nil];
        
        [device setTorchMode:AVCaptureTorchModeOff];
        
        [device unlockForConfiguration];
    }
}
@end
