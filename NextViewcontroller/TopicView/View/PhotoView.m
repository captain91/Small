//
//  PhotoView.m
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "PhotoView.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"

@interface PhotoView ()

@property(nonatomic, weak) UIImageView *gifView;

@end;

@implementation PhotoView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *gif = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc]initWithImage:gif];
        [self addSubview:gifView];
        
        self.gifView = gifView;
    }
    return self;
}

-(void)setPhoto:(Photo *)photo{
    _photo = photo;
    
    self.gifView.hidden = ![photo.imageUrl hasSuffix:@".gif"];
    
    //添加完整地址
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@",HttpAdress,photo.imageUrl];
    
    [self sd_setImageWithURL:[NSURL URLWithString:photoUrl]
            placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.layer.anchorPoint = CGPointMake(1, 1);
    self.gifView.layer.position = CGPointMake(self.bounds.size.width, self.bounds.size.height);
}

@end
