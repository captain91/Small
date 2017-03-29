//
//  TopicCell.m
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "TopicCell.h"

#import "TopicModel.h"
#import "StatusFrame.h"
#import "UIImageView+WebCache.h"
#import "StatusTopView.h"

@interface TopicCell ()

/** 微博的topView */
@property (nonatomic, weak) StatusTopView *topView;

@end

@implementation TopicCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"status";
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TopicCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - 重写setFrame
- (void)setFrame:(CGRect)frame{
    frame.origin.x  = StatusPadding * 0.5;
    frame.size.width -= StatusPadding;
    frame.origin.y += StatusPadding * 0.5;
    frame.size.height -= StatusPadding * 0.5;
    
    [super setFrame:frame];
}

#pragma mark - 初始化
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc]init];
        
        //初始化topView
        [self setUpTopView];
    }
    return self;
}
//初始化topView
- (void)setUpTopView {
    StatusTopView *topView = [[StatusTopView alloc]init];
    [self.contentView addSubview:topView];
    self.topView = topView;
}

#pragma mark - 设置数据

- (void)setStatusFrame:(StatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 设置数据和frame
    [self setupTopViewData];
    
}

/**
 *  设置原创微博数据和frame
 */
- (void)setupTopViewData
{
    StatusFrame *statusFrame = self.statusFrame;
    
    // 传递数据和布局
    self.topView.statusFrame = statusFrame;
    self.topView.frame = statusFrame.originalViewF;
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
