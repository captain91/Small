//
//  ShowImageView.h
//  SmallFeature
//
//  Created by Sun on 16/10/9.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPhotoView.h"

@protocol SPhotoViewsDelegate <NSObject>

-(void)deletePhotoWithIndex:(NSInteger)photoIndex;

@end

@interface SPhotosView : UIView <SPhotoViewDelegate>

@property(nonatomic,strong)NSArray *photos;

@property(nonatomic,weak)id<SPhotoViewsDelegate> deletePhotoDelegate;

//根据图片个数返回View大小
+ (CGFloat)sizeWithPhotosCount:(int)count;

@end
