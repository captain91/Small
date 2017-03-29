//
//  CommentFrame.h
//  SmallFeature
//
//  Created by Sun on 2016/10/27.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
#import "PhotosView.h"
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

@interface CommentFrame : NSObject

@property (nonatomic, assign, readonly) CGRect originalViewF;

@property(nonatomic, assign, readonly)CGRect headViewF;

@property(nonatomic, assign, readonly)CGRect titleLabelF;

@property(nonatomic, assign, readonly)CGRect summaryLabelF;

@property(nonatomic, assign, readonly)CGRect photoViewF;


//cell的高度
@property(nonatomic, assign, readonly)CGFloat cellHeight;

@property(nonatomic, strong) CommentModel *commentM;

@property(nonatomic, strong) NSArray *modelArray;

@end
