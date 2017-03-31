//
//  MoreViewController.m
//  SmallFeature
//
//  Created by Sun on 2017/2/28.
//  Copyright © 2017年 ssb. All rights reserved.
//

#import "MoreViewController.h"

#import "HealthKitViewController.h"

#import "NetWorkViewController.h"

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MoreViewController{
    
    NSMutableArray *functionTitleArray;
    
    NSMutableArray *viewControllerArray;
    
    UITableView *functionTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //customNavigationBar
    [self customNavigationBar];
    
    //创建功能按钮
    [self createFunctionTableView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - cutomNavigationBar
- (void)customNavigationBar{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"更多";
    
}

#pragma mark - 创建功能TableView
- (void)createFunctionTableView{
    
    functionTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    
    functionTableView.delegate = self;
    
    functionTableView.dataSource = self;
    
    functionTableView.sectionFooterHeight = 20;
    
    
    [self.view addSubview:functionTableView];
    
    functionTitleArray = [[NSMutableArray alloc]initWithObjects:@"读取步数",@"网络",nil];
    
    viewControllerArray = [[NSMutableArray alloc]initWithObjects:@"HealthKitViewController",@"NetWorkViewController",nil];
    
}

#pragma mark - TableViewDelegate
//delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return functionTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *funCell = [tableView dequeueReusableCellWithIdentifier:@"functionCell"];
    
    if (funCell == nil) {
        
        funCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"functionCell"];
    }
    
    funCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    funCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    funCell.textLabel.text = functionTitleArray[indexPath.row];
    
    return funCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELL_H;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self functionCellSelectedIndex:indexPath.row];
}


//时间分发
- (void)functionCellSelectedIndex:(NSInteger )indexCell{
    
    UIViewController *sadVc = [NSClassFromString(viewControllerArray[indexCell]) new];
    
    [self.navigationController pushViewController:sadVc animated:YES];
    
}


@end
