//
//  GILocationManager.h
//  PXSDKExample
//
//  Created by Ankudinov Alexander on 7/9/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GILocationManager : NSObject <CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLGeocoder *geocoder;

@end
