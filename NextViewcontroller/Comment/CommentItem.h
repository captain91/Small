//
//  CommentItem.h
//  SmallFeature
//
//  Created by Sun on 2016/10/26.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "CommentFrame.h"
@interface CommentItem : UITableViewCell

@property(nonatomic,assign,readonly)CGFloat cellHeight;

@property(nonatomic,strong)CommentFrame *cFrame;

@end
