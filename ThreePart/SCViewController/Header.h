//
//  Header.h
//  zhongUNetwork
//
//  Created by yumao on 15/10/15.
//  Copyright © 2015年 yumao. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */

#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kScreenBounds [[UIScreen mainScreen]bounds]
#define kSizeHeight(view) view.frame.size.height
#define kSizeWidth(view) view.frame.size.width
#define kOriginX(view) view.frame.origin.x
#define kOriginY(view) view.frame.origin.y


#define ScreenSize [UIScreen mainScreen].bounds.size

#define SystemVersion [[UIDevice currentDevice].systemVersion floatValue]
//480
#define sNowSizeHeight(x) (x/568.0)*([UIScreen mainScreen].bounds.size.height)
#define sNowSizeWidth(x) (x/320.0)*([UIScreen mainScreen].bounds.size.width)
//比例系数
#define kk ScreenSize.width / 320

#define HttpHead @"http://"

#define IpAddress @"112.124.113.109/"

#define DataHead @"appapi/"

#define EVERYPAGES  10


#import "SCNavTabBarController.h"


//返回参数函数处理
static NSString *CHECK_LOGIN = @"check_login";
static NSString *SHARE_DATA = @"share_data";
static NSString *WEB_READY = @"web_ready";
static NSString *WX_PAY = @"wx_pay";

//分享相关参数
static NSString *SHARE_TITLE = @"title";
static NSString *SHARE_LINK = @"link";
static NSString *SHARE_IMAGE_URL = @"img_url";
static NSString *SHARE_DESC = @"desc";


