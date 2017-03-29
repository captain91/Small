//
//  BuyStockViewController.h
//  SmallFeature
//
//  Created by Sun on 16/3/18.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuyStockViewControllerDelegate <NSObject>

-(void)refreshData;

@end
@interface BuyStockViewController : BaseViewController<UIAlertViewDelegate>
@property(assign)id <BuyStockViewControllerDelegate> delegate;

@property (nonatomic ,copy)NSString * stockId;

@property (nonatomic ,copy)NSString * stockName;

@property (nonatomic ,copy)NSString * stockBuyP;

@property (nonatomic ,copy)NSString * stockVolume;

@property (nonatomic ,copy)NSString * stockBuyTime;

@property (nonatomic ,copy)NSString * stockWhy;
@end
