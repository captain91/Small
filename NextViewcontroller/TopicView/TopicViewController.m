//
//  TopicViewController.m
//  SmallFeature
//
//  Created by Sun on 16/9/22.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicModel.h"

#import "StatusFrame.h"

#import "TopicCell.h"

#import "MJExtension.h"

@interface TopicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray *statusFrames;

@property(nonatomic, strong) UITableView *topicTableView;


@end

@implementation TopicViewController{
    
    NSArray *statusArray;
    
    NSInteger currentPage;
}

- (NSMutableArray *)statusFrames{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationBar];
    
    [self addDataSocurce];
    
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - customNavigationBar
-(void)customNavigationBar {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"话题";
}
#pragma mark - dataSource
- (void)addDataSocurce {
    
    [self requestDataWithPage:0];
}

#pragma mark -requestData
- (void)requestDataWithPage:(NSInteger )page {
    
    NSString *topicUrl = [NSString stringWithFormat:HTTP_TOPIC,page];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    [manager GET:topicUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"topic success");
        //解析数据
        [self analyDataWithDict:responseObject];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"topic error:%@",error);
    }];
}

-(void)analyDataWithDict:(NSDictionary *)dict {
    
    if (currentPage == 0) {
        
        [self.statusFrames removeAllObjects];
    }
    
    statusArray = dict[@"rows"];
    
    statusArray = [TopicModel objectArrayWithKeyValuesArray:statusArray];
    
    for (TopicModel *topicM in statusArray) {
        StatusFrame *sFrame = [[StatusFrame alloc]init];
        sFrame.topicM = topicM;
        [self.statusFrames addObject:sFrame];
    }
    
    [self.topicTableView reloadData];
}

#pragma mark - tableView
- (void)createTableView {
    
    self.topicTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.topicTableView.delegate = self;
    self.topicTableView.dataSource = self;
    self.topicTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view  addSubview:self.topicTableView];
    
    [self addMJRefresh];
}
#pragma mark - 添加刷新
-(void)addMJRefresh{
    
    [self.topicTableView addHeaderWithTarget:self action:@selector(refreshAction)];
    
    self.topicTableView.headerPullToRefreshText = @"下拉刷新";
    
    self.topicTableView.headerReleaseToRefreshText = @"松开刷新";
    
    self.topicTableView.headerRefreshingText = @"刷新中...";
    
    
    [self.topicTableView addFooterWithTarget:self action:@selector(addMoreData)];
    
    self.topicTableView.footerPullToRefreshText = @"上拉加载";
    
    self.topicTableView.footerReleaseToRefreshText = @"松开加载";
    
    self.topicTableView.footerRefreshingText = @"加载中...";
}
-(void)refreshAction{
    
    currentPage = 0;
    
    [self requestDataWithPage:currentPage];
    
    [self.topicTableView headerEndRefreshing];
}
-(void)addMoreData{
    
    currentPage++;
    
    [self requestDataWithPage:currentPage];
    
    [self.topicTableView footerEndRefreshing];
    
}

#pragma mark -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.statusFrames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicCell *cell = [TopicCell cellWithTableView:tableView];
    cell.statusFrame = self.statusFrames[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.statusFrames[indexPath.row] cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld个cell",indexPath.row);
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSLog(@"11112122333");
}

@end
