//
//  GILocationManager.m
//  PXSDKExample
//
//  Created by Ankudinov Alexander on 7/9/15.
//  Copyright (c) 2015 Agilie. All rights reserved.
//

#import "GILocationManager.h"
#import <AddressBook/AddressBook.h>
#import "GITracker.h"

@implementation GILocationManager

- (id)init {
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.geocoder = [[CLGeocoder alloc] init];
        self.locationManager.delegate = self;

        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations == nil) {
        return;
    }

    CLLocation *location = [locations lastObject];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks == nil)
            return;

        //CLPlacemark *currentLocPlacemark = [placemarks objectAtIndex:0];

        //NSString *coordinateString = [NSString stringWithFormat:@"%f,%f", currentLocPlacemark.location.coordinate.latitude, currentLocPlacemark.location.coordinate.longitude];

        /*[GITracker sendGeocode:[currentLocPlacemark country] countryIsoCode:[currentLocPlacemark ISOcountryCode] city:[[currentLocPlacemark addressDictionary] objectForKey:(NSString *) kABPersonAddressCityKey] location:coordinateString];
         */
         
        [self.locationManager stopUpdatingLocation];

    }];
}

@end
