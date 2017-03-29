//
//  CommentFrame.m
//  SmallFeature
//
//  Created by Sun on 2016/10/27.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "CommentFrame.h"

@implementation CommentFrame
//-(void)setCommentM:(CommentModel *)commentM {
//    _commentM = commentM;
//    
//    //cell宽度
//    CGFloat cellW = [UIScreen mainScreen].bounds.size.width - StatusPadding;
//    
//    //头像
//    CGFloat iconXY = StatusPadding;
//    CGFloat iconWH = 40;
//    _headViewF = CGRectMake(iconXY, iconXY, iconWH, iconWH);
//    
//    //标题
//    CGFloat titleX = iconXY + iconWH + StatusPadding/2;
//    CGFloat titleY = 5 + StatusPadding;
//    CGFloat titleW = cellW - 55;
//    _titleLabelF = CGRectMake(titleX, titleY, titleW, 3 * StatusPadding);
//    
//    //正文
//    CGFloat contentX = iconXY;
//    CGFloat contentY = CGRectGetMaxY(_titleLabelF) + StatusPadding;
//    CGFloat contentMaxW = cellW - 2 * StatusPadding;
//    CGSize contentSize = [commentM.content boundingRectWithSize:CGSizeMake(contentMaxW, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:StatusContentFont]} context:nil].size;
//    _summaryLabelF = (CGRect){contentX, contentY, contentSize};
//    //固定高度
////    _summaryLabelF = CGRectMake(contentX, contentY, contentMaxW, 50);
//    
//    CGFloat originalH = CGRectGetMaxY(_summaryLabelF) + StatusPadding;
//    
//    //配图
//    if (commentM.images.count) {
//        CGFloat photoX = StatusPadding;
//        CGFloat photoY = CGRectGetMaxY(_summaryLabelF) + StatusPadding;
//        CGSize photoSize = [PhotosView sizeWithPhotosCount:(int)commentM.images.count];
//        _photoViewF = CGRectMake(photoX, photoY, photoSize.width, photoSize.height);
//        
//        originalH = CGRectGetMaxY(_photoViewF) + StatusPadding;
//    }
//    
//    _originalViewF = CGRectMake(0, 0, cellW, originalH);
//    
//    //cell高度
//    _cellHeight = originalH + StatusPadding * 0.5;
//    
//}

- (void)setModelArray:(NSArray *)modelArray {
    
    CommentModel *commentM = modelArray[0]; 
    
    self.commentM = commentM;
    //cell宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width - StatusPadding;
    
    //一级评论布局
    //头像
    CGFloat iconXY = StatusPadding;
    CGFloat iconWH = 40;
    _headViewF = CGRectMake(iconXY, iconXY, iconWH, iconWH);
    
    //标题
    CGFloat titleX = iconXY + iconWH + StatusPadding/2;
    CGFloat titleY = 5 + StatusPadding;
    CGFloat titleW = cellW - 55;
    _titleLabelF = CGRectMake(titleX, titleY, titleW, 3 * StatusPadding);
    
    //正文
    CGFloat contentX = iconXY;
    CGFloat contentY = CGRectGetMaxY(_titleLabelF) + StatusPadding;
    CGFloat contentMaxW = cellW - 2 * StatusPadding;
    CGSize contentSize = [commentM.content boundingRectWithSize:CGSizeMake(contentMaxW, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:StatusContentFont]} context:nil].size;
    _summaryLabelF = (CGRect){contentX, contentY, contentSize};
    //固定高度
    //    _summaryLabelF = CGRectMake(contentX, contentY, contentMaxW, 50);
    
    CGFloat originalH = CGRectGetMaxY(_summaryLabelF) + StatusPadding;
    
    //配图
    if (commentM.images.count) {
        CGFloat photoX = StatusPadding;
        CGFloat photoY = CGRectGetMaxY(_summaryLabelF) + StatusPadding;
        CGSize photoSize = [PhotosView sizeWithPhotosCount:(int)commentM.images.count];
        _photoViewF = CGRectMake(photoX, photoY, photoSize.width, photoSize.height);
        
        originalH = CGRectGetMaxY(_photoViewF) + StatusPadding;
    }
    
    _originalViewF = CGRectMake(0, 0, cellW, originalH);
    
    if (modelArray.count >= 2) {
        //创建二级评论
        for (int c = 1; c < modelArray.count; c++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(StatusPadding, CGRectGetMaxY(_originalViewF) * (c - 1), contentMaxW, 30)];
            btn.backgroundColor = [UIColor lightGrayColor];
            originalH +=CGRectGetMaxY(btn.frame);
        }
    }
    
    
    //cell高度
    _cellHeight = originalH + StatusPadding * 0.5;
    
}
@end
