//
//  SPhotoBrower.h
//  SmallFeature
//
//  Created by Sun on 16/10/9.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPhotoItems : NSObject

@property (nonatomic, copy  ) NSString *url;
@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) UIImage *imageSource;

@end

@protocol KNPhotoBrowerDelegate <NSObject>

@optional
/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss;


@end

@interface SPhotoBrower : UIView
/**
 *  当前图片的下标
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  存放图片的模型 :url && UIView
 */
@property (nonatomic, strong) NSArray *itemsArr;
/**
 *  存放 ActionSheet 弹出框的内容 :NSString类型
 */
@property (nonatomic, strong) NSMutableArray *actionSheetArr;
/**
 *  是否需要右上角的按钮. Default is YES;
 */
@property (nonatomic, assign) BOOL isNeedRightTopBtn;
/**
 *  是否需要 顶部 1 / 9 控件 ,Default is YES
 */
@property (nonatomic, assign) BOOL isNeedPageNumView;
/**
 *  是否需要 底部 UIPageControl, Default is NO
 */
@property (nonatomic, assign) BOOL isNeedPageControl;

@property (nonatomic, weak  ) id<KNPhotoBrowerDelegate> delegate;

/**
 *  展现
 */
- (void)present;
/**
 *  消失
 */
- (void)dismiss;


@end
