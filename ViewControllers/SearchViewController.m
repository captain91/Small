//
//  SearchViewController.m
//  SmallFeature
//
//  Created by Sun on 16/1/26.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController{
    
    UITableView *searchTableView;
    
    NSMutableArray *visableArray;
    
    NSMutableArray *filterArray;
    
    NSMutableArray *dataSourceArray;

    UISearchBar *mySearchBar;
    
    UISearchController *searchVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationItem];
    
    [self initial];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -coutomNavigationItem
- (void)customNavigationItem{
    
    self.navigationItem.title = @"模糊搜索";
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)initial{
    
    dataSourceArray = [[NSMutableArray alloc]init];
    
    filterArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 26; i++) {
        
        for (int j = 0; j < 4; j++) {
            
            NSString *str = [NSString stringWithFormat:@"%c%d",'A' + i,j];
            
            [dataSourceArray addObject:str];
        }
    }
    
    visableArray = dataSourceArray;
    
    searchTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    searchTableView.delegate = self;
    
    searchTableView.dataSource = self;
    
    [self.view addSubview:searchTableView];
    
    
    
    searchVc = [[UISearchController alloc]initWithSearchResultsController:nil    ];
    
    searchVc.searchResultsUpdater = self;
    
    searchVc.dimsBackgroundDuringPresentation = NO;
    
    [searchVc.searchBar sizeToFit];
    
    searchVc.searchBar.placeholder = @"输入搜索关键词";
    
    [searchVc.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    
    searchTableView.tableHeaderView = searchVc.searchBar;
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!visableArray || visableArray.count == 0) {

        visableArray = dataSourceArray;
    }
    return visableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
        
    }
    
    cell.textLabel.text = visableArray[indexPath.row];
    
    return cell;
}
#pragma mark- 代理方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSLog(@"search");
    
    NSString *filterString = searchController.searchBar.text;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@",filterString];
    
    visableArray = [NSMutableArray arrayWithArray:[dataSourceArray filteredArrayUsingPredicate:predicate]];
    
    [searchTableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
