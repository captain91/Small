//
//  ScrollViewController.m
//  SmallFeature
//
//  Created by Sun on 16/7/11.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "ScrollViewController.h"

#import "ThreadViewController.h"

#import "ResearchViewController.h"

#import "OperationViewController.h"

#import "IntroductionViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ScrollViewController ()<MKMapViewDelegate>{

    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}

@end

@implementation ScrollViewController{

    NSArray * titleArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArray = [NSArray arrayWithObjects:@"直播",@"研报",@"操作",@"简介", nil];
    
    [self customNavigationBar];
    
//    [self createMapView];

}

-(void)customNavigationBar{
    
    self.navigationItem.title = @"定位";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Root" style:UIBarButtonItemStyleDone target:self action:@selector(popToRootVc)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithTitle:@"Root" style:UIBarButtonItemStyleDone target:self action:@selector(popToRootVc)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    self.navigationItem.prompt = @"Hello, I'm the prompt";
//    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor yellowColor] forKey:NSForegroundColorAttributeName];
//    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    
    //自定义leftBarButtonItem 返回手势还在
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    UIBarButtonItem * one = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtn)];
    
    UIBarButtonItem * two = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookBtn)];
    
    UIBarButtonItem * three = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editBtn)];
    
    [self setToolbarItems:[NSArray arrayWithObjects:one,two,three,nil]];
    
    
}
-(void)popToRootVc{
    
}
-(void)addBtn{
    //添加add
    NSLog(@"add");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)bookBtn{
    //book
    NSLog(@"book");
}
-(void)editBtn{
    //编辑
    NSLog(@"edit");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mapView
//地图
-(void)createMapView{
    CGRect rect = [UIScreen mainScreen].bounds;
    _mapView = [[MKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    
    _mapView.delegate = self;
    
    //请求定位
    _locationManager = [[CLLocationManager alloc]init];
    if (![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [_locationManager requestWhenInUseAuthorization];
    }

    _mapView.mapType = MKMapTypeStandard;
}
#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"%@",userLocation);
    
}
#pragma mark - 生命周期

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = NO;

}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}
@end
