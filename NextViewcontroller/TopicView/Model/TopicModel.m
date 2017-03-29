//
//  TopicModel.m
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "TopicModel.h"
#import "MJExtension.h"
#import "Photo.h"
@implementation TopicModel

-(NSDictionary *)objectClassInArray{
    return @{@"images":[Photo class]};
}
@end
