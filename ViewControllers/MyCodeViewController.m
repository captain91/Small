//
//  MyCodeViewController.m
//  SmallFeature
//
//  Created by Sun on 16/2/15.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "MyCodeViewController.h"

@interface MyCodeViewController ()

@end

@implementation MyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的二维码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showMyQrCode];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showMyQrCode{

    UIImageView *mycode = [[UIImageView alloc]initWithFrame:CGRectMake(5, 20, VIEW_WIDTH - 10, VIEW_HEIGHT * 0.75)];
    mycode.image = [UIImage imageNamed:@"myQrCode.jpg"];
    
    [self.view addSubview:mycode];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
@end
