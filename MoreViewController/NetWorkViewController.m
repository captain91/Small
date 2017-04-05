//
//  NetWorkViewController.m
//  SmallFeature
//
//  Created by Sun on 2017/3/30.
//  Copyright © 2017年 ssb. All rights reserved.
//

#import "NetWorkViewController.h"
#import <CoreTelephony/CTCellularData.h>
@interface NetWorkViewController ()<UIAlertViewDelegate>

@end

@implementation NetWorkViewController {
    NSInteger showTimes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络权限";
    
    [self createUI];
    //测试循环引用
//    NSMutableArray *firstArray = [NSMutableArray array];
//    NSMutableArray *secondArray = [NSMutableArray array];
//    
//    [firstArray addObject:secondArray];
//    [secondArray addObject:firstArray];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createUI {
    NSArray *btnTitleA = [NSArray arrayWithObjects:@"网络",@"跳转", nil];
    
    for (int i = 0; i< btnTitleA.count; i++) {
        UIButton *button= [[UIButton alloc]initWithFrame:CGRectMake((VIEW_WIDTH - 200)/3 + i * ((VIEW_WIDTH - 200)/3 + 100), 70, 100, 30)];
        [button setTitle:btnTitleA[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.5;
        button.tag = 100 + i;
        [self.view addSubview:button];
    }

}
-(void)buttonAction:(UIButton *)btn {
    switch (btn.tag - 100) {
        case 0:
            [self checkNetWork];
//            showTimes = 1;
            break;
        case 1:
            [self goSetting];
            break;
        default:
            break;
    }
}
#pragma mark - 检查网络权限
-(void)checkNetWork {
    
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        //获取网络状态
//        NSString *statusStr;
        
        switch (state) {
            case kCTCellularDataRestricted:
                showTimes = 1;
//                statusStr = @"网络受限";
                break;
            case kCTCellularDataNotRestricted:
//                statusStr = @"允许网络";
                break;
            case kCTCellularDataRestrictedStateUnknown:
//                statusStr = @"网络不明";
                break;
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //异步主线程
            if (showTimes == 1) {
                showTimes = 0;
                [self showAlert];
//                return;
            }
//            [MBProgressHUD showSuccess:statusStr];
        });
    };
}
-(void)goSetting {
    //iOS8及以后
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)showAlert {
    NSString *altTitle = @"已为\"功能集\"关闭了蜂窝移动数据";
    NSString *altMessage = @"您可以在\"设置\"中为此应用打开蜂窝移动数据";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:altTitle message:altMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //TODO:
    }];

    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //TODO:
        dispatch_async(dispatch_get_main_queue(), ^{
            [self goSetting];
        });
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:setAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
@end
