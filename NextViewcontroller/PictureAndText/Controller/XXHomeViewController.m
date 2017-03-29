//
//  XXHomeViewController.m
//  XXWB
//
//  Created by 刘超 on 14/12/15.
//  Copyright (c) 2014年 Leo. All rights reserved.
//

#import "XXHomeViewController.h"
#import "UIBarButtonItem+Extend.h"
#import "XXTitleButton.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "XXAccountTool.h"
#import "XXAccount.h"
#import "XXStatus.h"
#import "NSString+LCExtend.h"
#import "UIImageView+WebCache.h"
#import "XXStatusCell.h"
#import "XXStatusFrame.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

//详情
#import "AddPicAndTextViewController.h"

// 首页微博接口
#define XXHomeStatus @"https://api.weibo.com/2/statuses/home_timeline.json"


@interface XXHomeViewController ()

/**
 *  标题按钮状态
 */
@property (nonatomic, assign, getter = isTitleOpen) BOOL titleOpen;
@property (nonatomic, strong) NSMutableArray *statusFrames;

@end

@implementation XXHomeViewController{
    NSArray *statusArray;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (NSMutableArray *)statusFrames
{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置刷新
    [self setupRefresh];
    
    // 设置NavigationBar
    [self setupNavigationBar];
    
    // 初始化数据
    [self initDataArray];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = XXColor(226, 226, 226);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XXStatusPadding * 0.5, 0);
}

- (void)initDataArray{

    
}

/**
 *  设置刷新
 */
- (void)setupRefresh
{
    // 下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView headerBeginRefreshing];
    
    // 上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

/**
 *  下拉刷新
 */
- (void)headerRereshing
{
    [self.tableView headerEndRefreshing];
    statusArray = @[@{@"text":@"近日[心]，adidas Originals为经典鞋款Stan Smith打造Primeknit版本，并带来全新的“OG”系列。简约的鞋身采用白色透气Primeknit针织材质制作，再将Stan Smith代表性的绿、红、深蓝三个元年色调融入到鞋舌和后跟点缀，最后搭载上米白色大底来保留其复古风味。据悉该鞋款将在今月登陆全球各大adidas Originals指定店舖。",
                      @"pic_urls":@[@{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/21f6056a53f03d1df8774ca885cef091.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/4803e2da5b233e287c41bd7ce29a9e24.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/11b9b5bedb69345b2e31f2c476753823.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/bf7bda28bf03b08546644d9485751cef.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/e93383588cbbee3de37e4bb1a5a8a40e.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/a5939579ed41cf75d836598a1c98a32c.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/fec25e98c6a75b6f56c7d43f3352d445.png"},
                                    ]},
                    @{@"text":@"黄河风景游览区一日游",
                      @"pic_urls":@[@{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/5753f84774eef328f533a85248a8a1c9.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/1c70b846ffb4306d1c6a85657e605ae7.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/c2d64fc11d086538ca7dcb39f5fb160f.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/81f3634d26b89fe95eedb7b85a2f9008.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/f18cef9de8234bb2ac2097d3d79731a3.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/b497fc52fb729065a87ed3595c3fef3b.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/fe976fe3be1e310bf4b65bd31d5f4e8d.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/135a52ca2092c7f7098c713857d8a362.png"},
                                    @{@"thumbnail_pic":@"http://topmaster.server.zznorth.com/data/upload/image/201609/e778570c73a17e068f4e153848790c2a.png"},
                                    ]}];
    
    statusArray = [XXStatus objectArrayWithKeyValuesArray:statusArray];
    
    
    NSMutableArray *statusFrameArray = [NSMutableArray array];
    for (XXStatus *status in statusArray) {
        XXStatusFrame *statusFrame = [[XXStatusFrame alloc] init];
        statusFrame.status = status;
        [statusFrameArray addObject:statusFrame];
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:statusFrameArray];
    [tempArray addObjectsFromArray:self.statusFrames];
    self.statusFrames = tempArray;
    
    [self.tableView reloadData];
    if (statusFrameArray.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}

/**
 *  上拉加载
 */
- (void)footerRereshing
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Net
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *pars = [NSMutableDictionary dictionary];
    pars[@"access_token"] = [XXAccountTool account].access_token; // 用户token
    pars[@"count"] = @20; // 每页微博个数
    
    [manager GET:XXHomeStatus
      parameters:pars
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             [self.tableView footerEndRefreshing];
             
             NSArray *statusArray1 = [XXStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
             
             NSMutableArray *statusFrameArray = [NSMutableArray array];
             for (XXStatus *status in statusArray1) {
                 XXStatusFrame *statusFrame = [[XXStatusFrame alloc] init];
                 statusFrame.status = status;
                 [statusFrameArray addObject:statusFrame];
             }
             
             [self.statusFrames addObjectsFromArray:statusFrameArray];
             
             [self.tableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             [self.tableView footerEndRefreshing];
             
//             XXLog(@"error: %@", error.localizedDescription);
         }];
}


// 设置NavigationBar
- (void)setupNavigationBar
{
    self.navigationItem.title = @"微博";
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXStatusCell *cell = [XXStatusCell cellWithTableView:tableView];
    
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.statusFrames[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"cell被点击%ld，进入详情",indexPath.row);
    
    [self.navigationController pushViewController:[AddPicAndTextViewController new] animated:YES];
}

@end
