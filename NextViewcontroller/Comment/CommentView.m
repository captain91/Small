//
//  CommentView.m
//  SmallFeature
//
//  Created by Sun on 2016/10/26.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "CommentView.h"
#import "CommentModel.h"

#import "CommentItem.h"

@interface CommentView ()

@end

@implementation CommentView {
    NSMutableArray *_commentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _commentArray = [[NSMutableArray alloc]init];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-请求数据
-(void)requestData {
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentItem *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    if (cell ==nil) {
        cell = [[CommentItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
    }
    
//    cell.cFrame = 
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
