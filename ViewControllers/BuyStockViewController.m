//
//  BuyStockViewController.m
//  SmallFeature
//
//  Created by Sun on 16/3/18.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "BuyStockViewController.h"

@interface BuyStockViewController ()

@end

@implementation BuyStockViewController{

    UIButton *submitBtn;
    
    NSString *todayP;
    
    UIView * activityBG;
    
    UIActivityIndicatorView * activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"购买股票";
    
    [self createTable];
    
    [self createUIActivity];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUIActivity{
    activityBG = [[UIView alloc]initWithFrame:CGRectMake(VIEW_WIDTH - 110, 15, 20, 20)];
    
//    activityBG.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:activityBG];
    
    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center = CGPointMake(10.0f, 10.0f);
    
    [activityBG addSubview:activityView];

}

-(void)createTable{
    NSArray *titleArray = [NSArray arrayWithObjects:@"股票代码:",@"股票名称:",@"当前价格:"
                           ,@"报价时间:",@"买入价格:",@"买入数量:",@"买入理由:",nil];
    for (int i = 0; i<titleArray.count; i++) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 40 * i + 10, 80, 30)];
        
        titleLabel.text = titleArray[i];
        
        
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(115, 40 * i + 10, VIEW_WIDTH - 145, 30)];
        
        textF.borderStyle = UITextBorderStyleRoundedRect;
        
        textF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        textF.tag = 100 + i;
        
        if (i == 5){
            
            textF.placeholder = @"请输入100或100的整数倍";
        }
        
        if (i == 0) {
            
            textF.frame = CGRectMake(115,40 * i + 10,VIEW_WIDTH - 200,30);
            
            UIButton *search = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH - 80, 10, 50, 30)];
            
            [search setTitle:@"查找" forState:UIControlStateNormal];
            
            [search setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [search addTarget:self action:@selector(searchStock:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:search];
        }
        if (i == 6) {
            titleLabel.frame = CGRectMake(30, 40 * i + 10 + 15, 80, 30);
            
            UITextView *contentT = [[UITextView alloc]initWithFrame:CGRectMake(115, 40 * i + 10, VIEW_WIDTH - 145, 60)];
            
            contentT.layer.borderWidth = 1;
            
            contentT.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            contentT.layer.masksToBounds = YES;
            
            contentT.layer.cornerRadius = 5;
            
            contentT.tag = 100 + i;
            
            [self.view addSubview:contentT];
            [self.view addSubview:titleLabel];
            continue;
        }
        
        [self.view addSubview:titleLabel];
        
        [self.view addSubview:textF];
    }
    
    submitBtn = [[UIButton alloc]initWithFrame:CGRectMake((VIEW_WIDTH - 80)/2, 320, 100, 30)];
    
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    submitBtn.layer.borderWidth = 0.5;
    submitBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 5;
    
    [submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitBtn];
    
}

-(void)searchStock:(UIButton *)btn{
    
    NSLog(@"检查股票输入是否正确");
    
    [activityView startAnimating];
    //检查股票
    [self checkStock];
    
}

-(void)activityStop{
    
    [activityView stopAnimating];
    [activityView setHidesWhenStopped:YES];
}

-(void)checkStock{
    
    NSString *stockId = [(UITextField *)[self.view viewWithTag:100] text];
    
    if (stockId.length !=6) {
        
        [self activityStop];
        
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的股票代码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alt show];
        
        return;
    }
    
    NSString *stockType = [stockId substringToIndex:2];
    
    NSString *stockUrl;
    if ([stockType isEqualToString:@"60"]==YES) {
        
        stockUrl = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=sh%@",stockId];
        
    }else if([stockType isEqualToString:@"00"]==YES || [stockType isEqualToString:@"30"]==YES){
        
        stockUrl = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=sz%@",stockId];
    }else{
        
        [self activityStop];
        
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的股票代码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alt show];
        return;
    }
    
    //请求数据
    [self requestDataWithStockId:stockUrl];
    
    NSLog(@"%@",stockUrl);
    
    //股票代码
    self.stockId = stockId;
    
}

-(void)requestDataWithStockId:(NSString *)stockUrl{
    
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
        
        [self activityStop];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"Error:%@",error);
        
        [self activityStop];
        
    }];
}

//处理字符串取出数据
- (void)getTheStcokDetail:(NSString *)stockString{
    
    NSArray *firstA = [stockString componentsSeparatedByString:@"="];
    
    NSArray *detailA = [firstA[1] componentsSeparatedByString:@","];
    
    //股票名称
    self.stockName = [detailA[0] substringFromIndex:1];
    
    if(detailA.count < 30){
        //股票代码有问题
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入的股票代码有误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alt show];
        return;
    }
    //股票购买时间
    self.stockBuyTime =[NSString stringWithFormat:@"%@ %@",detailA[30],detailA[31]];
    
    
    NSArray *contextA =[NSArray arrayWithObjects:[detailA[0] substringFromIndex:1],detailA[3],[NSString stringWithFormat:@"%@ %@",detailA[30],detailA[31]], nil];
    for (int i= 0; i < 3; i++) {
        
        UITextField *textF = (UITextField *)[self.view viewWithTag:101 + i];
        
        textF.text = contextA[i];
    }
    
    //今开价格
    todayP = detailA[2];
    
}

//提交买入
-(void)submitBtn:(UIButton *)subBtn{
    NSLog(@"提交检查，数量，价格");
    
    float buyP = [(UITextField *)[self.view viewWithTag:104] text].floatValue;
    
    float maxP = todayP.floatValue * 1.1;
    
    float minP = todayP.floatValue * 0.9;
    
    if (buyP < minP || buyP > maxP) {
        
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"价格输入不合理,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
        return;
    }
    
    NSInteger volum = [(UITextField *)[self.view viewWithTag:105] text].integerValue;
    
    if (volum % 100 != 0 || volum == 0) {
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"数量输入不合理,请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
        return;
    }
    
    //记录结果存入模型，存入数组
    
    //股票买入价格
    self.stockBuyP =[NSString stringWithFormat:@"%f",buyP];
    //买入数量
    self.stockVolume = [NSString stringWithFormat:@"%ld",volum];
    //理由
    self.stockWhy = [(UITextView *)[self.view viewWithTag:106] text];
    
    
    StockModel *sModel = [StockModel new];
    
    sModel.stockId = self.stockId;
    sModel.stockName = self.stockName;
    sModel.stockBuyTime = self.stockBuyTime;
    sModel.stockBuyP = self.stockBuyP;
    sModel.stockVolume = self.stockVolume;
    sModel.stockWhy = self.stockWhy;
    if (self.stockWhy.length == 0 ) {
        self.stockWhy = @"暂无";
    }
    
    //老数组
    NSMutableArray *oldArray =[[NSMutableArray alloc]init];
    NSMutableArray *newArray = [[NSMutableArray alloc]init];
    
    NSLog(@"%@",NSHomeDirectory());
    
    //读取文件取得旧数据
    NSString *path = [self filePath];
    
    oldArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (oldArray.count > 0) {
        [newArray addObjectsFromArray:oldArray];
    }
    //添加新的数据
    [newArray addObject:sModel];
    
    //再归档
    [NSKeyedArchiver archiveRootObject:newArray toFile:path];
    
    UIAlertView *alt = [[UIAlertView alloc]initWithTitle:nil message:@"操作成功,继续操作OR返回持仓？" delegate:self cancelButtonTitle:@"继续操作" otherButtonTitles:@"返回持仓", nil];
    
    alt.tag = 1000;
    [alt show];
    

}
//UIalertviewdelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            NSLog(@"继续操作，可以把之前的内容清空");
            
            for (int i = 0; i < 6; i++) {
                
                UITextField *textFiled = (UITextField *)[self.view viewWithTag:100+i];
                
                textFiled.text = @"";
            }
            
            UITextView *textView = (UITextView *)[self.view viewWithTag:106];
            
            textView.text = @"";
        }
        if (buttonIndex == 1) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate refreshData];
        }

    }
}
#pragma mark -生命周期
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self resignFirst];
}

-(void)resignFirst{

    for (int i = 0; i < 6; i++) {
        
        UITextField *textFiled = (UITextField *)[self.view viewWithTag:100+i];
        
        [textFiled resignFirstResponder];
    }
    
    UITextView *textView = (UITextView *)[self.view viewWithTag:106];
    
    [textView resignFirstResponder];
}

//文件路径
-(NSString *)filePath{

    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"stock.plist"];
}
@end
