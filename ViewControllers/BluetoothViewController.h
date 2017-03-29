//
//  BluetoothViewController.h
//  SmallFeature
//
//  Created by Sun on 16/3/11.
//  Copyright © 2016年 ssb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothViewController : BaseViewController<CBCentralManagerDelegate,CBPeripheralDelegate>

@end
