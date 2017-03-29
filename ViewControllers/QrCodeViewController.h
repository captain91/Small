//
//  QrCodeViewController.h
//  SmallFeature
//
//  Created by Sun on 16/2/15.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QrCodeViewController : BaseViewController<UIWebViewDelegate>

@property (nonatomic, copy) NSString *strScan;

@property (nonatomic, copy) NSString *strCodeType;
@end
