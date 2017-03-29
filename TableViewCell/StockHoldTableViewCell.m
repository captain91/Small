//
//  StockHoldTableViewCell.m
//  SmallFeature
//
//  Created by Sun on 16/3/19.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "StockHoldTableViewCell.h"

#define LABEL_N_W 40
#define FONT 14
#define L_H 20
#define CONTENT_W   ((VIEW_WIDTH -10)/3-45)
@implementation StockHoldTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)createUI{

    NSArray *labelArray1 = [NSArray arrayWithObjects:@"证券:",@"入价:",@"持股:",@"代码:",@"现价:",@"市值:",nil];
    
    for (int i = 0 ; i < labelArray1.count; i++) {
       
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5 + i%3 *((VIEW_WIDTH -10)/3), i/3 * 25 + 5, LABEL_N_W, L_H)];
       
        label.textAlignment = 1;
       
        label.text = labelArray1[i];
        
        label.font = [UIFont systemFontOfSize:FONT];
        
//        label.backgroundColor = [UIColor redColor];
        
        [self addSubview:label];
    }
    
    self.stockName = [[UILabel alloc]init];
    self.stockId = [[UILabel alloc]init];
    
    self.stockBuyP = [[UILabel alloc]init];
    self.stockCurrentP = [[UILabel alloc]init];
    
    self.stockVolem = [[UILabel alloc]init];
    self.stockMarket = [[UILabel alloc]init];
    
    
    
    
   NSArray *concentArray = [NSArray arrayWithObjects:self.stockName,self.stockBuyP,self.stockVolem,self.stockId,self.stockCurrentP,self.stockMarket, nil];
    
    for (int i = 0 ; i < concentArray.count; i++) {
        
        UILabel *label2 = concentArray[i];
        
        label2.frame = CGRectMake(6 + LABEL_N_W + i%3 *((VIEW_WIDTH -10)/3) , i/3 * 25 + 5, CONTENT_W, L_H);
        
        label2.textAlignment = 1;
        
        label2.font = [UIFont systemFontOfSize:FONT];
        
//        label2.backgroundColor = [UIColor redColor];
       
        [self addSubview:label2];
    }
    
    
    self.stockProfit = [[UILabel alloc]init];
    self.stockPoint = [[UILabel alloc]init];
    
    self.stockCheckFull = [[UILabel alloc]init];
    self.stockCheckStop = [[UILabel alloc]init];
    
    self.stockBuyTime = [[UILabel alloc]init];
    self.stockBuyTime1 = [[UILabel alloc]init];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"盈亏/比例",@"止损/止盈",@"时间/日期", nil];
    
    for (int t = 0; t<titleArray.count; t++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10+ ((VIEW_WIDTH - 20)/3) * t, 60, (VIEW_WIDTH - 20)/3, L_H)];
        
        label.textAlignment =1;
        
        label.textColor = [UIColor brownColor];
        
        //        label.backgroundColor = [UIColor redColor];
        
        label.font = [UIFont systemFontOfSize:FONT];
        
        label.text = titleArray[t];
        
        [self addSubview:label];
        
    }
    
    NSArray *array2 = [NSArray arrayWithObjects:self.stockProfit,self.stockCheckStop,self.stockBuyTime,self.stockPoint,self.stockCheckFull,self.stockBuyTime1,nil];
    
    for (int i = 0 ; i < array2.count; i++) {
        
        UILabel *label2 = array2[i];
        
        label2.frame = CGRectMake(10+ i%3 * ((VIEW_WIDTH - 20)/3), i/3 * 25 + 60 + L_H , (VIEW_WIDTH - 20)/3, L_H);
        
        label2.textAlignment = 1;
        
        label2.font = [UIFont systemFontOfSize:FONT];
        
//        label2.backgroundColor = [UIColor redColor];
        
        [self addSubview:label2];
    }

    
    UILabel *why = [[UILabel alloc]initWithFrame:CGRectMake(10, 137, 70, L_H)];
    
    why.text = @"买入理由:";
    
    why.textAlignment = 1;
    
    why.font = [UIFont systemFontOfSize:FONT];
    
    [self addSubview:why];
    
    
    self.stockWhy = [[UIWebView alloc]initWithFrame:CGRectMake(12 + 70,130,VIEW_WIDTH - 70-22,40)];
    
    self.stockWhy.layer.borderWidth = 1;
    
    self.stockWhy.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.stockWhy.layer.masksToBounds = YES;
    
    self.stockWhy.layer.cornerRadius = 5;
    
    self.stockWhy.delegate = self;
    
    self.stockWhy.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.stockWhy];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, 179, VIEW_WIDTH-10, 1)];
    
    line.backgroundColor = [UIColor brownColor];
    
    [self addSubview:line];
}


-(void)reloadData{
    //名称代码
    self.stockId.text = self.sModel.stockId;
    self.stockName.text = self.sModel.stockName;
    
    //入价现价
    float currentPrice = self.currentPrice.floatValue;
    float buyPrice = self.sModel.stockBuyP.floatValue;
    float volem = self.sModel.stockVolume.floatValue;
    
    self.stockBuyP.text = [NSString stringWithFormat:@"%.3f",self.sModel.stockBuyP.floatValue];
    self.stockBuyP.textColor = [UIColor redColor];
    
    self.stockCurrentP.text = self.currentPrice;
    if (self.sModel.stockBuyP.floatValue >= currentPrice) {
        self.stockCurrentP.textColor = [UIColor greenColor];
    }else{
        self.stockCurrentP.textColor = [UIColor redColor];
    }
    
    //持仓和市值
    self.stockVolem.text = self.sModel.stockVolume;
    self.stockMarket.text =[NSString stringWithFormat:@"%.2f",self.sModel.stockVolume.floatValue * currentPrice];
    
    
    if (currentPrice !=0) {
        //盈亏比例
        float profit = (currentPrice - buyPrice) * volem;
        float point = profit/(currentPrice * volem) * 100;
        
        if (profit > 0) {
            self.stockPoint.textColor = [UIColor redColor];
            self.stockProfit.textColor = [UIColor redColor];
        }else{
            self.stockPoint.textColor = [UIColor greenColor];
            self.stockProfit.textColor = [UIColor greenColor];
        }
        
        self.stockProfit.text = [NSString stringWithFormat:@"%.2f",profit];
        self.stockPoint.text = [NSString stringWithFormat:@"%.2f%@",point,@"%"];
        
    }else{
        self.stockProfit.text = [NSString stringWithFormat:@"..."];
        self.stockPoint.text = [NSString stringWithFormat:@"..."];
    }
    
    //止损 止盈
    self.stockCheckStop.text = [NSString stringWithFormat:@"%.3f",buyPrice * 0.9];
    //公式
    self.stockCheckFull.text = [NSString stringWithFormat:@"%.3f",buyPrice * 1.1];
    
    NSArray *date = [self.sModel.stockBuyTime componentsSeparatedByString:@" "];
    if (date.count > 0) {
        //购买时间
        self.stockBuyTime.text = date[0];
        self.stockBuyTime1.text = date[1];
    }
    
    [self.stockWhy loadHTMLString:self.sModel.stockWhy baseURL:nil];
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];//修改百分比即可
}

@end
