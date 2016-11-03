//
//  PatientAppDelegate.m
//  privMD
//
//  Created by Rahul Sharma on 11/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "PatientAppDelegate.h"
#import "HelpViewController.h"
#import "PatientViewController.h"
#import "MapViewController.h"
#import "BookingDirectionViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AppointedDoctor.h"
#import "InvoiceViewController.h"
#import "PMDReachabilityWrapper.h"
#import <Crashlytics/Crashlytics.h>
#import <AudioToolbox/AudioToolbox.h>
#import "XDKAirMenuController.h"
#import "Flurry.h"
#import "InvoiceViewController.h"
#import <Pushwoosh/PushNotificationManager.h>

//TODO::GOOGLE PLUS
#import <GooglePlus/GooglePlus.h>


// Appbuileder
static NSString * const kClientID = @"251548696633-sjokjfsgstvgch5dberjspa1jk930tfd.apps.googleusercontent.com";


//testing
//static NSString *const kClientID= @"251548696633-jvel0km8csl9mnku8a6pi375rbu57d00.apps.googleusercontent.com";


@interface PatientAppDelegate()<GPPDeepLinkDelegate>

@property (nonatomic,strong) HelpViewController *helpViewController;
@property (nonatomic,strong) PatientViewController *splashViewController;
@property (nonatomic,strong) MapViewController *mapViewContoller;

@end

@implementation PatientAppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize _IsSwitchOn;
@synthesize paymentTypevalue;
@synthesize IscalenderscrollBool,_IsShowPaymentMODE,_IsShowMainView;

static UIView *mySharedView;

+ (void) initialize {
    mySharedView = [[UIView alloc]initWithFrame:CGRectMake(0, 430, 320, 50)];
    mySharedView.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
}
void uncaughtExceptionHandler(NSException *exception) {
    
    TELogInfo(@"The app has encountered an unhandled exception: %@", [exception debugDescription]);
    TELogInfo(@"Stack trace: %@", [exception callStackSymbols]);
    TELogInfo(@"desc: %@", [exception description]);
    TELogInfo(@"name: %@", [exception name]);
    TELogInfo(@"user info: %@", [exception userInfo]);
}
//use NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    _IsShowPaymentMODE=NO;
    //TODO::GOOGLE PLUS
    // Set app's client ID for |GPPSignIn| and |GPPShare|.
    [GPPSignIn sharedInstance].clientID = kClientID;
    // Read Google+ deep-link data.
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    
    //*****************
    
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"\n\n\n%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    
    
    [[PushNotificationManager pushManager] handlePushReceived:launchOptions];
    
    // make sure we count app open in Pushwoosh stats
    [[PushNotificationManager pushManager] sendAppOpen];
    
    // register for push notifications!
    [[PushNotificationManager pushManager] registerForPushNotifications];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [GMSServices provideAPIKey:kPMDGoogleMapsAPIKey];
    [self setupAppearance];
    
    //save device id
    NSString *uuidSting =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:uuidSting forKey:kPMDDeviceIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry setCrashReportingEnabled:YES];
    
    // Replace YOUR_API_KEY with the api key in the downloaded package
    [Flurry startSession:kPMDFlurryId];

    [[Crashlytics sharedInstance] setDebugMode:YES];
    [Crashlytics startWithAPIKey:@"8c41e9486e74492897473de501e087dbc6d9f391"];
    [self handlePushNotificationWithLaunchOption:launchOptions];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    TELogInfo(@"My userInfo is: %@", userInfo);
    NSString *jsonString = [userInfo objectForKey:@"u"];
    TELogInfo(@"My jsonString is: %@", jsonString);
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    TELogInfo(@"My token is: %@", data);
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    TELogInfo(@"My data is: %@", json);
    NSDictionary *userinfolocal = [[NSDictionary alloc]initWithObjectsAndKeys:json,@"aps", nil];
    TELogInfo(@"My userinfolocal is: %@", userinfolocal);
    NSDictionary *dictContainingUserInfo  = [[NSDictionary alloc]initWithDictionary:userinfolocal];
    TELogInfo(@"My dict is: %@", dictContainingUserInfo);
    
    int type = [userinfolocal[@"aps"][@"nt"] intValue];
    if(type == kNotificationTypeBookingComplete ){
        NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message :" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    

    [self handleNotificationForUserInfo:userinfolocal];
    

}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	TELogInfo(@"My token is: %@", deviceToken);
    NSLog(@"My token is: %@", deviceToken);
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:
                    [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    TELogInfo(@"My token is: %@", dt);
    NSLog(@"My token is: %@", dt);
    
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"])
    {
        //device is simulator
         [[NSUserDefaults standardUserDefaults]setObject:@"123" forKey:KDAgetPushToken];
    }
    else {
         [[NSUserDefaults standardUserDefaults]setObject:dt forKey:KDAgetPushToken];
        //for testing
        
    }
    
    [[PushNotificationManager pushManager] handlePushRegistration:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	TELogInfo(@"Failed to get token, error: %@", error);
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"]) {
        //device is simulator
        [[NSUserDefaults standardUserDefaults]setObject:@"123" forKey:KDAgetPushToken];
    }
}

-(void)gotocontrollerFortesting
{
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InvoiceViewController *invoiceVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"invoiceVC"];
    
    invoiceVC.doctorEmail = @"abhishek@mobifyi.com";
    invoiceVC.appointmentDate = @"2013-09-28 12:12:12";
    invoiceVC.appointmentid = @"1244";
    UINavigationController *naviVC =(UINavigationController*) self.window.rootViewController;
    [naviVC pushViewController:invoiceVC animated:YES];
    
}
    
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    /*
    int badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
    */ 
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLocationServicesChangedNameKey object:nil userInfo:nil];
    // Use Reachability to monitor connectivity
    PMDReachabilityWrapper *reachablity = [PMDReachabilityWrapper sharedInstance];
    [reachablity monitorReachability];
    
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        [self openActiveSessionWithPermissions:nil allowLoginUI:NO];
    }
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kNSUPassengerBookingStatusKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveContext];
}

#pragma mark - HandlePushNotification
/**
 *  handle push if app is opened by clicking push
 *  @param launchOptions pushpayload dictionary
 */
-(void)handlePushNotificationWithLaunchOption:(NSDictionary*)launchOptions {
    
    NSLog(@"handle push");
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
        
        //check if user is logged in
        if([[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken])
        {
                [self handleNotificationForUserInfo:remoteNotificationPayload];

        }
    }
}

-(void)noPushForceChangingController:(NSDictionary *)userInfo :(int)type{
    
  
//    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"pubnub Report" message:[NSString stringWithFormat:@"%@",userInfo] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
//    [alert1 show];

    NSDictionary *dictionary = [userInfo mutableCopy];
    
    if(type == kNotificationTypeBookingOnMyWay)
    {
        
//        NSUserDefaults *udPlotting = [NSUserDefaults standardUserDefaults];
//        [udPlotting setDouble:srcLat   forKey:@"srcLat"];
//        [udPlotting setDouble:srcLong  forKey:@"srcLong"];
//        [udPlotting setDouble:desLat   forKey:@"desLat"];
//        [udPlotting setDouble:desLong  forKey:@"desLong"];
        
        AppointedDoctor *appointedDoctor = [[AppointedDoctor alloc] init];
        appointedDoctor.driverName      =  dictionary[@"fName"];
        appointedDoctor.contactNumber   =  dictionary[@"mobile"];
        appointedDoctor.profilePicURL   =  dictionary[@"pPic"];
        appointedDoctor.email           =  dictionary[@"email"];
        appointedDoctor.status          =   @"Driver is on the way";
        appointedDoctor.appTdateForPresentAppt = dictionary[@"apptDt"];
        appointedDoctor.statusID = [NSString stringWithFormat:@"%d",type];
        appointedDoctor.appointmentID = dictionary[@"bid"];
        appointedDoctor.appoinmentDate = dictionary[@"dt"];
        
         NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:appointedDoctor];
        [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kNSUAppoinmentDoctorDetialKey];
        [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"email"] forKey:KUDriverEmail];
        [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"apptDt"] forKey:KUBookingDate];
        [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"bid"] forKey:@"bookingid"];
        [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"fName"] forKey:@"drivername"];
        [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"pPic"] forKey:@"driverpic"];
        [[NSUserDefaults standardUserDefaults] setObject:dictionary[@"mobile"] forKey:@"DriverTelNo"];
        //Status Key For Changing content on HomeViewController
        [[NSUserDefaults standardUserDefaults] setInteger:kNotificationTypeBookingOnMyWay forKey:@"STATUSKEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //Local Notification to notifyi HomeViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DRIVERONTHEWAY" object:nil userInfo:nil];
        
    }
    
    else if(type == kNotificationTypeBookingReachedLocation){
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
        AppointedDoctor *appointedDoctor = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
        
        appointedDoctor.statusID = [NSString stringWithFormat:@"%d",type];
        //appointedDoctor.appointmentID = dictionary[@"bid"];
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:appointedDoctor];
        [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kNSUAppoinmentDoctorDetialKey];
        
        //Status Key For Changing content on HomeViewController
        [[NSUserDefaults standardUserDefaults] setInteger:kNotificationTypeBookingReachedLocation forKey:@"STATUSKEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Local Notification to notifyi HomeViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DRIVERREACHED" object:nil userInfo:nil];
    }
    else if(type == kNotificationTypeBookingStarted){
        
        
        //Status Key For Changing content on HomeViewController
        [[NSUserDefaults standardUserDefaults] setInteger:kNotificationTypeBookingStarted forKey:@"STATUSKEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Local Notification to notifyi HomeViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JOBSTARTED" object:nil userInfo:nil];
    }

    else if (type == kNotificationTypeBookingComplete){ //
        
        //get driver detail
      
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
        AppointedDoctor *appointedDoctor = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
        
        appointedDoctor.statusID = [NSString stringWithFormat:@"%d",type];
        appointedDoctor.appointmentID = dictionary[@"bid"];
        
        //Status Key For Changing content on HomeViewController
        
        [[NSUserDefaults standardUserDefaults] setInteger:kNotificationTypeBookingComplete forKey:@"STATUSKEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:appointedDoctor];
        [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kNSUAppoinmentDoctorDetialKey];
        
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InvoiceViewController *invoiceVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"invoiceVC"];
        
        invoiceVC.doctorEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"DriverEmail"];
        invoiceVC.appointmentDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"BookingDate"];
        invoiceVC.appointmentid = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookingid"];
        
       // invoiceVC.isCancelBeforeTime = NO;
        UINavigationController *naviVC =(UINavigationController*) self.window.rootViewController;
        if (![[naviVC.viewControllers lastObject] isKindOfClass:[InvoiceViewController class]])
        {
            [naviVC pushViewController:invoiceVC animated:YES];
            
        }
    } //completed
    else if (type == kNotificationTypeBookingReject){
        
       _cancelReason  = [dictionary[@"r"] integerValue];
        
        NSString *cancelStatus = [self getCancelStatus:_cancelReason];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel Report" message:[NSString stringWithFormat:@"%@",cancelStatus] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"STATUSKEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //Local Notification to notifyi HomeViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JOBCOMPLETED" object:nil userInfo:nil];
    }
    else if (type == 11) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"STATUSKEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JOBCOMPLETED" object:nil userInfo:nil];
    }
    
}
-(NSString*)getCancelStatus:(int)statusCancel {
  
    NSString *cancelStatus;
    switch (statusCancel) {
        case 4:
            cancelStatus = @"Passenger not came";
            break;
        case 5:
            cancelStatus = @"Address wrong";
            break;
        case 6:
            cancelStatus = @"Passenger asked to cancel";
            break;
        case 7:
            cancelStatus = @"Dont charge customer";
            break;
        default:
            cancelStatus = @"Others";
            break;
    }

    return cancelStatus;
}
-(void)playNotificationSound{
    
    //play sound
    SystemSoundID	pewPewSound;
    NSString *pewPewPath = [[NSBundle mainBundle]
                            pathForResource:@"sigma-1-beep" ofType:@"mp3"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, & pewPewSound);
    AudioServicesPlaySystemSound(pewPewSound);
}

-(void)handleNotificationForUserInfo:(NSDictionary*)userInfo{
    
//    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Cancel Report" message:[NSString stringWithFormat:@"%@/nSTATUS",userInfo] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
//    [alert1 show];
    
   
    
    TELogInfo(@"Push Message %@ " ,userInfo);
    [self playNotificationSound];
    int type = [userInfo[@"aps"][@"nt"] intValue];
    // if ([userInfo[@"aps"][@"id"]integerValue] == [apDoc.appointmentID integerValue]) {
    
    if (type == kNotificationTypeBookingAccept) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message :" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"c"] forKey:@"SUBSCRIBEDCHANNEL"];
        //Status Key For Changing content on HomeViewController
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"STATUSKEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else if (type == kNotificationTypeBookingLaterReject) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message :" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if(type == kNotificationTypeBookingOnMyWay)
    {
        
        
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message :" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"c"] forKey:@"SUBSCRIBEDCHANNEL"];
//        //Status Key For Changing content on HomeViewController
//        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"STATUSKEY"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        
//        
//        AppointedDoctor *appointedDoctor = [[AppointedDoctor alloc] init];
//        appointedDoctor.driverName      =  userInfo[@"aps"][@"sname"];
//        appointedDoctor.contactNumber   =  userInfo[@"aps"][@"ph"];
//        appointedDoctor.profilePicURL   =  userInfo[@"aps"][@"pic"];
//        appointedDoctor.email           =  userInfo[@"aps"][@"e"];
//        appointedDoctor.status          =   @"Driver is on the way";
//        appointedDoctor.appTdateForPresentAppt = userInfo[@"aps"][@"d"];
//        appointedDoctor.statusID = [NSString stringWithFormat:@"%d",type];
//        appointedDoctor.appointmentID = userInfo[@"aps"][@"id"];
//        appointedDoctor.appoinmentDate = userInfo[@"aps"][@"d"];
//        
//        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"Message :" message:[NSString stringWithFormat:@"%@",appointedDoctor.driverName]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView1 show];
//        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:appointedDoctor];
//        [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kNSUAppoinmentDoctorDetialKey];
//        [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"e"] forKey:KUDriverEmail];
//        [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"d"] forKey:KUBookingDate];
//        [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"id"] forKey:@"bookingid"];
//        [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"sname"] forKey:@"drivername"];
//        [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"pic"] forKey:@"driverpic"];
//        [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"aps"][@"ph"] forKey:@"DriverTelNo"];
//        //Status Key For Changing content on HomeViewController
//        [[NSUserDefaults standardUserDefaults] setInteger:kNotificationTypeBookingOnMyWay forKey:@"STATUSKEY"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        //Local Notification to notifyi HomeViewController
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DRIVERONTHEWAY" object:nil userInfo:nil];

        
//        
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNSUIsPassengerBookedKey];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//        BOOL isAlreadyCame = [self checkCurrentStatus:kNotificationTypeBookingOnMyWay];
//        
//        BOOL isAlreadyBooked = [self checkIfBokkedOrNot];
//        if (isAlreadyCame && isAlreadyBooked) {
//            //do nothing
//        }
//        else if (!isAlreadyBooked){
//            //already completed
//        }
//        else {
//            
//            NSDictionary *dictionary = userInfo[@"aps"];
//            //Local Notification to notifyi HomeViewController
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBookingConfirmationNameKey object:nil userInfo:dictionary];
//        }
    }
    else if(type == kNotificationTypeBookingReachedLocation){
        
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
//        AppointedDoctor *appointedDoctor = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
//        
//        appointedDoctor.statusID = [NSString stringWithFormat:@"%d",type];
//        //appointedDoctor.appointmentID = dictionary[@"bid"];
//        
//        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:appointedDoctor];
//        [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kNSUAppoinmentDoctorDetialKey];
//        
//        //Status Key For Changing content on HomeViewController
//        [[NSUserDefaults standardUserDefaults] setInteger:kNotificationTypeBookingReachedLocation forKey:@"STATUSKEY"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        //Local Notification to notifyi HomeViewController
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DRIVERREACHED" object:nil userInfo:nil];

        
        
        
        
        
        
        
        
        BOOL isAlreadyCame = [self checkCurrentStatus:kNotificationTypeBookingReachedLocation];
        BOOL isAlreadyBooked = [self checkIfBokkedOrNot];
        if (isAlreadyCame && isAlreadyBooked) {
            //do nothing
        }
        else if (!isAlreadyBooked){
            //already completed
        }
        else {
        
        XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
        
        if (![menu.currentViewController isKindOfClass:[MapViewController class]]) {
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [menu openMenuAnimated];
            
            dispatch_after(0.2, dispatch_get_main_queue(), ^(void){
                [menu openViewControllerAtIndexPath:indexpath];
                [self noPushForceChangingController:[NSDictionary dictionary] :kNotificationTypeBookingReachedLocation];
            });
        }
        else{
            
           [self noPushForceChangingController:[NSDictionary dictionary] :kNotificationTypeBookingReachedLocation];
        }
        }
    } //kNotificationTypeBookingReachedLocation
    else if (type == kNotificationTypeBookingStarted) {
        
//        [[NSUserDefaults standardUserDefaults] setInteger:kNotificationTypeBookingStarted forKey:@"STATUSKEY"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        //Local Notification to notifyi HomeViewController
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"JOBSTARTED" object:nil userInfo:nil];
        
        
        
        [self noPushForceChangingController:[NSDictionary dictionary] :kNotificationTypeBookingStarted];
        
    }
    else if (type == kNotificationTypeBookingComplete){
        
        
        
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
//        AppointedDoctor *appointedDoctor = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
//        
//        appointedDoctor.statusID = [NSString stringWithFormat:@"%d",type];
//        appointedDoctor.appointmentID = userInfo[@"aps"][@"id"];
//        
//        //Status Key For Changing content on HomeViewController
//        
//        [[NSUserDefaults standardUserDefaults] setInteger:kNotificationTypeBookingComplete forKey:@"STATUSKEY"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:appointedDoctor];
//        [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kNSUAppoinmentDoctorDetialKey];
//        
//        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        InvoiceViewController *invoiceVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"invoiceVC"];
//        
//        invoiceVC.doctorEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"DriverEmail"];
//        invoiceVC.appointmentDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"BookingDate"];
//        invoiceVC.appointmentid = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookingid"];
//        
//        // invoiceVC.isCancelBeforeTime = NO;
//        UINavigationController *naviVC =(UINavigationController*) self.window.rootViewController;
//        if (![[naviVC.viewControllers lastObject] isKindOfClass:[InvoiceViewController class]])
//        {
//            [naviVC pushViewController:invoiceVC animated:YES];
//            
//        }

        
        
        
        
        
        
        
        
        
        
        BOOL isAlreadyCame = [self checkCurrentStatus:kNotificationTypeBookingComplete];
        BOOL isAlreadyBooked = [self checkIfBokkedOrNot];
        
        if (isAlreadyCame && isAlreadyBooked) {
            //do nothing
        }
        else if (!isAlreadyBooked){
            //already completed
        }
        else {
            NSDictionary *dictionary = userInfo[@"aps"];
            [self gotoInvoiceScreen:dictionary];
        }
        
    }
    else if(type == kNotificationTypeBookingReject){
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isDriverCanceledBookingOnce"];
        BOOL isDriverCancel = [[NSUserDefaults standardUserDefaults]boolForKey:@"isDriverCanceledBookingOnce"];
        BOOL isAlreadyBooked = [self checkIfBokkedOrNot];
        if (isDriverCancel && isAlreadyBooked) {
            NSDictionary *dictionary = userInfo[@"aps"];
            [self noPushForceChangingController:dictionary :kNotificationTypeBookingReject];
        }
    }
    
}

-(void)gotoInvoiceScreen :(NSDictionary *)detailsDict{
    
    
    
    //Status Key For Changing content on HomeViewController
    
    [[NSUserDefaults standardUserDefaults] setInteger:kNotificationTypeBookingComplete forKey:@"STATUSKEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InvoiceViewController *invoiceVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"invoiceVC"];
    invoiceVC.doctorEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"DriverEmail"];
    invoiceVC.appointmentDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"BookingDate"];
    invoiceVC.appointmentid = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookingid"];

    
    UINavigationController *naviVC =(UINavigationController*) self.window.rootViewController;
    
    if (![[naviVC.viewControllers lastObject] isKindOfClass:[InvoiceViewController class]])
    {
        [naviVC pushViewController:invoiceVC animated:YES];
        
    }

}

-(BOOL)checkCurrentStatus:(NSInteger)Status {
    
    NSInteger bookingStatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"STATUSKEY"];
    NSInteger newBookingStatus =   Status;
    
    if(bookingStatus != newBookingStatus && bookingStatus < newBookingStatus)
    {
        return NO;
    }
    else{
        return YES;
    }
}
-(BOOL)checkIfBokkedOrNot {
    
    BOOL isBooked = [[NSUserDefaults standardUserDefaults] boolForKey:kNSUIsPassengerBookedKey];
    
    if(isBooked)
    {
        return YES;
    }
    else{
        return NO;
    }
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -
#pragma mark Core Data stack



// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSLog(@"%@",storeURL);
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)setupAppearance {
//    
//    if(IS_IOS7)
//    {
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"login_navigationbr-568h.png"] forBarMetrics:UIBarMetricsDefault];
//    }
//    else
//    {
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"login_navigationbr.png"] forBarMetrics:UIBarMetricsDefault];
//    }
//    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:Trebuchet_MS size:16], NSFontAttributeName,
                               WHITE_COLOR, NSForegroundColorAttributeName, nil];
//    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];

    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:36.0/255.0 green:195.0/255.0 blue:155.0/255.0 alpha:1]];
    
   
}




#pragma mark - Public method implementation

-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      // Create a NSDictionary object and set the parameter values.
                                      NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                        session, @"session",
                                                                        [NSNumber numberWithInteger:status], @"state",
                                                                        error, @"error",
                                                                        nil];
                                      
                                      // Create a new notification, add the sessionStateInfo dictionary to it and post it.
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangeNotification"
                                                                                          object:nil
                                                                                        userInfo:sessionStateInfo];
                                      
                                  }];
    
}



//TODO::GOOGLE PLUS
#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    
     return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}









@end
