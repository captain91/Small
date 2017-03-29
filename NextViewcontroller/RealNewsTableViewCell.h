//
//  RealNewsTableViewCell.h
//  SmallFeature
//
//  Created by Sun on 16/8/5.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealNewsModel.h"
@interface RealNewsTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * connentLabel;

@property(nonatomic,strong)UILabel * lineL;
@property(nonatomic,strong)UIImageView * headImage;

-(void)reloadNewsWith:(RealNewsModel *)model;
@end
