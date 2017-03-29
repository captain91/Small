//
//  XXStatusTopView.m
//  XXWB
//
//  Created by Leo on 14-12-31.
//  Copyright (c) 2014年 Leo. All rights reserved.
//

#import "XXStatusTopView.h"
#import "XXStatus.h"
#import "XXStatusFrame.h"
#import "UIImageView+WebCache.h"
#import "XXPhoto.h"
#import "XXPhotoView.h"
#import "XXPhotosView.h"

@interface XXStatusTopView ()

/** 原创微博正文 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 原创微博配图 */
@property (nonatomic, weak) XXPhotosView *photosView;

@end

@implementation XXStatusTopView

#pragma mark - 初始化

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImageWithName:@"timeline_card_top_background"];
        self.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_top_background_highlighted"];
        
        // 6. 正文
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:XXStatusContentFont];
        contentLabel.textColor = XXColor(35, 35, 35);
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        // 7. 配图
        XXPhotosView *photosView = [[XXPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}


#pragma mark - 设置数据

- (void)setStatusFrame:(XXStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    XXStatus *status = statusFrame.status;

    // 正文
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    // 配图
    if (status.pic_urls.count) {
        self.photosView.hidden = NO;
        
        self.photosView.photos = status.pic_urls;
        
        self.photosView.frame = statusFrame.photoViewF;
    } else {
        self.photosView.hidden = YES;
    }
    
}

@end
