//
//  StockModel.m
//  SmallFeature
//
//  Created by Sun on 16/3/18.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "StockModel.h"

@implementation StockModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.stockId forKey:@"Id"];
    [aCoder encodeObject:self.stockName forKey:@"Name"];
    [aCoder encodeObject:self.stockBuyP forKey:@"BuyP"];
    [aCoder encodeObject:self.stockBuyTime forKey:@"BuyTime"];
    [aCoder encodeObject:self.stockVolume forKey:@"Volume"];
    [aCoder encodeObject:self.stockWhy forKey:@"Why"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.stockId = [aDecoder decodeObjectForKey:@"Id"];
        self.stockName = [aDecoder decodeObjectForKey:@"Name"];
        self.stockBuyP = [aDecoder decodeObjectForKey:@"BuyP"];
        self.stockBuyTime = [aDecoder decodeObjectForKey:@"BuyTime"];
        self.stockVolume = [aDecoder decodeObjectForKey:@"Volume"];
        self.stockWhy = [aDecoder decodeObjectForKey:@"Why"];
    }
    return self;
}
@end
