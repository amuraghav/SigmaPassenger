 //
//  PatientViewController.m
//  privMD
//
//  Created by Rahul Sharma on 11/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "PatientViewController.h"
#import "HelpViewController.h"
#import "ViewController.h"
#import "NetworkHandler.h"
#import "AppointedDoctor.h"
#import <MediaPlayer/MediaPlayer.h>
#import "User.h"

@interface PatientViewController () <UserDelegate>

@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;

@end

@implementation PatientViewController
@synthesize moviePlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
       
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"320X567.png"]]];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    if (IS_IPHONE_5) {
        
        imageview.image = [UIImage imageNamed:@"320X567.png"];
    }
//    else if (IS_IPHONE_6) {
//        
//        imageview.image = [UIImage imageNamed:@"375X667.png"];
//    }
    
    else {
        imageview.image = [UIImage imageNamed:@"320X480.png"];
    }
    [self.view addSubview:imageview];

}

-(void)viewDidAppear:(BOOL)animated
{
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken])
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(removeSplash) userInfo:Nil repeats:NO];
    }
    else{

        [self getDirection];
        
    }
}

-(void)removeSplash
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken])
    {
        User *user = [[User alloc] init];
        user.delegate = self;
        PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
        
        if ( [reachability isNetworkAvailable]) {
            
            [user updateUserSessionToken];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"The internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }
    else
    {
        HelpViewController *help = [self.storyboard instantiateViewControllerWithIdentifier:@"helpVC"];
        
        [[self navigationController ] pushViewController:help animated:NO];
        
    }

}

- (void)createMoviePlayer {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"TimelapseHamburg" withExtension:@"mov"];
    
    // video player
    MPMoviePlayerController *playerViewController = [[MPMoviePlayerController alloc] init];
    playerViewController.contentURL = url;
    playerViewController.view.frame = CGRectMake(0, 0, 320, 568);
    
    [self.view addSubview:playerViewController.view];
    
    float size = [[UIScreen mainScreen] bounds].size.height;
    CGRect frm = moviePlayer.view.frame;
    frm.size.height = size;
    moviePlayer.view.frame = frm;
    [moviePlayer setControlStyle:MPMovieControlStyleNone];
    [moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
    
    moviePlayer = playerViewController;
    moviePlayer.view.userInteractionEnabled = NO;
    moviePlayer.initialPlaybackTime = -1;
    moviePlayer.shouldAutoplay=NO;
    [moviePlayer prepareToPlay];
    [moviePlayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDirection) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];//moviePlayerFinishedPlaying
    
	
}

/**
 *  All Directions Method
 */
#pragma mark-CLLocation Delegate Method
- (void) getDirection
{
    
    clmanager = [[CLLocationManager alloc] init];
    clmanager.delegate = self;
    clmanager.distanceFilter = kCLDistanceFilterNone;
    clmanager.desiredAccuracy = kCLLocationAccuracyBest;
    [clmanager startUpdatingLocation];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        if  ([clmanager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [clmanager requestAlwaysAuthorization];
        }
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 To Get Updated lattitude & longitude
 @return nil.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *location = [locations lastObject];
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString * log = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    // lat =@"39.5807";
    // log =@"104.8772";
    
    
    [[NSUserDefaults standardUserDefaults]setObject:lat forKey:KNUCurrentLat];
    [[NSUserDefaults standardUserDefaults]setObject:log forKey:KNUCurrentLong];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLat] && [[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLong] == 0)
    {
       
    }
    else{
        
         [self requestForGoogleGeocoding :lat:log];
        
       
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [clmanager stopUpdatingLocation];
    
    //[self getAddressFromLatLon:location]
    
}

/*
 To print error msg of location manager
 @param error msg.
 @return nil.
 */

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorDenied) {
        // The user denied your app access to location information.
        
    }
    else  if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorNetwork) {
        
    }
    else  if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorDenied) {
        
    }
    
    NSLog(@"locationManager failed to update location : %@",[error localizedDescription]);
    
}

/*
 Get GoogleGeocoding
 @Params lattitude, longitude
 @Return nil.
 */

-(void)requestForGoogleGeocoding :(NSString*)lattitude :(NSString*)longitude
{
//	WebServiceHandler *handler = [[WebServiceHandler alloc] init];
//	[handler setRequestType:eLatLongparser];
//	NSString *string = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true",lattitude,longitude ];
//    
//	NSURL *url = [NSURL URLWithString:string];
//    
//	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
//    
//	[handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(googleReverseGeocodingResponse:)];
    
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[lattitude doubleValue] longitude:[longitude doubleValue]];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks lastObject];
             
             // strAdd -> take bydefault value nil
             strcurrentAddress = nil;
             
             if ([placemark.subThoroughfare length] != 0)
                 strcurrentAddress = placemark.subThoroughfare;
             
             if ([placemark.thoroughfare length] != 0)
             {
                 // strAdd -> store value of current location
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark thoroughfare],strcurrentAddress];
                 else
                 {
                     // strAdd -> store only this value,which is not null
                     strcurrentAddress = placemark.thoroughfare;
                 }
             }
             
             if ([placemark.postalCode length] != 0)
             {
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark postalCode],strcurrentAddress];
                 else
                     strcurrentAddress = placemark.postalCode;
             }
             
             if ([placemark.locality length] != 0)
             {
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark locality],strcurrentAddress];
                 else
                     strcurrentAddress = placemark.locality;
                 
                 [[NSUserDefaults standardUserDefaults]setObject:placemark.locality forKey:KNUserCurrentCity];
             }
             
             if ([placemark.administrativeArea length] != 0)
             {
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark administrativeArea],strcurrentAddress];
                 else
                     strcurrentAddress = placemark.administrativeArea;
                 
                 [[NSUserDefaults standardUserDefaults]setObject:placemark.administrativeArea forKey:KNUserCurrentState];
             }
             
             if ([placemark.country length] != 0)
             {
                 if ([strcurrentAddress length] != 0)
                     strcurrentAddress = [NSString stringWithFormat:@"%@, %@",[placemark country],strcurrentAddress];
                 else
                     strcurrentAddress = placemark.country;
                 
                 [[NSUserDefaults standardUserDefaults]setObject:placemark.country forKey:KNUserCurrentCountry];
             }
             
             NSLog(@"%@",strcurrentAddress);
             
             [[NSUserDefaults standardUserDefaults] setObject:strcurrentAddress forKey:@"myAddress"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             if (strcurrentAddress.length != 0) {
                   [self removeSplash];
             }
             
//             if (([placemark.locality length] != 0) && ([placemark.administrativeArea length] != 0) && ([placemark.country length] != 0)){
//                 [self removeSplash];
//             }
             
         }
     }];
    
	
}

-(void)googleReverseGeocodingResponse:(NSDictionary*)_response
{
    //hide Progress indcator
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    NSLog(@"%@",_response);
    NSDictionary *itemlist = [[NSMutableDictionary alloc]initWithDictionary:_response[@"ItemsList"]];
    
    NSLog(@" %@ ",itemlist);
    NSDictionary *dict  = [_response objectForKey:@"ItemsList"];
    
    if(!_response)
    {
        return;
    }
    else
    {
        NSString *country = [dict objectForKey:@"country"];
        NSString *state = [dict objectForKey:@"administrative_area_level_1"];
        NSString *city = [dict objectForKey:@"locality"];

        [[NSUserDefaults standardUserDefaults]setObject:country forKey:KNUserCurrentCountry];
        [[NSUserDefaults standardUserDefaults]setObject:state forKey:KNUserCurrentState];
        [[NSUserDefaults standardUserDefaults]setObject:city forKey:KNUserCurrentCity];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self removeSplash];
    }
    
}

-(void)userDidUpdateSessionSucessfully:(BOOL)sucess {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    
    ViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
    self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
    
}
-(void)userDidUpdateSessionUnSucessfully:(BOOL)sucess {
    
    HelpViewController *help = [self.storyboard instantiateViewControllerWithIdentifier:@"helpVC"];
    
    [[self navigationController ] pushViewController:help animated:NO];
}


@end
