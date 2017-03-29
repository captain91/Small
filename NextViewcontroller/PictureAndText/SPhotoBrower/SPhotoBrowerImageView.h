//
//  SPhotoBrowerImageView.h
//  SmallFeature
//
//  Created by Sun on 16/10/9.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNPch.h"

typedef void(^SingleTapBlock)(UITapGestureRecognizer *tap);

@interface SPhotoBrowerImageView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy  ) SingleTapBlock singleTapBlock;

- (void)sd_ImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder;

- (void)reloadFrames;

@end
