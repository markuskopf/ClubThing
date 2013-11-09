//
//  ViewController.m
//  TrojanThing
//
//  Created by Markus Kopf on 26/10/13.
//  Copyright (c) 2013 Markus Kopf. All rights reserved.
//pod "AFNetworking", "~> 2.0"

#import "LandingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SendLocationViewController.h"

@interface LandingViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation LandingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // See if the app has a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        //  call suque to the
    } else {
        // No, display the login page.
        // Do nothing so the user must login
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLoginPressed:(id)sender
{
    // Initialize a session object
    FBSession *session = [[FBSession alloc] init];
    
    if ([FBSession activeSession].isOpen) {
        [self performSegueWithIdentifier:@"location_segue" sender:self];
        return;
    }
    
    // Set the active session
    [FBSession setActiveSession:session];
    // Open the session
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                NSString *accessToken = [[FBSession.activeSession accessTokenData] accessToken];
                NSLog(@"Print accessToken %@", accessToken);
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                
                NSString *URLString = [NSString stringWithFormat:@"%@api/v1/login", kBaseURL];
                NSDictionary *parameters;
                @try {
                    parameters = @{@"facebookAccessToken": accessToken};
                }
                @catch (NSException *exception) {
                    NSLog(@"ERROR: %@", exception.description);
                }
                @finally {
                    NSLog(@"");
                }
                
                [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    self.appDelegate.accessToken = [responseObject objectForKey:@"accessToken"];
                    
                    [self performSegueWithIdentifier:@"location_segue" sender:self];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"location_segue"])
	{
        SendLocationViewController *locationSendVC = segue.destinationViewController;
        // do some magic
	}
}

-(void)facebookLogIn:(FBSessionState)status handleError:(NSError *)error
{
    if (!error) {
        [self performSegueWithIdentifier:@"location_segue" sender:nil];
    }
}


@end
