//
//  TodayViewController.m
//  SmallToday
//
//  Created by Sun on 16/3/31.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
//#import "StockViewController.h"
@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController{

    UIView *contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(0, 200);
    
    contentView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    contentView.userInteractionEnabled = YES;
    
    contentView.backgroundColor = [UIColor greenColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 100, 100)];
    
    [button addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"推出应用" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [contentView addSubview:button];
    
    [self.view addSubview:contentView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)pushNext:(UIButton *)btn{
    
//    StockViewController * stockVc = [StockViewController new];
    
//    [self.navigationController pushViewController:stockVc animated:YES];
    NSLog(@"怎么进入应用的");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}

@end
