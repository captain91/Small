//
//  FirstOpenViewController.h
//  SmallFeature
//
//  Created by Sun on 2017/4/5.
//  Copyright © 2017年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^enterAppBlock)();

@interface FirstOpenViewController : UIViewController
@property(nonatomic,copy)enterAppBlock enterAppBlock;
@end
