//
//  WebViewController.m
//  SmallFeature
//
//  Created by Sun on 16/4/6.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController{
    UIWebView * webView1;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"网页计算器";
    
    webView1 = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
//    webView1.scalesPageToFit = YES;
//    
//    webView1.delegate = self;
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.wstimes.cn"]];
    [webView1 loadRequest:request];
    
    [self.view addSubview:webView1];
    
//    [UIView beginAnimations:nil context:(__bridge void * _Nullable)(self.view)];
//    [UIView setAnimationDuration:0.2];
//    webView.transform=CGAffineTransformMakeScale(10,10);
//    [UIView setAnimationDelegate:self];
//    [UIView commitAnimations];
    
    // Do any additional setup after loading the view.
    

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.5"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
