//
//  QrCodeViewController.m
//  SmallFeature
//
//  Created by Sun on 16/2/15.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "QrCodeViewController.h"

@interface QrCodeViewController ()

@end

@implementation QrCodeViewController
{
    UIWebView *codeStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"二维码内容";
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
    
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self showTheCodeString];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 显示二维码扫描结果
- (void)showTheCodeString{

    codeStr = [[UIWebView alloc]initWithFrame:CGRectMake(30, 20,VIEW_WIDTH - 60, 300)];
    
    codeStr.scrollView.scrollEnabled = NO;
    
    codeStr.delegate = self;
    
    [codeStr loadHTMLString:self.strScan baseURL:nil];
    
    [self.view addSubview:codeStr];
    
    //是链接直接打开，否则显示内容
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.strScan]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *bodyStyle = @"document.getElementsByTagName('body')[0].style.textAlign = 'center';";
    [codeStr stringByEvaluatingJavaScriptFromString:bodyStyle];
}
@end
