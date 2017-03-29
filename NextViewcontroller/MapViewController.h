//
//  MapViewController.h
//  91HelloWorld
//
//  Created by 袁红霞 on 15/9/8.
//  Copyright (c) 2015年 hongxia Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@end
