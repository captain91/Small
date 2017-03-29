//
//  ShowImageView.m
//  SmallFeature
//
//  Created by Sun on 16/10/9.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "SPhotosView.h"
#import "SPhotoView.h"

#import "KNPhotoBrowerImageView.h"
#import "KNPhotoBrower.h"
#import "KNToast.h"

//#define PhotoW (VIEW_WIDTH - (4 * PhotoMargin))/3
//#define PhotoH (VIEW_WIDTH - (4 * PhotoMargin))/3
#define PhotoW 70
#define PhotoH 70
#define PhotoMargin 10

@implementation SPhotosView{
    UIScrollView *_bgScrollView;
    UIButton *addBtn;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.userInteractionEnabled = YES;
        _bgScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _bgScrollView.backgroundColor = [UIColor redColor];
//        [self addSubview:_bgScrollView];
        
        //初始化9个子控件
        for (int index = 0; index < 9; index++) {
            SPhotoView *sImageView = [[SPhotoView alloc]init];
            sImageView.deleteDelegate = self;
            sImageView.tag = index;
            sImageView.userInteractionEnabled = YES;
            [sImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTap:)]];
            [self addSubview:sImageView];
        }
        addBtn = [[UIButton alloc]init];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"AddPic"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addPic:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        
    }
    return self;
}

/**
 * 监听图片点击
 */
- (void)photoTap:(UITapGestureRecognizer *)tap {
    NSLog(@"点击了第%ld个图片",tap.view.tag);
    
    int count = (int)self.photos.count;
    // 1.封装图片数据    
    NSMutableArray *photosUrl = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        
        KNPhotoItems *items = [[KNPhotoItems alloc]init];
        items.isUrl = NO;
        items.sourceView = self.subviews[i];
        [photosUrl addObject:items];
    }
    
    //显示相册
    KNPhotoBrower *photoBrower = [[KNPhotoBrower alloc]init];
    photoBrower.itemsArr = photosUrl;
    photoBrower.currentIndex = tap.view.tag;
    [photoBrower present];

}

-(void)setPhotos:(NSArray *)photos {
    _photos = photos;
    
    for (int index = 0; index < self.subviews.count - 1; index++) {
        SPhotoView *sImageView;
        if ([self.subviews[index] isKindOfClass:[UIImageView class]]) {
              sImageView = self.subviews[index];
        }
        //一行最多三列
        int maxColumns = 3;
        int col = index % maxColumns;
        int row = index / maxColumns;
        CGFloat photoX = col * (PhotoW + PhotoMargin);
        CGFloat photoY = row * (PhotoH + PhotoMargin);
        
        if (index < photos.count) {
            sImageView.hidden = NO;
            //设置图片
            sImageView.image = photos[index];            
            //设置frame
            sImageView.frame = CGRectMake(photoX, photoY, PhotoW, PhotoH);            
            sImageView.contentMode = UIViewContentModeScaleToFill;
            sImageView.clipsToBounds = YES;
        }else {
            sImageView.hidden = YES;
        }
        if (index == photos.count) {
            addBtn.frame = CGRectMake(photoX, photoY, PhotoW, PhotoH);
        }
    }
}

-(void)addPic:(UIButton *)btn{
    NSLog(@"addPic");
}
+ (CGFloat)sizeWithPhotosCount:(int)count {
    //
    int maxColumns = 3;
    //总行数
    int rows = (count + maxColumns - 1) / maxColumns;
    //高度
    CGFloat photosH = rows * PhotoH + (rows - 1) * PhotoMargin;
    return photosH;
}

//代理方法
-(void)deletePhotoWithTag:(NSInteger)photoTag {
    
    if ([self.deletePhotoDelegate respondsToSelector:@selector(deletePhotoWithIndex:)]) {
        [self.deletePhotoDelegate deletePhotoWithIndex:photoTag];
        NSLog(@"走代理，删除照片");
    }
    //照片重新布局
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.photos];
    [tempArray removeObjectAtIndex:photoTag];
    self.photos = [tempArray copy];

}
@end
