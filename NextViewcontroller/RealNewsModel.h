//
//  RealNewsModel.h
//  SmallFeature
//
//  Created by Sun on 16/8/5.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealNewsModel : NSObject
@property(nonatomic,copy)NSString * id;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * summary;
@property(nonatomic,copy)NSString * content;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,copy)NSString * authorId;
@property(nonatomic,copy)NSString * authorName;
@property(nonatomic,copy)NSString * authorIcon;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * likeNum;
@property(nonatomic,copy)NSString * commentNum;
@property(nonatomic,copy)NSString * isSubscribe;
@property(nonatomic,copy)NSString * isLike;

@property(nonatomic)CGFloat cellH;

@end
