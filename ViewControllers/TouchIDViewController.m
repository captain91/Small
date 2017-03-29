//
//  TouchIDViewController.m
//  SmallFeature
//
//  Created by Sun on 16/1/25.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "TouchIDViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>

@interface TouchIDViewController ()

@end

@implementation TouchIDViewController{
    
    UIView *bgview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationItem];
    
    [self showView];
    
    [self touchIdCheck];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -coutomNavigationItem
- (void)customNavigationItem{
    
    self.navigationItem.title = @"Touch ID";
    
    self.view.backgroundColor = [UIColor whiteColor];
}
//验证不成功显示
- (void)showView{
    
    bgview = [[UIView alloc]initWithFrame:self.view.bounds];
    
    bgview.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bgview];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 120, VIEW_WIDTH - 100, 30)];
    
    [button setTitle:@"点击进行指纹解锁" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor colorWithRed:60.0/255 green:130.0/255 blue:255.0/255 alpha:1] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(touchIdCheck) forControlEvents:UIControlEventTouchUpInside];
    
    [bgview addSubview:button];
}

#pragma mark - touchID
- (void)touchIdCheck{
    
    //初始化上下文对象
    LAContext *context = [[LAContext alloc]init];
    
    NSError *error = nil;
    
    NSString *result = @"通过home键验证已有手机指纹";
    
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                
                //验证成功
                NSLog(@"验证成功");
                
                //必须加入主线程操作，不然太慢
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [bgview removeFromSuperview];
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, VIEW_WIDTH, 30)];
                    
                    label.text = @"指纹解锁成功";
                    
                    label.textAlignment = 1;
                    
                    [self.view addSubview:label];
                }];
                
            }else{
                
                NSLog(@"%@",error.localizedDescription);
                
                switch (error.code) {
                    case LAErrorAppCancel:
                        
                        NSLog(@"切换到其他app，系统取消验证");                        
                        break;
                    case LAErrorUserCancel:
                        
                        NSLog(@"用户取消Touch ID验证");
                        break;
                    case LAErrorUserFallback:
                        
                        NSLog(@"Touch ID 没验证过提示用户选择输入密码，切换到主线程处理");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //需要处理
                            NSLog(@"输入密码");
                        }];
                        break;
                    case LAErrorTouchIDLockout:
                        NSLog(@"要输入开机解锁密码,系统会自动弹出");
                        break;
                        
                    default:
                        NSLog(@"三次没有验证成功,自动消失，再三次没有成功，进入验证解锁密码");
                        NSLog(@"其他情况可以直接消失不管，可以不作处理");
                        break;
                }
            }
        }];
        
    }else{
        
        NSLog(@"不支持指纹识别");
        UIAlertView *alt =[[UIAlertView alloc]initWithTitle:@"提示" message:@"不支持指纹识别,进行其他验证操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alt show];
        
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

@end
