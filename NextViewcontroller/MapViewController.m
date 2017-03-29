//
//  MapViewController.m
//  91HelloWorld
//
//  Created by 袁红霞 on 15/9/8.
//  Copyright (c) 2015年 hongxia Yuan. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
{
    MKMapView * mapView;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    NSMutableDictionary *locationDetailInfo;
    
    UILabel *showLocationLabel;
    UIButton *changeMapTypeBtn;
    BOOL typeChange;
    
    UIButton *backToMeBtn;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"位置";
    

    [self initGUI];
    [self creaeteLabelShowWhereYouAre];
    // Do any additional setup after loading the view.
}

#pragma mark 添加地图控件
-(void)initGUI{
    locationDetailInfo = [[NSMutableDictionary alloc]init];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    mapView = [[MKMapView alloc]initWithFrame:rect];
    
    [self.view addSubview:mapView];
    mapView.delegate = self;
    
    geocoder = [[CLGeocoder alloc]init];
    
    locationManager = [[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        CLLocationDistance distance=10;
        locationManager.distanceFilter=distance;
        [locationManager startUpdatingLocation];
    }
    
    geocoder = [[CLGeocoder alloc]init];
    mapView.userTrackingMode = MKUserTrackingModeFollow;
    mapView.mapType = MKMapTypeStandard;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
     NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    
}
#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
//        NSLog(@"详细信息:%@",placemark.addressDictionary);
        locationDetailInfo =(id)placemark.addressDictionary;
        
        [self getTheLocationDetailInformation];
    }];
}
//解析详细信息
-(void)getTheLocationDetailInformation{
    NSLog(@"城市：%@",locationDetailInfo[@"City"]);
    NSLog(@"具体位置：%@",locationDetailInfo[@"Name"]);
    showLocationLabel.text  = locationDetailInfo[@"Name"];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
}

//创建label显示位置
-(void)creaeteLabelShowWhereYouAre{
    showLocationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,VIEW_HEIGHT - 45,VIEW_WIDTH,30)];
    showLocationLabel.textAlignment = NSTextAlignmentCenter;
    showLocationLabel.font= [UIFont systemFontOfSize:14];
    showLocationLabel.text = @"";
    [self.view addSubview:showLocationLabel];
    
    changeMapTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, VIEW_HEIGHT - 80 , 60, 30)];
    [changeMapTypeBtn setTitle:@"卫星地图" forState:UIControlStateNormal];
    changeMapTypeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [changeMapTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeMapTypeBtn addTarget:self action:@selector(changeTheMapType:) forControlEvents:UIControlEventTouchUpInside];
    changeMapTypeBtn.backgroundColor = [UIColor colorWithRed:255.0/255 green:0/255 blue:0/255 alpha:0.5];
    [self.view addSubview:changeMapTypeBtn];
    
    backToMeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, VIEW_HEIGHT - 115, 60, 30)];
    [backToMeBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backToMeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backToMeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backToMeBtn addTarget:self action:@selector(backToMe:) forControlEvents:UIControlEventTouchUpInside];
    backToMeBtn.backgroundColor = [UIColor colorWithRed:255.0/255 green:0/255 blue:0/255 alpha:0.5];
    [self.view addSubview:backToMeBtn];
    
//    showLocationLabel.backgroundColor = [UIColor redColor];
    
}
-(void)changeTheMapType:(UIButton *)btn{
    
    if (!typeChange) {
        typeChange = YES;
        
        mapView.mapType = MKMapTypeSatellite;
        [btn setTitle:@"标准地图" forState:UIControlStateNormal];
        
    }else{
        typeChange = NO;
        mapView.mapType = MKMapTypeStandard;
        [btn setTitle:@"卫星地图" forState:UIControlStateNormal];
    }
}

-(void)backToMe:(UIButton *)btn{
    
    NSLog(@"back to me");
    mapView.userTrackingMode = MKUserTrackingModeFollow;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
