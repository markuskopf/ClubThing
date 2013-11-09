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

- (void)setShouldSkipLogIn:(BOOL)skip {
    [[NSUserDefaults standardUserDefaults] setBool:skip forKey:@"ScrumptiousSkipLogIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldSkipLogIn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ScrumptiousSkipLogIn"];
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
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            }];
}
//
//#pragma mark - FBLoginView delegate
//
//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    // if you become logged in, no longer flag to skip log in
//    self.shouldSkipLogIn = NO;
//}
//
//- (void)loginView:(FBLoginView *)loginView
//      handleError:(NSError *)error{
//    NSString *alertMessage, *alertTitle;
//    
//    // Facebook SDK * error handling *
//    // Error handling is an important part of providing a good user experience.
//    // Since this sample uses the FBLoginView, this delegate will respond to
//    // login failures, or other failures that have closed the session (such
//    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
//    // and [- requestPermissionAndPost] on `SCViewController` for further
//    // error handling on other operations.
//    
//    if (error.fberrorShouldNotifyUser) {
//        // If the SDK has a message for the user, surface it. This conveniently
//        // handles cases like password change or iOS6 app slider state.
//        alertTitle = @"Something Went Wrong";
//        alertMessage = error.fberrorUserMessage;
//    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
//        // It is important to handle session closures as mentioned. You can inspect
//        // the error for more context but this sample generically notifies the user.
//        alertTitle = @"Session Error";
//        alertMessage = @"Your current session is no longer valid. Please log in again.";
//    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
//        // The user has cancelled a login. You can inspect the error
//        // for more context. For this sample, we will simply ignore it.
//        NSLog(@"user cancelled login");
//    } else {
//        // For simplicity, this sample treats other errors blindly, but you should
//        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
//        alertTitle  = @"Unknown Error";
//        alertMessage = @"Error. Please try again later.";
//        NSLog(@"Unexpected error:%@", error);
//    }
//    
//    if (alertMessage) {
//        [[[UIAlertView alloc] initWithTitle:alertTitle
//                                    message:alertMessage
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil] show];
//    }
//}
//
//- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
//    // Facebook SDK * login flow *
//    // It is important to always handle session closure because it can happen
//    // externally; for example, if the current session's access token becomes
//    // invalid. For this sample, we simply pop back to the landing page.
//    
//    
//    [self logOut];
//    
//}
//
//- (void)logOut {
//    // on log out we reset the main view controller
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.accessToken = nil;
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//
//- (IBAction)clickSkipLogIn:(id)sender {
//    self.shouldSkipLogIn = YES;
//    //    [self transitionToMainViewController];
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"location_segue"])
	{
        SendLocationViewController *locationSendVC = segue.destinationViewController;
        // do some magic
	}
}


@end