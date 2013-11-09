//
//  ViewController.h
//  TrojanThing
//
//  Created by Markus Kopf on 26/10/13.
//  Copyright (c) 2013 Markus Kopf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LandingViewController : UIViewController


-(void)facebookLogIn:(FBSessionState)status handleError:(NSError *)error;


@end
