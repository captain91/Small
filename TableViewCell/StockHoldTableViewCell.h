//
//  StockHoldTableViewCell.h
//  SmallFeature
//
//  Created by Sun on 16/3/19.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockHoldTableViewCell : UITableViewCell <UIWebViewDelegate>
@property(nonatomic,strong)UILabel * stockName;
@property(nonatomic,strong)UILabel * stockId;

@property(nonatomic,strong)UILabel * stockBuyP;
@property(nonatomic,strong)UILabel * stockCurrentP;

@property(nonatomic,strong)UILabel * stockProfit;
@property(nonatomic,strong)UILabel * stockPoint;

@property(nonatomic,strong)UILabel * stockVolem;
@property(nonatomic,strong)UILabel * stockMarket;

@property(nonatomic,strong)UILabel * stockCheckFull;
@property(nonatomic,strong)UILabel * stockCheckStop;

@property(nonatomic,strong)UILabel * stockHigh;
@property(nonatomic,strong)UILabel * stockLow;

@property(nonatomic,strong)UILabel * stockBuyTime;
//@property(nonatomic,copy)NSString * stockId;
@property(nonatomic,strong)UILabel * stockBuyTime1;

@property(nonatomic,strong)UIWebView * stockWhy;

@property(nonatomic,strong)StockModel * sModel;
@property(nonatomic,copy)NSString *currentPrice;

-(void)reloadData;
@end
