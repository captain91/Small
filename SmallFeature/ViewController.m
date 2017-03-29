//
//  ViewController.m
//  SmallFeature
//
//  Created by Sun on 16/1/21.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "ViewController.h"

#import "SAdViewController.h"

#import "TaxViewController.h"

#import "CountdownViewController.h"

#import "TouchIDViewController.h"

#import "SearchViewController.h"

#import "ImagesViewController.h"

#import "SubLBXScanViewController.h"
#import "LBXScanView.h"

#import "GenerateQrCodeViewController.h"

#import "ApplePayViewController.h"

#import "BluetoothViewController.h"

#import "StockViewController.h"

#import "HouseLoanViewController.h"

#import "ScrollViewController.h"

#import "RealNewsViewController.h"

#import "ShareViewController.h"

#import "MapViewController.h"

#import "XXHomeViewController.h"

#import "TopicViewController.h"

#import "CommentViewController.h"

#import "LiveViewController.h"

#define BUTTONTO_X 100

#define BUTTONTO_Y 64 + 20


#define ImageHight 200.0f

#define NavigationBarHight 64.0f


@interface ViewController ()

@end

@implementation ViewController{
    
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
    
    self.navigationItem.title = @"首页";
    
}

#pragma mark - 创建功能TableView
- (void)createFunctionTableView{
    
    functionTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    
    functionTableView.delegate = self;
    
    functionTableView.dataSource = self;
    
    functionTableView.sectionFooterHeight = 20;
    
    
//    functionTableView.contentInset = UIEdgeInsetsMake(ImageHight, 0, 0, 0);
    
    _zoomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"car"]];
    _zoomImageView.frame = CGRectMake(0, -ImageHight, self.view.frame.size.width, ImageHight);
    
    //contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
    _zoomImageView.contentMode = UIViewContentModeScaleAspectFill;//重点（不设置那将只会被纵向拉伸）
    
//    [functionTableView addSubview:_zoomImageView];
    
    
    [self.view addSubview:functionTableView];
    
    functionTitleArray = [[NSMutableArray alloc]initWithObjects:@"打电话",@"轮播广告",@"个人所得税计算",@"验证码And摇一摇",
                                                                @"Touch ID",@"模糊搜索",@"图片档案",@"二维码识别",
                                                                @"二维码生成",@"Apple Pay And LED",@"Bluetooth",@"持仓历史",
                                                                @"房贷计算器",@"滚动视图",@"实时资讯",@"分享",@"地图定位",@"微博首页",@"话题",@"话题详情",@"线程问题",nil];
    
    viewControllerArray = [[NSMutableArray alloc]initWithObjects:@"CallSomeBody",@"SAdViewController",@"TaxViewController",@"CountdownViewController",
                                                                @"TouchIDViewController",@"SearchViewController",@"ImagesViewController",
                                                                @"SubLBXScanViewController",@"GenerateQrCodeViewController",@"ApplePayViewController",
                                                                @"BluetoothViewController",@"StockViewController",@"HouseLoanViewController",
                                                                @"ScrollViewController",@"RealNewsViewController",@"ShareViewController",@"MapViewController",
                                                                @"XXHomeViewController",@"TopicViewController",@"CommentViewController",@"LiveViewController",nil];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = scrollView.contentOffset.y;
    
    if (y < -ImageHight) {
        CGRect frame = _zoomImageView.frame;
        frame.origin.y = y;
        frame.size.height = -y;
        _zoomImageView.frame = frame;
    }
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
    
    //打电话
    if (indexCell == 0) {
        
        [self callSomeBody];
        
        return;
    }
    //扫描二维码
    if (indexCell == 7) {
        //二维码
        [self pushQrCodeVc];
        
        return;
    }
    
    UIViewController *sadVc = [NSClassFromString(viewControllerArray[indexCell]) new];
    
    [self.navigationController pushViewController:sadVc animated:YES];
    
}

#pragma mark -对应事件实现
//打电话
- (void)callSomeBody{
    //刘傻叉电话
    NSMutableString *numberStr = [NSMutableString stringWithFormat:@"Tel:%@",@"13115713421"];
    
    UIWebView *callWeb = [[UIWebView alloc]init];
    
    [callWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:numberStr]]];
    
    [self.view addSubview:callWeb];
}

//二维码扫描
- (void)pushQrCodeVc{
    
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型，设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    
    SubLBXScanViewController *qrCodeVc = [SubLBXScanViewController new];
    
    qrCodeVc.style = style;
    
    [self.navigationController pushViewController:qrCodeVc animated:YES];
    
}

-(void)setTabBarBackImage{
    UIImage *image = nil;
    
    if (iOS7) {
        
        image = [UIImage imageNamed:@"NavBar64"];
        
    }else {
        
        image = [UIImage imageNamed:@"NavBar"];
        
    }
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    

}
@end
