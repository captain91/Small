//
//  PhotosView.m
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "PhotosView.h"

#import "Photo.h"
#import "PhotoView.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "KNPhotoBrowerImageView.h"
#import "KNPhotoBrower.h"
#import "KNToast.h"

#define PhotoW 70
#define PhotoH 70
#define PhotoMargin 10

@implementation PhotosView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化9个子控件
        for (int index = 0; index < 9; index++) {
            PhotoView *photoView = [[PhotoView alloc]init];
            photoView.tag = index;
            photoView.userInteractionEnabled = YES;
            [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)]];
            [self addSubview:photoView];
        }
    }
    return self;
}
/**
 *  监听图片点击
 */
- (void)photoTap:(UITapGestureRecognizer *)tap
{
    int count = (int)self.photos.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    
    NSMutableArray *photosUrl = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        // 图片路径
        // 替换为中等尺寸图片
//        NSString *url = [[self.photos[i] imageUrl] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        NSString *url = [NSString stringWithFormat:@"%@%@",HttpAdress,[self.photos[i] imageUrl]];
        photo.url = [NSURL URLWithString:url];
        
//        // 来源于哪个UIImageView
//        photo.srcImageView = self.subviews[i];
//        
//        [photos addObject:photo];
        
        
        //
        KNPhotoItems *items = [[KNPhotoItems alloc]init];
        items.url = url;
        items.sourceView = self.subviews[i];
        [photosUrl addObject:items];
    }
    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
    
    //显示相册
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc]init];
    photoBrower.itemsArr = photosUrl;
    photoBrower.currentIndex = tap.view.tag;
    [photoBrower present];
    
//    [photoBrower setDelegate:self];
}


- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    for (int index = 0; index < self.subviews.count; index++) {
        PhotoView *photoView = self.subviews[index];
        
        if (index < photos.count) {
            photoView.hidden = NO;
            
            // 传递模型
            photoView.photo = photos[index];
            
            // 设置frame
            int maxColumns = (photos.count == 4) ? 2 : 3;
            int col = index % maxColumns;
            int row = index / maxColumns;
            CGFloat photoX = col * (PhotoW + PhotoMargin);
            CGFloat photoY = row * (PhotoH + PhotoMargin);
            photoView.frame = CGRectMake(photoX, photoY, PhotoW, PhotoH);
            
            if (photos.count == 1) {
                photoView.contentMode = UIViewContentModeScaleAspectFit;
                photoView.clipsToBounds = NO;
            } else {
                photoView.contentMode = UIViewContentModeScaleAspectFill;
                photoView.clipsToBounds = YES;
            }
        } else {
            photoView.hidden = YES;
        }
    }
}

+ (CGSize)sizeWithPhotosCount:(int)count
{
    // 一行最多3列
    int maxColumns = (count == 4) ? 2 : 3;
    
    // 总行数
    int rows = (count + maxColumns - 1) / maxColumns;
    // 高度
    CGFloat photosH = rows * PhotoH + (rows - 1) * PhotoMargin;
    
    // 总列数
    int cols = (count >= maxColumns) ? maxColumns : count;
    // 宽度
    CGFloat photosW = cols * PhotoW + (cols - 1) * PhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
