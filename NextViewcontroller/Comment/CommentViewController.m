//
//  CommentViewController.m
//  SmallFeature
//
//  Created by Sun on 2016/10/26.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "CommentViewController.h"

#import "CommentModel.h"

@interface CommentViewController ()

@end

@implementation CommentViewController{
    NSMutableArray *_commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationBar];
    
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigation
- (void)customNavigationBar {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"话题详情";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"请求" style:UIBarButtonItemStyleDone target:self action:@selector(requestData)];
    
    _commentArray = [[NSMutableArray alloc]init];
}

#pragma mark-请求数据
-(void)requestData {
    
    [_commentArray removeAllObjects];
    
    NSString *topUrl = [NSString stringWithFormat:@"http://topmaster.server.zznorth.com/api/comment?a=query&contentId=25&page=0&pageSize=10"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10;
    [manager GET:topUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"topic success");
        //解析数据
        [self analyDataWithDict:responseObject];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"topic error:%@",error);
    }];
    
}

//解析数据
- (void)analyDataWithDict:(NSDictionary *)dataDict {
    
    NSArray *rows = dataDict[@"rows"];
    //整理数据
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (int index = 0; index < rows.count; index++) {
        CommentModel *model = [CommentModel new];
        [model setValuesForKeysWithDictionary:rows[index]];
        [tempArray addObject:model];
    }
    
    for (int f = 0; f < tempArray.count; f++) {
        NSMutableArray *aGroup = [[NSMutableArray alloc]init];
        
        CommentModel *model = [CommentModel new];
        model = tempArray[f];
        //首先判断是不是父评论，是的话在找他的子评论
        if ([model.parentId isEqualToString:@"0"]) {
            [aGroup addObject:model];
            for (int s = f; s < tempArray.count; s++) {
                CommentModel *model1 = [CommentModel new];
                model1 = tempArray[s];
                if ([model1.parentId isEqualToString:model.ID]) {
                    [aGroup addObject:model1];
                }
            }
            [_commentArray addObject:aGroup];
        }
    }
}


@end
