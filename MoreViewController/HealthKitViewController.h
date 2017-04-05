//
//  HealthKitViewController.h
//  SmallFeature
//
//  Created by Sun on 2017/2/28.
//  Copyright © 2017年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^getTitleStr)(NSString *title);

@interface HealthKitViewController : BaseViewController

@property(nonatomic,copy)getTitleStr titleBlock;

@end
