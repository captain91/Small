//
//  AppDelegate.h
//  SmallFeature
//
//  Created by Sun on 16/1/21.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#define App_Delegate      ((AppDelegate*)[[UIApplication sharedApplication]delegate])
@property (assign, nonatomic) NSInteger maxPicNum; //发布跟帖可选最大图片张数
@property (assign, nonatomic) NSInteger selectedPicNum; //已选择张数

@end

