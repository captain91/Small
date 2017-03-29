//
//  StatusFrame.m
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "StatusFrame.h"
#import "PhotosView.h"
@implementation StatusFrame
-(void)setTopicM:(TopicModel *)topicM{
    
    _topicM = topicM;
    
    //cell宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width - StatusPadding;
    
    //头像
    CGFloat iconXY = StatusPadding;
    CGFloat iconWH = 40;
    _headViewF = CGRectMake(iconXY, iconXY, iconWH, iconWH);
    
    //标题
    CGFloat titleX = iconXY;
    CGFloat titleY = CGRectGetMaxY(_headViewF) + StatusPadding;
    CGFloat titleW = cellW - 2 * StatusPadding;
    _titleLabelF = CGRectMake(titleX, titleY, titleW, 2 * StatusPadding);
    
    //正文
    CGFloat contentX = iconXY;
    CGFloat contentY = CGRectGetMaxY(_titleLabelF) + StatusPadding;
    CGFloat contentMaxW = cellW - 2 * StatusPadding;
//    CGSize contentSize = [topicM.summary boundingRectWithSize:CGSizeMake(contentMaxW, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:StatusContentFont]} context:nil].size;
//    _summaryLabelF = (CGRect){contentX, contentY, contentSize};
    //固定高度
    _summaryLabelF = CGRectMake(contentX, contentY, contentMaxW, 50);
    
    CGFloat originalH = CGRectGetMaxY(_summaryLabelF) + StatusPadding;

    //配图
    if (topicM.images.count) {
        CGFloat photoX = StatusPadding;
        CGFloat photoY = CGRectGetMaxY(_summaryLabelF) + StatusPadding;
        CGSize photoSize = [PhotosView sizeWithPhotosCount:(int)topicM.images.count];
        _photoViewF = CGRectMake(photoX, photoY, photoSize.width, photoSize.height);
        
        originalH = CGRectGetMaxY(_photoViewF) + StatusPadding;
    }
    
    _originalViewF = CGRectMake(0, 0, cellW, originalH);

    //cell高度
    _cellHeight = originalH + StatusPadding * 0.5;

}
@end
