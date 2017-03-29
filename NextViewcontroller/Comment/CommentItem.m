//
//  CommentItem.m
//  SmallFeature
//
//  Created by Sun on 2016/10/26.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "CommentItem.h"
#import "PhotosView.h"

#define StatusPadding 10

@interface CommentItem ()

/** 用户头像 */
@property (nonatomic, weak) UIImageView *headView;

@property (nonatomic, weak) UILabel *titleLabel;
/** 主评正文 */
@property (nonatomic, weak) UILabel *summaryLabel;
/** 配图 */
@property (nonatomic, weak) PhotosView *photosView;


@end
@implementation CommentItem

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
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

- (void)setCFrame:(CommentFrame *)cFrame {
    
    self.headView.frame = cFrame.headViewF;
    //头像
    NSString *headViewUrl = [NSString stringWithFormat:@"%@%@",HttpAdress,cFrame.commentM.userIcon];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:headViewUrl] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    
    self.titleLabel.frame = cFrame.titleLabelF;
    self.titleLabel.text = cFrame.commentM.userName;
    
    self.summaryLabel.frame = cFrame.summaryLabelF;
    self.summaryLabel.text = cFrame.commentM.content;
    
    //配图
    if (cFrame.commentM.images.count) {
        self.photosView.hidden = NO;
        self.photosView.photos = cFrame.commentM.images;
        self.photosView.frame = cFrame.photoViewF;
    }else{
        self.photosView.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
