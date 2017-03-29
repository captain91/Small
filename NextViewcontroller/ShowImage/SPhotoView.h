//
//  SImageView.h
//  SmallFeature
//
//  Created by Sun on 16/10/9.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SPhotoViewDelegate<NSObject>

-(void)deletePhotoWithTag:(NSInteger)photoTag;

@end

@interface SPhotoView : UIImageView

@property(nonatomic,strong)UIImage *sImage;

@property(nonatomic,weak)id<SPhotoViewDelegate> deleteDelegate;


@end
