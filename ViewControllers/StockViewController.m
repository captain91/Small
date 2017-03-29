//
//  StockViewController.m
//  SmallFeature
//
//  Created by Sun on 16/3/18.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "StockViewController.h"
#import "BuyStockViewController.h"

#import "StockHoldTableViewCell.h"
@interface StockViewController ()

@end

@implementation StockViewController{

    UITableView *tableViewHold;
    
    NSMutableArray *stockArray;
    
    NSMutableArray *currentPriceArray;
    
    NSMutableDictionary *currentPriceDict;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"持仓历史";
    
    [self customNavigationBar];
    
    [self initArray];
    
    [self getTheDataFormSandbox];
    
    [self requestCurrentPrice];
    
    [self createTableView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)initArray{

    stockArray = [[NSMutableArray alloc]init];
    
    currentPriceArray = [[NSMutableArray alloc]init];
    
    currentPriceDict = [[NSMutableDictionary alloc]init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)customNavigationBar{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(pushBuyStockVc)];
    
}
-(void)pushBuyStockVc{

    BuyStockViewController *buyVc = [BuyStockViewController new];
    
    buyVc.delegate = self;
    
    [self.navigationController pushViewController:buyVc animated:YES];
}

-(void)createTableView{

    tableViewHold = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStylePlain];
    
    tableViewHold.delegate = self;
    
    tableViewHold.dataSource = self;
    
    tableViewHold.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableViewHold];
    
    [self addRefresh];
}

-(void)addRefresh{
    
    [tableViewHold addHeaderWithTarget:self action:@selector(refreshAction)];
    tableViewHold.headerPullToRefreshText = @"下拉刷新";
    tableViewHold.headerReleaseToRefreshText = @"松开刷新";
    tableViewHold.headerRefreshingText = @"刷新中...";
    
}
-(void)refreshAction{
    
    [self refreshData];
    
    [tableViewHold headerEndRefreshing];
}


//代理方法刷新数据
-(void)refreshData{
    
    [self getTheDataFormSandbox];
    
    [self requestCurrentPrice];
}

#pragma mark - getData
//读取本地数据
-(void)getTheDataFormSandbox{
    
    NSString * path = [self filePath];
    
    //解归档
    stockArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
}

//请求现价
-(void)requestCurrentPrice{
    
    //循环请求当前价格
    for (StockModel *model in stockArray) {
        
        [self requestDataWithStockId:model.stockId];
    }
}

-(void)requestDataWithStockId:(NSString *)stockId{
    
    NSString *stockType = [stockId substringToIndex:2];
    
    NSString *stockUrl;
    
    if ([stockType isEqualToString:@"60"]==YES) {
        
        stockUrl = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=sh%@",stockId];
        
    }else if([stockType isEqualToString:@"00"]==YES || [stockType isEqualToString:@"30"]==YES){
        
        stockUrl = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=sz%@",stockId];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager GET:stockUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        //不是json数据
        NSString * stockDetailStr = [operation responseString];
        
        NSLog(@"GET:%@",stockDetailStr);
        
        //解析数据
        [self getTheStcokDetail:stockDetailStr];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"Error:%@",error);
    }];

}

//处理字符串取出数据
- (void)getTheStcokDetail:(NSString *)stockString{
    
    NSArray *firstA = [stockString componentsSeparatedByString:@"="];
    
    NSArray *detailA = [firstA[1] componentsSeparatedByString:@","];
    
    //股票名称
    NSString *stockName = [detailA[0] substringFromIndex:1];
    
    NSString *currentPrice = detailA[3];
    
    //添加到字典中
    [currentPriceDict setValue:currentPrice forKey:stockName];
    
    //请求完刷新数据
    if (currentPriceDict.allKeys.count == stockArray.count) {
        
        [tableViewHold reloadData];
    }
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return stockArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    StockHoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"holdCell"];
    
    if (cell == nil) {
        
        cell = [[StockHoldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"holdCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    StockModel *model = stockArray[indexPath.row];
    
    cell.sModel = model;
    
    if (currentPriceDict.allKeys.count == stockArray.count) {
        //根据键取值
        cell.currentPrice = [currentPriceDict valueForKey:model.stockName];
        
    }
    [cell reloadData];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 180;
}

//文件路径
-(NSString *)filePath{
    
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"stock.plist"];
}


//可以删除cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除内容；");
        //删除数组元素，然后在归档新数组，然后再重新
        
        [stockArray removeObjectAtIndex:indexPath.row];
        
        [tableViewHold deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        NSLog(@"%ld",indexPath.row);
        
        //再归档
        [NSKeyedArchiver archiveRootObject:stockArray toFile:[self filePath]];
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewRowAction *deleteRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [stockArray removeObjectAtIndex:indexPath.row];
        
        [tableViewHold deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSLog(@"%ld",indexPath.row);
        
        //再归档
        [NSKeyedArchiver archiveRootObject:stockArray toFile:[self filePath]];
    }];
    
    UITableViewRowAction *editRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"编辑");
    }];
    
    editRow.backgroundColor = [UIColor colorWithRed:0 green:124.0/255 blue:223.0/255 alpha:1];
    
    return @[deleteRow,editRow];
}

@end
