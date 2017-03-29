//
//  SPhotoBrowerCell.m
//  SmallFeature
//
//  Created by Sun on 16/10/9.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "SPhotoBrowerCell.h"

@implementation SPhotoBrowerCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView{
    __weak typeof(self) weakSelf = self;
    SPhotoBrowerImageView *photoBrowerView = [[SPhotoBrowerImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoBrowerView.singleTapBlock = ^(UITapGestureRecognizer *tap){
        if(weakSelf.singleTap){
            weakSelf.singleTap();
        }
    };
    _photoBrowerImageView = photoBrowerView;
    [self.contentView addSubview:photoBrowerView];
}

- (void)sd_ImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder{
    [_photoBrowerImageView sd_ImageWithUrl:[NSURL URLWithString:url] placeHolder:placeHolder];
}

- (void)dealloc{
    [_photoBrowerImageView.scrollView setZoomScale:1.f animated:NO];
}

@end
