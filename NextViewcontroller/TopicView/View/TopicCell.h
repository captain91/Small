//
//  TopicCell.h
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusFrame;

@interface TopicCell : UITableViewCell

@property(nonatomic, strong)StatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
