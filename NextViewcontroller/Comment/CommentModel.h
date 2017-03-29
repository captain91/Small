//
//  CommentModel.h
//  SmallFeature
//
//  Created by Sun on 2016/10/26.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *contentId;

@property(nonatomic,copy)NSString *userId;

@property(nonatomic,copy)NSArray *images;

@property(nonatomic,copy)NSString *userName;

@property(nonatomic,copy)NSString *userIcon;

@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString *time;

@property(nonatomic,copy)NSString *likeNum;

@property(nonatomic,copy)NSString *parentId;

@property(nonatomic,copy)NSString *isLike;

@end
