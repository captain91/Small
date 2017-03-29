//
//  LWActionSheetView.h
//  WarmerApp
//
//  Created by 刘微 on 16/3/2.
//  Copyright © 2016年 Warm+. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LWActionSheetView;

@protocol LWActionSheetViewDelegate <NSObject>

@optional

- (void)lwActionSheet:(LWActionSheetView *)actionSheet didSelectedButtonWithIndex:(NSInteger)index;

@end

@interface LWActionSheetView : UIView

@property (nonatomic,weak) id <LWActionSheetViewDelegate> delegate;

- (id)initTilesArray:(NSArray *)titles delegate:(id <LWActionSheetViewDelegate>)delegate;

- (void)show;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com