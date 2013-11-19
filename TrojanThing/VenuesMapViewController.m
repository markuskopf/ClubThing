//
//  VenuesMapViewController.m
//  TrojanThing
//
//  Created by Markus Kopf on 19/11/13.
//  Copyright (c) 2013 Markus Kopf. All rights reserved.
//

#import "VenuesMapViewController.h"
#import "VenueLocation.h"

#define METERS_PER_MILE 1609.344

@interface VenuesMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation VenuesMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mapView.delegate = self;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [self plotVenuePositions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
//    // 1
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = 39.281516;
//    zoomLocation.longitude= -76.580806;
//    
//    // 2
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//    
//    // 3
//    [_mapView setRegion:viewRegion animated:YES];
}


- (void)plotVenuePositions {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    for (NSString *element in self.venueListDict) {
        if ([element isEqualToString:@"venues"]) {
            NSArray *venueArray = (NSArray*)[self.venueListDict objectForKey:element];
            for (NSDictionary *dict in venueArray) {
//                NSString *latitude = [dict objectForKey:@"latitude"];
//                NSString *longitude = [dict objectForKey:@"longitude"];
//                NSString *name = [dict objectForKey:@"name"];

                NSNumber *latitude = [dict objectForKey:@"latitude"];
                NSNumber *longitude = [dict objectForKey:@"longitude"];
                NSString *venueDesc = [dict objectForKey:@"name"];

                CLLocationCoordinate2D coordinate;
                coordinate.latitude = latitude.doubleValue;
                coordinate.longitude = longitude.doubleValue;
                VenueLocation *annotation = [[VenueLocation alloc] initWithName:venueDesc address:venueDesc coordinate:coordinate] ;
                [_mapView addAnnotation:annotation];
            }
        }
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[VenueLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
//            annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}


@end
