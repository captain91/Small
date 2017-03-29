//
//  XXStatusCell.m
//  XXWB
//
//  Created by 刘超 on 14/12/19.
//  Copyright (c) 2014年 Leo. All rights reserved.
//

#import "XXStatusCell.h"
#import "XXStatus.h"
#import "XXStatusFrame.h"
#import "UIImageView+WebCache.h"
#import "XXStatusTopView.h"

@interface XXStatusCell ()

/** 微博的topView */
@property (nonatomic, weak) XXStatusTopView *topView;

@end

@implementation XXStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    XXStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[XXStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - 重写setFrame:方法

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = XXStatusPadding * 0.5;
    frame.size.width -= XXStatusPadding;
    frame.origin.y += XXStatusPadding * 0.5;
    frame.size.height -= XXStatusPadding * 0.5;
    
    [super setFrame:frame];
}

#pragma mark - 初始化

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] init];
        
        // 初始化微博的topView
        [self setupTopView];
        
    }
    return self;
}

/**
 *  初始化微博的topView
 */
- (void)setupTopView
{
    XXStatusTopView *topView = [[XXStatusTopView alloc] init];
    [self.contentView addSubview:topView];
    self.topView = topView;
}

/**
 *  初始化微博工具条
 */
#pragma mark - 设置数据

- (void)setStatusFrame:(XXStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 设置原创微博数据和frame
    [self setupTopViewData];    
}

/**
 *  设置原创微博数据和frame
 */
- (void)setupTopViewData
{
    XXStatusFrame *statusFrame = self.statusFrame;
    
    // 传递数据和布局
    self.topView.statusFrame = statusFrame;
    self.topView.frame = statusFrame.originalViewF;
}

@end
