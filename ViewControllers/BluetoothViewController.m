//
//  BluetoothViewController.m
//  SmallFeature
//
//  Created by Sun on 16/3/11.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import "BluetoothViewController.h"

#import <AudioToolbox/AudioToolbox.h>
@interface BluetoothViewController ()

@property (nonatomic ,strong)CBPeripheral *peripheral;

@property(nonatomic,strong)CBCharacteristic *characteristic;
@end

@implementation BluetoothViewController{
    
    CBCentralManager *manager;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.view.backgroundColor = [UIColor colorWithRed:207.0/255 green:23.0/255 blue:28.0/255 alpha:1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, VIEW_WIDTH, 30)];
    label.textAlignment = 1;
    label.text = @"蓝牙设备不整了，心情不好";
    [self.view addSubview:label];
    
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"点击震动",@"测试字符串", nil];
    
    for (int index = 0; index < titleArray.count; index++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH/3, index * 40 + 130, VIEW_WIDTH/3, 30)];
        
        [button setTitle:titleArray[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        //    button.backgroundColor = [UIColor lightGrayColor];
        
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.tag = index + 11;
        [button addTarget:self action:@selector(zhendong:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

-(void)zhendong:(UIButton * )btn{
   
    if (btn.tag == 11) {
        NSLog(@"点击震动");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }else if (btn.tag == 12){
        if ([[@"335" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
            NSLog(@"不进去");
        }else{
            NSLog(@"进不去");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bluetoothManager{
 
    manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
    [manager scanForPeripheralsWithServices:nil options:nil];
}

#pragma mark -代理协议

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    NSLog(@"wwwhhwhwhwhw");
}
//找到设备会调用
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"name:%@",peripheral);
    
    if (!peripheral || !peripheral.name || [peripheral.name isEqualToString:@""]) {
        
        return;
    }
    
    if (!self.peripheral || (self.peripheral.state == CBPeripheralStateDisconnected)){
     
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        NSLog(@"connect peripheral");
        [manager connectPeripheral:peripheral options:nil];
    }
}
//链接成功会调用
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    if (!peripheral) {
        return;
    }
    
    [manager stopScan];
    NSLog(@"peripheral did connect");
    [self.peripheral discoverServices:nil];
}
//找到service后会调用下面方法
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    NSArray *services = nil;
    
    if (peripheral != self.peripheral) {
        NSLog(@"wrong peripheral.\n");
        return;
    }
    
    if (error != nil) {
        NSLog(@"Error %@ ",error);
        return;
    }
    
    services = [peripheral services];
    if (!services || ![services count]) {
        NSLog(@"no services");
        return;
    }
    
    for (CBService * service in services) {
        NSLog(@"service:%@",service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
    //我们根据找到的service寻找其对应的Characteristic。
}
//找到characteristic调用
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    NSLog(@"characteristics:%@",[service characteristics]);
    
    NSArray *characteristics = [service characteristics];
    
    if (peripheral != self.peripheral) {
        NSLog(@"wrong Peripheral.hhh");
        return;
    }
    
    if (error != nil) {
        NSLog(@"Error %@",error);
        return;
    }
    
    self.characteristic = [characteristics firstObject];
//    [self.peripheral readValueForCharacteristic:self.characteristic];
    [self.peripheral setNotifyValue:YES forCharacteristic:self.characteristic];
}

//读到数据后会调用delegate
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    NSData *data = characteristic.value;
    
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
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
