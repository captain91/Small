//
//  SPhotoBrowerCell.h
//  SmallFeature
//
//  Created by Sun on 16/10/9.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPhotoBrowerImageView.h"

typedef void(^SingleTap)();

@interface SPhotoBrowerCell : UICollectionViewCell

- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder;

@property (nonatomic, copy  ) SingleTap singleTap;

@property (nonatomic, strong) SPhotoBrowerImageView *photoBrowerImageView;

@end