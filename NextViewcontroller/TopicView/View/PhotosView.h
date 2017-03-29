//
//  PhotosView.h
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosView : UIView

@property(nonatomic, strong)NSArray *photos;

//根据图片个数返回photosView大小
+ (CGSize)sizeWithPhotosCount:(int)count;

@end
