//
//  MBProgressHUD+NJ.h
//  GangAoApp2
//
//  Created by 港澳资讯 on 16/4/6.
//  Copyright © 2016年 王率统. All rights reserved.
//


#import "MBProgressHUD.h"

@interface MBProgressHUD (NJ)
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;
@end
