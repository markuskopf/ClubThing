//
//  SendLocationViewController.m
//  TrojanThing
//
//  Created by Markus Kopf on 26/10/13.
//  Copyright (c) 2013 Markus Kopf. All rights reserved.
//

#import "SendLocationViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "VenueTableViewController.h"
#import "VenuesMapViewController.h"

@interface SendLocationViewController ()

// location manager
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) CLLocation *sendLocation;
@property (weak, nonatomic) IBOutlet UIButton *sendLocationButton;

// data response
@property (strong, nonatomic) NSDictionary *venueListDict;

@property (weak, nonatomic) IBOutlet UIButton *showVenueButton;
@property (weak, nonatomic) IBOutlet UIView *venueContainerView;
@property (weak, nonatomic) IBOutlet UIView *locationContainerView;

// menu button
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (nonatomic, strong) SFSCollectionMenuController *collectionMenu;

@end

@implementation SendLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Get the CLLocationManager going.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // We don't want to be notified of small changes in location, preferring to use our
    // last cached results, if any.
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [self.locationManager startUpdatingLocation];
    
    _appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    _venueContainerView.alpha = 0.0f;
    _locationContainerView.alpha = 0.0f;
    _sendLocationButton.alpha = 0.0f;
    _showVenueButton.alpha = 0.0f;
    
    self.navigationItem.hidesBackButton = YES;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedMenuButton:(id)sender {
    
    if (!_collectionMenu) {
        _collectionMenu = [[SFSCollectionMenuController alloc] initWithDelegate:self];
    }
    [self.collectionMenu showMenuWithLightEffect:SFSLightEffectTypeMediumLight];
    
}

- (IBAction)sendLocationToServer:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kBaseURL, @"api/v1/venue/search?"];

    
    //@"accessToken": self.appDelegate.accessToken,
    
    NSDictionary *parameters = @{@"longitude" : [NSString stringWithFormat:@"%lf", self.sendLocation.coordinate.longitude],
                                 @"latitude" : [NSString stringWithFormat:@"%lf", self.sendLocation.coordinate.latitude]};
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        @try {
            self.venueListDict = (NSDictionary*)responseObject;
            
            if (self.venueListDict.count>0) {
                [UIView animateWithDuration:2.0f animations:^{
                    self.venueContainerView.alpha = 1.0f;
                    self.showVenueButton.alpha = 1.0f;
                }];
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"ERROR: %@", exception.description);
        }
        @finally {
            // do nothing
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"venues_segue"])
	{
		VenueTableViewController *venueTableViewController = segue.destinationViewController;
        venueTableViewController.venues = self.venueListDict;
        
	} else if ([segue.identifier isEqualToString:@"venues_map_segue"])
    {
        VenuesMapViewController *venuesMapVC = segue.destinationViewController;
        venuesMapVC.venueListDict = self.venueListDict;
    }
}


#pragma mark - CLLocationManagerDelegate methods and related

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (!oldLocation ||
        (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
         oldLocation.coordinate.longitude != newLocation.coordinate.longitude &&
         newLocation.horizontalAccuracy <= 100.0)) {
            NSTimeInterval interval = [newLocation.timestamp timeIntervalSinceNow];
            
            NSLog(@"Interval of newLocation timestamp: %d", abs(interval));
            NSLog(@"New-Location: %@", newLocation.description);

            if (abs(interval)<30 &&
                (newLocation.coordinate.latitude!=oldLocation.coordinate.latitude ||
                 newLocation.coordinate.longitude!=oldLocation.coordinate.longitude)) {

                NSLog(@"Selected-Location: %@", newLocation.description);
                self.sendLocation = newLocation;
                
                [manager stopUpdatingLocation];
                
                
                
                [UIView animateWithDuration:2.0 animations:^{
                    self.locationContainerView.alpha = 1.0f;
                    self.sendLocationButton.alpha = 1.0;
                }];
            }
        }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)setPlaceCacheDescriptorForCoordinates:(CLLocationCoordinate2D)coordinates {
    NSLog(@"");
}

#pragma mark - SFSCollectionMenuDelegate methods

- (UIView *)viewForMenu {
    return self.view;
}

- (NSInteger)numberOfButtonsInMenuController:(SFSCollectionMenuController *)controller {
    return 6;
}

- (UIImage *)imageForButtonAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *images = @[[UIImage imageNamed:@"camera"],
                        [UIImage imageNamed:@"chatBubble"],
                        [UIImage imageNamed:@"phone"],
                        [UIImage imageNamed:@"star"],
                        [UIImage imageNamed:@"tag"],
                        [UIImage imageNamed:@"voicemail"]];
    return images[indexPath.row];
}

- (UIColor *)backgroundColorForButtonAtIndexPath:(NSIndexPath *)indexPath {
    return  [UIColor redColor]; //  [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
}

- (void)controller:(SFSCollectionMenuController *)controller didTapButtonAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [NSString stringWithFormat:@"Button %d tapped", indexPath.row];

}

- (NSString *)accessibilityLabelForButtonAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *labels = @[@"Camera",
                        @"Chat",
                        @"Phone",
                        @"Star",
                        @"Tag",
                        @"Voicemail"];
    return labels[indexPath.row];
}

- (NSString *)accessibilityHintForButtonAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *hints = @[@"Opens the camera",
                       @"Starts a chat session",
                       @"Opens the phone app",
                       @"Marks this as a favorite",
                       @"Tags this for later",
                       @"Opens the voicemail interface to listen to voicemails"];
    return hints[indexPath.row];
}

- (UIImage *)imageForCloseButton {
    return [UIImage imageNamed:@"closeButtonGray"];
}

- (NSString *)labelTextForMenu {
    return @"My Menu";
}

- (UIColor *)colorForLabelText {
    return [UIColor whiteColor];
}

- (NSString *)accessibilityHintForMenuLabel {
    return @"Displaying My Menu to choose an option";
}

- (NSString *)accessibilityLabelForMenuLabel {
    return @"My Menu";
}



@end
