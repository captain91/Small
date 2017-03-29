//
//  SImageView.m
//  SmallFeature
//
//  Created by Sun on 16/10/9.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "SPhotoView.h"
@interface SPhotoView ()

@property(nonatomic,weak)UIButton *deleteBtn;

@end;

@implementation SPhotoView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"camera_edit_cut_cancel"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
    }
    return self;
}

//删除事件
-(void)removeSelf:(UIButton *)btn {
    
//    [self removeFromSuperview];
    NSLog(@"点击的image。tag = %ld",self.tag);
    if ([self.deleteDelegate respondsToSelector:@selector(deletePhotoWithTag:)]) {
        [self.deleteDelegate deletePhotoWithTag:self.tag];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.deleteBtn.layer.anchorPoint = CGPointMake(1, 0);
    self.deleteBtn.layer.position = CGPointMake(self.bounds.size.width, 0);
}
@end
