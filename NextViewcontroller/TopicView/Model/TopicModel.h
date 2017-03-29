//
//  TopicModel.h
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject

@property(nonatomic,copy)NSString *id;

@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *summary;

@property(nonatomic,copy)NSString *time;

@property(nonatomic,copy)NSString *authorId;

@property(nonatomic,copy)NSString *authorName;

@property(nonatomic,copy)NSString *authorIcon;

@property(nonatomic,copy)NSString *price;

@property(nonatomic,copy)NSString *isTeacher;

@property(nonatomic,copy)NSString *likeNum;

@property(nonatomic,copy)NSString *commentNum;

@property(nonatomic,copy)NSArray *images;
@end
