//
//  StatusTopView.m
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "StatusTopView.h"
#import "TopicModel.h"
#import "StatusFrame.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "PhotoView.h"
#import "PhotosView.h"

@interface StatusTopView ()

/** 原创微博头像 */
@property (nonatomic, weak) UIImageView *headView;

@property (nonatomic, weak) UILabel *titleLabel;
/** 原创微博正文 */
@property (nonatomic, weak) UILabel *summaryLabel;
/** 原创微博配图 */
@property (nonatomic, weak) PhotosView *photosView;


@end
@implementation StatusTopView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImageWithName:@"timeline_card_top_background"];
        self.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_top_background_highlighted"];
        
        //头像
        UIImageView *headView = [[UIImageView alloc]init];
        [self addSubview:headView];
        self.headView = headView;
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]init];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        //内容
        UILabel *summaryLabel = [[UILabel alloc]init];
        summaryLabel.numberOfLines = 0;
        [self addSubview:summaryLabel];
        self.summaryLabel = summaryLabel;
        
        //配图
        PhotosView *photosView = [[PhotosView alloc]init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}

#pragma mark - 设置数据
- (void)setStatusFrame:(StatusFrame *)statusFrame{
    _statusFrame = statusFrame;
    
    TopicModel *topicM = statusFrame.topicM;
    
    //头像
    NSString *headViewUrl = [NSString stringWithFormat:@"%@%@",HttpAdress,topicM.authorIcon];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:headViewUrl] placeholderImage:[UIImage imageNamed:@"master"]];
    self.headView.frame = statusFrame.headViewF;
    
    //标题
    self.titleLabel.text = topicM.title;
    self.titleLabel.frame = statusFrame.titleLabelF;
    
    //内容
    self.summaryLabel.text = topicM.summary;
    self.summaryLabel.frame = statusFrame.summaryLabelF;
    
    //配图
    if (topicM.images.count) {
        self.photosView.hidden = NO;
        self.photosView.photos = topicM.images;
        self.photosView.frame = statusFrame.photoViewF;
    }else{
        self.photosView.hidden = YES;
    }
}

@end
