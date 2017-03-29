//
//  StatusFrame.h
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicModel.h"

// 间距
#define StatusPadding 10
// 昵称字体
#define StatusNameFont 14
// 时间字体
#define StatusTimeFont 10
// 来源字体
#define StatusSourceFont StatusTimeFont
// 正文字体
#define StatusContentFont 14

@interface StatusFrame : NSObject

@property (nonatomic, assign, readonly) CGRect originalViewF;

@property(nonatomic, assign, readonly)CGRect headViewF;

@property(nonatomic, assign, readonly)CGRect titleLabelF;

@property(nonatomic, assign, readonly)CGRect summaryLabelF;

@property(nonatomic, assign, readonly)CGRect photoViewF;


//cell的高度
@property(nonatomic, assign, readonly)CGFloat cellHeight;

@property(nonatomic, strong) TopicModel *topicM;

@end
