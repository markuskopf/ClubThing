//
//  VenueLocation.h
//  TrojanThing
//
//  Created by Markus Kopf on 19/11/13.
//  Copyright (c) 2013 Markus Kopf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VenueLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
