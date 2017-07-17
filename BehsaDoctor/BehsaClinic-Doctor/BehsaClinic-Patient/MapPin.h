
//  MapPin.h
//  BehsaClinic-Patient
//
//  Created by Yarima on 3/28/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapPin : NSObject <MKAnnotation>
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;
@end
