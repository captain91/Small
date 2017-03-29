//
//  XXStatusFrame.m
//  XXWB
//
//  Created by 刘超 on 14/12/19.
//  Copyright (c) 2014年 Leo. All rights reserved.
//

#import "XXStatusFrame.h"
#import "XXStatus.h"
#import "NSString+LCExtend.h"
#import "XXPhotosView.h"

@implementation XXStatusFrame

- (void)setStatus:(XXStatus *)status
{
    _status = status;
    
    // cell宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width - XXStatusPadding;
    
    // 6. 正文
    CGFloat contentX = XXStatusPadding;
    CGFloat contentY =  XXStatusPadding;
    CGFloat contentMaxW = cellW - 2 * XXStatusPadding;
//    CGSize contentSize = [status.text sizeWithFont:[UIFont systemFontOfSize:XXStatusContentFont] constrainedToSize:CGSizeMake(contentMaxW, MAXFLOAT)];    
    CGSize contentSize = [status.text boundingRectWithSize:CGSizeMake(contentMaxW, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:XXStatusContentFont]} context:nil].size;
    _contentLabelF = (CGRect){contentX, contentY, contentSize};
    
    CGFloat originalH = CGRectGetMaxY(_contentLabelF) + XXStatusPadding;
    
    // 7. 配图
    if (status.pic_urls.count) {
        CGFloat photoX = XXStatusPadding;
        CGFloat photoY = CGRectGetMaxY(_contentLabelF) + XXStatusPadding;
        CGSize photoSize = [XXPhotosView sizeWithPhotosCount:(int)status.pic_urls.count];
        _photoViewF = CGRectMake(photoX, photoY, photoSize.width, photoSize.height);
        
        originalH = CGRectGetMaxY(_photoViewF) + XXStatusPadding;
    }
    _originalViewF = CGRectMake(0, 0, cellW, originalH);
    
    // cell的高度
    _cellHeight = originalH + XXStatusPadding * 0.5;
}

@end
