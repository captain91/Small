//
//  LWActionSheetTableViewCell.h
//  WarmerApp
//
//  Created by 刘微 on 16/3/2.
//  Copyright © 2016年 Warm+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWActionSheetTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString* title;


- (void)show;

@end


@interface LWActionSheetTableViewCellContent : UIView

@property (nonatomic,copy) NSString* title;

@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com