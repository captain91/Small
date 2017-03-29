//
//  CommentModel.m
//  SmallFeature
//
//  Created by Sun on 2016/10/26.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
