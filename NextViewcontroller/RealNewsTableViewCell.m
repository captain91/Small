//
//  RealNewsTableViewCell.m
//  SmallFeature
//
//  Created by Sun on 16/8/5.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "RealNewsTableViewCell.h"

@implementation RealNewsTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    //线条
    self.lineL = [UILabel new];
    self.lineL.frame = CGRectMake(15,0, 1, 100);
    self.lineL.backgroundColor = TABLEVIEWDEFAULTCOLOR;
    [self.contentView addSubview:self.lineL];
    
    self.headImage = [[UIImageView  alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
    self.headImage.userInteractionEnabled = NO;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 5;
    self.headImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.headImage];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, VIEW_WIDTH - 40, 20)];
    self.timeLabel.textColor = TabBarTintColor;
    [self.contentView addSubview:self.timeLabel];
    
    self.connentLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 30, VIEW_WIDTH - 40, 30)];
    
    self.connentLabel.textColor = [UIColor blackColor];
    self.connentLabel.textAlignment = NSTextAlignmentLeft;
    self.connentLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.connentLabel];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)reloadNewsWith:(RealNewsModel *)model{
    
    self.lineL.frame = CGRectMake(15, 0, 1, model.cellH);
    
    self.connentLabel.frame = CGRectMake(25, 20, VIEW_WIDTH - 35 - 40, model.cellH-40);
    
    self.timeLabel.text = [model.time substringFromIndex:10];
    
    self.connentLabel.text = model.content;
}

@end
