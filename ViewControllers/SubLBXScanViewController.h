//
//  SubLBXScanViewController.h
//  SmallFeature
//
//  Created by Sun on 16/2/15.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "LBXScanViewController.h"

#import "LBXAlertAction.h"


@interface SubLBXScanViewController : LBXScanViewController

#pragma mark - 定制页面

@property (nonatomic, strong) UILabel *topTitle;

#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码

//底部显示的功能
@property (nonatomic, strong) UIView *bottomItemsView;

//相册
@property (nonatomic, strong) UIButton *btnPhoto;

//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;

//我的二维码
@property (nonatomic, strong) UIButton *btnMyQR;


@end
