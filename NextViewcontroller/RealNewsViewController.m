//
//  RealNewsViewController.m
//  SmallFeature
//
//  Created by Sun on 16/8/5.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "RealNewsViewController.h"
#import "RealNewsModel.h"
#import "RealNewsTableViewCell.h"
@interface RealNewsViewController ()

@end

@implementation RealNewsViewController{
    
    UITableView * mainTableView;
    
    UITableView * leftTableView;
    
    BOOL isAdd;
    
    NSInteger currentPage;
    
    UILabel * timeLabel;
    
    
    NSMutableArray * dayArray;
    NSString * dayStr;
    NSString * tempStr;
    NSMutableDictionary * modelDict;
    NSMutableArray * newData;
    NSMutableArray * modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实时资讯";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self initDataArray];
    
    [self requestData];
    
    [self createTableView];
    
    
}

-(void)initDataArray{
    
    
    isAdd = YES;
    currentPage = 0;
    
    dayArray = [[NSMutableArray alloc]init];
    
    modelDict = [[NSMutableDictionary alloc]init];
    
    newData = [[NSMutableArray alloc]init];
    
    modelArray = [[NSMutableArray alloc]init];
}

-(void)requestData{
    
    //实时资讯
    NSString *realNewUrl = [NSString stringWithFormat:HotNews_Https,currentPage];
    
    currentPage++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 10;
    
    
    [manager GET:realNewUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"实时资讯");
        NSInteger error = [responseObject[@"error"] integerValue];
        if (error == 0) {
            //热门直播的数据
            [self analysHotNewsData:responseObject];
            
        }else{
            UIAlertView * alt = [[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alt show];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"news %@",error);
    }];
    
}

//实时资讯
-(void)analysHotNewsData:(NSDictionary * )newsDict{
    
    if (isAdd == NO) {
        [dayArray removeAllObjects];
        [newData removeAllObjects];
        [modelArray removeAllObjects];
        
        dayStr = @"";
        tempStr = nil;
    }
    
    NSArray * nArray = newsDict[@"rows"];
    
    for (int n = 0; n < nArray.count; n++) {
        
        RealNewsModel * nModel = [[RealNewsModel alloc]init];
        //KVC 赋值
        [nModel setValuesForKeysWithDictionary:nArray[n]];
        
        dayStr = [nModel.time substringToIndex:10];
        //第一次
        if (tempStr==nil) {
            //临时日期作比较
            tempStr = dayStr;
            //dayArray 只存日期，2016-08-05 ...
            [dayArray addObject:dayStr];
            
        }else{
            
            if ([dayStr isEqualToString:tempStr]==NO) {
                tempStr = dayStr;
                [dayArray addObject:dayStr];
                
                NSArray * tempArray = [NSArray arrayWithArray:newData];
                [modelArray addObject:tempArray];
                
                //日期换了 移除
                [newData removeAllObjects];
                for (NSArray * t in modelArray) {
                    if (t.count==0) {
                        [modelArray removeObject:t];
                        break;
                    }
                }
            }
        }
        //当日的数据
        [newData addObject:nModel];
        //数据结束，当日数据加到数组中
        if (n == nArray.count - 1) {
            [modelArray addObject:newData];
        }
    }
    //数据分组
    
    [mainTableView reloadData];
    
    [leftTableView reloadData];
}

#pragma mark - createTableView
-(void)createTableView{
    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(40, 0, VIEW_WIDTH - 40,VIEW_HEIGHT-64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    //分割线
    mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mainTableView];
    
    [self addMJRefresh];
    
    leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 50, VIEW_HEIGHT-64) style:UITableViewStylePlain];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    leftTableView.scrollEnabled = NO;
    
    [self.view addSubview:leftTableView];
}



#pragma mark - 添加刷新
-(void)addMJRefresh{
    
    [mainTableView addHeaderWithTarget:self action:@selector(refreshAction)];
    
    mainTableView.headerPullToRefreshText = @"下拉刷新";
    
    mainTableView.headerReleaseToRefreshText = @"松开刷新";
    
    mainTableView.headerRefreshingText = @"刷新中...";
    
    
    [mainTableView addFooterWithTarget:self action:@selector(addMoreData)];
    
    mainTableView.footerPullToRefreshText = @"上拉加载";
    
    mainTableView.footerReleaseToRefreshText = @"松开加载";
    
    mainTableView.footerRefreshingText = @"加载中...";
}
-(void)refreshAction{
    
    isAdd = NO;
    
    currentPage=0;
    
    [self requestData];
    
    [mainTableView headerEndRefreshing];
}
-(void)addMoreData{
    
    isAdd = YES;
    
    [self requestData];
    
    [mainTableView footerEndRefreshing];
    
}

#pragma mark UITableViewDataSource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dayArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == mainTableView) {
        static NSString *identifier = @"123";
        RealNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[RealNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (modelArray.count > 0) {
            [cell reloadNewsWith:modelArray[indexPath.section][indexPath.row]];
        }
        NSLog(@"实时资讯%ld",indexPath.row);
        
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
    
}
//选中的行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//返回每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *dataDic = self.dataArray[indexPath.row];
    RealNewsModel * model = modelArray[indexPath.section][indexPath.row];
    const UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.text = model.content;
    label.font = [UIFont systemFontOfSize:17];
    CGSize maximumLabelSize = CGSizeMake(mainTableView.frame.size.width - 35 -40, 9999);//labelsize的最大值
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];//关键语句
    model.cellH = 40 + expectSize.height;

    CGFloat leftCellH = 40 + expectSize.height;
    if (tableView == leftTableView) {
        
        if (indexPath.row == [modelArray[indexPath.section] count] - 1) {
            
            leftCellH-=45;
        }
        return leftCellH;
        
    }else{
     
        return 40+expectSize.height;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == leftTableView) {
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 32)];
        
        UILabel * dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 25, 20)];
        dayLabel.textColor = TabBarTintColor;
        dayLabel.textAlignment = 2;
        dayLabel.text = [dayArray[section]substringWithRange:NSMakeRange(8, 2)];
        dayLabel.font = [UIFont systemFontOfSize:18 weight:2];
        
        UILabel * dayLabelD = [[UILabel alloc]initWithFrame:CGRectMake(30, 3, 15, 17)];
        dayLabelD.textColor = TabBarTintColor;
        dayLabelD.font = [UIFont systemFontOfSize:14 weight:1.5];
        dayLabelD.text = @"日";
        
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(5, 20, 40, 1)];
        lineV.backgroundColor = HOMEPAGETEXTCOLOR;
        
        UILabel * yearAndMonthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, 50, 10)];
        yearAndMonthLabel.textAlignment = 1;
        yearAndMonthLabel.text = [NSString stringWithFormat:@"%@.%@",[dayArray[section]substringWithRange:NSMakeRange(0, 4)],[dayArray[section]substringWithRange:NSMakeRange(5, 2)]];;
        yearAndMonthLabel.font = [UIFont systemFontOfSize:12];
        yearAndMonthLabel.textColor = TabBarTintColor;
        
        
//        dayLabel.backgroundColor = [UIColor greenColor];
//        dayLabelD.backgroundColor = [UIColor blueColor];
//        yearAndMonthLabel.backgroundColor = [UIColor brownColor];
        
        [headView addSubview:yearAndMonthLabel];
        [headView addSubview:dayLabel];
        [headView addSubview:dayLabelD];
        [headView addSubview:lineV];
        return headView;
    }else{
        
        return nil;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == leftTableView) {
        return 45;
    }else{
       return 0.01;
    } 
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == mainTableView) {
        mainTableView.contentOffset = scrollView.contentOffset;
        
        leftTableView.contentOffset = scrollView.contentOffset;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
}

@end
