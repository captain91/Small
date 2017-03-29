//
//  SubLBXScanViewController.m
//  SmallFeature
//
//  Created by Sun on 16/2/15.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "SubLBXScanViewController.h"

#import "QrCodeViewController.h"

#import "LBXScanResult.h"

#import "LBXScanWrapper.h"

#import "MyCodeViewController.h"

@interface SubLBXScanViewController ()

@end

@implementation SubLBXScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.title = @"二维码识别";
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 生命周期
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [self drawBottomItems];
    
    [self drawTitle];
    
    [self.view bringSubviewToFront:_topTitle];
}

//绘制扫描区域
- (void)drawTitle{

    if (!_topTitle) {
        
        self.topTitle = [[UILabel alloc]init];
        
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        if ([UIScreen mainScreen].bounds.size.height <= 568) {
            
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        _topTitle.textAlignment = 1;
        
        _topTitle.numberOfLines = 0;
        
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        
        _topTitle.textColor = [UIColor whiteColor];
        
        [self.view addSubview:_topTitle];
    }
}

//绘制底部
- (void)drawBottomItems{
    
    if (_bottomItemsView)   return;
    
    //背景
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 164, CGRectGetWidth(self.view.frame), 100)];
    
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    
    
    //闪光灯
    self.btnFlash = [[UIButton alloc]init];
    
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
    
    [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    
    //相册
    self.btnPhoto = [[UIButton alloc]init];
    
    _btnPhoto.bounds = _btnFlash.bounds;
    
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    
    //我的二维码
    self.btnMyQR = [[UIButton alloc]init];
    
    _btnMyQR.bounds = _btnFlash.bounds;
    
    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
    
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
    
    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
    
    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_bottomItemsView addSubview:_btnFlash];
    
    [_bottomItemsView addSubview:_btnPhoto];
    
    [_bottomItemsView addSubview:_btnMyQR];
    
}


- (void)showError:(NSString *)str{

    [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了"];
    
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array{

    if (array.count < 1) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }

    LBXScanResult *scanResult = array[0];
    
    NSString *strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    [LBXScanWrapper systemVibrate];
    
//    [LBXScanWrapper systemSound];
    
    [self showNextVcWithScanResult:scanResult];
}


- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"提示" msg:strResult chooseBlock:^(NSInteger buttonIdx) {
        
        //点击完，继续扫码
        [weakSelf reStartDevice];
    } buttonsStatement:@"知道了",nil];
}

- (void)showNextVcWithScanResult:(LBXScanResult *)strResult{

    QrCodeViewController * qrVc = [QrCodeViewController new];
    
    qrVc.strCodeType = strResult.strBarCodeType;
    
    qrVc.strScan = strResult.strScanned;
    
    [self.navigationController pushViewController:qrVc animated:YES];
}
#pragma mark - 底部功能
//打开相机
- (void)openPhoto{

    if ([LBXScanWrapper isGetPhotoPermission]) {
        
        [self openLocalPhoto];
        
    }else{
        
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

//闪光灯
- (void)openOrCloseFlash{

    [super openOrCloseFlash];
    
    if (self.isOpenFlash) {
        
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}

//我的二维码

- (void)myQRCode{

    MyCodeViewController *myCode = [MyCodeViewController new];
    
    [self.navigationController pushViewController:myCode animated:YES];
}
@end
