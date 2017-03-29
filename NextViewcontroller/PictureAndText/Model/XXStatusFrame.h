//
//  XXStatusFrame.h
//  XXWB
//
//  Created by 刘超 on 14/12/19.
//  Copyright (c) 2014年 Leo. All rights reserved.
//  微博frame模型

#import <Foundation/Foundation.h>

// 间距
#define XXStatusPadding 10
// 昵称字体
#define XXStatusNameFont 14
// 时间字体
#define XXStatusTimeFont 10
// 来源字体
#define XXStatusSourceFont XXStatusTimeFont
// 正文字体
#define XXStatusContentFont 14

@class XXStatus;

@interface XXStatusFrame : NSObject

/** 原创微博父控件 */
@property (nonatomic, assign, readonly) CGRect originalViewF;
/** 原创微博正文 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;
/** 原创微博配图 */
@property (nonatomic, assign, readonly) CGRect photoViewF;


/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, strong) XXStatus *status;

@end
