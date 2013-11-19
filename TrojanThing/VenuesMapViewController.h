//
//  VenuesMapViewController.h
//  TrojanThing
//
//  Created by Markus Kopf on 19/11/13.
//  Copyright (c) 2013 Markus Kopf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface VenuesMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong)  NSDictionary *venueListDict;

@end
