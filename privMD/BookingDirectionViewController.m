//
//  BookingDirectionViewController.m
//  privMD
//
//  Created by Surender Rathore on 26/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "BookingDirectionViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "DirectionService.h"
#import <CoreLocation/CoreLocation.h>
#import "PatientPubNubWrapper.h"
#import "AppointedDoctor.h"
#import "NetworkHandler.h"
#import "RoundedImageView.h"
#import <AXRatingView.h>
#import "UIImageView+WebCache.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PatientAppDelegate.h"
#import "InvoiceViewController.h"

#define _height  110
#define _heightCenter  160
#define _width   274
#define _widthLabel   216

#define imgLinkForSharing @"http://www.appypie.com/"

//@interface CoordsList : NSObject
//@property(nonatomic, readonly, copy) GMSPath *path;
//@property(nonatomic, readonly) NSUInteger target;
//
//
//- (id)initWithPath:(GMSPath *)path;
//
//- (CLLocationCoordinate2D)next;
//
//@end
//
//@implementation CoordsList
//
//- (id)initWithPath:(GMSPath *)path {
//    if ((self = [super init])) {
//        _path = [path copy];
//        _target = 0;
//    }
//    return self;
//}
//
//- (CLLocationCoordinate2D)next {
//    ++_target;
//    if (_target == [_path count]) {
//        _target = 0;
//    }
//    return [_path coordinateAtIndex:_target];
//}
//
//@end


@interface BookingDirectionViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate,PatientPubNubWrapperDelegate> {
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    PatientPubNubWrapper *pubNub;
}
@property(nonatomic,strong)NSString *startLocation;
@property(nonatomic,strong)NSString *destinationLocation;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)GMSMutablePath *mutablePath;
@property(nonatomic,strong)GMSMarker *destinationMarker;
@property(nonatomic,strong)NSString *pubnubChannelName;
@property(nonatomic,assign)BOOL isPathPlotted;
@property(nonatomic,assign)BOOL isUpdatedLocation;
@property(nonatomic,assign)CLLocationCoordinate2D previouCoord;
@property (strong, nonatomic)  UIView *bottomContainerView;

@end


static float latitudeChange = 0.01234;
static float longitdeChange = 0.00234;

@implementation BookingDirectionViewController
@synthesize bottomContainerView;
@synthesize disnEta;
@synthesize pollingTimer;
@synthesize apptid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView {
    
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]initWithCapacity:2];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.778376
                                                            longitude:-122.409853
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
//    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
//                                                                 coordinate.latitude,
//                                                                 coordinate.longitude);
//    GMSMarker *marker = [GMSMarker markerWithPosition:position];
//    marker.map = mapView_;
//    
//    [waypoints_ addObject:marker];
//    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
//                                coordinate.latitude,coordinate.longitude];
//    
//    [waypointStrings_ addObject:positionString];
//    
//    if([waypoints_ count]>1){
//        NSString *sensor = @"false";
//        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
//                               nil];
//        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
//        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
//                                                          forKeys:keys];
//        DirectionService *mds=[[DirectionService alloc] init];
//        SEL selector = @selector(addDirections:);
//        [mds setDirectionsQuery:query
//                   withSelector:selector
//                   withDelegate:self];
//    }
    
}
- (void)addDirections:(NSDictionary *)json {
    
    if ([json[@"routes"] count]>0) {
        NSDictionary *routes = [json objectForKey:@"routes"][0];
        
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        NSString *overview_route = [route objectForKey:@"points"];
        GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.map = mapView_;
    }
    
    
}

#pragma mark- Service Call

-(void)sendRequestForCancelAppointment
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Please wait.."];
   
    //setup parameters
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *driverEmail = self.doctorEmail;
    NSString *appointmntDate = self.apptDateForPolling;
    NSString *currentDate = [Helper getCurrentDateTime];
    
    NSString *appointmntid = self.apptid;

    
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_dri_email":driverEmail,
                             @"ent_appnt_dt":appointmntDate,
                             @"ent_date_time":currentDate,
                             @"ent_appnt_id":appointmntid,
                             };
    
    TELogInfo(@"cancel params dict %@",params);
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:kSMCancelAppointment
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       TELogInfo(@"response %@",response);
                                       [self parseCancelAppointmentResponse:response];
                                   }
                               }];
}

-(void)parseCancelAppointmentResponse:(NSDictionary*)response {
   
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    if (response == nil) {
        return;
    }
    else if([response[@"errFlag"] integerValue] == 0 && [response[@"errNum"] integerValue] == 42)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Helper showAlertWithTitle:@"Message" Message:response[@"errMsg"]];
    }
    else if([response[@"errFlag"] integerValue] == 0 && [response[@"errNum"] integerValue] == 43)
    {
        NSString *driverEmail = self.doctorEmail;
        NSString *appointmntDate = self.apptDateForPolling;
         NSString *appointmntid = self.apptid;
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InvoiceViewController *invoiceVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"invoiceVC"];
        invoiceVC.doctorEmail = driverEmail;
        invoiceVC.appointmentDate = appointmntDate;
        //invoiceVC.appointmentid = dictionary[@"bid"];
       // invoiceVC.isCancelBeforeTime = YES;
        PatientAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        UINavigationController *naviVC =(UINavigationController*) appDelegate.window.rootViewController;
        [naviVC pushViewController:invoiceVC animated:YES];

    }
    else
    {
        
    }
}

/**
 *  Service call to get master Car details
 */

-(void)sendRequestToGetMasterCarDetails
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Please wait.."];
    
    //setup parameters
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *driverEmail = self.doctorEmail;
    NSString *currentDate = [Helper getCurrentDateTime];
    
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_dri_email":driverEmail,
                             @"ent_date_time":currentDate,
                             };
    
    TELogInfo(@"sendRequestToGetMasterCarDetails params dict %@",params);
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:kSMCancelAppointment
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       TELogInfo(@"sendRequestToGetMasterCarDetails Response(\n %@ \n)",response);
                                       [self parseMasterCarDetailsAppointmentResponse:response];
                                   }
                               }];
}

-(void)parseMasterCarDetailsAppointmentResponse:(NSDictionary*)response {
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    if (response == nil) {
        return;
    }
    else if([response[@"errFlag"] integerValue] == 0)
    {
        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
        [ud setObject:response[@"model"] forKey:@"MODEL"];
        [ud setObject:response[@"plateNo"] forKey:@"PLATE"];
        [ud synchronize];
      //  [Helper showAlertWithTitle:@"Message" Message:response[@"errMsg"]];
    }
    else
    {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
    AppointedDoctor *apDoc = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    NSString *titleMsg = @"";
    titleMsg = [NSString stringWithFormat:@"Driver is on the way (%@)",[titleMsg  stringByAppendingString:apDoc.appointmentID]];
    self.title = titleMsg;
    
    [self getCurrentLocation];
    [self createbottomContainerView];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    _pubnubChannelName = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientPubNubChannelkey];
    [self stopPubNubStream];
    
    [self startPollingTimer];
    
   // [PatientAppDelegate addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setmsgToLabel:) name:@"RemoveFromWindow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setmsgToLabel:) name:KUBERDriverStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,84,280,30)];
    msgLabel.tag = 200;
    [Helper setToLabel:msgLabel Text:[NSString stringWithFormat:@"%@",@"Driver is on the way"] WithFont:Trebuchet_MS FSize:15 Color:[UIColor blackColor]];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.backgroundColor = [UIColor colorWithWhite:1.00f alpha:1.000];
    [self.view addSubview:msgLabel];
    
    //[self subsCribeToPubNub];
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    reachability.target = self;
    reachability.selector = @selector(sendRequestToGetMasterCarDetails);
    if ( [reachability isNetworkAvailable]) {
        [self sendRequestToGetMasterCarDetails];
    }
    else{
        //[[ProgressIndicator sharedInstance]showMessage:@"No Network Connection" On:self.view];
        [Helper showAlertWithTitle:@"Message" Message:@"No Network Connection"];
    }

}
- (void)saveCurrentState
{
    // When the user leaves the app and then comes back again, he wants it to be in the exact same state
    // he left it. In order to do this we need to save the currently displayed album.
    // Since it's only one piece of information we can use NSUserDefaults.
    
    //[[NSUserDefaults standardUserDefaults] setInteger:currentAlbumIndex forKey:@"currentAlbumIndex"];
}
- (void)loadPreviousState
{
    //currentAlbumIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
}

-(void)setmsgToLabel:(NSNotification *)notification
{
    TELogInfo(@"notification %@ ",notification);
    NSString *status = [notification object];
    if ([[notification name] isEqualToString:KUBERDriverStatus])
    {
        TELogInfo (@"Successfully received the test notification!");
        UILabel *msgLabel = (UILabel *)[self.view viewWithTag:200];
        msgLabel.text = [NSString stringWithFormat:@"%@",status];

        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
        AppointedDoctor *apDoc = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
        NSString *appointmentID = @"";
        appointmentID = [NSString stringWithFormat:@"Driver reached (%@)",[appointmentID  stringByAppendingString:apDoc.appointmentID]];
            self.title = appointmentID;
        
    }
    else if ([[notification name] isEqualToString:@"RemoveFromWindow"]){
        TELogInfo (@"Successfully received the test notification for RemoveFromWindow!");
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
   
   // [self showBottomContainerView];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PUSH"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"NOPUSH"];
    [self stopTimer];
    [self unSubscribePubNubToStopUpdatingDoctorLocation];

   // [self hideBottomContainerView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - PubNub
-(void)subsCribeToPubNubOnLocation:(double)latitude Longitude:(double)longitude{
    
    //get doctors detail
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
    AppointedDoctor *apDoc = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    NSString *doctorEmailAddress = apDoc.email;
    NSString *appointmentDate    = _appointmentDate; //apDoc.appoinmentDate;
    
    //patient email
    NSString *patientEmail = [ud objectForKey:kNSUPatientEmailAddressKey];
    
    //pubnub initilization and subscribe to patient channel
    pubNub = [PatientPubNubWrapper sharedInstance];
    [pubNub subscribeOnChannels:@[_pubnubChannelName]];
    [pubNub setDelegate:self];
    
    //compose message to start stream
    NSDictionary *message = @{@"a":[NSNumber numberWithInt:kPubNubStartDoctorLocationStreamAction],
                              @"e_id": doctorEmailAddress,
                              @"chn": _pubnubChannelName,
                              @"pid": patientEmail,
                              @"dt" : appointmentDate};
    
   
    
    [pubNub sendMessageAsDictionary:message toChannel:kPMDPublishStreamChannel];
}

-(void)unSubscribePubNubToStopUpdatingDoctorLocation {
    
    NSDictionary *message = @{@"a":[NSNumber numberWithInt:kPubNubStartDoctorLocationStreamAction],
                              @"chn":_pubnubChannelName,
                              };
    
    [pubNub sendMessageAsDictionary:message toChannel:kPMDPublishStreamChannel];
    
    [pubNub unSubscribeOnChannel:_pubnubChannelName];
    
     pubNub.delegate = nil;
}
-(void)stopPubNubStream {
    
   
    NSDictionary *message = @{@"a":[NSNumber numberWithInt:kPubNubStopStreamAction],
                              @"chn": _pubnubChannelName,
                              };
    
    
    pubNub = [PatientPubNubWrapper sharedInstance];
    
    [pubNub sendMessageAsDictionary:message toChannel:kPMDPublishStreamChannel];
    
    [pubNub unSubscribeOnChannel:_pubnubChannelName];
    
    pubNub.delegate = nil;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCurrentLocation{
    
    //check location services is enabled
 if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
        
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Service" message:@"Unable to find your location,Please enable location services." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    
    if (!_isUpdatedLocation) {
        
        [_locationManager stopUpdatingLocation];
        
        //change flag that we have updated location once and we don't need it again
        _isUpdatedLocation = YES;
        
        
        
        
        //change map camera postion to current location
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                longitude:newLocation.coordinate.longitude
                                                                     zoom:10];
        [mapView_ setCamera:camera];
        
        
        //add marker at current location
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.map = mapView_;
        [waypoints_ addObject:marker];
        
        
        //save current location to plot direciton on map
        _startLocation = [NSString stringWithFormat:@"%.6f,%.6f",newLocation.coordinate.latitude, newLocation.coordinate.longitude];
        [waypointStrings_ insertObject:_startLocation atIndex:0];
        
        
        //subscribe to pubnub to get doctors location stream
        [self subsCribeToPubNubOnLocation:newLocation.coordinate.latitude Longitude:newLocation.coordinate.longitude];
        
        TELogInfo(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
        TELogInfo(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    TELogInfo(@"locationManager failed to update location : %@",[error localizedDescription]);
}

#pragma mark - UpdateDestination

-(void)updateDestinationOnMapWithLocation {
    
    [_mutablePath removeAllCoordinates];
    
    for (int i = 0; i<6; i++) {
        float latitude = 13.031176;
        float longitude = 77.593507;
        
        latitudeChange =  latitudeChange +  0.12334;
        longitdeChange = longitdeChange +  0.12334;
        
        latitude = latitude + latitudeChange;
        longitude = longitude + longitdeChange;
        
        [self updateDestinationLocationWithLatitude:latitude Longitude:longitude];
    }
}

-(void)updateDestinationLocationWithLatitude:(float)latitude Longitude:(float)longitude{
    
    if (!_isPathPlotted) {
        
        TELogInfo(@"pathplotted");
        _isPathPlotted = YES;
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                     latitude,
                                                                     longitude);
        
        _previouCoord = position;
        
        _destinationMarker = [GMSMarker markerWithPosition:position];
        _destinationMarker.map = mapView_;
        _destinationMarker.flat = YES;
        _destinationMarker.groundAnchor = CGPointMake(0.5f, 0.5f);
        _destinationMarker.icon = [UIImage imageNamed:@"car.png"];
        
        [waypoints_ addObject:_destinationMarker];
        NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                    latitude,longitude];
        
        [waypointStrings_ addObject:positionString];
        
        if([waypoints_ count]>1){
            NSString *sensor = @"false";
            NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                                   nil];
            NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
            NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                              forKeys:keys];
            DirectionService *mds=[[DirectionService alloc] init];
            SEL selector = @selector(addDirections:);
            [mds setDirectionsQuery:query
                       withSelector:selector
                       withDelegate:self];
        }
        
    }
    else {
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude,longitude);
        CLLocationDirection heading = GMSGeometryHeading(_previouCoord, position);
        _previouCoord = position;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:2.0];
        _destinationMarker.position = position;
        [CATransaction commit];
        if (_destinationMarker.flat) {
            _destinationMarker.rotation = heading;
        }
        
    }
    
    
    
}

- (void)animateToNextCoord:(GMSMarker *)marker {
//    CoordsList *coords = marker.userData;
//    CLLocationCoordinate2D coord = [coords next];
//    CLLocationCoordinate2D previous = marker.position;
//    
//    CLLocationDirection heading = GMSGeometryHeading(previous, coord);
//    CLLocationDistance distance = GMSGeometryDistance(previous, coord);
//    
//    // Use CATransaction to set a custom duration for this animation. By default, changes to the
//    // position are already animated, but with a very short default duration. When the animation is
//    // complete, trigger another animation step.
//    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:(distance / (1 * 1000))];  // custom duration, 50km/sec
//    
//    __weak BookingDirectionViewController *weakSelf = self;
//    [CATransaction setCompletionBlock:^{
//        [weakSelf animateToNextCoord:marker];
//    }];
//    
//    marker.position = coord;
//    
//    [CATransaction commit];
//    
//    // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
//    if (marker.flat) {
//        marker.rotation = heading;
//    }
}


#pragma mark - PubnubWrapperDelegate
-(void)recievedMessage:(NSDictionary*)messageDict onChannel:(NSString*)channelName;
{
  //  TELogInfo(@"message %@",messageDict);
    if ([channelName isEqualToString:_pubnubChannelName] && [messageDict[@"a"] integerValue] == 5) {
        if([messageDict[@"flag"]integerValue] == 0){
        float latitude = [messageDict[@"lat"] floatValue];
        float longitude = [messageDict[@"lon"] floatValue];
        
        disnEta = @{@"DIS" : messageDict[@"dis"],
                    @"ETA" : messageDict[@"eta"],
                    };
        
        [self updateDistance:messageDict[@"dis"] estimateTime:messageDict[@"eta"]];
        [self updateDestinationLocationWithLatitude:latitude Longitude:longitude];
        }
    }
}

-(void)updateDistance:(NSString*)distane estimateTime:(NSString*)eta{
    UIView *btmView = [self.view viewWithTag:3000];
    
    UILabel *distanceLabel = (UILabel*)[btmView viewWithTag:1000];
    distanceLabel.text = [NSString stringWithFormat:@"Distance : %@",distane];
    
    UILabel *timeLabel = (UILabel*)[btmView viewWithTag:2000];
    timeLabel.text = [NSString stringWithFormat:@"Time : %@",eta];
}

-(void)createbottomContainerView
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    bottomContainerView = [[UIView alloc]initWithFrame:CGRectMake(0,size.height-110, 320,110)];
    bottomContainerView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:1.000];
    bottomContainerView.tag = 3000;
    
    //get doctor detail
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
    AppointedDoctor *apDoc = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    
    
    RoundedImageView *profilepic = [[RoundedImageView alloc] initWithFrame:CGRectMake(10,5,80,80)];
    profilepic.image = [UIImage imageNamed:@"signup_profile_image.png"];
    [bottomContainerView addSubview:profilepic];
    
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForXXHDPIImage,apDoc.profilePicURL];
    TELogInfo(@"strUrl :%@",strImageUrl);
    
    [profilepic sd_setImageWithURL:[NSURL URLWithString:strImageUrl]
                  placeholderImage:[UIImage imageNamed:@"signup_profile_image.png"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageurl) {
                         }];
    UILabel *doctorName = [[UILabel alloc] initWithFrame:CGRectMake(100,5,165, 20)];
    [Helper setToLabel:doctorName Text:flStrForStr(apDoc.driverName) WithFont:Trebuchet_MS_Bold FSize:13 Color:[UIColor blackColor]];
    [bottomContainerView addSubview:doctorName];
    
    float rating = [ud floatForKey:@"Rating"];
    AXRatingView *starRatingView = [[AXRatingView alloc] initWithFrame:CGRectMake(100,25, 100, 20)];
    starRatingView.stepInterval = 0.0;
    starRatingView.highlightColor = [UIColor colorWithRed:0.982 green:0.823 blue:0.048 alpha:1.000];
    starRatingView.userInteractionEnabled = NO;
    [starRatingView sizeToFit];
    starRatingView.value = rating;
    [bottomContainerView addSubview:starRatingView];

    
    UILabel *vehicleNo = [[UILabel alloc] initWithFrame:CGRectMake(100,50,165,20)];
    vehicleNo.tag = 302;
    [Helper setToLabel:vehicleNo Text:[ud objectForKey:@"PLATE"] WithFont:Trebuchet_MS FSize:12 Color:UIColorFromRGB(0x666666)];
    [bottomContainerView addSubview:vehicleNo];
    
    UILabel *cartype = [[UILabel alloc] initWithFrame:CGRectMake(100,65,165,20)];
    cartype.tag = 301;
    [Helper setToLabel:cartype Text:[ud objectForKey:@"MODEL"] WithFont:Trebuchet_MS FSize:12 Color:UIColorFromRGB(0x666666)];
    [bottomContainerView addSubview:cartype];
    
    
    UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(5,90, 155, 15)];
    distance.tag = 1000;
    [Helper setToLabel:distance Text:[NSString stringWithFormat:@"Distance: %@",flStrForStr(apDoc.distance)] WithFont:Trebuchet_MS FSize:12 Color:[UIColor blackColor]];
    [bottomContainerView addSubview:distance];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(160, 90, 155, 15)];
    time.tag = 2000;
    [Helper setToLabel:time Text:[NSString stringWithFormat:@"Time: %@",flStrForStr(apDoc.distance)] WithFont:Trebuchet_MS FSize:12 Color:[UIColor blackColor]];
    [bottomContainerView addSubview:time];
    
    UIImage *nimage = [UIImage imageNamed:@"pdriver_arrow_off.png"];
    UIImage *himage = [UIImage imageNamed:@"pdriver_arrow_on.png"];
    
    UIButton *detailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailsButton.tag = 201;
    detailsButton.frame = CGRectMake(320-75,110/2-75/2,71,75);
    [detailsButton setBackgroundImage:nimage forState:UIControlStateNormal];
    [detailsButton setBackgroundImage:himage forState:UIControlStateNormal];
    [detailsButton addTarget:self action:@selector(detailsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomContainerView addSubview:detailsButton];
    
    [self.view addSubview:bottomContainerView];
}



-(void)detailsButtonClicked:(id)sender
{
    TELogInfo(@"DETAILS BUTTON CLICKED");
    
    UIButton *mBut = (UIButton *)sender;
    if(mBut.isSelected)
    {
        mBut.selected =NO;
        [self removeDriverDetailScreen];
    }
    else
    {
        mBut.selected = YES;
        [self createDriverDetailScreen];
        
    }
    
    
}

-(void)showBottomContainerView{
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGRect frame = bottomContainerView.frame;
    frame.origin.y = ( size.height - 110);
    
    [UIView animateWithDuration:.4f
                     animations:^{
                         
                         bottomContainerView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)hideBottomContainerView
{
    
    // CGSize size = [[UIScreen mainScreen] bounds].size;
    CGRect frame = bottomContainerView.frame;
    frame.origin.y = ( frame.origin.y + 110);
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         bottomContainerView.frame = frame;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [bottomContainerView removeFromSuperview];
                     }];
    
    
}

/**
 *  view that will add on the center of the window (Mainly showing share contact and cancel trip)
 */

-(void)createDriverDetailScreen
{
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].bounds.size.height-110)];
    coverView.tag = 499;
    coverView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [coverView addGestureRecognizer:tapRecognizer];
    
    UIView *cd = [[UIView alloc]initWithFrame:CGRectMake(22,508/2-160/2,274, _heightCenter)];
    cd.tag = 500;
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0,0,_width,52);
    shareButton.tag = 501;
    [Helper setButton:shareButton Text:@"Share ETA" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    shareButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [shareButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [shareButton setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cd addSubview:shareButton];
    
    UILabel *line1Label = [[UILabel alloc]initWithFrame:CGRectMake(20,52,_widthLabel,1)];
    line1Label.tag = 101;
    line1Label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"drivermenu_popup_divider"]];
    [cd addSubview:line1Label];
    
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactButton.frame = CGRectMake(0,53,_width,52);
    contactButton.tag = 502;
    [Helper setButton:contactButton Text:@"Contact driver" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    contactButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    contactButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [contactButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [contactButton setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
    [contactButton addTarget:self action:@selector(contactButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cd addSubview:contactButton];
    
    UILabel *line2Label = [[UILabel alloc]initWithFrame:CGRectMake(20,105,_widthLabel,1)];
    line2Label.tag = 101;
    line2Label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"drivermenu_popup_divider"]];
    [cd addSubview:line2Label];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0,106, 253,52);
    cancelButton.tag = 502;
    [Helper setButton:cancelButton Text:@"Cancel trip" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [cancelButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cd addSubview:cancelButton];
    cd.backgroundColor = [UIColor colorWithWhite:0.151 alpha:1.000];
    [coverView addSubview:cd];
    
    [self.view addSubview:coverView];
    
}


-(void)removeDriverDetailScreen
{
    UIView *cd = (UIView *)[self.view viewWithTag:499];
    [cd removeFromSuperview];
    
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    
   // if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        UIButton *mBtn = (UIButton *)[self.view viewWithTag:201];
        [self detailsButtonClicked:mBtn];
    }
}


-(void)shareButtonClicked:(id)sender{
    TELogInfo(@" shareButtonClicked CLICKED");
 
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share"delegate:self cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter",@"Email", nil];
    // [actionSheet showInView:self.view];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}


-(void)contactButtonClicked:(id)sender{
    TELogInfo(@"DETAILS contactButtonClicked CLICKED");
    
    UIButton *button = (UIButton *)sender;
    NSString *buttonTitle = button.currentTitle;
    
    TELogInfo(@"PhnNo. :%@",buttonTitle);
   // NSString *no = [[NSUserDefaults standardUserDefaults]objectForKey:@"DriverTelNo"];
    NSString *number = [NSString stringWithFormat:@"%@",@"123456789"];
    TELogInfo(@"PhnNo. :%@",number);
    NSURL* callUrl=[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
    
    //check  Call Function available only in iphone
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"This function is only available on the iPhone"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)buttonClicked:(id)sender {
    TELogInfo(@"CALLBACK cancelButtonClicked CLICKED");
    [self sendRequestForCancelAppointment];
}

#pragma mark -
#pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex==0)
    {
        [self shareOnFacebook];
    }
    
    else if(buttonIndex == 1)
    {
        
        [self shareOnTwitter];
        
    }
    
    else if(buttonIndex == 2)
    {
        
        [self EmaiSharing];
        
    }
    
    
}

-(void)shareOnTwitter
{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *strETA = [NSString stringWithFormat:@"I will be there within  %@ and my current distance from your location is %@",[disnEta objectForKey:@"ETA"],[disnEta objectForKey:@"DIS"]];
        

        
        [tweetSheet setInitialText:strETA];
       // NSString *strURL = [NSString stringWithFormat:@"%@",@"http:/googole.com/"];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgLinkForSharing]]];
        [tweetSheet addImage:image];
        // [tweetSheet addURL:[NSURL URLWithString:strURL]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Message"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}


-(void)shareOnFacebook
{
    [self publishWithWebDialog];
}

/*
 * Share using the Web Dialog
 */
- (void) publishWithWebDialog {
    // Put together the dialog parameters
    
   NSString *strETA = [NSString stringWithFormat:@"I will be there within  %@ and my current distance from your location is %@",flStrForObj([disnEta objectForKey:@"ETA"]),flStrForObj([disnEta objectForKey:@"DIS"])];
    
//    NSString *strURL = [NSString stringWithFormat:@"%@",@"http:/googole.com/"];
    // UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"FREETAXI",@"name",
     strETA,@"description",imgLinkForSharing,@"picture",nil];
    
  
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             [self showAlert:[self checkErrorMessage:error]];
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     [self showAlert:[self checkPostId:urlParams]];
                 }
             }
         }
     }];
}

/*
 * Helper method to parse URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}


#pragma mark - Helper methods
/*
 * Helper method to show alert results or errors
 */
- (NSString *)checkErrorMessage:(NSError *)error {
    NSString *errorMessage = @"";
    // if (error.fberrorUserMessage) {
    // errorMessage = error.fberrorUserMessage;
    // } else {
    errorMessage = @"Operation failed due to a connection problem, retry later.";
    // }
    return errorMessage;
}

/*
 * Helper method to check for the posted ID
 */
- (NSString *) checkPostId:(NSDictionary *)results {
    NSString *message = @"Posted successfully.";
    //    if (results[@"postId"]) {
    //       // message = [NSString stringWithFormat:@"Posted story, id: %@", results[@"postId"]];
    //        [self showAlert:@"Share Dialog not supported. Make sure you're using the latest Facebook app."];
    //    }
    return message;
}

/*
 * Helper method to show an alert
 */
- (void)showAlert:(NSString *) alertMsg {
    if (![alertMsg isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Result"
                                    message:alertMsg
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


-(void)EmaiSharing
{
    if ([MFMailComposeViewController canSendMail])
    {
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont
                                                                               fontWithName:Trebuchet_MS_Bold size:14], NSFontAttributeName,
                                    [UIColor whiteColor], NSForegroundColorAttributeName, nil];
        
        [[UINavigationBar appearance] setTitleTextAttributes:attributes];
        
        mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        NSString *strETA = [NSString stringWithFormat:@"I will be there within  %@ and my current distance from your location is %@",[disnEta objectForKey:@"ETA"],[disnEta objectForKey:@"DIS"]];

        [mailer setSubject:@"FREETAXI"];
        
        
        NSArray *toRecipents;
        NSMutableString* message =[[NSMutableString alloc] init];
        
        [message appendString:strETA];
        
        toRecipents = [NSArray arrayWithObject:@"3Embed@gmail.com"];
        
        
        //[message appendString:[NSString stringWithFormat:@"%@\n\n",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"]]];
        
        [mailer setMessageBody:message isHTML:NO];
        [mailer setToRecipients:toRecipents];
     //   NSString *strURL = [NSString stringWithFormat:@"%@",_urlImage];
       // UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]]];
        
        
        //still
       // NSData *photoData = UIImageJPEGRepresentation(image,1);
        
       // [mailer addAttachmentData:photoData mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"photo.png"]];
        
        //[self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:^{
            [[UINavigationBar appearance] setTitleTextAttributes:attributes];
        }];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
    //dispatch_async(dispatch_get_main_queue(), ^{ mailer = nil; });
    
}

/**
 *  Polling Service
 */

-(void)startPollingTimer{
    
    if (!pollingTimer)
    {
        pollingTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(checkOngoingAppointmentStatus) userInfo:Nil repeats:YES];
               NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:pollingTimer forMode:NSRunLoopCommonModes];
        [runloop addTimer:pollingTimer forMode:UITrackingRunLoopMode];
        
    }
}

- (void) stopTimer
{
    [pollingTimer invalidate];
    pollingTimer = nil;
}
-(void)checkOngoingAppointmentStatus{
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
   
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
    AppointedDoctor *apDoc = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    NSString *appDate = apDoc.appTdateForPresentAppt;
    NSString *appId =apDoc.appointmentID;
    NSString *currentDate = [Helper getCurrentDateTime];
    
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_user_type":@"2",
                             @"ent_appnt_dt":appDate,
                             @"ent_date_time":currentDate,
                             @"ent_appnt_id":appId,
                             };
    
    TELogInfo(@"kSMGetAppointmentDetial %@",params);
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:@"getApptStatus"
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       TELogInfo(@"response %@",response);
                                       [self parsepollingResponse:response];
                                   }
                               }];

}

-(void)parsepollingResponse:(NSDictionary *)responseDict{
    
    if (responseDict == nil) {
        return;
    }
    else if ([responseDict objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[responseDict objectForKey:@"Error"]];
    }
    else
    {
        if ([[responseDict objectForKey:@"errFlag"] integerValue] == 0)
        {
            if([[responseDict objectForKey:@"status"]integerValue] == 6)
            {
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"NOPUSH"]integerValue] == 4)
                {
                    TELogInfo(@" \n PUSH CAME HERE \n ");

                }
                else{
                     TELogInfo(@" \n PUSH DID NOT COME YET \n ");
                              [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"CONTROLLERCHANGED"];
                [(PatientAppDelegate*)[[UIApplication sharedApplication] delegate]noPushForceChangingController:responseDict :4];
                }
            }
            else if([[responseDict objectForKey:@"status"]integerValue] == 7)
            {
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"NOPUSH"]integerValue] == 5)
                {
                    TELogInfo(@" \n PUSH CAME HERE \n ");
                }
                else{
                    
                    TELogInfo(@" \n PUSH DID NOT COME YET \n ");
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"CONTROLLERCHANGED"];
                    [(PatientAppDelegate*)[[UIApplication sharedApplication] delegate]noPushForceChangingController:responseDict :5];
                }
            }
        }
    }
    

    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopTimer];
}


@end
