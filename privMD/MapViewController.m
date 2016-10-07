//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
//  MapViewController.m
//  DoctorMapModule
//
//  Created by Rahul Sharma on 03/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "MapViewController.h"
#import "PickUpViewController.h"
#import "XDKAirMenuController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>
#import "PatientPubNubWrapper.h"
#import "fareCalculatorViewController.h"
#import "BookingDirectionViewController.h"
#import "AppointedDoctor.h"
#import "InvoiceViewController.h"
#import "PaymentViewController.h"
#import "CustomNavigationBar.h"
#import "NetworkHandler.h"
#import "UploadProgress.h"
#import <AFNetworking.h>
#import "LocationServicesMessageVC.h"
#import "Entity.h"
#import "Database.h"
#import "DirectionService.h"
#import <AXRatingView.h>
#import "Fonts.h"
#import "UIImageView+WebCache.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PatientAppDelegate.h"
#import "RoundedImageView.h"
#import "STKSpinnerView.h"
#import "MyAppTimerClass.h"
#import "MessageViewController.h"


#define imgLinkForSharing @"http://uber.pbodev.info/newLogic.php/appimages/Icon-Small-never-change-name.png"


//Define Constants tag for my view
#define myProgressTag  5001
#define mapZoomLevel 17
#define pickupAddressTag 2500
#define addProgressViewTag 6000
#define carType1TAG 7000
#define carType2TAG 7001
#define carType3TAG 7002
#define carType4TAG 7003
#define msgLabelTag 7004

#define myCustomMarkerTag 5000
#define curLocImgTag 5001
#define driverArrivedViewTag 3000
#define driverMessageViewTag 3001
#define _height  110
#define _heightCenter  160
#define _width   274
#define _widthLabel   216

#define bottomViewWithCarTag 106
#define topViewTag 90
#define distanceMetric 1000

#define myCarTypesTag 11111

#define myCustomMainViewTag 1001

static MapViewController *sharedInstance = nil;

enum doctorType {
    Now = 1,
    Later = 2
};

typedef enum
{
    isChanging = 0,
    isFixed = 1
}locationchange;

@interface CoordsList : NSObject
@property(nonatomic, readonly, copy) GMSPath *path;
@property(nonatomic, readonly) NSUInteger target;


- (id)initWithPath:(GMSPath *)path;

- (CLLocationCoordinate2D)next;

@end

@implementation CoordsList

- (id)initWithPath:(GMSPath *)path {
    if ((self = [super init])) {
        _path = [path copy];
        _target = 0;
    }
    return self;
}

- (CLLocationCoordinate2D)next {
    ++_target;
    if (_target == [_path count]) {
        _target = 0;
    }
    return [_path coordinateAtIndex:_target];
}

@end


@interface MapViewController ()<PatientPubNubWrapperDelegate,CLLocationManagerDelegate,CustomNavigationBarDelegate>{
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    GMSGeocoder *geocoder_;
    PatientPubNubWrapper *pubNub;
    float desLat;
    float desLong;
    NSString *desAddr;
    NSString *desAddrline2;
    float srcLat;
    float srcLong;
    NSString *srcAddr;
    NSString *srcAddrline2;
    NSUInteger carTypesForLiveBooking;
    NSUInteger carTypesForLiveBookingServer;
    NSUInteger paymentTypesForLiveBooking;
    
    NSUInteger payment_type_calue;
    //Path Plotting Variables
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    float newLat;
    float newLong;
    
    float actual;
    float actualGMview;
    int docCount;
    double distanceOfClosetCar;
    
    NSInteger carTypesArrayCountValue;
    NSInteger carMaximumCapacity;
}

@property(nonatomic,strong) NSString *laterSelectedDate;
@property(nonatomic,strong) CustomNavigationBar *customNavigationBarView;
@property(nonatomic,strong) NSString *patientPubNubChannel;
@property(nonatomic,strong) NSString *serverPubNubChannel;
@property(nonatomic,strong) NSString *patientEmail;
@property(nonatomic,strong) NSMutableDictionary *allMarkers;
@property(nonatomic,strong) WildcardGestureRecognizer * tapInterceptor;
@property(nonatomic,strong) UIActionSheet *actionSheet;
@property(nonatomic,assign) float currentLatitude;
@property(nonatomic,assign) float currentLongitude;
@property(nonatomic,assign) float currentLatitudeFare;
@property(nonatomic,assign) float currentLongitudeFare;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,assign) BOOL isUpdatedLocation;
@property(nonatomic,strong) UIView *PikUpViewForConfirmScreen;
@property(nonatomic,strong) UIView *DropOffViewForConfirmScreen;
//Progress Indicator
@property(nonatomic,strong) UIProgressView * threadProgressView;
@property(nonatomic,strong) UIView *myProgressView;
@property(nonatomic,strong) UIView *addProgressBarView;
@property(nonatomic,strong) NSString *cardId;
@property(nonatomic,strong) NSString *subscribedChannel;
@property(nonatomic,assign)BOOL isDriverArrived;
@property(nonatomic,assign)BOOL isDriverOnTheWay;
//Path Plotting Variables
@property(nonatomic,assign)BOOL isPathPlotted;
@property(nonatomic,assign)CLLocationCoordinate2D previouCoord;
@property(nonatomic,strong)GMSMarker *destinationMarker;
@property(nonatomic,strong)NSString *startLocation;
@property(nonatomic,weak)NSTimer *pubnubStreamTimer;
@property(nonatomic,weak) NSTimer *pollingTimer;
@property(nonatomic,assign) double driverCurLat;
@property(nonatomic,assign) double driverCurLong;
@property(nonatomic,strong) NSDictionary *disnEta;
@property(nonatomic,strong) NSMutableArray *arrayOFDriverChannels;
@property(nonatomic,strong) NSMutableArray *arrayOfDriverEmail;
@property(nonatomic,strong) NSMutableArray *arrayOfCarTypes;
@property(nonatomic,strong) NSMutableArray *arrayOfMastersAround;

@property(nonatomic,strong) UIView *spinnerView;

//suri
@property(nonatomic,assign)BOOL isBookingStatusCheckedOnce;
@property(nonatomic,assign)BOOL isSelectinLocation;
@property(nonatomic,assign)BOOL isAddressManuallyPicked;


@end

static int isLocationChanged;

@implementation MapViewController

@synthesize doctors;
@synthesize dictSelectedDoctor;
@synthesize threadProgressView;
@synthesize PikUpViewForConfirmScreen;
@synthesize DropOffViewForConfirmScreen;
@synthesize addProgressBarView;
@synthesize customNavigationBarView;
@synthesize cardId;
@synthesize laterSelectedDate;
@synthesize disnEta,pollingTimer,pubnubStreamTimer,subscribedChannel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

+ (instancetype) getSharedInstance
{
    return sharedInstance;
}

#pragma mark-
#pragma WebServices

#pragma Mark - SearchDoctorAroundYou

- (void) sendRequestgetETAnDistance {
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    
    NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&key=AIzaSyC8Wp93bbMkFMa4g6_Zy6Rrc9UIHM7zA2M",_driverCurLat,_driverCurLong,_currentLatitude,_currentLongitude];
    
    NSURL *url = [NSURL URLWithString:[Helper removeWhiteSpaceFromURL:strUrl]];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(addressResponse:)];
    
}

#pragma mark Webservice Handler(Response) -

- (void)addressResponse:(NSDictionary *)response{
    
    if (!response) {
        
        // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //  [alertView show];
        
    }else if ([response objectForKey:@"Error"]){
        //[Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
    }
    else{
        
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        
        if ([[dictResponse objectForKey:@"statusNumber"] intValue] == 0)
        {
            NSArray *routes =  response[@"ItemsList"][@"routes"];
            if( routes.count != 0 )
            {
                NSString *distance = response[@"ItemsList"][@"routes"][0][@"legs"][0][@"distance"][@"text"];
                
                NSString *eta =  response[@"ItemsList"][@"routes"][0][@"legs"][0][@"duration"][@"text"];
                
                disnEta = @{@"DIS" : distance,
                            @"ETA" : eta,
                            };
                
                [self updateDistance:distance estimateTime:eta];
            }
            else
            {
                NSLog(@"ADD RESPONSE COMING NULL");
            }
        }
        
        
    }
}


/**
 *  cancel live booking
 */
-(void)sendAppointmentRequestForLiveBookingCancellation{
    
    [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Cancel.."];  //setup parameters
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             };
    
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:kSMCancelOngoingAppointment
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       
                                       [self getLiveCancelResponse:response];
                                   }
                               }];
    
    
}
-(void)sendAppointmentRequestForLiveBooking {
    
    
  
    
//    UIView *customView = [self.view viewWithTag:160];
//    UITextField *textAddress = (UITextField *)[customView viewWithTag:161];
//    NSLog(@"%@",textAddress.text);
//    if(textAddress.text.length == 0){
//        
//        [Helper showAlertWithTitle:@"Message" Message:@"Please select DropOff Location first."];
//        return;
//    }
    
    if (_arrayOfDriverEmail.count) {
        
      
            
            if(!cardId || [cardId isKindOfClass:[NSNull class]]) {
                
                [Helper showAlertWithTitle:@"Message" Message:@"Please select Card to continue booking process."];
                return;
            

            }
        
            isRequestingButtonClicked = YES;
            [self driverBooking];
    

       
    }
    else {
        
        [self bookingNotAccetedByAnyDriverScreenLayout];
        [Helper showAlertWithTitle:@"Message" Message:@"It seems like no driver around you.Please try again."];
    }
    
}


-(void)alertpopView{
    
    
    viewCarTypes = [[UIView alloc] init];
    
    
    
    CGRect rect = self.view.frame;
    
    rect.origin.y = 120;
    rect.size.height = rect.size.height/2-20;
    
    [viewCarTypes setTag:myCarTypesTag];
    
    [viewCarTypes setFrame:rect];
    
    [viewCarTypes setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];

    
    UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    crossButton.frame = CGRectMake(165, 200, 140, 40);
    
    //[CardButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_pickup_bg_on.png"] forState:UIControlStateNormal];
    
    [crossButton setBackgroundColor:BUTTON_BG_Color];
    [Helper setButton:crossButton Text:@"CANCEL" WithFont:Trebuchet_MS FSize:13.0f TitleColor:[UIColor blackColor] ShadowColor:nil];
    [crossButton addTarget:self action:@selector(BtncrossAction) forControlEvents:UIControlEventTouchUpInside];
    [crossButton setShowsTouchWhenHighlighted:YES];
    [viewCarTypes addSubview:crossButton];
    
    
    
    UIButton *buttonCheckBoxHandicap = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCheckBoxHandicap.frame = CGRectMake(12, 200, 140, 40);
    [buttonCheckBoxHandicap setBackgroundColor:BUTTON_BG_Color];
    [Helper setButton:buttonCheckBoxHandicap Text:@"OK" WithFont:Trebuchet_MS FSize:13.0f TitleColor:[UIColor blackColor] ShadowColor:nil];
    [buttonCheckBoxHandicap addTarget:self action:@selector(BtnOkAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonCheckBoxHandicap setShowsTouchWhenHighlighted:YES];
    
    [viewCarTypes addSubview:buttonCheckBoxHandicap];

    
    
    UIView *viewSelectCarTypes = [[UIView alloc] initWithFrame:CGRectMake(10,70,300,110)];
    
    [viewSelectCarTypes setBackgroundColor:[UIColor whiteColor]];
    
    txtName = [[UITextField alloc] initWithFrame:CGRectMake(5,5,290, 40)];
    
    [txtName setBackgroundColor:[UIColor clearColor]];
    
    [txtName setTextAlignment:NSTextAlignmentCenter];
    
    [txtName setBackground:[UIImage imageNamed:@"LogIn-Text-Bg.png"]];
    
    [txtName setDelegate:self];
    
    [txtName setPlaceholder:@"Name"];
    
    [txtName setText:@""];
    
    
    txtPhone = [[UITextField alloc] initWithFrame:CGRectMake(5,60,290, 40)];
    
    [txtPhone setBackgroundColor:[UIColor clearColor]];
    
    [txtPhone setTextAlignment:NSTextAlignmentCenter];
    
    [txtPhone setBackground:[UIImage imageNamed:@"LogIn-Text-Bg.png"]];
    
    [txtPhone setDelegate:self];
    
    [txtPhone setPlaceholder:@"Phone"];
    
    [txtPhone setText:@""];
    

    
    [viewSelectCarTypes addSubview:txtName];
    
    [viewSelectCarTypes addSubview:txtPhone];
    
    [viewCarTypes addSubview:viewSelectCarTypes];
    
    
    
    UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapForRemove:)];
    
    tapOnView.numberOfTapsRequired = 1;
    
    [viewCarTypes addGestureRecognizer:tapOnView];
    
    
    
    [self.view addSubview:viewCarTypes];
    
    [self.view bringSubviewToFront:viewCarTypes];
    

    
}

- (void)handletapForRemove:(UIGestureRecognizer *)recognizer
{
    
    [self.view endEditing:YES];
    [viewCarTypes removeFromSuperview];
}

- (void)BtncrossAction
{
    
    [self.view endEditing:YES];
    [viewCarTypes removeFromSuperview];
}

- (void)BtnOkAction
{
    
    if([txtName.text isEqualToString:@""]) {
         [Helper showAlertWithTitle:@"Message" Message:@"Please enter your name."];
        
    }
    else if([txtPhone.text isEqualToString:@""]) {
         [Helper showAlertWithTitle:@"Message" Message:@"Please enter your phone."];
    }else{
        isRequestingButtonClicked = YES;
        [self driverBooking];
        
        [self.view endEditing:YES];
        [viewCarTypes removeFromSuperview];

        
    }
    
   
}

-(void)driverBooking {
    
    if(docCount <= _arrayOfDriverEmail.count-1) {
        
        [self callServiceToBookDriver: [_arrayOfDriverEmail objectAtIndex:docCount]];
        docCount++;
    }
    else {
        
        [self bookingNotAccetedByAnyDriverScreenLayout];
        [Helper showAlertWithTitle:@"Message" Message:@"Currently all drivers are busy,Please try again."];
    }
}
-(void)bookingNotAccetedByAnyDriverScreenLayout {
    
    docCount = 0;
    actual = 1;
    desLat = 0;
    desLong = 0;
    isRequestingButtonClicked = NO;
    paymentTypesForLiveBooking = 0;
    UIView *v = [self.view viewWithTag:myCustomMarkerTag];
    v.hidden = NO;
    [self removeAddProgressView];
    [self addCustomLocationView];
    [self handleTap:nil];
    //[self getCurrentLocation:nil];
    
}

-(void)bookingAccetedBySomeDriverScreenLayout {
    
    _myAppTimerClassObj = [MyAppTimerClass sharedInstance];
    [_myAppTimerClassObj stopPublishTimer];
    
    [_allMarkers removeAllObjects];
    UIView *v = [self.view viewWithTag:myCustomMarkerTag];
    v.hidden = YES;
    [self removeAddProgressView];
    [self handleTap:nil];
    [mapView_ clear];
}
/**
 *  send request for live booking
 */
-(void)callServiceToBookDriver:(NSString *)driverEmail {
    
    
    isLocationChanged = isChanging;
    [_myProgressView setHidden:NO];
    UIView *v = [self.view viewWithTag:myCustomMarkerTag];
    v.hidden = YES;
    
    //Createview For Cancellation
    [self makeMyProgressBarMoving];
    
    
    //setup parameters
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    
    //! is for nil [NSNull class] is for other type of like Null NULL null and length is for checking
    if (!srcAddrline2 || srcAddrline2 == (id)[NSNull null] || srcAddrline2.length == 0 ){
        srcAddrline2 = @"";
    }
    if (isNowSelected == YES) {
        laterSelectedDate = @"";
    }
    else{
        laterSelectedDate = @"";
    }
    
    NSString *zipcode = @"90210";
    NSString *pickupLatitude =  [NSString stringWithFormat:@"%f",srcLat];
    NSString *pickupLongitude = [NSString stringWithFormat:@"%f",srcLong];
    
    if (srcAddr == (id)[NSNull null] || srcAddr.length == 0 )
    {
        UITextField *textAddress = (UITextField *)[PikUpViewForConfirmScreen viewWithTag:pickupAddressTag];
        srcAddr = textAddress.text;
        
    }
    NSString *pickAddress = srcAddr;
    NSString *dropLatitude;
    NSString *dropLongitude;
    NSString *dropAddress;
    
    if (desAddrline2 == Nil) {
        desAddrline2 = @"";
    }
    
    if(desLat == 0 && desLong == 0) {
        dropLatitude = @"";
        dropLongitude =@"";
        dropAddress =  @"";
        
    }
    else {
        dropLatitude = [NSString stringWithFormat:@"%f",desLat];
        dropLongitude = [NSString stringWithFormat:@"%f",desLong];
        dropAddress = desAddr;
    }
    if(!cardId || [cardId isKindOfClass:[NSNull class]]) {
        cardId = @"";
    }
    
    if(!promocode_id || [promocode_id isKindOfClass:[NSNull class]]) {
        promocode_id = @"";
    }

    
   //ToDO Add for Helper code
//
//    NSString* txtnamestr;
//    NSString* txtphonestr;
//    
//    if (txtName.text == nil || [txtName.text isKindOfClass:[NSNull class]]) {
//        txtnamestr=@"";
//    }
//    if (txtPhone.text == nil ||  [txtPhone.text isKindOfClass:[NSNull class]]) {
//        
//         txtphonestr=@"";
//        
//    }
//    
//    if (appDelegate._IsSwitchOn == YES) {
//        
//        txtnamestr= txtName.text;
//        txtphonestr =txtPhone.text;
//        
//    }
//   
//    NSLog(@"%@",txtphonestr);
//    NSLog(@"%@",txtnamestr);
//    NSString *ent_helper =@"0";
//    NSString *ent_handicap_friendly =@"1";
//    NSString *ent_pet_friendly =@"1";
    
    paymentTypesForLiveBooking=2;
    NSString *dateTime = [Helper getCurrentDateTime];
    @try {
      

        
        NetworkHandler *networHandler = [NetworkHandler sharedInstance];
        
        if (isPopLockSelected) {
            
            NSDictionary *params = @{@"ent_sess_token":sessionToken,
                                     @"ent_dev_id":deviceID,
                                     @"ent_wrk_type":[NSString stringWithFormat:@"%ld",carTypesForLiveBookingServer],
                                     @"ent_lat":pickupLatitude,
                                     @"ent_long":pickupLongitude,
                                     @"ent_addr_line1":pickAddress,
                                     @"ent_addr_line2":srcAddrline2,
                                     @"ent_drop_lat":dropLatitude,
                                     @"ent_drop_long":dropLongitude,
                                     @"ent_drop_addr_line1":dropAddress,
                                     @"ent_drop_addr_line2":desAddrline2,
                                     @"ent_zipcode":zipcode,
                                     @"ent_extra_notes":@"",
                                     @"ent_date_time":dateTime,
                                     @"ent_later_dt":laterSelectedDate,
                                     @"ent_payment_type":[NSNumber numberWithInteger:paymentTypesForLiveBooking],
                                     @"ent_card_id":cardId,
                                     @"ent_dri_email":driverEmail,
                                     @"ent_promocode_id":promocode_id,
                                     @"ent_appointment_type":@"2"
                                     };
            
            NSLog(@"BookingRequest %@",params);
            
            
            [networHandler composeRequestWithMethod:kSMLiveBookingPopLock
                                            paramas:params
                                       onComplition:^(BOOL success, NSDictionary *response){
                                           
                                           if (success) { //handle success response
                                               NSUserDefaults *udPlotting = [NSUserDefaults standardUserDefaults];
                                               [udPlotting setDouble:srcLat   forKey:@"srcLat"];
                                               [udPlotting setDouble:srcLong  forKey:@"srcLong"];
                                               [udPlotting setDouble:desLat   forKey:@"desLat"];
                                               [udPlotting setDouble:desLong  forKey:@"desLong"];
                                               
                                               [self getBookingAppointment:response];
                                           }
                                           else{
                                               
                                               [Helper showAlertWithTitle:@"Failed" Message:@"Your request failed,Please try again."];
                                               [self bookingNotAccetedByAnyDriverScreenLayout];                                       }
                                       }];
            
        }
        else{
            
            NSDictionary *params = @{@"ent_sess_token":sessionToken,
                                     @"ent_dev_id":deviceID,
                                     @"ent_wrk_type":[NSString stringWithFormat:@"%ld",carTypesForLiveBookingServer],
                                     @"ent_lat":pickupLatitude,
                                     @"ent_long":pickupLongitude,
                                     @"ent_addr_line1":pickAddress,
                                     @"ent_addr_line2":srcAddrline2,
                                     @"ent_drop_lat":dropLatitude,
                                     @"ent_drop_long":dropLongitude,
                                     @"ent_drop_addr_line1":dropAddress,
                                     @"ent_drop_addr_line2":desAddrline2,
                                     @"ent_zipcode":zipcode,
                                     @"ent_extra_notes":@"",
                                     @"ent_date_time":dateTime,
                                     @"ent_later_dt":laterSelectedDate,
                                     @"ent_payment_type":[NSNumber numberWithInteger:paymentTypesForLiveBooking],
                                     @"ent_card_id":cardId,
                                     @"ent_dri_email":driverEmail,
                                     @"ent_promocode_id":promocode_id
                                     };
            
            NSLog(@"BookingRequest %@",params);
            
        [networHandler composeRequestWithMethod:kSMLiveBooking
                                        paramas:params
                                   onComplition:^(BOOL success, NSDictionary *response){
                                       
                                       if (success) { //handle success response
                                           NSUserDefaults *udPlotting = [NSUserDefaults standardUserDefaults];
                                           [udPlotting setDouble:srcLat   forKey:@"srcLat"];
                                           [udPlotting setDouble:srcLong  forKey:@"srcLong"];
                                           [udPlotting setDouble:desLat   forKey:@"desLat"];
                                           [udPlotting setDouble:desLong  forKey:@"desLong"];
                                           
                                           [self getBookingAppointment:response];
                                       }
                                       else{
                                           
                                           [Helper showAlertWithTitle:@"Failed" Message:@"Your request failed,Please try again."];
                                           [self bookingNotAccetedByAnyDriverScreenLayout];                                       }
                                   }];
        }
    }
    @catch (NSException *exception) {
        TELogInfo(@"BookingRequest Exception : %@",[exception description]);
    }
}

/**
 *  Booking for later
 *
 *  @param responseDictionary return type void and takes no argument
 */

-(void)getLiveCancelResponse:(NSDictionary *)responseDictionary{
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    NSString *titleMsg = @"Message";
    NSString *errMsg = @"";
    [self bookingNotAccetedByAnyDriverScreenLayout];
    
    if (!responseDictionary)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[responseDictionary objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([responseDictionary objectForKey:@"Error"])
    {
        //[Helper showAlertWithTitle:@"Error" Message:[responseDictionary objectForKey:@"Error"]];
        errMsg = [responseDictionary objectForKey:@"errMsg"];
    }
    else
    {
        if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 0)
        {
            errMsg = [responseDictionary objectForKey:@"errMsg"];
            
        }
        else if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 1)
        {
            errMsg = [responseDictionary objectForKey:@"errMsg"];
        }
        else
        {
            errMsg = [responseDictionary objectForKey:@"errMsg"];
        }
    }
    
    [Helper showAlertWithTitle:titleMsg Message:errMsg];
    
}
-(void)getBookingAppointment:(NSDictionary *)responseDictionary
{
    NSLog(@"booking%@",responseDictionary);
    if (!responseDictionary)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[responseDictionary objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([responseDictionary objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[responseDictionary objectForKey:@"Error"]];
    }
    else
    {
        if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 0 &&[[responseDictionary objectForKey:@"errNum"] intValue] == 39)
        {
            BOOL isNewBooking = [self checkBookingID:[responseDictionary[@"bid"] integerValue]];
            if (isNewBooking) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseDictionary[@"bid"] forKey:@"BOOKINGID"];
                isRequestingButtonClicked = NO;
                docCount = 0;
                NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
                [ud setObject:responseDictionary[@"email"] forKey:KUDriverEmail];
                [ud setObject:responseDictionary[@"apptDt"] forKey:KUBookingDate];
                [ud setObject:responseDictionary[@"rating"] forKey:@"Rating"];
                if ([ud boolForKey:kNSUIsPassengerBookedKey]) {
                    //do nothing
                }
                else{
                    [ud setBool:YES forKey:kNSUIsPassengerBookedKey];
                    BOOL isAlreadyCalled = [self checkServiceCalledAtleastOnce];
                    if (!isAlreadyCalled) {
                        
                        [self sendRequestToGetDriverDetails:responseDictionary[@"email"] :responseDictionary[@"apptDt"] :responseDictionary[@"bid"]];
                        
                    }
                    
                }
                [ud synchronize];
            }
            
        }
        else if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 0 &&[[responseDictionary objectForKey:@"errNum"] intValue] == 78){
            [Helper showAlertWithTitle:@"Message" Message:[responseDictionary objectForKey:@"errMsg"]];
        }
        else if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 1)
        {
            [self sendAppointmentRequestForLiveBooking];
            
        }
        else
        {
            
        }
    }
}


#pragma mark ViewLifeCycle-
- (void)makeMyProgressBarMoving {
    
    if(!addProgressBarView)
    {
        addProgressBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
       // addProgressBarView.backgroundColor = theam_color;
        addProgressBarView.backgroundColor = BUTTON_VIEW_Color;
       
        //[UIColor colorWithRed:0.230 green:0.128 blue:0.101 alpha:1.000];//
        [addProgressBarView setUserInteractionEnabled:YES];
        CALayer *layer = [addProgressBarView layer];
        [layer setRasterizationScale:1];
        [layer setShouldRasterize:YES];
        
        _myProgressView = [[UIView alloc]initWithFrame:CGRectMake(10,self.view.frame.size.height/2-50/2,300,50)];
        //UIImage *ima = [UIImage imageNamed:@"conformation_btn_pickup_bg"];
        _myProgressView.layer.cornerRadius = 5.0f;
        _myProgressView.tag = myProgressTag;
        _myProgressView.backgroundColor =  CLEAR_COLOR;//[UIColor colorWithPatternImage:ima];
        UILabel *reqText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 25)];
        reqText.textAlignment = NSTextAlignmentCenter;
        [Helper setToLabel:reqText Text:@"Requesting..." WithFont:Trebuchet_MS FSize:12 Color:[UIColor blackColor]];
        [_myProgressView addSubview:reqText];
        threadProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10,25,280,10)];
        threadProgressView.progress = 0;
        [_myProgressView addSubview:threadProgressView];
        [addProgressBarView addSubview:_myProgressView];
        
        UIView *cancelAnimationView = [[UIView alloc]initWithFrame:CGRectMake(135,self.view.frame.size.height-50,37,37)];
        cancelAnimationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cancel_btn"]];
        [cancelAnimationView setUserInteractionEnabled:YES];
        cancelAnimationView.multipleTouchEnabled = NO;
        [addProgressBarView addSubview:cancelAnimationView];
        
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
//                                                   initWithTarget:self
//                                                   action:@selector(longpressToCancel:)];
//        longPress.minimumPressDuration = 0.5;
//        [cancelAnimationView addGestureRecognizer:longPress];
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.delegate = self;
        [cancelAnimationView addGestureRecognizer:singleTap];
        
        
        
        
        [self.view addSubview:addProgressBarView];
        [self.view bringSubviewToFront:addProgressBarView];
        actual = [threadProgressView progress];
        [self updateThreadProgressView];
    }
}

-(void)updateThreadProgressView
{
    if (actual < 1)
    {
        threadProgressView.progress = actual;
        
        actual = actual + 0.005533335;
        NSLog(@"actual=== %.1f",actual);
        
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateThreadProgressView) userInfo:nil repeats:NO];
    }
    else if (actual > 1)
    {
        [self bookingNotAccetedByAnyDriverScreenLayout];
    }
    else{
        
        NSLog(@"actual last value=== %.1f",actual);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    strDistance= @"---";
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
	// Do any additional setup after loading the view.
    sharedInstance = self;
    _patientEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientEmailAddressKey];
    _patientPubNubChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientPubNubChannelkey];
    _serverPubNubChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDPublishStreamChannel];

    pubNub = [PatientPubNubWrapper sharedInstance];
    // [self clearUserDefaultsAfterBookingCompletion];
    [[TELogger getInstance] initiateFileLogging];
    newLat = [[[NSUserDefaults standardUserDefaults]objectForKey:KNUCurrentLat]floatValue];
    newLong = [[[NSUserDefaults standardUserDefaults]objectForKey:KNUCurrentLong]floatValue];
    carTypesForLiveBooking = 1;
    carTypesForLiveBookingServer = 0;
    isNowSelected = YES;
    isLaterSelected = NO;
    threadProgressView.progress = 0.0;
    self.navigationController.navigationBarHidden = YES;
    CGRect rect = self.view.frame;
    rect.origin.y = -44;
    [self.view setFrame:rect];
    
    NSUserDefaults *ud =   [NSUserDefaults standardUserDefaults];
    double curLat = [[ud objectForKey:KNUCurrentLat] doubleValue];
    double curLong = [[ud objectForKey:KNUCurrentLong] doubleValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:curLat longitude:curLong zoom:18];
    
    UIView *customMapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    CGRect rectMap = customMapView.frame;
    
    mapView_ = [GMSMapView mapWithFrame:rectMap camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    [mapView_ clear];
    customMapView = mapView_;
    geocoder_ = [[GMSGeocoder alloc] init];
    [self.view addSubview:customMapView];
    
    [self addCustomNavigationBar];
    if ([ud boolForKey:kNSUIsPassengerBookedKey]) {
        
        [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Checking Booking Status.."];
        [self checkBookingStatus];
    }
    else {
        
        
        [self changeContentOfPresentController:nil];
    }
    
    
    //CHECK FOR NOTIFICATION AND CHANGE CONTROLLER
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentOfPresentController:) name:@"DRIVERONTHEWAY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentOfPresentController:) name:@"DRIVERREACHED"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentOfPresentController:) name:@"JOBSTARTED" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentOfPresentController:) name:@"JOBCOMPLETED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookingConfirmed:) name:kNotificationBookingConfirmationNameKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationServicesChanged:) name:kNotificationLocationServicesChangedNameKey object:nil];
    [self subscribeToPassengerChannel];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString  *cardSelectionStr=@"Payment type";
    [defaults setObject:cardSelectionStr forKey:@"payment_mode"];
    [defaults synchronize];
    
    appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate._IsShowMainView == NO) {
        
          [self createMainView];
    }
    
    
    isPopLockSelected =[[NSUserDefaults standardUserDefaults] boolForKey:@"isPopLockSelected"];
    if (isPopLockSelected) {
        
         DropOffViewForConfirmScreen.hidden=YES;
    }
    else{
         DropOffViewForConfirmScreen.hidden=NO;
    }
    
  
}



-(void)createMainView{
    
        mainView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        // View =[self.view viewWithTag:myCustomMainViewTag];
        UIImageView *bgImage =[[UIImageView alloc]init];
        bgImage.frame=mainView.frame;
        bgImage.image=[UIImage imageNamed:@"homeBg.png"];
        [mainView addSubview:bgImage];
        [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    
        UIButton *_buttonNow = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonNow.frame = CGRectMake(40,240,240,40);
        
        [Helper setButton:_buttonNow Text:@"REQUEST A RIDE" WithFont:Trebuchet_MS FSize:13 TitleColor:[UIColor blackColor]ShadowColor:nil];
        _buttonNow.tag = 2060;
        [_buttonNow setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_buttonNow setBackgroundColor:[UIColor colorWithRed:131.0/255.0 green:227.0/255.0 blue:230.0/255.0 alpha:1]];
        [_buttonNow addTarget:self action:@selector(buttonRideNowLaterClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonNow setSelected:YES];
        _buttonNow.layer.cornerRadius = 20;
        _buttonNow.layer.borderWidth = 1;
        _buttonNow.layer.borderColor = [UIColor whiteColor].CGColor;
        _buttonNow.clipsToBounds = true;
        UIImageView *btnIcon =[[UIImageView alloc]init];
        btnIcon.frame=CGRectMake(5, 5, 50, 25);
        btnIcon.image=[UIImage imageNamed:@"Car-70x30"];
        [_buttonNow addSubview:btnIcon];
        [mainView addSubview:_buttonNow];
        
        UIButton *_buttonLater = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonLater.frame = CGRectMake(40,290,240,40);
        [Helper setButton:_buttonLater Text:@"REQUEST POP A LOCK" WithFont:Trebuchet_MS FSize:13 TitleColor:[UIColor blackColor] ShadowColor:nil];
        _buttonLater.tag = 2061;
        [_buttonLater addTarget:self action:@selector(buttonRideNowLaterClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonLater setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_buttonLater setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:220.0/255.0 blue:239.0/255.0 alpha:1]];
        _buttonLater.layer.cornerRadius = 20;
        _buttonLater.layer.borderWidth = 1;
        _buttonLater.layer.borderColor = [UIColor whiteColor].CGColor;
        _buttonLater.clipsToBounds = true;
    
        UIImageView *btnLaterIcon =[[UIImageView alloc]init];
        btnLaterIcon.frame=CGRectMake(10, -5, 25, 50);
        btnLaterIcon.image=[UIImage imageNamed:@"Key-30x68"];
        [_buttonLater addSubview:btnLaterIcon];
    
        [mainView addSubview:_buttonLater];
    
    
}

-(void)buttonRideNowLaterClicked:(UIButton *)sender{
     appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
     appDelegate._IsShowMainView=YES;
    
    UIButton *_buttonNow = (UIButton *)[[self.view viewWithTag:78] viewWithTag:2060];
    UIButton *_buttonLater = (UIButton *)[[self.view viewWithTag:78] viewWithTag:2061];
    
    UIButton *mBtn = (UIButton *)sender;
    if (sender.tag == 2060) {
        
       mainView.hidden=YES;
        
        [mBtn setTitle:@"REQUEST A RIDE" forState:(UIControlStateHighlighted) | (UIControlStateSelected)];
        [_buttonNow setSelected:YES];
        [_buttonLater setSelected:NO];
        isNowSelected = YES;
        isLaterSelected = NO;
        isPopLockSelected = NO;
        [[NSUserDefaults standardUserDefaults] setBool:isPopLockSelected forKey:@"isPopLockSelected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         DropOffViewForConfirmScreen.hidden=NO;
        [self createCenterView :@"SET PICKUP LOCATION"];
    }
    else if(sender.tag == 2061){
      
        [mBtn setTitle:@"REQUEST POP A LOCK" forState:(UIControlStateHighlighted) | (UIControlStateSelected)];
        [_buttonNow setSelected:NO];
        [_buttonLater setSelected:YES];
         mainView.hidden=YES;

        isNowSelected = NO;
        isLaterSelected = YES;
        isPopLockSelected = YES;
        
        [[NSUserDefaults standardUserDefaults] setBool:isPopLockSelected forKey:@"isPopLockSelected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        DropOffViewForConfirmScreen.hidden=YES;
        [self createCenterView :@"SET A POP A LOCK"];
               
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
     NSString *payment_type = [[NSUserDefaults standardUserDefaults]objectForKey:@"payment_mode"];
    
    if ([payment_type isEqualToString:@"Payment type"]) {
        
    }else{
        
        [self addCustomViewForShowingCardFareWithAnimation];
    }
    
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    if (!_isSelectinLocation) {
        
        _isSelectinLocation = NO;
        //First unsubscribe to the channel you are listening to,then clear all the array contents so that the map will launch freshly
        [self unSubsCribeToPubNubChannels:_arrayOFDriverChannels];
        [_allMarkers removeAllObjects];
        [mapView_ clear];
        if (_arrayOFDriverChannels) {
            [_arrayOFDriverChannels removeAllObjects] ;
            _arrayOFDriverChannels = nil;
        }
        
        //Make All the bool values to default one
        [self removeAddProgressView];
        [self stopPubNubStream];
        _myAppTimerClassObj = [MyAppTimerClass sharedInstance];
        [_myAppTimerClassObj stopPublishTimer];
        [_myAppTimerClassObj stopEtaNDisTimer];
        
    }
    
    
}
/**
 *  Stop the receiving data from pubnub server
 */
-(void)stopPubNubStream {
    
    pubNub = [PatientPubNubWrapper sharedInstance];
    pubNub.delegate = nil;
    
}
-(void)removeAddProgressView{
    
    if(addProgressBarView != nil)
    {
        [addProgressBarView removeFromSuperview];
        threadProgressView = nil;
        addProgressBarView = nil;
        actual = 1;
    }
    
}
- (void) viewDidAppear:(BOOL)animated{
    
 //   [self addgestureToMap];
    if (IS_SIMULATOR)
    {
        _currentLatitude = 13.028866;
        _currentLongitude = 77.589760;
        CLLocationCoordinate2D locationCord = CLLocationCoordinate2DMake(_currentLatitude,_currentLongitude);
        mapView_.camera = [GMSCameraPosition cameraWithTarget:locationCord
                                                         zoom:14];
    }
}
-(void)clearUserDefaultsAfterBookingCompletion {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kNSUAppoinmentDoctorDetialKey];
    [ud removeObjectForKey:kNSUPassengerBookingStatusKey];
    [ud removeObjectForKey:@"subscribedChannel"];
    [ud setBool:NO forKey:kNSUIsPassengerBookedKey];
    [ud setBool:NO forKey:@"isServiceCalledOnce"];
    [ud removeObjectForKey:@"DriverTelNo"];
    [ud removeObjectForKey:@"MODEL"];
    [ud removeObjectForKey:@"PLATE"];
    [ud removeObjectForKey:@"drivername"];
    [ud removeObjectForKey:@"driverpic"];
    [ud removeObjectForKey:@"srcLat"];
    [ud removeObjectForKey:@"srcLong"];
    [ud removeObjectForKey:@"desLat"];
    [ud removeObjectForKey:@"desLong"];
    [ud removeObjectForKey:KUDriverEmail];
    [ud removeObjectForKey:KUBookingDate];
    [ud synchronize];
    
}
#pragma Mark - ChangeController
-(void)bookingConfirmed:(NSNotification*)notification {
    
    NSDictionary *userinfo = notification.userInfo;
    NSString *email = userinfo[@"e"];
    NSString *bookingDate = userinfo[@"d"];
    NSString *bookingId = userinfo[@"bid"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:email forKey:KUDriverEmail];
    [ud setObject:bookingDate forKey:KUBookingDate];
    [ud synchronize];
    BOOL isAlreadyCalled = [self checkServiceCalledAtleastOnce];
    if (!isAlreadyCalled) {
        
        [self sendRequestToGetDriverDetails:email :bookingDate :bookingId];
    }
}

-(void)changeContentOfPresentController:(NSNotification *)notification {
    
    
    //TODO:: Add new code
    [DropOffViewForConfirmScreen removeFromSuperview];
     DropOffViewForConfirmScreen = nil;
    
    
    if ([notification.name isEqualToString:@"JOBCOMPLETED"]) {
        
        _isDriverOnTheWay = NO;
        _isDriverArrived = NO;
        isRequestingButtonClicked = NO;
        docCount = 0;
        [mapView_ clear];
        [self removeDriverDetailScreen];
        actual = 1;
        //First unsubscribe to the channel you are listening to,then clear all the array contents so that the map will launch freshly
        [self unSubsCribeToPubNubChannels:_arrayOFDriverChannels];
        if (subscribedChannel.length != 0) {
            NSArray *arrChn = [[NSArray alloc]initWithObjects:subscribedChannel, nil];
            [self unSubsCribeToPubNubChannels:arrChn];
        }
        
        [self clearUserDefaultsAfterBookingCompletion];
        [mapView_ clear];
        
        if (_arrayOFDriverChannels) {
            [_arrayOFDriverChannels removeAllObjects] ;
            _arrayOFDriverChannels = nil;
            [_arrayOfDriverEmail removeAllObjects] ;
            _arrayOfDriverEmail = nil;
            [_allMarkers removeAllObjects];
            _allMarkers = nil;
        }
        //[self addBottomView];
        _myAppTimerClassObj = [MyAppTimerClass sharedInstance];
        [_myAppTimerClassObj stopPublishTimer];
        [_myAppTimerClassObj stopEtaNDisTimer];
        [_myAppTimerClassObj startPublishTimer];
        
    }
    
    NSInteger bookingStatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"STATUSKEY"];
    
    if (bookingStatus == kNotificationTypeBookingOnMyWay) {
        
        if (!_isDriverOnTheWay) {
            
            _isDriverOnTheWay = YES;
            _isPathPlotted = NO;
            waypoints_ = [[NSMutableArray alloc]init];
            waypointStrings_ = [[NSMutableArray alloc]initWithCapacity:2];
            _patientPubNubChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientPubNubChannelkey];
            [mapView_ clear];
            
            [self subscribeOnlyBookedDriver];
            
            UIImageView *img = (UIImageView*)[self.view viewWithTag:curLocImgTag];
            img.hidden = YES;
            
            UIView *markerView =[self.view viewWithTag:myCustomMarkerTag];
            markerView.hidden = YES;
            
            UIView *bottomContainerView =[self.view viewWithTag:bottomViewWithCarTag];
            bottomContainerView.hidden = YES;
            
            UIView *topContainerView =[self.view viewWithTag:topViewTag];
            topContainerView.hidden = YES;
            
            //Add custom navigation to the viewcontroller
            [self addCustomNavigationBar];
            [self createDriverArrivedView];
            [self createDriverMessageShowingView:bookingStatus];
            
            NSUserDefaults *udLat = [NSUserDefaults standardUserDefaults];
            _currentLatitude =  [udLat doubleForKey:@"srcLat"];
            _currentLongitude = [udLat doubleForKey:@"srcLong"];
            
            [self setStartLocationCoordinates:_currentLatitude Longitude:_currentLongitude:2];
            [mapView_ animateToViewingAngle:35];
            GMSCameraPosition *srcLocation = [GMSCameraPosition cameraWithLatitude:_currentLatitude
                                                                         longitude:_currentLongitude
                                                                              zoom:15];
            [mapView_ setCamera:srcLocation];
            if (_driverCurLong == 0 && _driverCurLat == 0) {
                //do nothing
            }
            else {
                _isPathPlotted = NO;
                [self updateDestinationLocationWithLatitude:_driverCurLat Longitude:_driverCurLong];
            }
            [self sendRequestgetETAnDistance];
            _myAppTimerClassObj = [MyAppTimerClass sharedInstance];
            [_myAppTimerClassObj startEtaNDisTimer];
            
            
        }
        
    }
    else if (bookingStatus == kNotificationTypeBookingReachedLocation || bookingStatus == kNotificationTypeBookingStarted){
        
        if (!_isDriverArrived) {
            
            _isDriverArrived = YES;
            UIImageView *img = (UIImageView*)[self.view viewWithTag:curLocImgTag];
            img.hidden = YES;
            
            UIView *bottomContainerView =[self.view viewWithTag:bottomViewWithCarTag];
            bottomContainerView.hidden = YES;
            
            UIView *markerView =[self.view viewWithTag:myCustomMarkerTag];
            markerView.hidden = YES;
            
            UIView *topContainerView =[self.view viewWithTag:topViewTag];
            topContainerView.hidden = YES;
            
            UIView *driverView = [self.view viewWithTag:driverArrivedViewTag];
            [driverView removeFromSuperview];
            
            UILabel *driverMsgLabel = (UILabel *)[self.view viewWithTag:driverMessageViewTag];
            [driverMsgLabel removeFromSuperview];
            
            //Add custom navigation to the viewcontroller
            [self addCustomNavigationBar];
            [self createDriverArrivedView];
            [self createDriverMessageShowingView:bookingStatus];
            _isPathPlotted = NO;
            [mapView_ clear];
            waypoints_ = [[NSMutableArray alloc]init];
            waypointStrings_ = [[NSMutableArray alloc]initWithCapacity:2];
            
            NSUserDefaults *udLat = [NSUserDefaults standardUserDefaults];
            
            _driverCurLat = [udLat doubleForKey:@"desLat"];
            _driverCurLong = [udLat doubleForKey:@"desLong"];
            
            if(! (_driverCurLat == 0 || _driverCurLong == 0)) {
                
                [self setStartLocationCoordinates:_driverCurLat Longitude:_driverCurLong:3];
                
            }
            if(! (_currentLatitude == 0 || _currentLongitude == 0)) {
                
                CLLocationCoordinate2D position = CLLocationCoordinate2DMake(_currentLatitude,_currentLongitude);
                GMSMarker *destMarker = [GMSMarker markerWithPosition:position];
                destMarker.icon = [UIImage imageNamed:@"default_marker_p"];
                destMarker.map = mapView_;
                [self updateDestinationLocationWithLatitude:_currentLatitude Longitude:_currentLongitude];
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_currentLatitude
                                                                        longitude:_currentLongitude
                                                                             zoom:15];
                [mapView_ setCamera:camera];
            }
            
          //  For ETA n DISTANCE
//            _myAppTimerClassObj = [MyAppTimerClass sharedInstance];
//            [_myAppTimerClassObj stopEtaNDisTimer];
//            [self sendRequestgetETAnDistance];
//            [_myAppTimerClassObj startEtaNDisTimer];
//            [self subscribeOnlyBookedDriver];
            
        }
        else {
            [self addCustomNavigationBar];
        }
    }
    
    else {
        
        [mapView_ animateToViewingAngle:0];
        UIView *driverView = [self.view viewWithTag:driverArrivedViewTag];
        [driverView removeFromSuperview];
        
        UILabel *driverMsgLabel = (UILabel *)[self.view viewWithTag:driverMessageViewTag];
        [driverMsgLabel removeFromSuperview];
        
        UIImageView *img = (UIImageView*)[self.view viewWithTag:curLocImgTag];
        img.hidden = NO;
        
        UIView *markerView =[self.view viewWithTag:myCustomMarkerTag];
        markerView.hidden = NO;
        markerView.userInteractionEnabled = YES;
        //Add custom navigation to the viewcontroller
        [self addCustomNavigationBar];
        [self addCustomLocationView];
        [self createCenterView :@"SET PICKUP LOCATION"];
        
        [self getCurrentLocation];
        NSMutableArray *carTypes = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KUBERCarArrayKey]];
        
        _arrayOfCarTypes = [carTypes mutableCopy];
        if (_arrayOfCarTypes.count > 0)
        {
            [self addBottomView];
            if (carTypesForLiveBookingServer == 0) {
                carTypesForLiveBookingServer = [_arrayOfCarTypes[0][@"type_id"] integerValue];
            }
             carTypesForLiveBooking = 1;
            
        }
        [self publishPubNubStream];
        //[self contactButtonClicked:nil];
        
        if (isPopLockSelected) {
            
            DropOffViewForConfirmScreen.hidden=YES;
        }
        else{
            DropOffViewForConfirmScreen.hidden=NO;
        }

    }
}

-(void)buttonNowLaterClicked:(UIButton *)sender{
    
    UIButton *_buttonNow = (UIButton *)[[self.view viewWithTag:78] viewWithTag:2050];
    UIButton *_buttonLater = (UIButton *)[[self.view viewWithTag:78] viewWithTag:2051];
    
    UIButton *mBtn = (UIButton *)sender;
    if (sender.tag == 2050) {
        
        [mBtn setTitle:@"BOOK NOW" forState:(UIControlStateHighlighted) | (UIControlStateSelected)];
        [mBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
        [_buttonLater setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        
        [_buttonNow setSelected:YES];
        [_buttonLater setSelected:NO];
        isNowSelected = YES;
        isLaterSelected = NO;
    }
    else if(sender.tag == 2051){
        
        [mBtn setTitle:@"BOOK LATER" forState:(UIControlStateHighlighted) | (UIControlStateSelected)];
        [mBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
        [_buttonNow setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        [_buttonNow setSelected:NO];
        [_buttonLater setSelected:YES];
       //[self showDatePickerWithTitle:@"LATER BOOKING"];
        isNowSelected = NO;
        isLaterSelected = YES;
        
    }
}

-(UIView *)createCustomNavBar
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(90,20,160,44)];
    navView.backgroundColor = CLEAR_COLOR;
    navView.tag = 2052;
    UIButton *_buttonNow = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonNow.frame = CGRectMake(0,5,80,30);
    
    [Helper setButton:_buttonNow Text:@"BOOK NOW" WithFont:Trebuchet_MS FSize:13 TitleColor:UIColorFromRGB(0xffffff) ShadowColor:nil];
    _buttonNow.tag = 2050;
    [_buttonNow setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [_buttonNow setBackgroundImage:[UIImage imageNamed:@"conformation_btn_booknow_off"] forState:UIControlStateNormal];
    [_buttonNow setBackgroundImage:[UIImage imageNamed:@"conformation_btn_booknow_on"] forState:UIControlStateSelected];
    [_buttonNow addTarget:self action:@selector(buttonNowLaterClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonNow setSelected:YES];
    [navView addSubview:_buttonNow];
    
    UIButton *_buttonLater = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonLater.frame = CGRectMake(80,5,80,30);
    [Helper setButton:_buttonLater Text:@"BOOK LATER" WithFont:Trebuchet_MS FSize:13 TitleColor:UIColorFromRGB(0xffffff) ShadowColor:nil];
    _buttonLater.tag = 2051;
    [_buttonLater addTarget:self action:@selector(buttonNowLaterClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonLater setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [_buttonLater setBackgroundImage:[UIImage imageNamed:@"conformation_btn_booklater_off"] forState:UIControlStateNormal];
    [_buttonLater setBackgroundImage:[UIImage imageNamed:@"conformation_btn_booklater_on"] forState:UIControlStateSelected];
    
    [navView addSubview:_buttonLater];
    
    return navView;
}

//-(void)longpressToCancel:(UILongPressGestureRecognizer*)sender {
//    
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        //Do Whatever You want on End of Gesture
//    }
//    else if (sender.state == UIGestureRecognizerStateBegan){
//        
//        PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
//        reachability.target = self;
//        if ( [reachability isNetworkAvailable]) {
//            [self sendAppointmentRequestForLiveBookingCancellation];
//        }
//        else{
//            
//            [Helper showAlertWithTitle:@"Message" Message:@"No Network Connection"];
//        }
//        
//        [self removeAddProgressView];
//    }
//    
//}

-(void)singleTapAction:(UITapGestureRecognizer *)gesture {
    
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    reachability.target = self;
    if ( [reachability isNetworkAvailable]) {
        [self sendAppointmentRequestForLiveBookingCancellation];
    }
    else{
        
        [Helper showAlertWithTitle:@"Message" Message:@"No Network Connection"];
    }
    
    [self removeAddProgressView];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PubNub Methods
#pragma mark - PubNubWrapperDelegate

-(void)subsCribeToPubNubChannel:(NSString*)channel{
    
    pubNub = [PatientPubNubWrapper sharedInstance];
    [pubNub subscribeOnChannels:@[channel]];
    [pubNub setDelegate:self];
}

-(void)subsCribeToPubNubChannels:(NSArray *)channels{
    
    pubNub = [PatientPubNubWrapper sharedInstance];
    [pubNub subscribeOnChannels:channels];
    [pubNub setDelegate:self];
}
-(void)unSubsCribeToPubNubChannels:(NSArray *)channels {
    
    pubNub = [PatientPubNubWrapper sharedInstance];
    [pubNub unSubscribeOnChannels:channels];
    
    [pubNub setDelegate:self];
}

-(void)subscribeToPassengerChannel{
    
    pubNub = [PatientPubNubWrapper sharedInstance];
    
    _patientPubNubChannel = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUPatientPubNubChannelkey];
    
    [pubNub subscribeOnChannels:@[_patientPubNubChannel]];
    
    [pubNub setDelegate:self];
}
-(void)checkDifferenceBetweenTwoLocationAndUpdateCache {
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:newLat longitude:newLong];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:srcLat longitude:srcLong];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    if (distance > 50000) {
        
        carTypesForLiveBookingServer = 1;
        carTypesForLiveBooking = 1;
        isComingTocheckCarTypes = NO;
        [mapView_ clear];
        newLat = srcLat;
        newLong = srcLong;
    }
    
}

/**
 *  publishPubNubStream to receiving doctors near around patient current location
 */
-(void)publishPubNubStream {
    
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    
    if ( [reachability isNetworkAvailable]) {
        
        NSDictionary *message=nil;
        
        if (isPopLockSelected) {
            
            //For PopLock functionality
            
            message = @{@"a":[NSNumber numberWithInt:kPubNubStartStreamAction],
                                      @"pid": _patientEmail,
                                      @"lt": [NSNumber numberWithDouble:srcLat],
                                      @"lg": [NSNumber numberWithDouble:srcLong],
                                      @"chn": _patientPubNubChannel,
                                      @"st": [NSNumber numberWithInt:kAppointmentTypeNow],
                                      @"tp":[NSNumber numberWithInteger:carTypesForLiveBookingServer],
                                      @"rq_tp":[NSNumber numberWithInt:1],
                                    };
            

            
        }
        else{
            
            //For normal ride functionality
            
            message = @{@"a":[NSNumber numberWithInt:kPubNubStartStreamAction],
                                      @"pid": _patientEmail,
                                      @"lt": [NSNumber numberWithDouble:srcLat],
                                      @"lg": [NSNumber numberWithDouble:srcLong],
                                      @"chn": _patientPubNubChannel,
                                      @"st": [NSNumber numberWithInt:kAppointmentTypeNow],
                                      @"tp":[NSNumber numberWithInteger:carTypesForLiveBookingServer],
                                      
                                      };
            
        }
        
        if (!(srcLat == 0 || srcLong == 0)) {
            
            [self checkDifferenceBetweenTwoLocationAndUpdateCache];
            [pubNub sendMessageAsDictionary:message toChannel:_serverPubNubChannel];
        }
    }
    
}
-(void)publishAcknowledgePubNubStream:(NSInteger)Status BookingID:(NSInteger)bookingid {
    
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    
    if ( [reachability isNetworkAvailable]) {
        
        NSString *email = [[NSUserDefaults standardUserDefaults]objectForKey:KUDriverEmail];
        //pubnub initilization and subscribe to patient channel
        pubNub = [PatientPubNubWrapper sharedInstance];
        
        NSDictionary *message = @{@"a":[NSNumber numberWithInt:3],
                                  @"e_id":email,
                                  @"bid":[NSNumber numberWithInt:bookingid],
                                  @"st":[NSNumber numberWithInt:Status]
                                  };
        
        [pubNub sendMessageAsDictionary:message toChannel:_serverPubNubChannel];
        
    }
}

-(BOOL)checkCurrentStatus:(NSInteger)Status {
    
    NSInteger bookingStatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"STATUSKEY"];
    NSInteger newBookingStatus =   Status;
    
    if(bookingStatus != newBookingStatus && bookingStatus < newBookingStatus)
    {
        return NO;
    }
    else {
        return YES;
    }
}
-(BOOL)checkBookingID:(NSInteger)Status {
    
    NSInteger bookingID = [[NSUserDefaults standardUserDefaults] integerForKey:@"BOOKINGID"];
    NSInteger newBookingID =   Status;
    
    if(bookingID != newBookingID && bookingID < newBookingID)
    {
        return YES; //yes its a new booking
    }
    else {
        return NO; //old booking
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
-(BOOL)checkServiceCalledAtleastOnce {
    
    BOOL isCalledOnce = [[NSUserDefaults standardUserDefaults] boolForKey:@"isServiceCalledOnce"];
    
    if(isCalledOnce)
    {
        return YES;
    }
    else{
        return NO;
    }
    
}
-(void)messageA5ComesHere:(NSDictionary *)messageDict {
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isDriverCanceledBookingOnce"];
    BOOL isDriverCancel = [[NSUserDefaults standardUserDefaults]boolForKey:@"isDriverCanceledBookingOnce"];
    BOOL isAlreadyBooked = [self checkIfBokkedOrNot];
    BOOL isNewBooking = [self checkBookingID:[messageDict[@"bid"] integerValue]];
    if (isNewBooking) {
        if (isDriverCancel && isAlreadyBooked) {
            
            NSInteger bookingID = [[NSUserDefaults standardUserDefaults] integerForKey:@"BOOKINGID"];
            [self publishAcknowledgePubNubStream:5 BookingID:bookingID];
            
            [self clearUserDefaultsAfterBookingCompletion];
            int newBookingStatus =  10;
            
            NSDictionary *dictReason = @{@"r": messageDict[@"r"]};
            
            [(PatientAppDelegate*)[[UIApplication sharedApplication] delegate]noPushForceChangingController:dictReason :newBookingStatus];
        }
    }
    
}
-(void)messageA6ComesHere:(NSDictionary *)messageDict {
    
    BOOL isNewBooking = [self checkBookingID:[messageDict[@"bid"] integerValue]];
    if (isNewBooking) {
        
        [_allMarkers removeAllObjects];
        isRequestingButtonClicked = NO; //This is bool value for checking requesting button clicked or not
        docCount = 0; //This count is for calling service
        float latitude = [messageDict[@"lt"] floatValue];
        float longitude = [messageDict[@"lg"] floatValue];
        
        _driverCurLat = [messageDict[@"lt"] doubleValue];
        _driverCurLong = [messageDict[@"lg"] doubleValue];
        NSString *email = messageDict[@"e_id"];
        NSString *bookingDate = messageDict[@"dt"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        // [ud setObject:messageDict[@"rating"] forKey:@"Rating"];
        [ud setObject:messageDict[@"bid"] forKey:@"BOOKINGID"];
        [ud setObject:messageDict[@"ph"] forKey:@"DriverTelNo"];
        [ud setBool:YES forKey:kNSUIsPassengerBookedKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        BOOL isAlreadyCame = [self checkCurrentStatus:kNotificationTypeBookingOnMyWay];
        BOOL isAlreadyBooked = [self checkIfBokkedOrNot];
        
        if (isAlreadyCame && isAlreadyBooked) {
            //do nothing
//            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
//            [pi showMessage:@"Already On the way" On:self.view];
        }
        else if(!isAlreadyBooked) {
            
//            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
//            [pi showMessage:@"This Booking finished already(6)" On:self.view];
        }
        else {
            
            
            [ud setObject:email forKey:KUDriverEmail];
            [ud setObject:bookingDate forKey:KUBookingDate];
            [ud synchronize];
            BOOL isAlreadyCalled = [self checkServiceCalledAtleastOnce];
            if (!isAlreadyCalled) {
                
                [self sendRequestToGetDriverDetails:email :bookingDate :messageDict[@"bid"]];
                [self updateDestinationLocationWithLatitude:latitude Longitude:longitude];
            }
            NSInteger bookingID = [[NSUserDefaults standardUserDefaults] integerForKey:@"BOOKINGID"];
            [self publishAcknowledgePubNubStream:kNotificationTypeBookingOnMyWay BookingID:bookingID];
            
        }
    } //NewBooking
    
}
-(void)messageA7ComesHere:(NSDictionary *)messageDict {
    
    [_allMarkers removeAllObjects];
    float latitude = [messageDict[@"lt"] floatValue];
    float longitude = [messageDict[@"lg"] floatValue];
    
    _driverCurLat = [messageDict[@"lt"] doubleValue];
    _driverCurLong = [messageDict[@"lg"] doubleValue];
    
    
    BOOL isAlreadyCame = [self checkCurrentStatus:kNotificationTypeBookingReachedLocation];
    
    BOOL isAlreadyBooked = [self checkIfBokkedOrNot];
    
    if (isAlreadyCame && isAlreadyBooked) {
        
        //do nothing
//        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
//        [pi showMessage:@"Push status : Arrived" On:self.view];
    }
    else if(!isAlreadyBooked) {
        
//        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
//        [pi showMessage:@"This Booking finished already(6)" On:self.view];
    }
    else {
        
        [(PatientAppDelegate*)[[UIApplication sharedApplication] delegate]noPushForceChangingController:[NSDictionary dictionary] :kNotificationTypeBookingReachedLocation];
        [self updateDestinationLocationWithLatitude:latitude Longitude:longitude];
        NSInteger bookingID = [[NSUserDefaults standardUserDefaults] integerForKey:@"BOOKINGID"];
        [self publishAcknowledgePubNubStream:kNotificationTypeBookingReachedLocation BookingID:bookingID];
    }
    
    
    
}

-(void)messageA8ComesHere:(NSDictionary *)messageDict {
    
    [_allMarkers removeAllObjects];
    float latitude = [messageDict[@"lt"] floatValue];
    float longitude = [messageDict[@"lg"] floatValue];
    
    _driverCurLat = [messageDict[@"lt"] doubleValue];
    _driverCurLong = [messageDict[@"lg"] doubleValue];
    
    
    BOOL isAlreadyCame = [self checkCurrentStatus:kNotificationTypeBookingStarted];
    
    BOOL isAlreadyBooked = [self checkIfBokkedOrNot];
    
    if (isAlreadyCame && isAlreadyBooked) {
        
        //do nothing
//        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
//        [pi showMessage:@"Push status :Journey Started" On:self.view];
    }
    else if(!isAlreadyBooked) {
        
//        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
//        [pi showMessage:@"This Booking finished already(8)" On:self.view];
    }
    else {
        
        [(PatientAppDelegate*)[[UIApplication sharedApplication] delegate]noPushForceChangingController:[NSDictionary dictionary] :kNotificationTypeBookingStarted];
        [self updateDestinationLocationWithLatitude:latitude Longitude:longitude];
        NSInteger bookingID = [[NSUserDefaults standardUserDefaults] integerForKey:@"BOOKINGID"];
        [self publishAcknowledgePubNubStream:kNotificationTypeBookingStarted BookingID:bookingID];
    }
    
    
    
}
-(void)messageA9Comeshere:(NSDictionary *)messageDict {
    
    BOOL isNewBooking = [self checkBookingID:[messageDict[@"bid"] integerValue]];
    if (isNewBooking) {
        
        [_allMarkers removeAllObjects];
        _driverCurLat = [messageDict[@"lt"] doubleValue];
        _driverCurLong = [messageDict[@"lg"] doubleValue];
        
        BOOL isAlreadyCame = [self checkCurrentStatus:kNotificationTypeBookingComplete];
        
        BOOL isAlreadyBooked = [self checkIfBokkedOrNot];
        
        if (isAlreadyCame && isAlreadyBooked) {
            
            //do nothing
//            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
//            [pi showMessage:@"Push status : Completed" On:self.view];
        }
        else if(!isAlreadyBooked) {
            
//            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
//            [pi showMessage:@"This Booking finished already(9)" On:self.view];
        }
        else {
            
            [(PatientAppDelegate*)[[UIApplication sharedApplication] delegate]noPushForceChangingController:[NSDictionary dictionary] :kNotificationTypeBookingComplete];
        }
    }
    
}
-(void)messageA2ComeshereWithFlag1:(NSDictionary *)messageDict {
    
    [mapView_ clear];
    [self unSubsCribeToPubNubChannels:_arrayOFDriverChannels];
    [_arrayOFDriverChannels removeAllObjects] ;
    _arrayOFDriverChannels = nil;
    [_arrayOfDriverEmail removeAllObjects] ;
    _arrayOfDriverEmail = nil;
    [_allMarkers removeAllObjects] ;
    _allMarkers = nil;
    [self hideActivityIndicatorWithMessage];
    _myAppTimerClassObj = [MyAppTimerClass sharedInstance];
    [_myAppTimerClassObj stopSpinTimer];
    
}
-(void)messageA2ComeshereWithFlag0:(NSDictionary *)messageDict {
    
    if (!_arrayOFDriverChannels) {
        
        NSArray *channelsData = messageDict[@"masArr"];
        
        _arrayOFDriverChannels = [[NSMutableArray alloc] init];
        
        for(NSDictionary *dict in channelsData){
            [_arrayOFDriverChannels addObject:dict[@"chn"]];
            
        }
        
        doctors = [[NSMutableArray alloc] init];
        [doctors addObjectsFromArray:channelsData];
        [self addCustomMarkerFor:0];
        
        [self subsCribeToPubNubChannels:_arrayOFDriverChannels];
    }
    else {
        
        NSArray *channelsData = messageDict[@"masArr"];
        NSMutableArray *arrayNewChannels = [[NSMutableArray alloc] init];
        for(NSDictionary *dict in channelsData){
            [arrayNewChannels addObject:dict[@"chn"]];
        }
        
        if (_arrayOFDriverChannels.count > arrayNewChannels.count) {
            
            NSMutableArray *channelToRemove = [[NSMutableArray alloc] init];
            //need to remove one channel
            for(NSString *channel in _arrayOFDriverChannels){
                if ([arrayNewChannels containsObject:channel]) {
                    //do nothing
                }
                else {
                    
                    //remove channel
                    [channelToRemove addObject:channel];
                    GMSMarker *marker =  _allMarkers[channel];
                    [self removeMarker:marker];
                    [_allMarkers removeObjectForKey:channel];
                }
            }
            
            //unsubscribe removed channels
            [_arrayOFDriverChannels removeObjectsInArray:channelToRemove];
            [self unSubsCribeToPubNubChannels:channelToRemove];
        }
        else if (_arrayOFDriverChannels.count < arrayNewChannels.count) {
            //need to add new channel
            
            NSMutableArray *channelsToAdd = [[NSMutableArray alloc] init];
            for(NSString *channel in arrayNewChannels){
                if ([_arrayOFDriverChannels containsObject:channel]) {
                    //do nothing
                }
                else {
                    //add channel and subscribe here
                    [channelsToAdd addObject:channel];
                }
            }
            
            doctors = [[NSMutableArray alloc] init];
            [doctors addObjectsFromArray:channelsData];
            [self addCustomMarkerFor:0];
            [_arrayOFDriverChannels addObjectsFromArray:channelsToAdd];
            [self subsCribeToPubNubChannels:channelsToAdd];
        }
        else if (_arrayOFDriverChannels.count == arrayNewChannels.count) {
            //if channel count is same but the channel id is different
            
            NSMutableArray *channelsToAdd = [[NSMutableArray alloc] init];
            NSMutableArray *channelToRemove = [[NSMutableArray alloc] init];
            BOOL isOldArrayNeedToBeChanged = NO;
            for(NSString *channel in _arrayOFDriverChannels) {
                
                if ([arrayNewChannels containsObject:channel] == YES) {
                    //do nothing
                    
                } //if
                else {
                    //add channel and subscribe here
                    isOldArrayNeedToBeChanged = YES;
                    [channelToRemove addObject:channel];
                    GMSMarker *marker =  _allMarkers[channel];
                    [self removeMarker:marker];
                    [_allMarkers removeObjectForKey:channel];
                }
                
            }
            
            if (isOldArrayNeedToBeChanged == YES) {
                for(NSString *channel in arrayNewChannels){
                    
                    if ([_arrayOFDriverChannels containsObject:channel]) {
                        //do remove marker from map
                        
                    }
                    else {
                        //add channel and subscribe here
                        [channelsToAdd addObject:channel];
                        
                    } //else innermost
                }
                
                
                doctors = [[NSMutableArray alloc] init];
                [doctors addObjectsFromArray:channelsData];
                [self unSubsCribeToPubNubChannels:channelToRemove];
                [self subsCribeToPubNubChannels:channelsToAdd];
                [_arrayOFDriverChannels addObjectsFromArray:channelsToAdd];
                [_arrayOFDriverChannels removeObjectsInArray:channelToRemove];
                [self addCustomMarkerFor:0];
                
            }
            
        }//else if outer
        
    }
}

-(void)messageA2ForTesting:(NSDictionary *)messageDict {
    
    if (!_arrayOFDriverChannels) {
        _arrayOFDriverChannels = [[NSMutableArray alloc] init];
        _arrayOfMastersAround = messageDict[@"masArr"];
        for (int masArrIndex = 0;masArrIndex < _arrayOfMastersAround.count; masArrIndex++) {
            
            NSArray *channelsData = _arrayOfMastersAround[masArrIndex][@"mas"];
            for(NSDictionary *dict in channelsData){
                [_arrayOFDriverChannels addObject:dict[@"chn"]];
                
            }
        }
        
        doctors = [[NSMutableArray alloc] init];
        [doctors addObjectsFromArray:_arrayOfMastersAround[0][@"mas"]];
        
        if (doctors.count > 0) {
            
            id dis = _arrayOfMastersAround[0][@"mas"][0][@"d"];
            [self updateTheNearestDriverinSpinitCircle:dis];
            [self addCustomMarkerFor:0];
        }
        else {
            [self hideActivityIndicatorWithMessage];
        }
        [self subsCribeToPubNubChannels:_arrayOFDriverChannels];
    }
    else {
        
        NSArray *arrayOfNewDriversAround = messageDict[@"masArr"];
        NSMutableArray *arrayNewChannels = [[NSMutableArray alloc] init];
        for (int masArrIndex = 0;masArrIndex < arrayOfNewDriversAround.count; masArrIndex++) {
            
            NSArray *channelsData = arrayOfNewDriversAround[masArrIndex][@"mas"];
            for(NSDictionary *dict in channelsData){
                [arrayNewChannels addObject:dict[@"chn"]];
                
            }
        }
        _arrayOfMastersAround = [arrayOfNewDriversAround mutableCopy]; //update the array
        NSArray *arr = [[NSArray alloc]initWithArray:_arrayOfMastersAround[carTypesForLiveBooking-1][@"mas"]];
        if (arr.count > 0) {
            id dis = _arrayOfMastersAround[carTypesForLiveBooking-1][@"mas"][0][@"d"];
            [self updateTheNearestDriverinSpinitCircle:dis];
        }
        
        if (_arrayOFDriverChannels.count > arrayNewChannels.count) {
            
            NSMutableArray *channelToRemove = [[NSMutableArray alloc] init];
            //need to remove one channel
            for(NSString *channel in _arrayOFDriverChannels){
                if ([arrayNewChannels containsObject:channel]) {
                    //do nothing
                }
                else {
                    
                    //remove channel
                    [channelToRemove addObject:channel];
                    GMSMarker *marker =  _allMarkers[channel];
                    [self removeMarker:marker];
                    [_allMarkers removeObjectForKey:channel];
                }
            }
            
            //unsubscribe removed channels
            [_arrayOFDriverChannels removeObjectsInArray:channelToRemove];
            [self unSubsCribeToPubNubChannels:channelToRemove];
        }
        else if (_arrayOFDriverChannels.count < arrayNewChannels.count) {
            //need to add new channel
            
            NSMutableArray *channelsToAdd = [[NSMutableArray alloc] init];
            NSMutableArray *markerToAdd = [[NSMutableArray alloc] init];
            
            for(NSString *channel in arrayNewChannels){
                
                if ([_arrayOFDriverChannels containsObject:channel]) {
                    //do nothing
                }
                else {
                    //add channel and subscribe here
                    [channelsToAdd addObject:channel];
                    [markerToAdd addObjectsFromArray:arrayNewChannels];
                }
            }
            if (!doctors) {
                doctors = [[NSMutableArray alloc]init];
            }
            [doctors addObjectsFromArray:_arrayOfMastersAround[carTypesForLiveBooking-1][@"mas"]];
            
            [self addCustomMarkerFor:0];
            [_arrayOFDriverChannels addObjectsFromArray:channelsToAdd];
            [self subsCribeToPubNubChannels:channelsToAdd];
        }
        
    }
    
}


-(void)messageA2ComeshereWithDriverEmails:(NSDictionary *)messageDict {
    
    //This will come inside only when the requesting is not happening when the user will request this will stop coming inside so that the array of driver email list will be static
    
    NSArray *emailData = messageDict[@"es"][carTypesForLiveBooking-1][@"em"];
    
    if(!_arrayOfDriverEmail) { //For the first time when the array in not initialised copy all the data from the array
        _arrayOfDriverEmail = [emailData mutableCopy];
    }
    if (emailData.count != _arrayOfDriverEmail.count) { //when array count from server changes
        
        if(_arrayOfDriverEmail) {
            [_arrayOfDriverEmail removeAllObjects];
            _arrayOfDriverEmail = nil;
            _arrayOfDriverEmail = [emailData mutableCopy];
        }
        else {
            _arrayOfDriverEmail = [emailData mutableCopy];
        }
        
    }
    else if (emailData.count == _arrayOfDriverEmail.count){ //when array count from server is same
        
        if ([emailData isEqualToArray:_arrayOFDriverChannels]) {
            
        }
        else { //if the cotent is not same just copy the new array from the server
            
            [_arrayOfDriverEmail removeAllObjects];
            _arrayOfDriverEmail = nil;
            _arrayOfDriverEmail = [emailData mutableCopy];
            
        }
    }
}


-(void)messageA2ComeshereWithCarTypes:(NSDictionary *)messageDict {
    
    NSArray *carTypesArray = messageDict[@"types"];
    
    if (carTypesArray.count > 0) {
        
        if(!_arrayOfCarTypes) { //For the first time when the array in not initialised copy all the data from the array
            _arrayOfCarTypes = [carTypesArray mutableCopy];
            carTypesForLiveBookingServer = [messageDict[@"types"][0][@"type_id"] integerValue];
            [self handleTap:nil];
            [self addBottomView];
            
        }
        if (carTypesArray.count != _arrayOfCarTypes.count) { //when array count from server changes
            
            [_arrayOfCarTypes removeAllObjects];
            _arrayOfCarTypes = nil;
            _arrayOfCarTypes = [carTypesArray mutableCopy];
            carTypesForLiveBookingServer = [messageDict[@"types"][0][@"type_id"] integerValue];
            [self handleTap:nil];
            [self addBottomView];
            
        }
        else if (carTypesArray.count == _arrayOfCarTypes.count){ //when array count from server is same
            
            if ([carTypesArray isEqualToArray:_arrayOfCarTypes]) {
                
            }
            else { //if the cotent is not same just copy the new array from the server
                
                [_arrayOfCarTypes removeAllObjects];
                _arrayOfCarTypes = nil;
                _arrayOfCarTypes = [carTypesArray mutableCopy];
                carTypesForLiveBookingServer = [messageDict[@"types"][0][@"type_id"] integerValue];
                [self handleTap:nil];
                [self addBottomView];
                
            }
        }
        
    }
    else {
        
        if (!isComingTocheckCarTypes) {
            isComingTocheckCarTypes = YES;
            [_arrayOfCarTypes removeAllObjects];
            _arrayOfCarTypes = nil;
            [self handleTap:nil];
            [self addBottomView];
            for (UIView *va in [self.view subviews]) {
                
                if (va.tag == bottomViewWithCarTag) {
                    [va removeFromSuperview];
                }
            }
        }
        
        
    }
}
bool isComingTocheckCarTypes;

-(void)recievedMessage:(NSDictionary*)messageDict onChannel:(NSString*)channelName
{
    NSLog(@"%@",channelName);
    NSLog(@" %@",messageDict);
    //TELogInfo(@"recievedMessage %@ on channel %@",messageDict,channelName);
    
    if ([messageDict[@"a"] integerValue] == 5 && [messageDict[@"flag"] intValue] == 0) // driver cancel the booking
    {
        [self messageA5ComesHere:messageDict];
    }
    else if ([messageDict[@"a"] integerValue] == 6 && [messageDict[@"flag"] intValue] == 0) // driver is on the way
    {
        [self messageA6ComesHere:messageDict];
        
    }
    else if ([messageDict[@"a"] integerValue] == 7 && [messageDict[@"flag"] intValue] == 0) //driver is reached on pickup locaiton
    {
        [self messageA7ComesHere:messageDict];
    }
    else if ([messageDict[@"a"] integerValue] == 8 && [messageDict[@"flag"] intValue] == 0) //driver is reached on pickup locaiton
    {
        [self messageA8ComesHere:messageDict];
    }
    else if ([messageDict[@"a"] integerValue] == 9 && [messageDict[@"flag"] intValue] == 0) //booking complete
    {
        [self messageA9Comeshere:messageDict];
    }
    else if ([channelName isEqualToString:_patientPubNubChannel] && [messageDict[@"a"] intValue] == 2)  {
        
        if ([[messageDict objectForKey:@"flag"] intValue] == 1) //No channels
        {
            [self messageA2ComeshereWithFlag1:messageDict];
            
            //CarTypes Will come always irresective of the flag Value
            [self messageA2ComeshereWithCarTypes:messageDict];
            
        }
        else if ([[messageDict objectForKey:@"flag"] intValue] == 0) //success
        {
            //CarTypes Will come always irresective of the flag Value
            [self messageA2ComeshereWithCarTypes:messageDict];
            
            //For initializing the array with nearest drivers
            if(!isRequestingButtonClicked) {
                
                [self messageA2ComeshereWithDriverEmails:messageDict];
            }
            
            [self messageA2ForTesting:messageDict];            
        }
    }
    
    else if ([messageDict[@"a"] integerValue] == 4){ //getting drivers from pubnub
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kNSUIsPassengerBookedKey]) {
            
            float latitude = [messageDict[@"lt"] floatValue];
            float longitude = [messageDict[@"lg"] floatValue];
            
            _driverCurLat = [messageDict[@"lt"] doubleValue];
            _driverCurLong = [messageDict[@"lg"] doubleValue];
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(_driverCurLat,_driverCurLong);
            GMSCameraUpdate *locationUpdate = [GMSCameraUpdate setTarget:position];
            [mapView_ animateWithCameraUpdate:locationUpdate];
            
            [self updateDestinationLocationWithLatitude:latitude Longitude:longitude];
        }
        else{
            
            doctors = [NSMutableArray arrayWithObject:messageDict];
            [self addCustomMarkerFor:kRoadyoCarTwo];
            
        }
    }
    else{
        
    }
}

#pragma Mark- Path Plotting

/**
 *  Update Destination of an incoming Doctor
 *  Returns void and accept two arguments
 *  @param latitude  Doctor Latitude
 *  @param longitude incoming Doctor longitude
 */

-(void)updateDestinationLocationWithLatitude:(float)latitude Longitude:(float)longitude {
    
    if (!_isPathPlotted) {
        
        NSLog(@"pathplotted");
        _isPathPlotted = YES;
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude,longitude);
        
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

-(void)setStartLocationCoordinates:(float)latitude Longitude:(float)longitude :(int)type {
    
    //change map camera postion to current location
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:15];
    [mapView_ setCamera:camera];
    
    
    //add marker at current location
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    
    marker.map = mapView_;
    [waypoints_ addObject:marker];
    
    if (type == 2) {
        marker.icon = [UIImage imageNamed:@"default_marker_p"];
    }
    else {
        marker.icon = [UIImage imageNamed:@"default_marker_d"];
    }
    //save current location to plot direciton on map
    _startLocation = [NSString stringWithFormat:@"%.6f,%.6f",latitude, longitude];
    [waypointStrings_ insertObject:_startLocation atIndex:0];
    
}
-(void)subscribeOnlyBookedDriver{
    
    /*    here array count is checking app goes background or not
     because at that point of time it content will be zero so get the value from user default
     
     */
    
    if (_arrayOFDriverChannels) {
        
        if (_arrayOFDriverChannels.count > 0) {
            
            NSMutableArray *channelToRemove = [[NSMutableArray alloc] init];
            
            for(NSString *channel in _arrayOFDriverChannels){
                if  ([subscribedChannel isEqualToString:channel]) {
                    //do nothing
                    
                }
                else {
                    [channelToRemove addObject:channel];
                    GMSMarker *marker =  _allMarkers[channel];
                    [self removeMarker:marker];
                    [_allMarkers removeObjectForKey:channel];
                }
            }
            [_arrayOFDriverChannels removeObjectsInArray:channelToRemove];
            [self unSubsCribeToPubNubChannels:channelToRemove];
            
        }
    }
    else {
        subscribedChannel = [[NSUserDefaults standardUserDefaults] objectForKey:@"subscribedChannel"];
        if (subscribedChannel.length != 0) {
            
            [self subsCribeToPubNubChannel:subscribedChannel];
        }
        else {
            
            [self clearUserDefaultsAfterBookingCompletion];
            [self changeContentOfPresentController:nil];
        }

    }
}
- (void)addDirections:(NSDictionary *)json {
    
    if ([json[@"routes"] count]>0) {
        NSDictionary *routes = [json objectForKey:@"routes"][0];
        
        NSDictionary *route = [routes objectForKey:@"overview_polyline"];
        NSString *overview_route = [route objectForKey:@"points"];
        GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        [polyline setStrokeWidth:3.0];
        [polyline setStrokeColor:[UIColor blackColor]];
        polyline.map = mapView_;
    }
    
    
}

- (void)animateToNextCoord:(GMSMarker *)marker {
    
    CoordsList *coords = marker.userData;
    CLLocationCoordinate2D coord = [coords next];
    CLLocationCoordinate2D previous = marker.position;
    
    CLLocationDirection heading = GMSGeometryHeading(previous, coord);
    CLLocationDistance distance = GMSGeometryDistance(previous, coord);
    
    // Use CATransaction to set a custom duration for this animation. By default, changes to the
    // position are already animated, but with a very short default duration. When the animation is
    // complete, trigger another animation step.
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:(distance / (1 * 1000))];  // custom duration, 50km/sec
    
    __weak MapViewController *weakSelf = self;
    [CATransaction setCompletionBlock:^{
        [weakSelf animateToNextCoord:marker];
    }];
    
    marker.position = coord;
    
    [CATransaction commit];
    
    // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
    if (marker.flat) {
        marker.rotation = heading;
    }
}

-(void)didFailedToConnectPubNub:(NSError *)error{
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showMessage:[error localizedDescription] On:self.view];
    [self hideAcitvityIndicator];
}

-(void)addgestureToMap
{
    _tapInterceptor = [[WildcardGestureRecognizer alloc] init];
    __weak typeof(self) weakSelf = self;
    _tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event , int touchtype)
	{
        {
            if (touchtype == 1)
            {
                [weakSelf startAnimation];
            }
            else {
                
                [weakSelf endAnimation];
            }
        }
	};
    
	[mapView_  addGestureRecognizer:_tapInterceptor];
    
}


#pragma mark GMSMapviewDelegate -

- (void) mapView:(GMSMapView *) mapView willMove:(BOOL)gesture{
    
    if(PikUpViewForConfirmScreen && DropOffViewForConfirmScreen)
    {
            isLocationChanged = isFixed;
    }
    else
    {
        if(isFareButtonClicked == NO)
        {
            isLocationChanged = isChanging;
        }
        else
        {
            isFareButtonClicked = NO;
        }
    }
    
}

- (void) mapView:(GMSMapView *) mapView didChangeCameraPosition:(GMSCameraPosition *) position{
    
}

- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker{
    
}
- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker{
    isLocationChanged = isChanging;
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    
    NSInteger bookingStatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"STATUSKEY"];
    
    if ((bookingStatus == kNotificationTypeBookingOnMyWay) || (bookingStatus == kNotificationTypeBookingReachedLocation)) {
        
    }
    else{
        
        
        CGPoint point1 = mapView_.center;
        CLLocationCoordinate2D coor = [mapView_.projection coordinateForPoint:point1];
        _currentLatitude = coor.latitude;
        _currentLongitude = coor.longitude;
        
        if (_isAddressManuallyPicked) {
            _isAddressManuallyPicked = NO;
            return;
        }
        else {
            [self getAddress:coor];
            [self startSpinitAgain];
            
        }
        
    }
}
- (void) mapView:(GMSMapView *)	mapView didLongPressAtCoordinate:(CLLocationCoordinate2D) coordinate
{
    
}
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    return nil;
}

#pragma mark Custom Methods -

- (void)addCustomNavigationBar{
    
    NSInteger bookingStatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"STATUSKEY"];
    
    if(!customNavigationBarView)
    {
        customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
        customNavigationBarView.tag = 78;
        customNavigationBarView.delegate = self;
        [customNavigationBarView setTitle:@"HOME"];
        [customNavigationBarView setTintColor:[UIColor colorWithRed:246/255.0 green:206/255.0 blue:18/255.0 alpha:1]];
        [self.view addSubview:customNavigationBarView];
    }
    
    if(isCustomMarkerSelected == YES)
    {
        [[customNavigationBarView viewWithTag:2052] setHidden:YES];
        [customNavigationBarView setTitle:@"CONFIRMATION"];
        
    }
    else if (bookingStatus == kNotificationTypeBookingOnMyWay)
    {
        [[customNavigationBarView viewWithTag:2052] setHidden:YES];
        [customNavigationBarView setTitle:@"DRIVER ON THE WAY"];
    }
    else if (bookingStatus == kNotificationTypeBookingReachedLocation)
    {
        [[customNavigationBarView viewWithTag:2052] setHidden:YES];
        [customNavigationBarView setTitle:@"DRIVER REACHED"];
     
    }
    else if (bookingStatus == kNotificationTypeBookingStarted)
    {
        [[customNavigationBarView viewWithTag:2052] setHidden:YES];
        [customNavigationBarView setTitle:@"JOURNEY STARTED"];
      
    }
    else
    {
        
        UIButton *BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        BackButton.frame = CGRectMake(265,26,45,30);
        [Helper setButton:BackButton Text:@"BACK" WithFont:Oswald_Light FSize:17 TitleColor:[UIColor whiteColor]ShadowColor:nil];
        [BackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [BackButton setShowsTouchWhenHighlighted:YES];
        [BackButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
        [BackButton addTarget:self action:@selector(BackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        BackButton.tag = 111100;
        [customNavigationBarView addSubview:BackButton];
        [[customNavigationBarView viewWithTag:2052] setHidden:NO];
        [self.view addSubview:customNavigationBarView];
        [customNavigationBarView setTitle:@"TRACK DRIVER"];
        [customNavigationBarView setBackgroundColor:BUTTON_NG_Color];
        
        
        
    }
    
    
}

-(void)BackButtonClicked{
    
   
    if(isCustomMarkerSelected == YES)
    {
        [self navCancelButtonClciked];
    }
     [self createMainView];
    
}

-(void)addCustomLocationView
{
    UIView *vb = [self.view viewWithTag:topViewTag];
    NSArray *arr = self.view.subviews;
    
    if (![arr containsObject:vb]) {
        
        UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 44)];
        customView.backgroundColor = [UIColor whiteColor];
        customView.tag = topViewTag;
        [customView setHidden:NO];
        customView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_locationbar.png"]];
        
        UIButton *buttonSearchLoc = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonSearchLoc.frame = CGRectMake(2, 44/2 - 45/2,45,45);
        buttonSearchLoc.tag = 91;
        [Helper setButton:buttonSearchLoc Text:@"" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor blackColor] ShadowColor:nil];
        [buttonSearchLoc setImage:[UIImage imageNamed:@"home_search.png"] forState:UIControlStateNormal];
        [buttonSearchLoc addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:buttonSearchLoc];
        
        UILabel *labelPickUp = [[UILabel alloc]initWithFrame:CGRectMake(customView.frame.size.width/2-120/2,0,120,20)];
        [Helper setToLabel:labelPickUp Text:@"Pickup Location" WithFont:Trebuchet_MS FSize:10 Color:WHITE_COLOR];
        labelPickUp.textAlignment = NSTextAlignmentCenter;
        [customView addSubview:labelPickUp];
        
        _textFeildAddress = [[UITextField alloc]initWithFrame:CGRectMake(50,20,215,22)];
        _textFeildAddress.placeholder = @"Location";
        _textFeildAddress.tag = 101;
        _textFeildAddress.enabled = NO;
        _textFeildAddress.delegate = self;
        _textFeildAddress.textAlignment = NSTextAlignmentCenter;
        _textFeildAddress.font = [UIFont fontWithName:Trebuchet_MS size:10];
        [customView addSubview:_textFeildAddress];
        
        
        UIButton *buttonCurrentLocation = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCurrentLocation.frame = CGRectMake(270,44/2 -45/2,45,45);
        buttonCurrentLocation.tag = 102;
        [buttonCurrentLocation setBackgroundImage:[UIImage imageNamed:@"home_currentlocation_off.png"] forState:UIControlStateNormal];
        [buttonCurrentLocation setBackgroundImage:[UIImage imageNamed:@"home_currentlocation_on.png"] forState:UIControlStateSelected];
        [buttonCurrentLocation addTarget:self action:@selector(getCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:buttonCurrentLocation];
        
        [self.view addSubview:customView];
        
        
        //TODO::DROPOFF LOCATION CHANGES
        [self addCustomLocationDropOffViewForConfirmScreen];
        
        //TODO::TILL HERE
    }
    
}
/**
 *  after the completion of request submission the view in again bring into picture as it was hidden during the time of creating pikupviewcontroller
 */
-(void)requestSubmittedAddthelocationView
{
    UIView *LV = [self.view viewWithTag:topViewTag];
    [LV setHidden:NO];
    CGRect RTEC = LV.frame;
    RTEC.origin.y = 64;
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         LV.frame = RTEC;
                     }
                     completion:^(BOOL finished){
                     }];
    [self startAnimation];
    
}

/**
 *  add another view that will open after clicking setpickup location on map
 */

-(void)addCustomLocationPikUpViewForConfirmScreen
{
    if(!PikUpViewForConfirmScreen)
    {
        PikUpViewForConfirmScreen = [[UIView alloc]initWithFrame:CGRectMake(0,64,320,0)];
        PikUpViewForConfirmScreen.backgroundColor = [UIColor whiteColor];
        PikUpViewForConfirmScreen.tag = 150;
        PikUpViewForConfirmScreen.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_locationbar.png"]];

        CGRect basketTopFrame = PikUpViewForConfirmScreen.frame;
        basketTopFrame.size.height = 44;
        UIImageView *imgStr = [[UIImageView alloc]initWithFrame:CGRectMake(5,0, 45, 45)];
        imgStr.image =  [UIImage imageNamed:@"conformation_icn_currentlocation"];
        [PikUpViewForConfirmScreen addSubview:imgStr];
        
        UILabel *labelPickUp = [[UILabel alloc]initWithFrame:CGRectMake(PikUpViewForConfirmScreen.frame.size.width/2-120/2,0,120,20)];
        [Helper setToLabel:labelPickUp Text:@"Pickup Location" WithFont:Trebuchet_MS FSize:10 Color:WHITE_COLOR];
        labelPickUp.textAlignment = NSTextAlignmentCenter;
        [PikUpViewForConfirmScreen addSubview:labelPickUp];
        
        UITextField *pickUpAddress = [[UITextField alloc]initWithFrame:CGRectMake(50,2,215, 42)];
        pickUpAddress.placeholder = @"Current Location";
        pickUpAddress.tag = pickupAddressTag;
        pickUpAddress.enabled = NO;
        pickUpAddress.delegate = self;
        pickUpAddress.textAlignment = NSTextAlignmentCenter;
        pickUpAddress.font = [UIFont fontWithName:Trebuchet_MS size:10];
        [PikUpViewForConfirmScreen addSubview:pickUpAddress];
        
        UIButton *pickUpAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pickUpAddressButton.frame = CGRectMake(50,2,215, 42);
        pickUpAddressButton.tag = 155;
        //[buttonCurrentLocation setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
        [pickUpAddressButton addTarget:self action:@selector(pickupLocationAction:) forControlEvents:UIControlEventTouchUpInside];
        [PikUpViewForConfirmScreen addSubview:pickUpAddressButton];
        

        UIButton *addDropLocButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addDropLocButton.frame = CGRectMake(280,11,30,30);
        addDropLocButton.tag = 151;
        [Helper setButton:addDropLocButton Text:@"+" WithFont:Trebuchet_MS FSize:25.0f TitleColor:[UIColor blackColor] ShadowColor:nil];
        [addDropLocButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [addDropLocButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
        [addDropLocButton addTarget:self action:@selector(plusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [PikUpViewForConfirmScreen addSubview:addDropLocButton];
        
        [UIView animateWithDuration:0.3
                              delay:0.2
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             // basketTop.frame = basketTopFrame;
                             // basketBottom.frame = basketBottomFrame;
                             // LV.frame = RTEC;
                             PikUpViewForConfirmScreen.frame = basketTopFrame;
                         }
                         completion:^(BOOL finished){
                         }];
        
        UIView *cuView = [self.view viewWithTag:topViewTag];
        UITextField *textAddress = (UITextField *)[cuView viewWithTag:101];
        pickUpAddress.text =  textAddress.text;
        srcAddr = pickUpAddress.text;
        {
            _currentLatitudeFare = _currentLatitude;
            _currentLongitudeFare =  _currentLongitude;
            
        }
        [self.view addSubview:PikUpViewForConfirmScreen];
        
        /**
         *  Remove Location View From superview Add it again if Required
         *  / ADDED IN CANCELBUTTONCLICKED AND AFTER GETTING THE RESPONSE
         */
        UIView *customLocationView = [self.view viewWithTag:topViewTag];
        [customLocationView removeFromSuperview];
    }
    
}

/**
 *  Adding View For After clicking "+" button on PickUp location Label
 */
-(void)addCustomLocationDropOffViewForConfirmScreen
{
    if(!DropOffViewForConfirmScreen)
    {
        DropOffViewForConfirmScreen = [[UIView alloc]initWithFrame:CGRectMake(0,64,320,44)];
        DropOffViewForConfirmScreen.backgroundColor = [UIColor whiteColor];
        DropOffViewForConfirmScreen.tag = 160;
        DropOffViewForConfirmScreen.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_locationbar.png"]];
        
        CGRect basketTopFrame = DropOffViewForConfirmScreen.frame;
        basketTopFrame.origin.y = 108;
        
        
            
            UIImageView *imgStr = [[UIImageView alloc]initWithFrame:CGRectMake(5,0, 45, 45)];
            imgStr.image =  [UIImage imageNamed:@"conformation_icn_dropoff"];
            [DropOffViewForConfirmScreen addSubview:imgStr];
            UILabel *labelPickUp = [[UILabel alloc]initWithFrame:CGRectMake(DropOffViewForConfirmScreen.frame.size.width/2-120/2,0,120,20)];
            [Helper setToLabel:labelPickUp Text:@"Dropoff Location" WithFont:Trebuchet_MS FSize:10 Color:WHITE_COLOR];
            labelPickUp.textAlignment = NSTextAlignmentCenter;
            [DropOffViewForConfirmScreen addSubview:labelPickUp];
            UITextField *pickUpAddress = [[UITextField alloc]initWithFrame:CGRectMake(50,2,215, 42)];
            pickUpAddress.placeholder = @"DropOff Location";
            pickUpAddress.tag = 161;
            pickUpAddress.enabled = NO;
            pickUpAddress.delegate = self;
            pickUpAddress.textAlignment = NSTextAlignmentCenter;
            pickUpAddress.font = [UIFont fontWithName:Trebuchet_MS size:10];
            [DropOffViewForConfirmScreen addSubview:pickUpAddress];
            
            UIButton *addDropLocButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addDropLocButton.frame = CGRectMake(280,11,30,30);
            addDropLocButton.tag = 162;
            [Helper setButton:addDropLocButton Text:@"+" WithFont:Trebuchet_MS FSize:25.0f TitleColor:[UIColor blackColor] ShadowColor:nil];
            [addDropLocButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [addDropLocButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
            [addDropLocButton addTarget:self action:@selector(plusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [DropOffViewForConfirmScreen addSubview:addDropLocButton];
            

        
        
        UIButton *pickUpAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pickUpAddressButton.frame = CGRectMake(50,2,215, 42);
        pickUpAddressButton.tag = 165;
        //[buttonCurrentLocation setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
        [pickUpAddressButton addTarget:self action:@selector(pickupLocationAction:) forControlEvents:UIControlEventTouchUpInside];
        [DropOffViewForConfirmScreen addSubview:pickUpAddressButton];
        
        
            [UIView animateWithDuration:0.3
                              delay:0.2
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             // basketTop.frame = basketTopFrame;
                             // basketBottom.frame = basketBottomFrame;
                             DropOffViewForConfirmScreen.frame = basketTopFrame;
                         }
                         completion:^(BOOL finished){
                         }];
        [self.view addSubview:DropOffViewForConfirmScreen];
        
    }
    
}
/**
 *  Add thid view for showing current position and a Button to choose pcikup location
 *
 */
-(void)createCenterView : (NSString *)text{
    
    UIView *alreadyContains = [self.view viewWithTag:curLocImgTag];
    NSArray *arr = self.view.subviews;
    UIView *buttonView = [self.view viewWithTag:myCustomMarkerTag];
    
    if([arr containsObject:buttonView]){
        NSInteger anIndex = [arr indexOfObject :buttonView];
        NSArray * buttonSubviewArr   = [[arr objectAtIndex:anIndex] subviews];
        if([[buttonSubviewArr objectAtIndex:0] isKindOfClass:[UIButton class]]){
        UIButton *button = [buttonSubviewArr objectAtIndex:0];
        [button setTitle:text forState:UIControlStateNormal];
        }else{
            UIButton *button = [buttonSubviewArr objectAtIndex:1];
            [button setTitle:text forState:UIControlStateNormal];
        }
    }
    
    
    
    if (![arr containsObject:alreadyContains]) {
    
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 25/2,(mapView_.frame.size.height/2)-22, 25, 33)];
        img.image = [UIImage imageNamed:@"map_icn_currentlocation"];
        img.tag = curLocImgTag;
        [img setHidden:NO];
        [self.view addSubview:img];
        
        
        UIView *customMarkerview = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-231/2,(self.view.frame.size.height/2)-70,231,43)];
        customMarkerview.tag = myCustomMarkerTag;
        [customMarkerview setUserInteractionEnabled:NO];
        [customMarkerview setHidden:NO];
        UIButton *customMarkerTopBottom = [UIButton buttonWithType:UIButtonTypeCustom];
        customMarkerTopBottom.frame = CGRectMake(0, 0, 231, 43);
        UIImage *selImage = [UIImage imageNamed:@"home_pickuplocation_bg_on.png"];
        UIImage *norImage = [UIImage imageNamed:@"home_pickuplocation_bg.png"];
        [customMarkerTopBottom setBackgroundImage:selImage forState:UIControlStateHighlighted];
        [customMarkerTopBottom setBackgroundImage:norImage forState:UIControlStateNormal];
        [customMarkerTopBottom addTarget:self action:@selector(customMarkerTopBottomClicked) forControlEvents:UIControlEventTouchUpInside];
        customMarkerTopBottom.userInteractionEnabled = YES;
        [customMarkerview addSubview:customMarkerTopBottom];
        
       
        [Helper setButton:customMarkerTopBottom Text:text WithFont:Trebuchet_MS FSize:13 TitleColor:UIColorFromRGB(0xffffff) ShadowColor:nil];
        
        
        [customMarkerTopBottom setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [customMarkerTopBottom setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateHighlighted];
        customMarkerTopBottom.titleLabel.textAlignment = NSTextAlignmentRight;
        customMarkerTopBottom.titleEdgeInsets = UIEdgeInsetsMake(-5,20,0,0);
        
        customMarkerTopBottom.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        customMarkerTopBottom.imageEdgeInsets = UIEdgeInsetsMake(-5,200,0,0);
        
        [customMarkerTopBottom setImage:[UIImage imageNamed:@"map_arrow"] forState:UIControlStateNormal];
        [customMarkerTopBottom setImage:[UIImage imageNamed:@"map_arrow"] forState:UIControlStateHighlighted];
        
        
        _spinnerView = [[UIView alloc] initWithFrame:CGRectMake(5,5, 30, 30)];
        _spinnerView.backgroundColor = [UIColor clearColor];
        _spinnerView.tag = msgLabelTag;
        [customMarkerview addSubview:_spinnerView];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5,5, 20, 20)];
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [activityIndicator startAnimating];
        activityIndicator.tag = 200;
        [_spinnerView addSubview:activityIndicator];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(2,0,30, 30)];
        messageLabel.tag = 100;
        messageLabel.numberOfLines = 2;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.hidden = YES;
        [Helper setToLabel:messageLabel Text:@"" WithFont:HELVETICANEUE_LIGHT FSize:10 Color:[UIColor whiteColor]];
        [_spinnerView addSubview:messageLabel];
        
        
        customMarkerview.backgroundColor = CLEAR_COLOR;
        [self.view addSubview:customMarkerview];
    }
    else{
        
    }
}

-(void)startSpinitAgain {
    _myAppTimerClassObj = [MyAppTimerClass sharedInstance];
    [_myAppTimerClassObj startSpinTimer];
    [self shoActivityIndicator];
}
-(void)updateTheNearestDriverinSpinitCircle:(id)disTance {
    
    _myAppTimerClassObj = [MyAppTimerClass sharedInstance];
    [_myAppTimerClassObj stopSpinTimer];
    [self hideAcitvityIndicator];
    id dis = disTance;
    distanceOfClosetCar = [dis floatValue];
    
    float milesData = [dis floatValue]/distanceMetric;
    NSLog(@"milesData= %f",milesData);
    
    strDistance = [NSString stringWithFormat:@"%.3f Miles",milesData];
    [lbl4 setText:[NSString stringWithFormat:@"%@",strDistance]];
    
    NSInteger distanceInTime = ((milesData * 1609.34f) / 11.11);// 40k/h assume
    NSLog(@"distanceInTime= %ld",(long)distanceInTime);
    
    UILabel *msgLabel = (UILabel *)[[[self.view viewWithTag:myCustomMarkerTag] viewWithTag:msgLabelTag] viewWithTag:100];
    
    if(distanceInTime < 60){
        
        [msgLabel setText:[NSString stringWithFormat:@"0\n MIN"]];
        
    }
    else if(distanceInTime >= 60 && distanceInTime < 3600){
        
        distanceInTime = distanceInTime/60;
        [msgLabel setText:[NSString stringWithFormat:@"%ld\n MIN",distanceInTime]];
        
    }
    else if(distanceInTime >= 3660){
        
        distanceInTime = distanceInTime/3600;
        [msgLabel setText:[NSString stringWithFormat:@"%ld\n HR",distanceInTime]];
    }
    
    
    NSLog(@"%@",msgLabel.text);

    
}

-(void)hideAcitvityIndicator {
    
    UIView *markerView = (UIView *)[self.view viewWithTag:myCustomMarkerTag];
    [markerView setUserInteractionEnabled:YES];
    UILabel *msgLabel = (UILabel *)[[[self.view viewWithTag:myCustomMarkerTag] viewWithTag:msgLabelTag] viewWithTag:100];
    UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[[[self.view viewWithTag:myCustomMarkerTag] viewWithTag:msgLabelTag] viewWithTag:200];
    msgLabel.hidden = NO;
    indicatorView.hidden = YES;
}

-(void)shoActivityIndicator {
    
    UIView *markerView = (UIView *)[self.view viewWithTag:myCustomMarkerTag];
    [markerView setUserInteractionEnabled:NO];
    UILabel *msgLabel = (UILabel *)[[[self.view viewWithTag:myCustomMarkerTag] viewWithTag:msgLabelTag] viewWithTag:100];
    UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[[[self.view viewWithTag:myCustomMarkerTag] viewWithTag:msgLabelTag] viewWithTag:200];
    msgLabel.hidden = YES;
    indicatorView.hidden = NO;
    
}

-(void)hideActivityIndicatorWithMessage{
    UILabel *msgLabel = (UILabel *)[[[self.view viewWithTag:myCustomMarkerTag] viewWithTag:msgLabelTag] viewWithTag:100];
    msgLabel.hidden = NO;
    [msgLabel setText:[NSString stringWithFormat:@"No Drivers"]];
    [self hideAcitvityIndicator];
    
    
    strDistance = @"---";
    [lbl4 setText:[NSString stringWithFormat:@"%@",strDistance]];
    
}

- (void)animateInBottomView
{
    UIView *bottomView = [self.view viewWithTag:bottomViewWithCarTag];
    CGRect frameTopview = bottomView.frame;
    frameTopview.origin.y = self.view.bounds.size.height - 50;
    
    [UIView animateWithDuration:0.6f animations:^{
        bottomView.frame = frameTopview;
    }];
}

- (void)animateOutBottomView
{
    UIView *bottomView = [self.view viewWithTag:bottomViewWithCarTag];
    CGRect frameTopview = bottomView.frame;
    frameTopview.origin.y = self.view.bounds.size.height+20;
    
    [UIView animateWithDuration:0.6f animations:^{
        bottomView.frame = frameTopview;
    }];
}

/**
 *  add bottom view on map for the selection of Medical specialist
 */
- (void) addBottomView
{
    //NSMutableArray *carTypes = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KUBERCarArrayKey]];
    
    carTypesArrayCountValue = _arrayOfCarTypes.count;
    if (carTypesArrayCountValue == 0) {
        
        [Helper showAlertWithTitle:@"Message" Message:@"Sorry we are not availabe in your area at the moment."];
    }
    else {
        
        for (UIView *va in [self.view subviews]) {
            
            if (va.tag == bottomViewWithCarTag) {
                [va removeFromSuperview];
            }
        }
        
        UIView *customBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+20,320,60)];
    
        
         customBottomView.backgroundColor = BG_Color;
        
        customBottomView.tag = bottomViewWithCarTag;
        [customBottomView setHidden:NO];
        [self.view addSubview:customBottomView];
        
        
//        UIButton *CarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        CarButton.frame = CGRectMake(5,5,310,40);
//        //[CardButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_pickup_bg_on.png"] forState:UIControlStateNormal];
//        [CarButton setBackgroundColor:BUTTON_BG_Color];
//        [Helper setButton:CarButton Text:@"Change Car Types" WithFont:Trebuchet_MS FSize:18.0f TitleColor:[UIColor whiteColor] ShadowColor:nil];
//        [CarButton addTarget:self action:@selector(changeCarTypes:) forControlEvents:UIControlEventTouchUpInside];
//        CarButton.tag = 1111;
//        [CarButton setShowsTouchWhenHighlighted:YES];
//        
//        CarButton.layer.borderWidth=1.0f;
//        CarButton.layer.borderColor=[UIColor whiteColor].CGColor;
//        [customBottomView addSubview:CarButton];
        
        
        //TODO :: Add a single button
        
        
        NSDictionary *dict = [[NSDictionary alloc]init];
        
        UIImageView *carImageView;
        
        int xStartPoint = 12;
        int xOffset,tagValue = 180;
        UIImage *BgImg = [UIImage imageNamed:@"home_carinfo_timeslider"];
        switch (carTypesArrayCountValue) {
            case 1:{
                xStartPoint = 130;
                xOffset = 0;
                BgImg = nil;
                
                carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(150,13,40,40)];
                
            }
                break;
                
            case 2:{
                xOffset = 210;
                BgImg = [UIImage imageNamed:@"home_carinfo_timeslider"];
                if (carTypesForLiveBooking == 1) {
                    carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30,13,40,40)];
                }
                else {
                    carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260,13,40,40)];
                }
            }
                break;
                
            case 3:{
                xOffset = 120;
                BgImg = [UIImage imageNamed:@"home_carinfo_timeslider_three"];
                if (carTypesForLiveBooking == 1) {
                    carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30,13,40,40)];
                }
                else  if (carTypesForLiveBooking == 2) {
                    carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(150,13,40,40)];
                }
                else {
                    carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260,13,40,40)];
                }
            }
                break;
            case 4:{
                xOffset = 75;
                BgImg = [UIImage imageNamed:@"home_carinfo_timeslider_four"];
                if (carTypesForLiveBooking == 1) {
                    carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30,13,40,40)];
                }
                else  if (carTypesForLiveBooking == 2) {
                    carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(105,13,40,40)];
                }
                else  if (carTypesForLiveBooking == 3) {
                    carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(180,13,40,40)];
                }
                else {
                    carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260,13,40,40)];
                }
            }
                break;
            default:
                break;
        }
        
        //TODO:: HERE I WRITTEN CODE
        NSDictionary *dictionaryForFirstCar = [_arrayOfCarTypes objectAtIndex:0];
        NSString *strMaxVal = [NSString stringWithFormat:@"%@",[dictionaryForFirstCar valueForKey:@"max_size"]];
        carMaximumCapacity = [strMaxVal integerValue];
        NSLog(@"%ld",(long)carMaximumCapacity);
        
        //TODO:: TILL HERE
    
        for(dict in _arrayOfCarTypes)
        {
            UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(xStartPoint,3,60,10)];
            carName.tag = tagValue;
            carName.text = [dict[@"type_name"] uppercaseString];
            [Helper setToLabel:carName Text:carName.text WithFont:Trebuchet_MS_Bold FSize:10 Color:BLACK_COLOR];
            carName.textAlignment = NSTextAlignmentCenter;
            [customBottomView addSubview:carName];
            xStartPoint = xStartPoint + xOffset;
            tagValue++;
        }
        
        UIView *straightLine = [[UIView alloc]initWithFrame:CGRectMake(40,30,240,10)];
        [customBottomView addSubview:straightLine];
        straightLine.backgroundColor = [UIColor colorWithPatternImage:BgImg];
        
        
        carImageView.image = [UIImage imageNamed:@"home_carinfo_caricon"];
        carImageView.tag = 10000;
        carImageView.userInteractionEnabled = YES;
        [customBottomView addSubview:carImageView];
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [carImageView addGestureRecognizer:singleTap];
        
        if (carTypesArrayCountValue > 1) {
            
            UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customBottomViewhandleTap:)];
            tapOnView.numberOfTapsRequired = 1;
            [customBottomView addGestureRecognizer:tapOnView];
            
            UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [carImageView addGestureRecognizer:panGest];
        }
        
        [self animateInBottomView];
    }
    
}

//TO:: DO:: for Ride Later

-(IBAction)rideLatercall:(id)sender{
    
    UIView *customView = [self.view viewWithTag:160];
    UITextField *textAddress = (UITextField *)[customView viewWithTag:161];
    NSLog(@"%@",textAddress.text);
    if(textAddress.text.length == 0){
        
        [Helper showAlertWithTitle:@"Message" Message:@"Please select DropOff Location first."];
        return;
    }
    else{
    
    viewCarTypes = [[UIView alloc] init];
    CGRect rect = self.view.frame;
    rect.size.height = rect.size.height;
    [viewCarTypes setTag:myCarTypesTag];
    [viewCarTypes setFrame:rect];
    [viewCarTypes setBackgroundColor:BG_Color];
    
    
    UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame = CGRectMake(270,5,40,40);
    //[CardButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_pickup_bg_on.png"] forState:UIControlStateNormal];
    [crossButton setBackgroundColor:NavBarTint_Color];
    [Helper setButton:crossButton Text:@"X" WithFont:Trebuchet_MS FSize:25.0f TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [crossButton addTarget:self action:@selector(crossPressed:) forControlEvents:UIControlEventTouchUpInside];
    [crossButton setShowsTouchWhenHighlighted:YES];
    [viewCarTypes addSubview:crossButton];
    
    
    UIView *viewSelectCarTypes = [[UIView alloc] initWithFrame:CGRectMake(10,70,290,40)];
    [viewSelectCarTypes setBackgroundColor:[UIColor whiteColor]];
    txtfCarTypes = [[UITextField alloc] initWithFrame:CGRectMake(0,0,290, 40)];
    [txtfCarTypes setBackgroundColor:[UIColor clearColor]];
    [txtfCarTypes setTextAlignment:NSTextAlignmentCenter];
    [txtfCarTypes setBackground:[UIImage imageNamed:@"LogIn-Text-Bg.png"]];
    [txtfCarTypes setDelegate:self];
    [txtfCarTypes setPlaceholder:@"Select Date"];
    [txtfCarTypes setText:@""];
    [viewSelectCarTypes addSubview:txtfCarTypes];
    [viewCarTypes addSubview:viewSelectCarTypes];
    
    UIView *viewSelectTime = [[UIView alloc] initWithFrame:CGRectMake(10,120,290,40)];
    [viewSelectTime setBackgroundColor:[UIColor whiteColor]];
    txtftime = [[UITextField alloc] initWithFrame:CGRectMake(0,0,290, 40)];
    [txtftime setBackgroundColor:[UIColor clearColor]];
    [txtftime setTextAlignment:NSTextAlignmentCenter];
    [txtftime setBackground:[UIImage imageNamed:@"LogIn-Text-Bg.png"]];
    [txtftime setDelegate:self];
    [txtftime setPlaceholder:@"Select Time"];
    [txtftime setText:@""];
    [viewSelectTime addSubview:txtftime];
    [viewCarTypes addSubview:viewSelectTime];
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0,self.view.frame.size.height-40,self.view.frame.size.width,40);
    //[CardButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_pickup_bg_on.png"] forState:UIControlStateNormal];
    [submitButton setBackgroundColor:BUTTON_BG_Color];
    [Helper setButton:submitButton Text:@"SUBMIT" WithFont:Trebuchet_MS FSize:15.0f TitleColor:[UIColor blackColor] ShadowColor:nil];
    [submitButton addTarget:self action:@selector(submitbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setShowsTouchWhenHighlighted:YES];
    [viewCarTypes addSubview:submitButton];
    
//    UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapOnCarTypes:)];
//    tapOnView.numberOfTapsRequired = 1;
//    [viewCarTypes addGestureRecognizer:tapOnView];
    [self.view addSubview:viewCarTypes];
    [self.view bringSubviewToFront:viewCarTypes];
    [self InitializeSelectYourDOBDatePicked];
    [self InitializeSelectYourTimeDatePicked];
        
    }
    
    
}

//Add new code for date and time picker view

#pragma mark-------------- Picker View Initializing ----------------------------------

-(void)InitializeSelectYourDOBDatePicked
{
    
   
    
    datePicker  = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    [txtfCarTypes setInputView:datePicker];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
   
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
   
   //  NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
     datePicker.minimumDate = minDate;
    //datePicker.maximumDate = maxDate;


    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                   target:self action:@selector(doneKeyboard:)];
    doneButton.tintColor = [UIColor blueColor];
    UIToolbar *ToolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     datePicker.frame.size.height-50, 320, 50)];
    
    ToolBar.items=[[NSArray alloc]initWithObjects:spaceBarItem, doneButton, nil];
    [ToolBar setBarStyle:UIBarStyleBlackTranslucent];
    [ToolBar setTintColor:[UIColor lightGrayColor]];
    [ToolBar setBarTintColor:[UIColor lightGrayColor]];
    
    txtfCarTypes.inputAccessoryView=ToolBar;
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:spaceBarItem ,
                             doneButton, nil];
    [ToolBar setItems:toolbarItems];
    
}



-(void)updateTextField:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    txtfCarTypes.text = [dateFormatter stringFromDate:sender.date];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


-(void)doneKeyboard:(id )sender
{
//    
//          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//          datePicker = [[UIDatePicker alloc] init];
//    
//        if([txtfCarTypes isFirstResponder]){
//    
//    
//          //  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//            txtfCarTypes.text = [dateFormatter stringFromDate:datePicker.date];
//        }
//    
//        else if ([txtftime isFirstResponder])
//        {
//    
//           //  [dateFormatter setDateFormat:@"HH:mm:ss"];
//    
//            txtftime.text = [dateFormatter stringFromDate:datePicker.date];
//            
//        }
    
    [txtftime resignFirstResponder];
    [txtfCarTypes resignFirstResponder];
}
//...........................................Date picker view.................................................

#pragma mark-------------- Picker View Initializing ----------------------------------

-(void)InitializeSelectYourTimeDatePicked
{
    
    
    UIDatePicker *timePicker = [[UIDatePicker alloc] init];
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker addTarget:self action:@selector(updateTimeTextField:)
         forControlEvents:UIControlEventValueChanged];
    [txtftime setInputView:timePicker];
    
    
    
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                   target:self action:@selector(doneKeyboard:)];
    doneButton.tintColor = [UIColor blueColor];
    UIToolbar *ToolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     timePicker.frame.size.height-50, 320, 50)];
    
    ToolBar.items=[[NSArray alloc]initWithObjects:spaceBarItem, doneButton, nil];
    [ToolBar setBarStyle:UIBarStyleBlackTranslucent];
    [ToolBar setTintColor:[UIColor lightGrayColor]];
    [ToolBar setBarTintColor:[UIColor lightGrayColor]];
    
    txtftime.inputAccessoryView=ToolBar;
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:spaceBarItem ,
                             doneButton, nil];
    [ToolBar setItems:toolbarItems];
}

-(void)updateTimeTextField:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    txtftime.text = [dateFormatter stringFromDate:sender.date];
}











//TODO :: Add New code

-(IBAction)changeCarTypes:(id)sender{
    
    //[Helper showAlertWithTitle:@"Message" Message:@"Coming Soon."];
    _keyboardToolbar= nil;
    arrayMaximumNumberOfPayee = [[NSMutableArray alloc] init];
    for(NSDictionary* dict in _arrayOfCarTypes)
    {
        
        NSLog(@"%@",dict);
        NSString *type_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type_name"]];
        [arrayMaximumNumberOfPayee addObject:type_name];
    }
    
    NSDictionary *dict;
    NSLog(@"%@",strSaveLastCarName);
    if([strSaveLastCarName isEqualToString:@"No car"]){
        
        dict = [_arrayOfCarTypes objectAtIndex:0];
    }
    else{
        
        int i = 0;
        int saveIndex = 0;
        for(NSDictionary *dict1 in _arrayOfCarTypes){
            
            NSString *type_name = [NSString stringWithFormat:@"%@",[dict1 valueForKey:@"type_name"]];
            if([type_name isEqualToString:strSaveLastCarName]){
                
                saveIndex= i;
            }
            i++;
        }
        
        NSLog(@"%@",_arrayOfCarTypes);
        NSLog(@"%d",saveIndex);
        
        dict = [_arrayOfCarTypes objectAtIndex:saveIndex];
    }
    
    
    [self changeCarTypesWithdetail:dict];
}

-(void)changeCarTypesWithdetail:(NSDictionary *)dict{
    
    viewCarTypes = [[UIView alloc] init];
    
    CGRect rect = self.view.frame;
    rect.size.height = rect.size.height;
    [viewCarTypes setTag:myCarTypesTag];
    [viewCarTypes setFrame:rect];
    [viewCarTypes setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    NSLog(@"%@",dict);
    
    
    
    UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame = CGRectMake(270,5,40,40);
    //[CardButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_pickup_bg_on.png"] forState:UIControlStateNormal];
    [crossButton setBackgroundColor:NavBarTint_Color];
    [Helper setButton:crossButton Text:@"X" WithFont:Trebuchet_MS FSize:25.0f TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [crossButton addTarget:self action:@selector(crossPressed:) forControlEvents:UIControlEventTouchUpInside];
    [crossButton setShowsTouchWhenHighlighted:YES];
    [viewCarTypes addSubview:crossButton];
    
    
    
    
//    UIView *viewForCheckbox = [[UIView alloc] initWithFrame:CGRectMake(10,135,300,100)];
//    [viewForCheckbox setBackgroundColor:NavBarTint_Color];
//
//    UIButton *buttonCheckBoxHandicap = [UIButton buttonWithType:UIButtonTypeCustom];
//     buttonCheckBoxHandicap.frame = CGRectMake(5, 5, 34, 34);
//    [buttonCheckBoxHandicap setImage:[UIImage imageNamed:@"signup_btn_checkbox_off"] forState:UIControlStateNormal];
//    [buttonCheckBoxHandicap setImage:[UIImage imageNamed:@"signup_btn_checkbox_on"] forState:UIControlStateSelected];
//    [buttonCheckBoxHandicap addTarget:self action:@selector(checkButtonHandicapClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *lblHandicap = [[UILabel alloc] init];
//    [lblHandicap setFrame:CGRectMake(40, 5, 100, 34)];
//    [lblHandicap setBackgroundColor:[UIColor clearColor]];
//    [lblHandicap setTextColor:[UIColor whiteColor]];
//    [lblHandicap setText:@"Handicap"];
//    
//    
//    
//    UIButton *buttonCheckBoxPetFriendly = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonCheckBoxPetFriendly.frame = CGRectMake(5, 45, 34, 34);
//    [buttonCheckBoxPetFriendly setImage:[UIImage imageNamed:@"signup_btn_checkbox_off"] forState:UIControlStateNormal];
//    [buttonCheckBoxPetFriendly setImage:[UIImage imageNamed:@"signup_btn_checkbox_on"] forState:UIControlStateSelected];
//    [buttonCheckBoxPetFriendly addTarget:self action:@selector(checkButtonPetFriendlyClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *lblPetFriendly = [[UILabel alloc] init];
//    [lblPetFriendly setFrame:CGRectMake(40, 45, 100, 34)];
//    [lblPetFriendly setBackgroundColor:[UIColor clearColor]];
//    [lblPetFriendly setTextColor:[UIColor whiteColor]];
//    [lblPetFriendly setText:@"Pet Friendly"];
//    
//    
//    
//    
//    [viewForCheckbox addSubview:lblHandicap];
//    [viewForCheckbox addSubview:buttonCheckBoxHandicap];
//    
//    [viewForCheckbox addSubview:buttonCheckBoxPetFriendly];
//    [viewForCheckbox addSubview:lblPetFriendly];

    
    
    
    
    
    
    
    
    UIView *viewSelectCarTypes = [[UIView alloc] initWithFrame:CGRectMake(10,70,300,50)];
    [viewSelectCarTypes setBackgroundColor:[UIColor whiteColor]];
    txtfCarTypes = [[UITextField alloc] initWithFrame:CGRectMake(5,5,290, 40)];
    [txtfCarTypes setBackgroundColor:[UIColor clearColor]];
    [txtfCarTypes setTextAlignment:NSTextAlignmentCenter];
    [txtfCarTypes setBackground:[UIImage imageNamed:@"LogIn-Text-Bg.png"]];
    [txtfCarTypes setDelegate:self];
    [txtfCarTypes setPlaceholder:@"Car Types"];
    [txtfCarTypes setText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"type_name"]]];
    [viewSelectCarTypes addSubview:txtfCarTypes];
    [viewCarTypes addSubview:viewSelectCarTypes];
    
    //TODO :: only for use frame
    UILabel *lblVehicleDetail = [[UILabel alloc] init];
    [lblVehicleDetail setFrame:CGRectMake(10, (viewSelectCarTypes.frame.origin.y+viewSelectCarTypes.frame.size.height+5), viewSelectCarTypes.frame.size.width, viewSelectCarTypes.frame.size.height)];
    [lblVehicleDetail setBackgroundColor:[UIColor clearColor]];
   // [lblVehicleDetail setTextColor:[UIColor whiteColor]];
   // [lblVehicleDetail setText:@"Car Detail:"];
   // [viewCarTypes addSubview:lblVehicleDetail];
    
     //TODO :: End
    
    
     UIView *viewVehicleTypes = [[UIView alloc] init];
    [viewVehicleTypes setFrame:CGRectMake(10, (lblVehicleDetail.frame.origin.y+lblVehicleDetail.frame.size.height+5),300,260)];
    [viewVehicleTypes setBackgroundColor:NavBarTint_Color];
    lblVehicleName = [[UILabel alloc] init];
    [lblVehicleName setFrame:CGRectMake(0,0, viewVehicleTypes.frame.size.width,50)];
    [lblVehicleName setTextAlignment:NSTextAlignmentCenter];
    [lblVehicleName setBackgroundColor:[UIColor clearColor]];
    [lblVehicleName setTextColor:[UIColor whiteColor]];
    //[lblVehicleName setText:@"Car"];
    [lblVehicleName setText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"type_name"]]];
    
    //TODO :: Car details lbl
    UILabel *lblcardetails = [[UILabel alloc] init];
    [lblcardetails setFrame:CGRectMake(10, 0, 100, 50)];
    [lblcardetails setBackgroundColor:[UIColor clearColor]];
    [lblcardetails setTextColor:[UIColor whiteColor]];
    [lblcardetails setText:@"Car Details:"];
    [viewVehicleTypes addSubview:lblcardetails];
    [viewVehicleTypes addSubview:lblVehicleName];
    
    
    UIView *viewVehicleDetail = [[UIView alloc] init];
    [viewVehicleDetail setFrame:CGRectMake(0, (lblVehicleName.frame.origin.y+lblVehicleName.frame.size.height+5),lblVehicleName.frame.size.width,100)];
    [viewVehicleDetail setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbl1 = [[UILabel alloc] init];
    [lbl1 setFrame:CGRectMake(0,10, viewVehicleTypes.frame.size.width/3,40)];
    [lbl1 setTextAlignment:NSTextAlignmentCenter];
    [lbl1 setBackgroundColor:[UIColor clearColor]];
    [lbl1 setTextColor:[UIColor blackColor]];
    [lbl1 setText:@"DIST"];
    [viewVehicleDetail addSubview:lbl1];
    
    UILabel *lbl2 = [[UILabel alloc] init];
    [lbl2 setFrame:CGRectMake(viewVehicleTypes.frame.size.width/3+2,10, viewVehicleTypes.frame.size.width/3,40)];
    [lbl2 setTextAlignment:NSTextAlignmentCenter];
    [lbl2 setBackgroundColor:[UIColor clearColor]];
    [lbl2 setTextColor:[UIColor blackColor]];
    [lbl2 setText:@"MIN FARE"];
    [viewVehicleDetail addSubview:lbl2];
    
    UILabel *lbl3 = [[UILabel alloc] init];
    [lbl3 setFrame:CGRectMake((viewVehicleTypes.frame.size.width/3)*2+2,10, viewVehicleTypes.frame.size.width/3,40)];
    [lbl3 setTextAlignment:NSTextAlignmentCenter];
    [lbl3 setBackgroundColor:[UIColor clearColor]];
    [lbl3 setTextColor:[UIColor blackColor]];
    [lbl3 setText:@"MAX SIZE"];
    [viewVehicleDetail addSubview:lbl3];
    
    
    lbl4 = [[UILabel alloc] init];
    [lbl4 setFrame:CGRectMake(0,(lbl1.frame.origin.y+lbl1.frame.size.height+5), viewVehicleTypes.frame.size.width/3,40)];
    [lbl4 setTextAlignment:NSTextAlignmentCenter];
    [lbl4 setBackgroundColor:[UIColor clearColor]];
    [lbl4 setTextColor:[UIColor blackColor]];
    [lbl4 setText:[NSString stringWithFormat:@"%@",strDistance]];
    [viewVehicleDetail addSubview:lbl4];
    
    lbl5 = [[UILabel alloc] init];
    [lbl5 setFrame:CGRectMake(viewVehicleTypes.frame.size.width/3+2,(lbl1.frame.origin.y+lbl1.frame.size.height+5), viewVehicleTypes.frame.size.width/3,40)];
    [lbl5 setTextAlignment:NSTextAlignmentCenter];
    [lbl5 setBackgroundColor:[UIColor clearColor]];
    [lbl5 setTextColor:[UIColor blackColor]];
    [lbl5 setText:[NSString stringWithFormat:@"$%@",[dict objectForKey:@"min_fare"]]];
    [viewVehicleDetail addSubview:lbl5];
    
    lbl6 = [[UILabel alloc] init];
    [lbl6 setFrame:CGRectMake((viewVehicleTypes.frame.size.width/3)*2+2,(lbl1.frame.origin.y+lbl1.frame.size.height+5), viewVehicleTypes.frame.size.width/3,40)];
    [lbl6 setTextAlignment:NSTextAlignmentCenter];
    [lbl6 setBackgroundColor:[UIColor clearColor]];
    [lbl6 setTextColor:[UIColor blackColor]];
    [lbl6 setText:[NSString stringWithFormat:@"%@ ppl",[dict objectForKey:@"max_size"]]];
    [viewVehicleDetail addSubview:lbl6];
    
    
    [viewVehicleTypes addSubview:viewVehicleDetail];
    
    
    lblBaseFare = [[UILabel alloc] init];
    [lblBaseFare setFrame:CGRectMake(0,(viewVehicleDetail.frame.origin.y+viewVehicleDetail.frame.size.height+5), viewVehicleTypes.frame.size.width,50)];
    [lblBaseFare setTextAlignment:NSTextAlignmentCenter];
    [lblBaseFare setBackgroundColor:[UIColor clearColor]];
    [lblBaseFare setTextColor:[UIColor whiteColor]];
    [lblBaseFare setText:[NSString stringWithFormat:@"$%@ base fare",[dict objectForKey:@"basefare"]]];
    [viewVehicleTypes addSubview:lblBaseFare];
    
    lblDistance = [[UILabel alloc] init];
    [lblDistance setFrame:CGRectMake(0,(lblBaseFare.frame.origin.y+lblBaseFare.frame.size.height), viewVehicleTypes.frame.size.width,50)];
    [lblDistance setTextAlignment:NSTextAlignmentCenter];
    [lblDistance setBackgroundColor:[UIColor clearColor]];
    [lblDistance setTextColor:[UIColor whiteColor]];
    [lblDistance setText:[NSString stringWithFormat:@"$%@/Min and $%@/mi",[dict objectForKey:@"price_per_min"],[dict objectForKey:@"price_per_km"]]];
    [viewVehicleTypes addSubview:lblDistance];
    
    [viewCarTypes addSubview:viewVehicleTypes];
    //[viewCarTypes addSubview:viewForCheckbox];
    UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapOnCarTypes:)];
    tapOnView.numberOfTapsRequired = 1;
    [viewCarTypes addGestureRecognizer:tapOnView];
    [self.view addSubview:viewCarTypes];
    [self.view bringSubviewToFront:viewCarTypes];
    [self setPickerView];
    [self Set_ToolBar];
}


- (IBAction)checkButtonHandicapClicked:(id)sender
{
    UIButton *mBut = (UIButton *)sender;
    
    if(mBut.isSelected)
    {
       // isTnCButtonSelected = NO;
        [mBut setSelected:NO];
        
        
    }
    else
    {
      //  isTnCButtonSelected = YES;
        [mBut setSelected:YES];
        
        
    }
}

- (IBAction)checkButtonPetFriendlyClicked:(id)sender
{
    UIButton *mBut = (UIButton *)sender;
    
    if(mBut.isSelected)
    {
        // isTnCButtonSelected = NO;
        [mBut setSelected:NO];
        
        
    }
    else
    {
        //  isTnCButtonSelected = YES;
        [mBut setSelected:YES];
        
        
    }
}






-(void)fillDetailsOnCarTypesWithdetail:(NSDictionary *)dict{
    
    [lblVehicleName setText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"type_name"]]];
    [txtfCarTypes setText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"type_name"]]];
    [lbl5 setText:[NSString stringWithFormat:@"$%@",[dict objectForKey:@"min_fare"]]];
    [lbl6 setText:[NSString stringWithFormat:@"%@ ppl",[dict objectForKey:@"max_size"]]];
    [lblBaseFare setText:[NSString stringWithFormat:@"$%@ base fare",[dict objectForKey:@"basefare"]]];
    [lblDistance setText:[NSString stringWithFormat:@"$%@/Min and $%@/mi",[dict objectForKey:@"price_per_min"],[dict objectForKey:@"price_per_km"]]];
    
    
    NSLog(@"dict= %@",dict);
    NSLog(@"txtfCarTypes.text= %@",txtfCarTypes.text);
    NSLog(@"lbl5.text= %@",lbl5.text);
    NSLog(@"lbl6.text= %@",lbl6.text);
    
    NSLog(@"lblBaseFare.text= %@",lblBaseFare.text);
    NSLog(@"lblDistance.text= %@",lblDistance.text);
}


-(IBAction)submitbuttonAction:(id)sender{
    
    
    if (txtfCarTypes.text.length == 0) {
        
        [Helper showAlertWithTitle:@"Message" Message:@"Please select date for later booking."];
    }
    else if (txtftime.text.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Please select future date for later booking."];
    }
    else{
        
        
        
    [self callServiceToLaterBooking:txtftime.text withdate:txtfCarTypes.text withdriver:@""];
        
        
    }
    
}


-(void)callServiceToLaterBooking:(NSString *)time withdate:(NSString*)Date withdriver:(NSString *)driverEmail {
    
    

    //setup parameters
    //setup parameters
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    
    //! is for nil [NSNull class] is for other type of like Null NULL null and length is for checking
    if (!srcAddrline2 || srcAddrline2 == (id)[NSNull null] || srcAddrline2.length == 0 ){
        srcAddrline2 = @"";
    }
   
    
    NSString *zipcode = @"90210";
    NSString *pickupLatitude =  [NSString stringWithFormat:@"%f",srcLat];
    NSString *pickupLongitude = [NSString stringWithFormat:@"%f",srcLong];
    
    if (srcAddr == (id)[NSNull null] || srcAddr.length == 0 )
    {
        UITextField *textAddress = (UITextField *)[PikUpViewForConfirmScreen viewWithTag:pickupAddressTag];
        srcAddr = textAddress.text;
        
    }
    NSString *pickAddress = srcAddr;
    NSString *dropLatitude;
    NSString *dropLongitude;
    NSString *dropAddress;
    
    if (desAddrline2 == Nil) {
        desAddrline2 = @"";
    }
    
    if(desLat == 0 && desLong == 0) {
        dropLatitude = @"";
        dropLongitude =@"";
        dropAddress =  @"";
        
    }
    else {
        dropLatitude = [NSString stringWithFormat:@"%f",desLat];
        dropLongitude = [NSString stringWithFormat:@"%f",desLong];
        dropAddress = desAddr;
    }
    
    driverEmail=@"";
    laterSelectedDate =[NSString stringWithFormat:@"%@ %@",Date,time];
    paymentTypesForLiveBooking=2;
    promocode_id=@"";
    cardId=@"";
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *timeZoneName = [timeZone name];
    
    NSString *dateTime = [Helper getCurrentDateTime];
    @try {
        NSDictionary *params = @{@"ent_sess_token":sessionToken,
                                 @"ent_dev_id":deviceID,
                                 @"ent_wrk_type":[NSString stringWithFormat:@"%ld",carTypesForLiveBookingServer],
                                 @"ent_lat":pickupLatitude,
                                 @"ent_long":pickupLongitude,
                                 @"ent_addr_line1":pickAddress,
                                 @"ent_addr_line2":srcAddrline2,
                                 @"ent_drop_lat":dropLatitude,
                                 @"ent_drop_long":dropLongitude,
                                 @"ent_drop_addr_line1":dropAddress,
                                 @"ent_drop_addr_line2":desAddrline2,
                                 @"ent_zipcode":zipcode,
                                 @"ent_extra_notes":@"",
                                 @"ent_date_time":dateTime,
                                 @"ent_later_dt":laterSelectedDate,
                                 @"ent_payment_type":[NSNumber numberWithInteger:paymentTypesForLiveBooking],
                                 @"ent_card_id":cardId,
                                 @"ent_dri_email":driverEmail,
                                 @"ent_promocode_id":promocode_id,
                                 @"ent_booking_timezone":timeZoneName
                                 };
        
        NSLog(@"BookingRequest %@",params);
        
        NetworkHandler *networHandler = [NetworkHandler sharedInstance];
        [networHandler composeRequestWithMethod:kSMLaterBooking
                                        paramas:params
                                   onComplition:^(BOOL success, NSDictionary *response){
                                       
                                       if (success) {
                                           
                                           NSLog(@"Later Booking response:: %@",response);
                                           
                                           
                                           //handle success response
 //                                          NSUserDefaults *udPlotting = [NSUserDefaults standardUserDefaults];
//                                           [udPlotting setDouble:srcLat   forKey:@"srcLat"];
//                                           [udPlotting setDouble:srcLong  forKey:@"srcLong"];
//                                           [udPlotting setDouble:desLat   forKey:@"desLat"];
//                                           [udPlotting setDouble:desLong  forKey:@"desLong"];
                                           
                                           [self getLaterBookingAppointment:response];
                                       }
                                       else{
                                           
                                           [Helper showAlertWithTitle:@"Failed" Message:@"Your request failed,Please try again."];
                                        }
                                   }];
    }
    @catch (NSException *exception) {
        TELogInfo(@"BookingRequest Exception : %@",[exception description]);
    }
}

-(void)getLaterBookingAppointment:(NSDictionary *)responseDictionary
{
    
    [self.view endEditing:YES];
    [viewCarTypes removeFromSuperview];

    NSLog(@"booking%@",responseDictionary);
    if (!responseDictionary)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[responseDictionary objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([responseDictionary objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[responseDictionary objectForKey:@"Error"]];
    }
    else
    {
        if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 0 &&[[responseDictionary objectForKey:@"errNum"] intValue] == 39)
        {
            BOOL isNewBooking = [self checkBookingID:[responseDictionary[@"bid"] integerValue]];
            if (isNewBooking) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseDictionary[@"bid"] forKey:@"BOOKINGID"];
                isRequestingButtonClicked = NO;
                docCount = 0;
                NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
                [ud setObject:responseDictionary[@"email"] forKey:KUDriverEmail];
                [ud setObject:responseDictionary[@"apptDt"] forKey:KUBookingDate];
                [ud setObject:responseDictionary[@"rating"] forKey:@"Rating"];
                if ([ud boolForKey:kNSUIsPassengerBookedKey]) {
                    //do nothing
                }
                else{
                    [ud setBool:YES forKey:kNSUIsPassengerBookedKey];
                    BOOL isAlreadyCalled = [self checkServiceCalledAtleastOnce];
                    if (!isAlreadyCalled) {
                        
                        [self sendRequestToGetDriverDetails:responseDictionary[@"email"] :responseDictionary[@"apptDt"] :responseDictionary[@"bid"]];
                        
                    }
                    
                }
                [ud synchronize];
            }
            
        }
        else if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 0 &&[[responseDictionary objectForKey:@"errNum"] intValue] == 78){
            [self bookingNotAccetedByAnyDriverScreenLayout];
            [Helper showAlertWithTitle:@"Message" Message:[responseDictionary objectForKey:@"errMsg"]];
        }
        else if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 1)
        {
            
            [Helper showAlertWithTitle:@"Message" Message:[responseDictionary objectForKey:@"errMsg"]];
           // [self submitbuttonAction:nil];
            
        }
        else
        {
            
        }
    }
}




-(IBAction)crossPressed:(id)sender{
    
    //
    //    [self.view endEditing:YES];
    //    [viewCarTypes removeFromSuperview];
    //
    //    NSLog(@"_arrayOfCarTypes= %@",_arrayOfCarTypes);
    //    NSString *strText = [NSString stringWithFormat:@"%@",txtfCarTypes.text];
    //    NSDictionary *dictSaveValue = [[NSDictionary alloc] init];
    //    int saveIndex = 0;
    //
    //    dictSaveValue = [_arrayOfCarTypes objectAtIndex:0];
    //
    //    NSLog(@"dictSaveValue= %@",dictSaveValue);
    //    NSLog(@"saveIndex== %d",saveIndex);
    //
    //    carTypesForLiveBooking =  saveIndex+1;
    //    carTypesForLiveBookingServer = [[dictSaveValue valueForKey:@"type_id"] integerValue];
    //
    //   // lblCarType.text = [NSString stringWithFormat:@"%@",[dictSaveValue valueForKey:@"type_name"]];
    //
    //     lblCarType.text = strText;
    //
    //    strSaveLastCarName=@"No car";
    //    txtfCarTypes.text = [arrayMaximumNumberOfPayee objectAtIndex:0];
    //
    //    [self fillDetailsOnCarTypesWithdetail:dictSaveValue];
    //
    //    [self changeMapMarker:saveIndex];
    //    [self publishPubNubStream];
    //
    //
    //
    [self.view endEditing:YES];
    [viewCarTypes removeFromSuperview];
    
    NSLog(@"_arrayOfCarTypes= %@",_arrayOfCarTypes);
    NSString *strText = [NSString stringWithFormat:@"%@",txtfCarTypes.text];
    NSDictionary *dictSaveValue = [[NSDictionary alloc] init];
    
    int i = 0;
    int saveIndex = 0;
    for(NSDictionary *dict1 in _arrayOfCarTypes){
        
        NSString *type_name = [NSString stringWithFormat:@"%@",[dict1 valueForKey:@"type_name"]];
        if([type_name isEqualToString:strText]){
            
            dictSaveValue = dict1;
            saveIndex= i;
        }
        i++;
    }
    NSLog(@"dictSaveValue= %@",dictSaveValue);
    NSLog(@"saveIndex== %d",saveIndex);
    
    carTypesForLiveBooking =  saveIndex+1;
    carTypesForLiveBookingServer = [[dictSaveValue valueForKey:@"type_id"] integerValue];
    lblCarType.text =  lblCarType.text = strText;;
    
    [self changeMapMarker:saveIndex];
    [self publishPubNubStream];
    
}

- (void)handleSingleTapOnCarTypes:(UIGestureRecognizer *)recognizer
{
    
    [self.view endEditing:YES];
    [viewCarTypes removeFromSuperview];
    
    NSLog(@"_arrayOfCarTypes= %@",_arrayOfCarTypes);
    NSString *strText = [NSString stringWithFormat:@"%@",txtfCarTypes.text];
    NSDictionary *dictSaveValue = [[NSDictionary alloc] init];
    
    int i = 0;
    int saveIndex = 0;
    for(NSDictionary *dict1 in _arrayOfCarTypes){
        
        NSString *type_name = [NSString stringWithFormat:@"%@",[dict1 valueForKey:@"type_name"]];
        if([type_name isEqualToString:strText]){
            
            dictSaveValue = dict1;
            saveIndex= i;
        }
        i++;
    }
    NSLog(@"dictSaveValue= %@",dictSaveValue);
    NSLog(@"saveIndex== %d",saveIndex);
    
    carTypesForLiveBooking =  saveIndex+1;
    carTypesForLiveBookingServer = [[dictSaveValue valueForKey:@"type_id"] integerValue];
    lblCarType.text = [NSString stringWithFormat:@"%@",[dictSaveValue valueForKey:@"type_name"]];
    
    [self changeMapMarker:saveIndex];
    [self publishPubNubStream];
    
}


/**
 *  Scale Label Text
 *
 *  @param  It will scale the text of the Label
 *
 *  @return returns void and accept integer value
 */

-(void)scaleLabelText:(int)labeltag {
    
    UILabel *lbl = (UILabel *)[[self.view viewWithTag:bottomViewWithCarTag]viewWithTag:labeltag];
    lbl.font = [UIFont fontWithName:Trebuchet_MS_Bold size:10];
    lbl.transform = CGAffineTransformScale(lbl.transform, 0.25, 0.25);
    
    [UIView animateWithDuration:1.0 animations:^{
        lbl.transform = CGAffineTransformScale(lbl.transform, 4, 4);
    }];
}
/**
 *  To get cartype for ublishing and live booking
 *
 *  @param  accepts void return int
 *
 *  @return <#return value description#>
 */
-(NSInteger)getCarTypeId {
    
    NSDictionary *dict;
    NSInteger type_id;
    if (_arrayOfCarTypes.count != 0) {
        
        switch (carTypesForLiveBooking) {
            case 1:
                dict = [_arrayOfCarTypes objectAtIndex:0];
                type_id = [dict[@"type_id"] integerValue];
                break;
            case 2:
                dict = [_arrayOfCarTypes objectAtIndex:1];
                type_id = [dict[@"type_id"] integerValue];
                break;
            case 3:
                dict = [_arrayOfCarTypes objectAtIndex:2];
                type_id = [dict[@"type_id"] integerValue];
                break;
            case 4:
                dict = [_arrayOfCarTypes objectAtIndex:3];
                type_id = [dict[@"type_id"] integerValue];
                break;
            default:
                type_id = 0;
                break;
        }
    }
    else {
        
        type_id = 0;
    }
    return type_id;
}

/**
 *  Touch event on car types
 *
 *  @param typeCar <#typeCar description#>
 */

- (void)handleSingleTap:(UIGestureRecognizer *)recognizer
{
    if(!isPopLockSelected){
    UIView *v = [self.view viewWithTag:myCustomMarkerTag];
    v.hidden = YES;
    CALayer *mainViewLayer = self.view.layer;
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction;
    [UIView animateWithDuration:0.5 delay:0.0 options:options animations:^
     {
         mainViewLayer.transform = CATransform3DScale(mainViewLayer.transform, 0.9, (self.view.frame.size.height - 40) / self.view.frame.size.height, 1);
     } completion:^(BOOL finished) {
     }];
    
    NSInteger type_id = [_arrayOfCarTypes[carTypesForLiveBooking-1][@"type_id"]integerValue];

    [self addCustomCarButtonPressedView:type_id];
    }
}
-(void)clearTheMapBeforeChagingTheCarTypes {
    
    [self unSubsCribeToPubNubChannels:_arrayOFDriverChannels];
    [_arrayOFDriverChannels removeAllObjects];
    [_allMarkers removeAllObjects];
    [_arrayOfDriverEmail removeAllObjects];
    _arrayOfDriverEmail = nil;
    _arrayOFDriverChannels = nil;
    [mapView_ clear];
    
}

-(void)changeMapMarker:(NSInteger)type {
    
    [_allMarkers removeAllObjects];
    [mapView_ clear];
    doctors = [[NSMutableArray alloc] init];
    [doctors addObjectsFromArray:_arrayOfMastersAround[type][@"mas"]];
    
    if (doctors.count > 0) {
        
        if (doctors.count >3) {
            GMSCameraUpdate *zoomCamera = [GMSCameraUpdate zoomTo:mapZoomLevel+1];
            [mapView_ animateWithCameraUpdate:zoomCamera];
            
        }
        else {
            GMSCameraUpdate *zoomCamera = [GMSCameraUpdate zoomTo:mapZoomLevel];
            [mapView_ animateWithCameraUpdate:zoomCamera];
            
        }
        id dis = _arrayOfMastersAround[type][@"mas"][0][@"d"];
        [self updateTheNearestDriverinSpinitCircle:dis];
        [self addCustomMarkerFor:0];
    }
    else {
        [self hideActivityIndicatorWithMessage];
    }
    
}

-(void)customBottomViewhandleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    UIView *piece = [gestureRecognizer view];
    UIImageView *imgView = (UIImageView *)[piece viewWithTag:10000];
    CGPoint currentlocation = [gestureRecognizer locationInView:self.view];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {

        CGFloat delta_x = 40;
        switch (carTypesArrayCountValue) {
            case 2:
            {
                if (currentlocation.x > 150) {
                    if (carTypesForLiveBooking != 2) {
                        delta_x = 270;//location.x - previousLocation.x;
                        carTypesForLiveBooking =  2;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[1][@"type_id"] integerValue];
                        
                        //TODO:: HERE I WRITTEN CODE
                        
                        //carMaximumCapacity = [_arrayOfCarTypes[1][@"max_size"]integerValue];;
                        //NSLog(@"%ld",(long)carMaximumCapacity);
                        
                        //TODO:: TILL HERE
                        
                        
                        imgView.image = [UIImage imageNamed:@"home_carinfo_caricon_on"];
                        [self scaleLabelText:181];
                        [self changeMapMarker:1];
                        [self publishPubNubStream];
                    }
                    else{
                        delta_x = 270;
                    }
                    
                }
                else {
                    if (carTypesForLiveBooking != 1) {
                        delta_x = 40;//location.x - previousLocation.x;
                        
                        carTypesForLiveBooking =  1;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[0][@"type_id"] integerValue];
                        
                        //TODO:: HERE I WRITTEN CODE
                        
                        //carMaximumCapacity = [_arrayOfCarTypes[0][@"max_size"]integerValue];;
                        //NSLog(@"%ld",(long)carMaximumCapacity);
                        
                        //TODO:: TILL HERE
                        
                        
                        imgView.image = [UIImage imageNamed:@"home_carinfo_caricon"];
                        [self scaleLabelText:180];
                        [self changeMapMarker:0];
                        [self publishPubNubStream];
                    }
                    else {
                        delta_x = 40;
                    }
                    
                }
                
            }
                break;
                
            case 3:
            {
                
                if (currentlocation.x > 220) {
                    if (carTypesForLiveBooking != 3) {
                        delta_x = 270;//location.x - previousLocation.x;
                        carTypesForLiveBooking =  3;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[2][@"type_id"] integerValue];
                        
                        //TODO:: HERE I WRITTEN CODE
                        
                        //carMaximumCapacity = [_arrayOfCarTypes[2][@"max_size"]integerValue];;
                        //NSLog(@"%ld",(long)carMaximumCapacity);
                        
                        //TODO:: TILL HERE
                        
                        
                        imgView.image = [UIImage imageNamed:@"home_carinfo_caricon_on"];
                        [self scaleLabelText:182];
                        [self changeMapMarker:2];
                        [self publishPubNubStream];
                    }
                    else{
                        delta_x = 270;
                    }
                    
                }
                else if (currentlocation.x > 100 && currentlocation.x < 220) {
                    
                    if (carTypesForLiveBooking != 2) {
                        delta_x = 160;
                        carTypesForLiveBooking =  2;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[1][@"type_id"] integerValue];
                        
                        //TODO:: HERE I WRITTEN CODE
                        
                        //carMaximumCapacity = [_arrayOfCarTypes[1][@"max_size"]integerValue];;
                        //NSLog(@"%ld",(long)carMaximumCapacity);
                        
                        //TODO:: TILL HERE
                        
                        imgView.image = [UIImage imageNamed:@"home_carinfo_caricon"];
                        [self scaleLabelText:181];
                        [self changeMapMarker:1];
                        [self publishPubNubStream];
                    }
                    else {
                        delta_x = 160;
                    }
                    
                }
                else {
                    if (carTypesForLiveBooking != 1) {
                        delta_x = 40;
                        carTypesForLiveBooking =  1;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[0][@"type_id"] integerValue];
                        
                        //TODO:: HERE I WRITTEN CODE
                        
                        //carMaximumCapacity = [_arrayOfCarTypes[0][@"max_size"]integerValue];;
                        //NSLog(@"%ld",(long)carMaximumCapacity);
                        
                        //TODO:: TILL HERE
                        
                        
                        imgView.image = [UIImage imageNamed:@"home_carinfo_caricon"];
                        [self scaleLabelText:180];
                        [self changeMapMarker:0];
                        [self publishPubNubStream];
                    }
                    else {
                        delta_x = 40;
                    }
                    
                }
            }
                break;
                
            case 4:
            {
                if (currentlocation.x > 220) {
                    
                    if (carTypesForLiveBooking != 4) {
                        delta_x = 270;
                        carTypesForLiveBooking =  4;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[3][@"type_id"] integerValue];
                        //TODO:: HERE I WRITTEN CODE
                        
                        //carMaximumCapacity = [_arrayOfCarTypes[3][@"max_size"]integerValue];;
                        //NSLog(@"%ld",(long)carMaximumCapacity);
                        
                        //TODO:: TILL HERE
                        [self scaleLabelText:183];
                        [self changeMapMarker:3];
                        [self publishPubNubStream];
                    }
                    else {
                        delta_x = 270;
                        carTypesForLiveBooking =  4;
                    }
                }
                else if (currentlocation.x > 40 && currentlocation.x < 80 ) {
                    
                    if (carTypesForLiveBooking != 1) {
                        delta_x = 40;//location.x - previousLocation.x;
                        carTypesForLiveBooking =  1;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[0][@"type_id"] integerValue];
                        
                        //TODO:: HERE I WRITTEN CODE
                        
                        //carMaximumCapacity = [_arrayOfCarTypes[0][@"max_size"]integerValue];;
                        //NSLog(@"%ld",(long)carMaximumCapacity);
                        
                        //TODO:: TILL HERE
                        
                        [self scaleLabelText:180];
                        [self changeMapMarker:0];
                        [self publishPubNubStream];
                    }
                    else{
                        delta_x = 40;
                        carTypesForLiveBooking =  1;
                        
                    }
                    
                }
                else if (currentlocation.x > 80 && currentlocation.x < 160 ) {
                    
                    
                    if (carTypesForLiveBooking != 2) {
                        delta_x = 130;
                        carTypesForLiveBooking =  2;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[1][@"type_id"] integerValue];
                        
                        
                        //TODO:: HERE I WRITTEN CODE
                        
                        //carMaximumCapacity = [_arrayOfCarTypes[1][@"max_size"]integerValue];;
                        //NSLog(@"%ld",(long)carMaximumCapacity);
                        
                        //TODO:: TILL HERE
                        
                        
                        [self scaleLabelText:181];
                        [self changeMapMarker:1];
                        [self publishPubNubStream];
                    }
                    else {
                        delta_x = 130;
                        carTypesForLiveBooking =  2;
                    }
                    
                }
                else if (currentlocation.x > 160 && currentlocation.x < 220 ) {
                    
                    
                    if (carTypesForLiveBooking != 3) {
                        delta_x = 200;
                        carTypesForLiveBooking =  3;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[2][@"type_id"] integerValue];
                        
                        //TODO:: HERE I WRITTEN CODE
                        
                        //carMaximumCapacity = [_arrayOfCarTypes[2][@"max_size"]integerValue];;
                        //NSLog(@"%ld",(long)carMaximumCapacity);
                        
                        //TODO:: TILL HERE
                        
                        [self scaleLabelText:182];
                        [self changeMapMarker:2];
                        [self publishPubNubStream];
                    }
                    else {
                        delta_x = 200;
                        carTypesForLiveBooking =  3;
                    }
                    
                }
                
            }
                break;
                
            default:
                break;
        }
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [imgView setCenter:CGPointMake(delta_x,33)];
                         }
                         completion:^(BOOL finished){
                         }];
    }
}
- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIImageView *piece = (UIImageView *)[gestureRecognizer view];
    
    CGPoint currentlocation = [gestureRecognizer locationInView:self.view];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [piece setCenter:CGPointMake([piece center].x + translation.x,33)];
                         }
                         completion:^(BOOL finished){
                         }];
        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
    }
    else if([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        CGFloat delta_x = 40;
        switch (carTypesArrayCountValue) {
            case 2:
            {
                if (currentlocation.x > 150) {
                    
                    if ([piece center].x >= 150 && carTypesForLiveBooking != 2) {
                        delta_x = 270;
                        carTypesForLiveBooking =  2;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[1][@"type_id"] integerValue];
                        piece.image = [UIImage imageNamed:@"home_carinfo_caricon_on"];
                        [self scaleLabelText:181];
                        [self changeMapMarker:1];
                        [self publishPubNubStream];
                        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
                    }
                    else {
                        delta_x = 270;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[1][@"type_id"] integerValue];
                    }
                }
                else {
                    
                    if ([piece center].x <= 150 && carTypesForLiveBooking != 1) {
                        delta_x = 40;//location.x - previousLocation.x;
                        carTypesForLiveBooking =  1;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[0][@"type_id"] integerValue];
                        piece.image = [UIImage imageNamed:@"home_carinfo_caricon"];
                        // [self clearTheMapBeforeChagingTheCarTypes];
                        [self scaleLabelText:180];
                        // [self startSpinitAgain];
                        [self changeMapMarker:0];
                        [self publishPubNubStream];
                        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
                    }
                    else{
                        delta_x = 40;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[0][@"type_id"] integerValue];
                        
                    }
                    
                }
                
            }
                break;
                
            case 3:
            {
                
                if (currentlocation.x > 220) {
                    
                    if ([piece center].x >= 200 && carTypesForLiveBooking != 3) {
                        delta_x = 270;
                        carTypesForLiveBooking =  3;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[2][@"type_id"] integerValue];
                        piece.image = [UIImage imageNamed:@"home_carinfo_caricon_on"];
                        [self changeMapMarker:2];
                        [self scaleLabelText:182];
                        [self publishPubNubStream];
                        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
                    }
                    else {
                        delta_x = 270;
                        carTypesForLiveBooking =  3;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[2][@"type_id"] integerValue];
                    }
                }
                else if (currentlocation.x > 40 && currentlocation.x < 100 ) {
                    
                    
                    if ([piece center].x >= 60 && carTypesForLiveBooking != 1) {
                        delta_x = 40;//location.x - previousLocation.x;
                        carTypesForLiveBooking =  1;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[0][@"type_id"] integerValue];
                        piece.image = [UIImage imageNamed:@"home_carinfo_caricon"];
                        [self changeMapMarker:0];
                        [self scaleLabelText:180];
                        [self publishPubNubStream];
                        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
                    }
                    else{
                        delta_x = 40;
                        carTypesForLiveBooking =  1;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[0][@"type_id"] integerValue];
                    }
                    
                }
                else if (currentlocation.x > 100 && currentlocation.x < 220 ) {
                    
                    
                    if ([piece center].x >= 170 && carTypesForLiveBooking != 2) {
                        delta_x = 160;
                        carTypesForLiveBooking =  2;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[1][@"type_id"] integerValue];
                        piece.image = [UIImage imageNamed:@"home_carinfo_caricon_on"];
                        [self changeMapMarker:1];
                        [self scaleLabelText:181];
                        [self publishPubNubStream];
                        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
                    }
                    else {
                        delta_x = 160;
                        carTypesForLiveBooking =  2;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[1][@"type_id"] integerValue];
                    }
                    
                }
                
            }
                break;
                
            case 4:
            {
                if (currentlocation.x > 220) {
                    
                    if (carTypesForLiveBooking != 4) {
                        delta_x = 270;
                        carTypesForLiveBooking =  4;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[3][@"type_id"] integerValue];
                        piece.image = [UIImage imageNamed:@"home_carinfo_caricon_on"];
                        [self changeMapMarker:3];
                        [self scaleLabelText:183];
                        [self publishPubNubStream];
                        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
                    }
                    else {
                        delta_x = 270;
                        carTypesForLiveBooking =  4;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[3][@"type_id"] integerValue];
                    }
                }
                else if (currentlocation.x > 40 && currentlocation.x < 80 ) {
                    if ([piece center].x >= 60 && carTypesForLiveBooking != 1) {
                        delta_x = 40;//location.x - previousLocation.x;
                        carTypesForLiveBooking =  1;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[0][@"type_id"] integerValue];
                        piece.image = [UIImage imageNamed:@"home_carinfo_caricon"];
                        [self scaleLabelText:180];
                        [self changeMapMarker:0];
                        [self publishPubNubStream];
                        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
                    }
                    else{
                        delta_x = 40;
                        carTypesForLiveBooking =  1;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[0][@"type_id"] integerValue];
                        
                    }
                    
                }
                else if (currentlocation.x > 80 && currentlocation.x < 160 ) {
                    
                    if ([piece center].x >= 60 && carTypesForLiveBooking != 2) {
                        delta_x = 130;
                        carTypesForLiveBooking =  2;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[1][@"type_id"] integerValue];
                        piece.image = [UIImage imageNamed:@"home_carinfo_caricon_on"];
                        [self changeMapMarker:1];
                        [self scaleLabelText:181];
                        [self startSpinitAgain];
                        [self publishPubNubStream];
                        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
                    }
                    else {
                        delta_x = 130;
                        carTypesForLiveBooking =  2;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[1][@"type_id"] integerValue];
                    }
                    
                }
                else if (currentlocation.x > 160 && currentlocation.x < 220 ) {
                    
                    if ([piece center].x >= 130 && carTypesForLiveBooking != 3) {
                        delta_x = 200;
                        carTypesForLiveBooking =  3;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[2][@"type_id"] integerValue];
                        piece.image = [UIImage imageNamed:@"home_carinfo_caricon_on"];
                        [self scaleLabelText:182];
                        [self changeMapMarker:2];
                        [self publishPubNubStream];
                        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
                    }
                    else {
                        delta_x = 200;
                        carTypesForLiveBooking =  3;
                        carTypesForLiveBookingServer = [_arrayOfCarTypes[2][@"type_id"] integerValue];
                    }
                    
                }
                
            }
                break;
                
            default:
                break;
        }
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [piece setCenter:CGPointMake(delta_x,33)];
                         }
                         completion:^(BOOL finished){
                         }];
    }
}




-(void)addCustomCarButtonPressedView:(NSUInteger)typeCar
{
    // get your window screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //create a new view with the same size
    UIView* coverView = [[UIView alloc] initWithFrame:screenRect];
    coverView.tag = 300;
    // change the background color to black and the opacity to 0.6
    coverView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardetails_screen_bg-568h"]];
    // add this new view to your main view
    [self.view addSubview:coverView];
    // when you are done with it , you can romove it :
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [coverView addGestureRecognizer:tapRecognizer];
    
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(23, [UIScreen mainScreen].bounds.size.height/2-50,273,106)];
    centerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardetails_bg.png"]];
    centerView.tag = 600;
    [coverView addSubview:centerView];
    
    UILabel *centerLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260,50)];
    //    centerLabel.numberOfLines = 3;
    centerLabel1.textAlignment = NSTextAlignmentCenter;
    
    NSMutableArray *carTypes = [_arrayOfCarTypes mutableCopy];//   [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KUBERCarArrayKey]];
    NSDictionary *dict = [[NSDictionary alloc]init];
    
    for(dict in carTypes)
    {
        if(typeCar == [dict[@"type_id"]integerValue])
        {
            break;
        }
        
    }
    NSString *curreny =  [PatientGetLocalCurrency getCurrencyLocal:[flStrForObj(dict[@"basefare"]) floatValue]];
    
    [Helper setToLabel:centerLabel1 Text:[NSString stringWithFormat:@"%@ BASE FARE",curreny] WithFont:Trebuchet_MS FSize:15 Color:UIColorFromRGB(0xffffff)];
    [centerView addSubview:centerLabel1];
    UILabel *centerLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(5,50,263,6)];
    centerLabel3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_cardetails_divider"]];
    [centerView addSubview:centerLabel3];
    
    UILabel *centerLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0,56,260,50)];
    //    centerLabel.numberOfLines = 3;
    centerLabel2.textAlignment = NSTextAlignmentCenter;
    NSString *price_per_min =  [PatientGetLocalCurrency getCurrencyLocal:[flStrForObj(dict[@"price_per_min"]) floatValue]];
    NSString *price_per_km =  [PatientGetLocalCurrency getCurrencyLocal:[flStrForObj(dict[@"price_per_km"]) floatValue]];
    
    [Helper setToLabel:centerLabel2 Text:[NSString stringWithFormat:@"%@ / Min and %@ / Mile",price_per_min,price_per_km] WithFont:Trebuchet_MS FSize:14 Color:UIColorFromRGB(0xffffff)];
    [centerView addSubview:centerLabel2];
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320,100)];
    bottomView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:1.0f];
    
    CGRect basketTopFrame = bottomView.frame;
    basketTopFrame.origin.y = [UIScreen mainScreen].bounds.size.height -100;
    
    UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 26)];
    carName.text = dict[@"type_name"];
    [Helper setToLabel:carName Text:carName.text WithFont:Trebuchet_MS_Bold FSize:10 Color:BLACK_COLOR];
    carName.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardetails_carname.png"]];
    carName.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:carName];
    
    UIImage *img = [UIImage imageNamed:@"cardetails_crossbutton"];
    UIImageView *cross = [[UIImageView alloc]initWithFrame:CGRectMake(290,0,28, 28)];
    [bottomView addSubview:cross];
    cross.image = img;
    
    UIView *BSV = [[UIView alloc]initWithFrame:CGRectMake(0,26, 320, 74)];
    [bottomView addSubview:BSV];
    BSV.backgroundColor = [UIColor whiteColor];
    
    UILabel *eta = [[UILabel alloc]initWithFrame:CGRectMake(0,3,105,20)];
    [Helper setToLabel:eta Text:@"DISTANCE" WithFont:Trebuchet_MS_Bold FSize:14 Color:BLACK_COLOR];
    eta.textAlignment = NSTextAlignmentCenter;
    [BSV addSubview:eta];
    
    UILabel *minFare = [[UILabel alloc]initWithFrame:CGRectMake(105,3,105,20)];
    [Helper setToLabel:minFare Text:@"MIN FARE" WithFont:Trebuchet_MS_Bold FSize:14 Color:BLACK_COLOR];
    minFare.textAlignment = NSTextAlignmentCenter;
    [BSV addSubview:minFare];
    
    UILabel *maxSize = [[UILabel alloc]initWithFrame:CGRectMake(210,3,105,20)];
    [Helper setToLabel:maxSize Text:@"MAX SIZE" WithFont:Trebuchet_MS_Bold FSize:14 Color:BLACK_COLOR];
    maxSize.textAlignment = NSTextAlignmentCenter;
    [BSV addSubview:maxSize];
    
    UILabel *etafield = [[UILabel alloc]initWithFrame:CGRectMake(0,15,105,54)];
    
    [Helper setToLabel:etafield Text:[NSString stringWithFormat:@"%.2f Miles",distanceOfClosetCar/distanceMetric] WithFont:Trebuchet_MS FSize:14 Color:BLACK_COLOR];
    etafield.textAlignment = NSTextAlignmentCenter;
    [BSV addSubview:etafield];
    
    UILabel *Hline = [[UILabel alloc]initWithFrame:CGRectMake(105,15,1,45)];
    [BSV addSubview:Hline];
    Hline.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardetails_carinfo_divider.png"]];
    
    
    UILabel *minFareField = [[UILabel alloc]initWithFrame:CGRectMake(106,15,105,54)];
    NSString *txt =  [PatientGetLocalCurrency getCurrencyLocal:[flStrForObj(dict[@"min_fare"]) floatValue]];
    
    [Helper setToLabel:minFareField Text:txt WithFont:Trebuchet_MS FSize:14 Color:BLACK_COLOR];
    minFareField.textAlignment = NSTextAlignmentCenter;
    [BSV addSubview:minFareField];
    
    UILabel *Hline1 = [[UILabel alloc]initWithFrame:CGRectMake(212,15,1,45)];
    [BSV addSubview:Hline1];
    Hline1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cardetails_carinfo_divider.png"]];
    
    //TODO:: HERE I WRITTEN CODE
    
    NSString *strMaxVal = [NSString stringWithFormat:@"%@",dict[@"max_size"]];
    carMaximumCapacity = [strMaxVal integerValue];
    NSLog(@"%ld",(long)carMaximumCapacity);
    
    //TODO:: TILL HERE
    
    UILabel *maxSizefield = [[UILabel alloc]initWithFrame:CGRectMake(213,15,105,58)];
    maxSizefield.text = [NSString stringWithFormat:@"%@ people",dict[@"max_size"]];
    [Helper setToLabel:maxSizefield Text:maxSizefield.text WithFont:Trebuchet_MS FSize:14 Color:BLACK_COLOR];
    
    maxSizefield.textAlignment = NSTextAlignmentCenter;
    [BSV addSubview:maxSizefield];
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         bottomView.frame = basketTopFrame;
                     }
                     completion:^(BOOL finished){
                     }];
    
    [coverView addSubview:bottomView];
    
}

-(void)addCustomViewForShowingCardFareWithAnimation
{
    //Adding View For animation
    UIView *basketTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    UIView *basketBottom = [[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height,320,200)];
    basketTop.backgroundColor =[[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    basketBottom.backgroundColor = CLEAR_COLOR; //[[UIColor lightGrayColor] colorWithAlphaComponent:1.0];
    [self.view addSubview:basketBottom];
    basketBottom.tag = 499;
    //  [self.view addSubview:basketTop];
    
    //changing frame for anoimation
    CGRect basketTopFrame = basketBottom.frame;
    basketTopFrame.origin.y = [UIScreen mainScreen].bounds.size.height - 200;//-basketTopFrame.size.height;
    
    CGRect basketBottomFrame = basketBottom.frame;
    basketBottomFrame.origin.y = self.view.bounds.size.height;
    
    //REquest bottom
    UIButton *requestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    requestButton.frame = CGRectMake(0,basketBottom.frame.size.height-50,320,50);
    NSString *msgText = @"Request Driver";
    
    if (isNowSelected == YES) {
//        NSLog(@"%@",_arrayOfCarTypes);
//        msgText = [msgText stringByAppendingString:_arrayOfCarTypes[carTypesForLiveBooking-1][@"type_name"]];
//        NSLog(@"%@",msgText);
//        msgText = [msgText uppercaseString];
    }
    else if (isLaterSelected == YES)
    {
        msgText = laterSelectedDate;
        msgText = [msgText stringByAppendingString:_arrayOfCarTypes[carTypesForLiveBooking-1][@"type_name"]];
    }
    [Helper setButton:requestButton Text:msgText WithFont:Trebuchet_MS FSize:13 TitleColor:UIColorFromRGB(0xffffff) ShadowColor:nil];
    
    [requestButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
    [requestButton setShowsTouchWhenHighlighted:YES];
    [requestButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [requestButton setBackgroundColor:BUTTON_BG_Color];
    
    [requestButton addTarget:self action:@selector(sendAppointmentRequestForLiveBooking) forControlEvents:UIControlEventTouchUpInside];
    requestButton.tag = 500;
    
    UIView *customBottomView=nil;
    
//    if(isPopLockSelected){
//        
//        customBottomView = [[UIView alloc]initWithFrame:CGRectMake(10,basketBottom.frame.size.height-150,300,100)];
//    }
//    else{
    
        customBottomView = [[UIView alloc]initWithFrame:CGRectMake(10,basketBottom.frame.size.height-190,300,140)];
        
        
//    }
    
   
     customBottomView.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithPatternImage:[UIImage imageNamed:@"conform_farequotebtn_bg.png"]];
     customBottomView.tag = 501;
    [basketBottom addSubview:customBottomView];
    
    UIButton *CardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [CardButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [CardButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [CardButton setBackgroundColor:[UIColor whiteColor]];
    appDelegate = (PatientAppDelegate*)[UIApplication sharedApplication].delegate;
    context = [appDelegate managedObjectContext];
	if (context != nil)
    {
        arrDBResult = [[NSMutableArray alloc] initWithArray:[Database getCardDetails]];
        NSString *payment_type = [[NSUserDefaults standardUserDefaults]objectForKey:@"payment_mode"];
        NSString *booking_type =nil;
        if ([payment_type isEqualToString:@"Card"]) {
            payment_type_calue=0;
            booking_type=@"0";
        }
        else if([payment_type isEqualToString:@"Cash"]){
              payment_type_calue=1;
            booking_type=@"1";
        }else if([payment_type isEqualToString:@"Pin"]){
              payment_type_calue=2;
            booking_type=@"2";
        }else{
            //assign 5 when user not select any type of payment
            payment_type_calue=5;
            booking_type=@"";
        }
        
        if(booking_type.length != 0){
          //  Entity *fav = arrDBResult[0];
           // NSString *imageName = [self setPlaceholderToCardType:fav.cardtype];
           // [CardButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
           // [CardButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -80.0, 0.0, 0.0)];
           // [CardButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0,-20.0, 0.0, 0.0)];
            //  [CardButton setTitle:[NSString stringWithFormat:@"PERSONAL ****%@",fav.last4] forState:UIControlStateNormal];
           
           
         
            [Helper setButton:CardButton Text:payment_type WithFont:Trebuchet_MS FSize:13 TitleColor:[UIColor blackColor] ShadowColor:nil];
           // cardId = fav.idCard;
            paymentTypesForLiveBooking = payment_type_calue;
        }
        else{
            
//            if (isPopLockSelected) {
//                
//                CardButton.frame = CGRectMake(0,00,300,37);
//                CardButton.tag = 502;
//                [CardButton addTarget:self action:@selector(cardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//                [Helper setButton:CardButton Text:@"Select Payment Type" WithFont:Trebuchet_MS FSize:13 TitleColor:[UIColor blackColor] ShadowColor:nil];
//            }
//            else{
                 CardButton.frame = CGRectMake(0,37,300,37);
                 CardButton.tag = 503;
                 [CardButton addTarget:self action:@selector(fareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            (isPopLockSelected)?[Helper setButton:CardButton Text:@"Service Estimate" WithFont:Trebuchet_MS FSize:13 TitleColor:[UIColor blackColor] ShadowColor:nil]:[Helper setButton:CardButton Text:@"Fare Estimate" WithFont:Trebuchet_MS FSize:13 TitleColor:[UIColor blackColor] ShadowColor:nil];
            
//                 [Helper setButton:CardButton Text:@"Fare Estimate" WithFont:Trebuchet_MS FSize:13 TitleColor:[UIColor blackColor] ShadowColor:nil];
            
                UIButton *PromoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                PromoButton.frame = CGRectMake(0,0,300,37);
                [Helper setButton:PromoButton Text:@"Select Payment Type" WithFont:Trebuchet_MS FSize:13 TitleColor:[UIColor blackColor]ShadowColor:nil];
                [PromoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [PromoButton setShowsTouchWhenHighlighted:YES];
                [PromoButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
                [PromoButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_farequote_off.png"] forState:UIControlStateNormal];
                [PromoButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_farequote_on.png"] forState:UIControlStateSelected];
                [PromoButton addTarget:self action:@selector(cardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                 PromoButton.tag = 502;
                [customBottomView addSubview:PromoButton];
                
//            }
            
                [CardButton setShowsTouchWhenHighlighted:YES];
            
        }
    }
    
    if (appDelegate._IsSwitchOn == YES) {
       
        
    }else{
        
         [customBottomView addSubview:CardButton];
    }
   
    //FAirView
    UIView *FareView = [[UIView alloc]init];
    [FareView setBackgroundColor:UIThemecolor];
    UIButton *FareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isPopLockSelected) {
//        FareView.frame= CGRectMake(0,37,300,50);
//        FareButton.frame = CGRectMake(15,44,260,36);
        
        
        FareView.frame= CGRectMake(0,74,300,50);
        FareButton.frame = CGRectMake(15,81,260,36);
    }else{
        FareView.frame= CGRectMake(0,74,300,50);
        FareButton.frame = CGRectMake(15,81,130,36);
    }
    [customBottomView addSubview:FareView];
    (isPopLockSelected)?[Helper setButton:FareButton Text:@"REQUEST" WithFont:Trebuchet_MS FSize:12 TitleColor:UIColorFromRGB(0xffffff) ShadowColor:nil]:[Helper setButton:FareButton Text:@"RIDE NOW" WithFont:Trebuchet_MS FSize:12 TitleColor:UIColorFromRGB(0xffffff) ShadowColor:nil];
        
    [FareButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [FareButton setShowsTouchWhenHighlighted:YES];
    [FareButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [FareButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_farequote_off.png"] forState:UIControlStateNormal];
    [FareButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_farequote_on.png"] forState:UIControlStateSelected];
    
    
    //TODO :: I have added New Promo Code Button and Method
    /*
    UIButton *PromoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    PromoButton.frame = CGRectMake(155,44,130,36);
    [Helper setButton:PromoButton Text:@"Promo Code" WithFont:Trebuchet_MS FSize:12 TitleColor:UIColorFromRGB(0xffffff) ShadowColor:nil];
    [PromoButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [PromoButton setShowsTouchWhenHighlighted:YES];
    [PromoButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [PromoButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_farequote_off.png"] forState:UIControlStateNormal];
    [PromoButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_farequote_on.png"] forState:UIControlStateSelected];
    [PromoButton addTarget:self action:@selector(PromoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    PromoButton.tag = 5033;
    [customBottomView addSubview:PromoButton];
    */
    //ToDo :: End
    
    
    //TODO :: I have added New Promo Code Button and Method
    UIButton *PromoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    PromoButton.frame = CGRectMake(155,81,130,36);
    [Helper setButton:PromoButton Text:@"RIDE LATER" WithFont:Trebuchet_MS FSize:12 TitleColor:UIColorFromRGB(0xffffff) ShadowColor:nil];
    [PromoButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [PromoButton setShowsTouchWhenHighlighted:YES];
    [PromoButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    [PromoButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_farequote_off.png"] forState:UIControlStateNormal];
    [PromoButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_farequote_on.png"] forState:UIControlStateSelected];
    [PromoButton addTarget:self action:@selector(rideLatercall:) forControlEvents:UIControlEventTouchUpInside];
     PromoButton.tag = 5033;
    
    if (isPopLockSelected){
       
    }else{
        
        [customBottomView addSubview:PromoButton];
    }
    
   
    //ToDo :: End

    [FareButton addTarget:self action:@selector(sendAppointmentRequestForLiveBooking) forControlEvents:UIControlEventTouchUpInside];
    FareButton.tag = 5022;
    [customBottomView addSubview:FareButton];
    
    [UIView animateWithDuration:0.2
                          delay:0.4
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         // basketTop.frame = basketTopFrame;
                         // basketBottom.frame = basketBottomFrame;
                         basketBottom.frame = basketTopFrame;
                     }
                     completion:^(BOOL finished){
                     }];
}



-(void)PromoButtonClicked{
    
    NSLog(@"Promo code");
    
    
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Promo Code"
                                        message:@"Please enter your promo code."
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Submit", nil];
    
    UITextField *emailForgot = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 225, 30)];
    emailForgot.delegate =self;
    
    emailForgot.placeholder = @"Promo Code";
    
    [forgotPasswordAlert addSubview:emailForgot];
    
    
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [forgotPasswordAlert show];
    
    TELogInfo(@"password recovery to be done here");
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
        
        UITextField *forgotEmailtext = [alertView textFieldAtIndex:0];
        TELogInfo(@"Email Name: %@", forgotEmailtext.text);
        
        if ((unsigned long)forgotEmailtext.text.length == 0)
        {
            
            TELogInfo(@"Promo code: %@", forgotEmailtext.text);
            [Helper showAlertWithTitle:@"Message" Message:@"Enter your Promo Code."];
            
        }
        else
        {
            TELogInfo(@"Promo code: %@", forgotEmailtext.text);
            [self addPromoCode:forgotEmailtext.text];
            
        }
        
    }
    else
    {
        TELogInfo(@"cancel");
        
        
    }
    
}

- (void)addPromoCode:(NSString *)text
{
    
    
    [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Loading.."];    //setup parameters
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_promocode_text":text,
                             };
    
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:kSMAddPromoCode
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       
                                       [self getPromocodeResponse:response];
                                   }
                               }];
    
}

-(void)getPromocodeResponse:(NSDictionary *)responseDictionary{
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    NSString *titleMsg = @"Message";
    NSString *errMsg = @"";
    promocode_id = @"";
    
    
    
    
    
    if (!responseDictionary)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[responseDictionary objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([responseDictionary objectForKey:@"Error"])
    {
        //[Helper showAlertWithTitle:@"Error" Message:[responseDictionary objectForKey:@"Error"]];
        errMsg = [responseDictionary objectForKey:@"errMsg"];
    }
    else
    {
        if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 0)
        {
            errMsg = [responseDictionary objectForKey:@"errMsg"];
            promocode_id = [responseDictionary objectForKey:@"promocode_id"];
            
        }
        else if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 1)
        {
            errMsg = [responseDictionary objectForKey:@"errMsg"];
            
            
        }
        else
        {
            errMsg = [responseDictionary objectForKey:@"errMsg"];
        }
    }
    
    [Helper showAlertWithTitle:titleMsg Message:errMsg];
    
}




/**
 *  This methods get called after calling Handletap method,it brings the main view to its original position
 */

- (void)closeAnimation
{
    //    [UIView animateWithDuration:0.3f animations:^{
    //
    //        self.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
    //        CGRect frame = self.view.frame;
    //        frame.origin.x = 0.f;
    //        self.view.frame = frame;
    //
    //        frame = self.view.frame;
    //        frame.origin.x = 0.f;
    //        self.view.frame = frame;
    //    }];
    [UIView animateWithDuration:0.5f animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeTransparentView{
    
    UIView *viewToClose = [self.view viewWithTag:50];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [viewToClose removeFromSuperview];
    
    [UIView commitAnimations];
    
}

- (void)changeCurrentLocation:(NSDictionary *)dictAddress{
    
    NSString *latitude = [dictAddress objectForKey:@"lat"];
    NSString *longitude = [dictAddress objectForKey:@"lng"];
    NSLog(@"selected lat and longitude :%@ %@",longitude,latitude);
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
    mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:mapZoomLevel-3];
    
}

- (void)custimizeMyLocationButton{
    UIButton *myLocationButton = (UIButton*)[[mapView_ subviews] lastObject];
    myLocationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    CGRect frame = myLocationButton.frame;
    frame.origin.y = -310;
    frame.origin.x = -10;
    myLocationButton.frame = frame;
}

#pragma mark - Animations
- (void)startAnimation{
    
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    UIView *customNaviagtionBar = [self.view viewWithTag:78];
    CGRect rect2 = customNaviagtionBar.frame;
    rect2.origin.y = -44;
    customNaviagtionBar.frame = rect2;
    
    
    if(isCustomMarkerSelected == YES)
    {
        if(PikUpViewForConfirmScreen && DropOffViewForConfirmScreen){
            CGRect rectPick = PikUpViewForConfirmScreen.frame;
            rectPick.origin.y = 20;
            PikUpViewForConfirmScreen.frame = rectPick;
            
            CGRect rectDrop = DropOffViewForConfirmScreen.frame;
            rectDrop.origin.y = 64;
            DropOffViewForConfirmScreen.frame = rectDrop;
        }
        else{
            CGRect rect = PikUpViewForConfirmScreen.frame;
            rect.origin.y = 20;
            PikUpViewForConfirmScreen.frame = rect;
        }
        
        
    }
    else{
        UIView *customLocationView = [self.view viewWithTag:topViewTag];
        CGRect rect = customLocationView.frame;
        rect.origin.y = 20;
        customLocationView.frame = rect;
        
    }
    [UIView commitAnimations];
    
    [self animateOutBottomView];
    
}

- (void)endAnimation{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    UIView *customNaviagtionBar = [self.view viewWithTag:78];
    CGRect rect2 = customNaviagtionBar.frame;
    
    
    rect2.origin.y = 0;
    customNaviagtionBar.frame = rect2;
    
    
    
    if(isCustomMarkerSelected == YES)
    {
        if(PikUpViewForConfirmScreen && DropOffViewForConfirmScreen){
            CGRect rectPick = PikUpViewForConfirmScreen.frame;
            rectPick.origin.y = 64;
            PikUpViewForConfirmScreen.frame = rectPick;
            
            CGRect rectDrop = DropOffViewForConfirmScreen.frame;
            rectDrop.origin.y = 108;
            DropOffViewForConfirmScreen.frame = rectDrop;
        }
        else{
            CGRect rect = PikUpViewForConfirmScreen.frame;
            rect.origin.y = 64;
            PikUpViewForConfirmScreen.frame = rect;
        }
        
        
    }
    else {
        UIView *customLocationView = [self.view viewWithTag:topViewTag];
        CGRect rect = customLocationView.frame;
        rect.origin.y = 64;
        customLocationView.frame = rect;
    }
    
    [UIView commitAnimations];
    [self animateInBottomView];
}


#pragma mark -UIButton Action

-(void)plusButtonClicked:(id)sender
{
    isLocationChanged = isFixed;
    isFareButtonClicked = YES;
    
    UIButton *btn = (UIButton *)[PikUpViewForConfirmScreen viewWithTag:151];
    [self pickupLocationAction:btn];
}
-(void)minusButtonClicked:(id)sender
{
    UIView *dropOff = [self.view viewWithTag:160];
    CGRect dropOffTop = dropOff.frame;
    dropOffTop.origin.y = 0;
    [UIView animateWithDuration:0.6f animations:^{
        dropOff.frame = dropOffTop;
    }];
    [DropOffViewForConfirmScreen removeFromSuperview];
    DropOffViewForConfirmScreen = nil;
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    if(isCustomMarkerSelected == YES)
    {
        isCustomMarkerSelected = NO;
        [self addCustomNavigationBar];
    }
    
    UIView *v = [self.view viewWithTag:myCustomMarkerTag];
    v.hidden = NO;
    
    UIView *coverView = [self.view viewWithTag:300];
    [coverView removeFromSuperview];
    
    
    UIView *basketBottom = [self.view viewWithTag:499];
    UIView *pickUp = [self.view viewWithTag:150];
    UIView *dropOff = [self.view viewWithTag:160];
    
    //    UIView *dropOff = [self.view viewWithTag:160];
    
    CGRect basketTopFrame = basketBottom.frame;
    basketTopFrame.origin.y = 568;//-basketTopFrame.size.height;
    
    CGRect pickUpTop = pickUp.frame;
    pickUpTop.origin.y = 10;
    
    CGRect dropOffTop = dropOff.frame;
    dropOffTop.origin.y = 74+45;
    
    UIView *LV = [self.view viewWithTag:topViewTag];
    CGRect RTEC = LV.frame;
    RTEC.origin.y = 74;
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         basketBottom.frame = basketTopFrame;
                         pickUp.frame = pickUpTop;
                         dropOff.frame = dropOffTop;
                         LV.frame = RTEC;
                     }
                     completion:^(BOOL finished){
                     }];
    
    [PikUpViewForConfirmScreen removeFromSuperview];
    PikUpViewForConfirmScreen = nil;
    
    //TODO::DROPOFF LOCATION CHANGES
    //    [DropOffViewForConfirmScreen removeFromSuperview];
    //    DropOffViewForConfirmScreen = nil;
    
    //TODO::TILL HERE
    
    
    [basketBottom removeFromSuperview];
    // Do Your thing.
    [self closeAnimation];
    
}

-(void)navCancelButtonClciked
{
    isLocationChanged = isChanging;
    [self addCustomLocationView];
    [self getCurrentLocation:nil];
    [self handleTap:nil];
}
-(void)rightBarButtonClicked:(UIButton *)sender{
    [self gotolistViewController];
}
-(void)leftBarButtonClicked:(UIButton *)sender{
    if(isCustomMarkerSelected == YES)
    {
        [self navCancelButtonClciked];
    }
    else
    {
        [self menuButtonPressed:sender];
    }
    
}
-(void)customMarkerTopBottomClicked
{
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Comming Soon!" message:@"This feature is under Process!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    alert=nil;
//    return;
    
    
    
    if (_textFeildAddress.text.length == 0) {
        
        UIView *markerView = (UIView *)[self.view viewWithTag:myCustomMarkerTag];
        [markerView setUserInteractionEnabled:NO];
        
    }
    else {
        UIView *markerView = (UIView *)[self.view viewWithTag:myCustomMarkerTag];
        [markerView setUserInteractionEnabled:YES];
        UIView *v = [self.view viewWithTag:myCustomMarkerTag];
        v.hidden = YES;
        isCustomMarkerSelected = YES;
        [self addCustomNavigationBar];
        [self addCustomViewForShowingCardFareWithAnimation];
        [self addCustomLocationPikUpViewForConfirmScreen];
    }
    
    
}

/**
 * this button will lead you to select card for payment screen
 */
-(void)cardButtonClicked
{
    
     appDelegate._IsShowPaymentMODE=YES;
    isLocationChanged = isFixed; //to fix the pickup location
    isFareButtonClicked = YES; //to make sure that the pickup location is fixed
    _isAddressManuallyPicked = YES;
    
    PaymentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentView"];
    vc.callback = ^(NSString *cardIde , NSString *type){
        NSString *imageName = [self setPlaceholderToCardType:type];
        UIView *v = [self.view viewWithTag:501];
        UIButton *btn = (UIButton *)[v viewWithTag:502];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -80.0, 0.0, 0.0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0,-20.0, 0.0, 0.0)];
        
        if ([appDelegate.paymentTypevalue isEqualToString:@"cash"]) {
            
            
            [btn setTitle:[NSString stringWithFormat:@"%@",cardIde] forState:UIControlStateNormal];
            cardId = cardIde;
            paymentTypesForLiveBooking = 2;
            
        }else{
            
            [btn setTitle:[NSString stringWithFormat:@"PERSONAL ****%@",cardIde] forState:UIControlStateNormal];
            cardId = cardIde;
            
            paymentTypesForLiveBooking = 1;
            
        }
        
        
    };
    
    vc.isComingFromSummary = YES;
    _isSelectinLocation = YES;
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:navBar animated:YES completion:nil];
    
}
/**
 *  when the search button on the home screen is clicked
 *
 *  @param sender sender of the button whose tag is 91,This method is to make sure the location is not changing after picking up the fixing the pickup location
 */
-(void)searchButtonClicked:(id)sender
{
    isLocationChanged = isFixed;
    isFareButtonClicked = YES;
    
    UIButton *mBtn = (UIButton *)sender;
    [self pickupLocationAction:mBtn];
}

/**
 *  this button will either lead you to select drop location or if both the location is selected then directly to fare calculator screen
 */
-(void)fareButtonClicked
{
    if(isPopLockSelected){
        NSDictionary *params = @{@"cLoc":[NSString stringWithFormat:@"%f",_currentLongitudeFare],
                                 @"cLat":[NSString stringWithFormat:@"%f",_currentLatitudeFare],
                                 @"pLoc":[NSString stringWithFormat:@"%f",srcLong],
                                 @"pLat":[NSString stringWithFormat:@"%f",srcLat],
                                 @"pAddr":srcAddr,
                                 @"dLat":[NSString stringWithFormat:@"%f",desLat],
                                 @"dLon":[NSString stringWithFormat:@"%f",desLong],
                                 @"dAddr":@"",
                                 };
        
        fareCalculatorViewController *invoiceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fareVC"];
        invoiceVC.locationDetails = params;
        invoiceVC.isComingFromMapVC = YES;
        invoiceVC.carTypesForLiveBookingServer = carTypesForLiveBookingServer;
        
        _isSelectinLocation = YES;
        invoiceVC.isPopLockSelected  = true;
    

        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:invoiceVC];
        [self presentViewController:navBar animated:YES completion:nil];
        
        
    }
    
    
    
    else{
    isLocationChanged = isFixed;
    isFareButtonClicked = YES;
    _isAddressManuallyPicked = YES;
    if(srcAddr == nil)
    {
        UITextField *textAddress = (UITextField *)[PikUpViewForConfirmScreen viewWithTag:pickupAddressTag];
        
        srcAddr = textAddress.text;
        srcAddrline2 = @"";
    }
    
    if(DropOffViewForConfirmScreen == nil)
    {
        [self pickupLocationAction:nil];
        if(desAddr == nil)
            desAddr = @"";
        desAddrline2 = @"";
    }
    else
    {
        if (desAddr == nil) {
            
            [self pickupLocationAction:nil];
            if(desAddr == nil)
                desAddr = @"";
            desAddrline2 = @"";
            
        }else{
            
            NSDictionary *params = @{@"cLoc":[NSString stringWithFormat:@"%f",_currentLongitudeFare],
                                     @"cLat":[NSString stringWithFormat:@"%f",_currentLatitudeFare],
                                     @"pLoc":[NSString stringWithFormat:@"%f",srcLong],
                                     @"pLat":[NSString stringWithFormat:@"%f",srcLat],
                                     @"pAddr":srcAddr,
                                     @"dLat":[NSString stringWithFormat:@"%f",desLat],
                                     @"dLon":[NSString stringWithFormat:@"%f",desLong],
                                     @"dAddr":desAddr,
                                     };
            
            fareCalculatorViewController *invoiceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fareVC"];
            invoiceVC.locationDetails = params;
            invoiceVC.isComingFromMapVC = YES;
            invoiceVC.carTypesForLiveBookingServer = carTypesForLiveBookingServer;
             invoiceVC.isPopLockSelected  = true;
            _isSelectinLocation = YES;
            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:invoiceVC];
            [self presentViewController:navBar animated:YES completion:nil];
            
        }
        
        
    }
    }
}

- (IBAction)menuButtonPressed:(id)sender
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

-(void)gotolistViewController
{
    
    
}

- (void)getCurrentLocation:(UIButton *)sender{
    
    CLLocation *location = mapView_.myLocation;
    _currentLatitude = location.coordinate.latitude;
    _currentLongitude = location.coordinate.longitude;
    
    if (location) {
        [mapView_ animateToLocation:location.coordinate];
    }
    
    //for fare calculations
    if((isFareButtonClicked == YES)&&(PikUpViewForConfirmScreen))
    {
        _currentLatitudeFare = location.coordinate.latitude;
        _currentLongitudeFare = location.coordinate.longitude;
        
    }
    [self checkDifferenceBetweenTwoLocationAndUpdateCache];
}

- (void)pickupLocationAction:(UIButton *)sender
{
    PickUpViewController *pickController = [self.storyboard instantiateViewControllerWithIdentifier:@"pick"];
    if(sender.tag == 155){
        pickController.locationType = 1;
        pickController.isComingFromMapVCFareButton = NO;
    }
    else if(sender.tag == 165){
        pickController.locationType = 2;
        pickController.isComingFromMapVCFareButton = NO;
    }
    else if(sender.tag == 91){
        pickController.locationType = 4;
        pickController.isComingFromMapVCFareButton = NO;
    }
    else if(sender.tag == 151){
        pickController.locationType = 3;
        pickController.isComingFromMapVCFareButton = NO;
    }
    else{
        pickController.locationType = 3;
        pickController.isComingFromMapVCFareButton = YES;
    }
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:pickController];
    //[self.navigationController pushViewController:invoiceVC animated:YES];
    pickController.latitude =  [NSString stringWithFormat:@"%f",mapView_.myLocation.coordinate.latitude];
    pickController.longitude = [NSString stringWithFormat:@"%f",mapView_.myLocation.coordinate.longitude];
    
    pickController.carTypesForLiveBookingServer = carTypesForLiveBookingServer;
    
    pickController.onCompletion = ^(NSDictionary *dict,NSInteger locationType){
        
        _isAddressManuallyPicked = YES;
        
        NSString *addressText = flStrForStr(dict[@"address1"]);
        addressText = [addressText stringByAppendingString:flStrForStr(dict[@"address2"])];
        if(locationType == 1)
        {
            UITextField *textAddress = (UITextField *)[PikUpViewForConfirmScreen viewWithTag:pickupAddressTag];
            textAddress.text = addressText;
            srcAddr = flStrForStr(dict[@"address1"]);
            srcAddrline2 = flStrForStr(dict[@"address2"]);
            srcLat = [dict[@"lat"] floatValue];
            srcLong = [dict[@"lng"] floatValue];
            
        }
        else if(locationType == 4)
        {
            _textFeildAddress.text = addressText;
            srcAddr = flStrForStr(dict[@"address1"]);
            srcAddrline2 = flStrForStr(dict[@"address2"]);
            srcLat = [dict[@"lat"] floatValue];
            srcLong = [dict[@"lng"] floatValue];
            
        }
        else if (locationType == 2)
        {
            UIView *customView = [self.view viewWithTag:160];
            UITextField *textAddress = (UITextField *)[customView viewWithTag:161];
            textAddress.text = addressText;
            desAddr = flStrForStr(dict[@"address1"]);
            desAddrline2 = flStrForStr(dict[@"address2"]);
            desLat = [dict[@"lat"] floatValue];
            desLong = [dict[@"lng"] floatValue];
            
        }
        else
        {
            [self addCustomLocationDropOffViewForConfirmScreen];
            UIView *customView = [self.view viewWithTag:160];
            UITextField *textAddress = (UITextField *)[customView viewWithTag:161];
            textAddress.text = addressText;
            desAddr = flStrForStr(dict[@"address1"]);
            desAddrline2 = flStrForStr(dict[@"address2"]);
            desLat = [dict[@"lat"] floatValue];
            desLong = [dict[@"lng"] floatValue];
        }
       // [self performSelectorOnMainThread:@selector(changeCurrentLocation:) withObject:dict waitUntilDone:YES];
        
    };
    AppointmentLocation *apLocaion = [AppointmentLocation sharedInstance];
    apLocaion.currentLatitude = [NSNumber numberWithDouble:_currentLatitudeFare] ;
    apLocaion.currentLongitude =  [NSNumber numberWithDouble:_currentLongitudeFare];
    apLocaion.pickupLatitude = [NSNumber numberWithDouble:srcLat];
    apLocaion.pickupLongitude = [NSNumber numberWithDouble:srcLong];
    apLocaion.dropOffLatitude = [NSNumber numberWithDouble:desLat];
    apLocaion.dropOffLongitude = [NSNumber numberWithDouble:desLong];
    apLocaion.srcAddressLine1 = flStrForObj(srcAddr);
    apLocaion.srcAddressLine2 = flStrForObj(srcAddrline2);
    apLocaion.desAddressLine1 = flStrForObj(desAddr);
    apLocaion.desAddressLine2 = flStrForObj(desAddrline2);
    
    _isSelectinLocation = YES;
    
    [self presentViewController:navBar animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"pickup"])
    {
        PickUpViewController *pickController = [segue destinationViewController];
        pickController.latitude =  [NSString stringWithFormat:@"%f",mapView_.myLocation.coordinate.latitude];
        pickController.longitude = [NSString stringWithFormat:@"%f",mapView_.myLocation.coordinate.longitude];
        pickController.carTypesForLiveBookingServer = carTypesForLiveBookingServer;
        pickController.onCompletion = ^(NSDictionary *dict,NSInteger locationType){
            UIView *customView = [mapView_ viewWithTag:90];
            UITextField *textAddress = (UITextField *)[customView viewWithTag:101];
            textAddress.text = dict[@"formatted_address"];
            //labelAddress.text = dict[@"formatted_address"];
            //[btn setTitle:dict[@"formatted_address"] forState:UIControlStateNormal];
            
            [self performSelectorOnMainThread:@selector(changeCurrentLocation:) withObject:dict waitUntilDone:YES];
            
            NSString *latitude = [dict valueForKeyPath:@"geometry.location.lat"];
            NSString *longitude = [dict valueForKeyPath:@"geometry.location.lng"];
            
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
            [mDict setValue:latitude forKey:@"Latitude"];
            [mDict setValue:longitude forKey:@"Longitude"];
            
        };
    }
}

- (void)getAddress:(CLLocationCoordinate2D)coordinate{
    
    GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response,
                                          NSError *error) {
        if (response && response.firstResult) {
            
            GMSAddress *address = response.firstResult;
            NSString *addresstext = [address.lines componentsJoinedByString:@","];
            
            UIView *customView = [self.view viewWithTag:topViewTag];
            UITextField *textAddress = (UITextField *)[customView viewWithTag:101];
            textAddress.text =  addresstext; //[response.firstResult.lines objectAtIndex:0];
            //  UIView *customView1 = [self.view viewWithTag:150];
            UITextField *pickUpAddress= (UITextField *)[PikUpViewForConfirmScreen viewWithTag:pickupAddressTag];
            if(!(isLocationChanged == isFixed))
            {
                pickUpAddress.text = addresstext; //[response.firstResult.lines objectAtIndex:0];
            }
            if(PikUpViewForConfirmScreen && DropOffViewForConfirmScreen)
            {
                UIView *customView = [self.view viewWithTag:160];
                UITextField *textAddress = (UITextField *)[customView viewWithTag:161];
                textAddress.text =  addresstext;//[response.firstResult.lines objectAtIndex:0];
                desAddr = textAddress.text;
                desAddrline2 = flStrForObj(response.firstResult.subLocality);
                desLat = response.firstResult.coordinate.latitude;
                desLong = response.firstResult.coordinate.longitude;
                
            }
            else
            {
                srcLat = response.firstResult.coordinate.latitude;
                srcLong = response.firstResult.coordinate.longitude;
                srcAddr = pickUpAddress.text;
                srcAddrline2 = flStrForObj(response.firstResult.subLocality);
            }
        }
        else
        {
            // NSLog(@"Could not reverse geocode point (%f,%f): %@",
            //coordinate.latitude, coordinate.longitude, error);
        }
    };
    
    [geocoder_ reverseGeocodeCoordinate:coordinate completionHandler:handler];
    
}

#pragma mark UITextField Delegate -
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)getCurrentLocation {
    
    //check location services is enabled
    if ([CLLocationManager locationServicesEnabled]) {
        
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if  ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.locationManager requestAlwaysAuthorization];
            }
        }
        [_locationManager startUpdatingLocation];
        
        
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Service" message:@"Unable to find your location,Please enable location services." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

#pragma mark - PAYMENT
-(NSString *)setPlaceholderToCardType:(NSString *)mycardType
{
    NSString* cardTypeName   = @"placeholder";
    if([mycardType isEqualToString:@"amex"])
        cardTypeName = @"amex";
    else if([mycardType isEqualToString:@"diners"])
        cardTypeName = @"diners";
    else if([mycardType isEqualToString:@"discover"])
        cardTypeName = @"discover";
    else if([mycardType isEqualToString:@"jcb"])
        cardTypeName = @"jcb";
    else if([mycardType isEqualToString:@"MasterCard"])
        cardTypeName = @"mastercard";
    else if([mycardType isEqualToString:@"Visa"])
        cardTypeName = @"visa.png";
    
    return cardTypeName;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSInteger bookingStatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"STATUSKEY"];
    
    if (bookingStatus == kNotificationTypeBookingOnMyWay) {
        if (!_isUpdatedLocation) {
            
            [_locationManager stopUpdatingLocation];
            
            //change flag that we have updated location once and we don't need it again
            _isUpdatedLocation = YES;
            
            //save current location to plot direciton on map
            _currentLatitude = newLocation.coordinate.latitude;
            _currentLongitude =  newLocation.coordinate.longitude;
            
            [_allMarkers removeAllObjects];
            [mapView_ clear];
            
            if (_currentLatitude == 0 && _currentLongitude == 0) {
                //[self stopPubNubStream];
            }
            else {
                //[self stopPubNubStream];
                [self setStartLocationCoordinates:_currentLatitude Longitude:_currentLongitude:2];
            }
            
            
        }
    }
    else if (bookingStatus == kNotificationTypeBookingReachedLocation){
        
        [_locationManager stopUpdatingLocation];
        //change map camera postion to current location
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                longitude:newLocation.coordinate.longitude
                                                                     zoom:15];
        [mapView_ setCamera:camera];
        
        
        //add marker at current location
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        //save current location to plot direciton on map
        _currentLatitude = newLocation.coordinate.latitude;
        _currentLongitude =  newLocation.coordinate.longitude;
        
        //get address for current location
        [self getAddress:position];
        
        //change flag that we have updated location once and we don't need it again
        _isUpdatedLocation = YES;
    }
    else{
        if (!_isUpdatedLocation) {
            _isUpdatedLocation = YES;
            [_locationManager stopUpdatingLocation];
            //change map camera postion to current location
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                    longitude:newLocation.coordinate.longitude
                                                                         zoom:15];
            [mapView_ setCamera:camera];
            
            
            //add marker at current location
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
            //save current location to plot direciton on map
            _currentLatitude = newLocation.coordinate.latitude;
            _currentLongitude =  newLocation.coordinate.longitude;
            
            //get address for current location
            [self getAddress:position];
            
            MyAppTimerClass *obj = [MyAppTimerClass sharedInstance];
            [obj startPublishTimer];
            
            
        }
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorDenied) {
        // The user denied your app access to location information.
        [self gotoLocationServicesMessageViewController];
    }
    TELogInfo(@"locationManager failed to update location : %@",[error localizedDescription]);
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showMessage:[error localizedDescription] On:self.view];
    
}

-(void)locationServicesChanged:(NSNotification*)notification{
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self gotoLocationServicesMessageViewController];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized){
        [self.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)gotoLocationServicesMessageViewController{
    
    LocationServicesMessageVC *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"locationVC"];
    UINavigationController *navigationVC  = [[UINavigationController alloc] initWithRootViewController:locationVC];
    [self.navigationController presentViewController:navigationVC animated:YES completion:nil];
}

/**
 *  swithc between appointment type
 *  @param sender button
 */

- (void)checkDoctorsAvailability:(UIButton *)sender{
    
    if (sender.tag == 107) // Now
    {
        isNowSelected = YES;
        isLaterSelected = NO;
        [sender setSelected:isNowSelected];
        UIButton *laterButton =  (UIButton*)[(UIView*)[sender superview] viewWithTag:108];
        [laterButton setSelected:isLaterSelected];
        
    }
    else if(sender.tag == 108) //Later
    {
        isNowSelected = NO;
        isLaterSelected = YES;
        
        [sender setSelected:isLaterSelected];
        
        UIButton *nowButton =  (UIButton*)[(UIView*)[sender superview] viewWithTag:107];
        [nowButton setSelected:isNowSelected];
    }
    
}

/**
 *  will return the Medical Specialist
 *
 *  @return MedicalSpecialistType Nurse or Doctor
 */
-(CarSpecialistType)getSelectedCarTypes {
    
    if (isCarType1Selected) {
        return   kRoadyoCarOne;
    }
    else if(isCarType2Selected){
        return kRoadyoCarTwo;
    }
    if (isCarType3Selected) {
        return   kRoadyoCarThree;
    }
    else {
        return kRoadyoCarFour;
    }
    
}

/**
 *  will return the Appointment Type
 *
 *  @return Appointment type Nor or Later
 */
-(AppointmentType)getSelectedAppointmentType {
    
    if (isNowSelected) {
        return  kAppointmentTypeNow;
    }
    
    return kAppointmentTypeLater;
    
}

/**
 *  Plots Marker on Map
 *  @param medicalSpecialist doctor or nurse
 */

- (void)addCustomMarkerFor:(CarSpecialistType)medicalSpecialist
{
    TELogInfo(@"Drivers Around : %@ ",doctors);
    
    if (!_allMarkers) {
        
        _allMarkers = [[NSMutableDictionary alloc] init];
    }
    
    for (int i = 0; i < doctors.count; i++)
    {
        
        NSDictionary *dict = doctors[i];
        float latitude = [dict[@"lt"] floatValue];
        float longitude = [dict[@"lg"] floatValue];
        
        if (!_allMarkers[dict[@"chn"]]) {
                TELogInfo(@"Drivers Channel Present Already : %@ \n ",_allMarkers[dict[@"chn"]]);
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(latitude, longitude);
            marker.tappable = YES;
            marker.flat = YES;
            marker.groundAnchor = CGPointMake(0.5f, 0.5f);
            marker.userData =  dict;
            if (carTypesForLiveBooking == 1) {
                marker.icon = [UIImage imageNamed:@"home_caricon_blue.png"];
            }
            else if (carTypesForLiveBooking == 2){
                marker.icon = [UIImage imageNamed:@"home_caricon_red.png"];
            }
            else if (carTypesForLiveBooking == 3){
                marker.icon = [UIImage imageNamed:@"home_caricon_black.png"];
            }
            else if (carTypesForLiveBooking == 4){
                marker.icon = [UIImage imageNamed:@"home_caricon.png"];
            }

            marker.map = mapView_;
            
            [_allMarkers setObject:marker forKey:dict[@"chn"]];
        }
        else {
            
            GMSMarker *marker = _allMarkers[dict[@"chn"]];
            CLLocationCoordinate2D lastPosition =  marker.position;
            CLLocationCoordinate2D newPosition = CLLocationCoordinate2DMake(latitude, longitude);
            CLLocationDirection heading = GMSGeometryHeading(lastPosition, newPosition);
            marker.position = newPosition;
            [CATransaction begin];
            [CATransaction setAnimationDuration:2.0];
            marker.position = CLLocationCoordinate2DMake(latitude, longitude);
            [CATransaction commit];
            if (marker.flat) {
                marker.rotation = heading;
            }
        }
        
        
    }
    
    [doctors removeAllObjects];
    
}

-(void)removeMarker:(GMSMarker*)marker{
    
    marker.map = mapView_;
    marker.map = nil;
}

/**
 *  checking for push is coming or not
 */

#pragma mark - WebServiceRequest

-(void)sendRequestToGetDriverDetails:(NSString *)driEmail :(NSString *)apptDt :(NSString *)apptid{
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isServiceCalledOnce"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self bookingAccetedBySomeDriverScreenLayout];
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
    
    NSString *docEmail = driEmail;
    NSString *appointmntDate = apptDt;
    NSString *currentDate = [Helper getCurrentDateTime];
    
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_email":docEmail,
                             @"ent_user_type":@"2",
                             @"ent_appnt_dt":appointmntDate,
                             @"ent_date_time":currentDate,
                             @"ent_appnt_id":apptid,
                             };
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:kSMGetAppointmentDetial
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   if (success) { //handle success response
                                       
                                       [self parseDriverDetailResponse:response];
                                       
                                   }
                                   else {
                                       
                                       [pi hideProgressIndicator];
                                   }
                               }];
}

#pragma mark - WebService Response

-(void)parseDriverDetailResponse:(NSDictionary*)response{
    
    NSLog(@"parseDriverDetailResponse");
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
    if (response == nil) {
        return;
    }
    else if ([response objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
    }
    else
    {
        if ([[response objectForKey:@"errFlag"] integerValue] == 0)
        {
            NSArray *driverLatitudeLongitude = [response[@"ltg"] componentsSeparatedByString:@","];
            _driverCurLat = [driverLatitudeLongitude[0] doubleValue];
            _driverCurLong = [driverLatitudeLongitude[1]doubleValue];
            
            NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
            [ud setObject:response[@"model"] forKey:@"MODEL"];
            [ud setObject:response[@"plateNo"] forKey:@"PLATE"];
            [ud setObject:response[@"chn"] forKey:@"subscribedChannel"];
            
            subscribedChannel = response[@"chn"];
            [(PatientAppDelegate*)[[UIApplication sharedApplication] delegate]noPushForceChangingController:response :6];
            
        }
    }
}

/**
 *  date picker
 *
 *  @param  Select date for the later booking
 *
 *  @return return void and accept title string to show title on its view
 */


/**
 *  Polling Service
 */
-(void)startPollingTimer{
    
    //    if (!pollingTimer)
    //    {
    //        pollingTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(checkBookingStatus) userInfo:Nil repeats:YES];
    //        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    //        [runloop addTimer:pollingTimer forMode:NSRunLoopCommonModes];
    //        [runloop addTimer:pollingTimer forMode:UITrackingRunLoopMode];
    //
    //    }
}


/**
 *  polling check Returns nothing and accepts nothing
 */
-(void)checkBookingStatus {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud objectForKey:KUDriverEmail];
    [ud objectForKey:KUBookingDate];
    [ud synchronize];
    
    
    if ([ud boolForKey:kNSUIsPassengerBookedKey]) {
        
        //   NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
        //   AppointedDoctor *apDoc = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
        
        PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
        
        if ( [reachability isNetworkAvailable]) {
            
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kNSUIsPassengerBookedKey]) {
                
                [self checkOngoingAppointmentStatus:[ud objectForKey:@"BookingDate"]];
            }
            else{
                
                if (!_isBookingStatusCheckedOnce) {
                    
                    [[ProgressIndicator sharedInstance] showPIOnView:self.view withMessage:@"Checking Booking Status.."];
                    
                    [self checkOngoingAppointmentStatus:[ud objectForKey:@"BookingDate"]];
                    
                }
            }
        }
    }
    
    
    
}

/**
 *  Polling check
 */

-(void)checkOngoingAppointmentStatus:(NSString *)appDate {
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    NSString *appointmntDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"BookingDate"];
    
    NSString *BOOKINGID = [[NSUserDefaults standardUserDefaults]objectForKey:@"BOOKINGID"];

    
    
    if (appDate == nil || appDate.length == 0) {
        appointmntDate = appointmntDate;
    }
    else {
        appointmntDate = appDate;
    }
    
    NSString *currentDate = [Helper getCurrentDateTime];
    
    @try {
        NSDictionary *params = @{@"ent_sess_token":sessionToken,
                                 @"ent_dev_id":deviceID,
                                 @"ent_user_type":@"2",
                                 @"ent_appnt_dt":appointmntDate,
                                 @"ent_date_time":currentDate,
                                 @"ent_appnt_id":BOOKINGID,
                                 };
        
        NetworkHandler *networHandler = [NetworkHandler sharedInstance];
        [networHandler composeRequestWithMethod:@"getApptStatus"
                                        paramas:params
                                   onComplition:^(BOOL success, NSDictionary *response){
                                       
                                       if (success) { //handle success response
                                           [self performSelectorOnMainThread:@selector(parsepollingResponse:) withObject:response waitUntilDone:YES];
                                           // [self parsepollingResponse:response];
                                       }
                                   }];
    }
    @catch (NSException *exception) {
        
        [[ProgressIndicator sharedInstance] hideProgressIndicator];
        [self clearUserDefaultsAfterBookingCompletion];
        [self changeContentOfPresentController:nil];
        NSLog(@"Exception %@",[exception description]);
    }
    
    
    
}
-(void)parsepollingResponse:(NSDictionary *)responseDict{
    
    NSLog(@"parsepollingResponse responseDict %@ ",responseDict);
    [[ProgressIndicator sharedInstance] hideProgressIndicator];
    
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
            NSDictionary *dictionary;
            if (responseDict[@"data"]) {
                dictionary =  responseDict[@"data"][0];
                NSArray *driverLatitudeLongitude = [dictionary[@"ltg"] componentsSeparatedByString:@","];
                _driverCurLat = [driverLatitudeLongitude[0] doubleValue];
                _driverCurLong = [driverLatitudeLongitude[1]doubleValue];
                
            }
            else {
                dictionary =  responseDict;
            }
            
            
            NSInteger newBookingStatus =   [[dictionary objectForKey:@"status"]integerValue];
            
            if (newBookingStatus == 5) { //driver cancelled booking
                
                [self clearUserDefaultsAfterBookingCompletion];
                newBookingStatus = 10;
            }
            else if (newBookingStatus == 4) // cancelled booking
            {
                [self clearUserDefaultsAfterBookingCompletion];
                newBookingStatus = 11;
            }
            [(PatientAppDelegate*)[[UIApplication sharedApplication] delegate]noPushForceChangingController:dictionary :newBookingStatus];
            
        }
        else {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self changeContentOfPresentController:nil];
            });
        }
    }
}

/**
 *  CREATING A VIEW THAT WILL SHOW THE DRIVER STATUS
 *
 *  @return RETURNS VOID ACCEPT NOTHING
 */

-(void)createDriverMessageShowingView:(int)bookingStatus {
    
    UILabel *vb = (UILabel *)[self.view viewWithTag:driverMessageViewTag];
    NSArray *arr = self.view.subviews;
    
    if (![arr containsObject:vb]) {
        
        
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,84,280,40)];
        msgLabel.tag = driverMessageViewTag;
        [Helper setToLabel:msgLabel Text:[NSString stringWithFormat:@"%@",@"BOOKING ID :"] WithFont:Trebuchet_MS_Bold FSize:15 Color:[UIColor blackColor]];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.layer.borderWidth = 0.5f;
        msgLabel.layer.borderColor = [UIColor blackColor].CGColor;
        msgLabel.backgroundColor = [UIColor colorWithWhite:1.00f alpha:1.000];
        [self.view addSubview:msgLabel];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *appointmentID = @"";
        if (bookingStatus == kNotificationTypeBookingReachedLocation){
            appointmentID = [NSString stringWithFormat:@"BOOKING ID : %@",[appointmentID  stringByAppendingString:flStrForObj([ud objectForKey:@"bookingid"])]];
        }
        else{
            appointmentID = [NSString stringWithFormat:@"BOOKING ID : %@",[appointmentID  stringByAppendingString:flStrForObj([ud objectForKey:@"bookingid"])]];
        }
        msgLabel.text = appointmentID;
    }
    else{
        
    }
    
}

-(void)changeLabelMessageToShowDriverStatus:(int)bookingStatus
{
    UILabel *msgLabel = (UILabel *)[self.view viewWithTag:driverMessageViewTag];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
    AppointedDoctor *apDoc = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    NSString *appointmentID = @"";
    if (bookingStatus == kNotificationTypeBookingReachedLocation){
        appointmentID = [NSString stringWithFormat:@"Driver reached (%@)",[appointmentID  stringByAppendingString:apDoc.appointmentID]];
    }
    else{
        appointmentID = [NSString stringWithFormat:@"Driver on the way (%@)",[appointmentID  stringByAppendingString:apDoc.appointmentID]];
    }
    msgLabel.text = appointmentID;
}


/**
 *  CREATING A VIEW THAT WILL APPEAR AFTER GETTING THE FIRST PUSH
 */

-(void)createDriverArrivedView
{
    UIView *vb = [self.view viewWithTag:driverArrivedViewTag];
    NSArray *arr = self.view.subviews;
    
    if (![arr containsObject:vb]) {
        
        CGSize size = [[UIScreen mainScreen] bounds].size;
        
        UIView *bottomContainerView = [[UIView alloc]initWithFrame:CGRectMake(0,size.height-110, 320,110)];
        bottomContainerView.backgroundColor =BUTTON_BG_Color;
        [bottomContainerView setHidden:NO];
        bottomContainerView.tag = driverArrivedViewTag;
        
        //get doctor detail
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        RoundedImageView *profilepic = [[RoundedImageView alloc] initWithFrame:CGRectMake(10,5,80,80)];
        profilepic.image = [UIImage imageNamed:@"signup_profile_image.png"];
        [bottomContainerView addSubview:profilepic];
        
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForOriginalImage,[ud objectForKey:@"driverpic"]];
        [profilepic sd_setImageWithURL:[NSURL URLWithString:strImageUrl]
                   placeholderImage:[UIImage imageNamed:@"signup_profile_image.png"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imgUrl) {
                          }];

        UILabel *doctorName = [[UILabel alloc] initWithFrame:CGRectMake(100,5,165, 20)];
        [Helper setToLabel:doctorName Text:flStrForStr([ud objectForKey:@"drivername"]).uppercaseString WithFont:Trebuchet_MS_Bold FSize:13 Color:[UIColor whiteColor]];
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
        [Helper setToLabel:vehicleNo Text:[ud objectForKey:@"PLATE"] WithFont:Trebuchet_MS FSize:12 Color:[UIColor whiteColor]];
        [bottomContainerView addSubview:vehicleNo];
        
        UILabel *cartype = [[UILabel alloc] initWithFrame:CGRectMake(100,65,165,20)];
        cartype.tag = 301;
        [Helper setToLabel:cartype Text:[ud objectForKey:@"MODEL"] WithFont:Trebuchet_MS FSize:12 Color:[UIColor whiteColor]];
        [bottomContainerView addSubview:cartype];
        
        
        UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(5,90, 155, 15)];
        distance.tag = 1000;
        [Helper setToLabel:distance Text:[NSString stringWithFormat:@"Distance: %@...",@"Updating"] WithFont:Trebuchet_MS FSize:12 Color:[UIColor whiteColor]];
        [bottomContainerView addSubview:distance];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(160, 90, 155, 15)];
        time.tag = 2000;
        [Helper setToLabel:time Text:[NSString stringWithFormat:@"Time: %@...",@"Updating"] WithFont:Trebuchet_MS FSize:12 Color:[UIColor whiteColor]];
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
    else{
        
    }
}



-(void)detailsButtonClicked:(id)sender
{
    UIButton *mBut = (UIButton *)sender;
    if(mBut.isSelected)
    {
        mBut.selected = NO;
        [self removeDriverDetailScreen];
    }
    else
    {
        mBut.selected = YES;
        [self createDriverDetailScreen];
        
    }
}

/**
 *  view that will add on the center of the window (Mainly showing share contact and cancel trip)
 */

-(void)createDriverDetailScreen
{
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].bounds.size.height-110)];
    coverView.tag = 499;
    coverView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForDetailButtonClicked:)];
    [coverView addGestureRecognizer:tapRecognizer];
    
    UIView *cd = [[UIView alloc]initWithFrame:CGRectMake(22,508/2-160/2,274, _heightCenter)];
    cd.tag = 500;
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0,0,_width,52);
    shareButton.tag = 501;
    [Helper setButton:shareButton Text:@"SHARE ETA" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
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
    contactButton.frame = CGRectMake(0,53,_width/2,52);
    contactButton.tag = 502;
    [Helper setButton:contactButton Text:@"MESSAGE" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    contactButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    contactButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [contactButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [contactButton setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
    [contactButton addTarget:self action:@selector(contactButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
   // [cd addSubview:contactButton];
    
    UIButton *callDriver = [UIButton buttonWithType:UIButtonTypeCustom];
    callDriver.frame = CGRectMake(0,53,_width/2,52);
    callDriver.tag = 503;
    contactButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [Helper setButton:callDriver Text:@"CALL" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    callDriver.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [callDriver setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [callDriver setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
    [callDriver addTarget:self action:@selector(callToDriver) forControlEvents:UIControlEventTouchUpInside];
    [cd addSubview:callDriver];
    
    NSInteger bookingStatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"STATUSKEY"];
    
    if (bookingStatus == kNotificationTypeBookingStarted) {
        
        
        cd.frame = CGRectMake(22,508/2-160/2,274, _heightCenter-54);
    }
    else {
        
        UILabel *line2Label = [[UILabel alloc]initWithFrame:CGRectMake(20,105,_widthLabel,1)];
        line2Label.tag = 102;
        line2Label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"drivermenu_popup_divider"]];
        [cd addSubview:line2Label];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0,106, 253,52);
        cancelButton.tag = 502;
        [Helper setButton:cancelButton Text:@"CANCEL TRIP" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cancelButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [cancelButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [cancelButton setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cd addSubview:cancelButton];
        
    }
    cd.backgroundColor = NavBarTint_Color;
    [coverView addSubview:cd];
    
    [self.view addSubview:coverView];
    
}


-(void)removeDriverDetailScreen
{
    UIView *cd = (UIView *)[self.view viewWithTag:499];
    [cd removeFromSuperview];
    
}

- (void)handleTapForDetailButtonClicked:(UITapGestureRecognizer*)recognizer
{
    
    // if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        UIButton *mBtn = (UIButton *)[self.view viewWithTag:201];
        [self detailsButtonClicked:mBtn];
    }
}

-(void)shareButtonClicked:(id)sender{
    
    UIButton *mBtn = (UIButton *)[self.view viewWithTag:201];
    [self detailsButtonClicked:mBtn];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share"delegate:self cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter",@"Email", nil];
    // [actionSheet showInView:self.view];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}
-(void)callToDriver {
    
    NSString *number = [[NSUserDefaults standardUserDefaults]objectForKey:@"DriverTelNo"];
    NSURL* callUrl=[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",flStrForStr(number)]];
    
    //check  Call Function available only in iphone
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"This function is only available on the iPhone"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)contactButtonClicked:(id)sender{
    
    UIButton *mBtn = (UIButton *)[self.view viewWithTag:201];
    [self detailsButtonClicked:mBtn];
    NSString *number = [[NSUserDefaults standardUserDefaults]objectForKey:@"DriverTelNo"];
    MessageViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"messageVC"];
    messageVC.driverMobileNumber = number;
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:messageVC];
    [self presentViewController:navBar animated:YES completion:nil];
}

-(void)buttonClicked:(id)sender {
    
    UIButton *mBtn = (UIButton *)[self.view viewWithTag:201];
    [self detailsButtonClicked:mBtn];
    
    [self sendRequestForCancelAppointment];
    
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
    
    NSString *driverEmail  = [[NSUserDefaults standardUserDefaults] objectForKey:KUDriverEmail];
    NSString *appointmntDate = [[NSUserDefaults standardUserDefaults] objectForKey:KUBookingDate];
    
     NSString *BookingID = [[NSUserDefaults standardUserDefaults] objectForKey:@"BOOKINGID"];
    
    
    NSString *currentDate = [Helper getCurrentDateTime];
    
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_dri_email":driverEmail,
                             @"ent_appnt_dt":appointmntDate,
                             @"ent_date_time":currentDate,
                             @"ent_appnt_id":BookingID,
                             };
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:kSMCancelAppointment
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
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
        
        UIButton *mBtn = (UIButton *)[self.view viewWithTag:201];
        [self detailsButtonClicked:mBtn];
        
    }
    else if([response[@"errFlag"] integerValue] == 0 && [response[@"errNum"] integerValue] == 43)
    {
        
        UIButton *mBtn = (UIButton *)[self.view viewWithTag:201];
        [self detailsButtonClicked:mBtn];
        
        
    }
    else
    {
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JOBCOMPLETED" object:nil userInfo:nil];
    [self getCurrentLocation:nil];
    [Helper showAlertWithTitle:@"Message" Message:response[@"errMsg"]];
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
        //     NSString *strETA = [NSString stringWithFormat:@"I will be there within  and my current distance from your location is"];
        [tweetSheet setInitialText:strETA];
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"109.90"]]];
        [tweetSheet addImage:image];
        
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Uber App",@"name",
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
        
        //   NSString *strETA = [NSString stringWithFormat:@"I will be there within and my current distance from your location is"];
        [mailer setSubject:@"Uber App"];
        
        
        NSArray *toRecipents;
        NSMutableString* message =[[NSMutableString alloc] init];
        
        [message appendString:strETA];
        
        toRecipents = [NSArray arrayWithObject:@"rajkumar.iosdev@gmail.com"];
        
        
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

-(void)updateDistance:(NSString*)distane estimateTime:(NSString*)eta{
    UIView *btmView = [self.view viewWithTag:driverArrivedViewTag];
    
    UILabel *distanceLabel = (UILabel*)[btmView viewWithTag:1000];
    distanceLabel.text = [NSString stringWithFormat:@"Distance : %@",distane];
    
    UILabel *timeLabel = (UILabel*)[btmView viewWithTag:2000];
    timeLabel.text = [NSString stringWithFormat:@"Time : %@",eta];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DRIVERONTHEWAY" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DRIVERREACHED" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JOBSTARTED" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JOBCOMPLETED" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationBookingConfirmationNameKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLocationServicesChangedNameKey object:nil];
    
}

-(void)Set_ToolBar
{
    if (_keyboardToolbar == nil)
    {
        _keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44.0f)];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            [_keyboardToolbar setTranslucent:YES];
        }
        // _keyboardToolbar.layer.borderWidth = 1.0f;
        // _keyboardToolbar.layer.borderColor = [UIColor grayColor].CGColor;
        //_keyboardToolbar.layer.masksToBounds = NO;
        // _keyboardToolbar.clipsToBounds = YES;
        
        //_PreviousButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Prev", @"")   style:UIBarButtonItemStyleBordered target:self action:@selector(PreviousButton:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(resignKeyboard:)];
        
        doneBarItem.tintColor = [UIColor blueColor];
        [_keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil]];
        txtfCarTypes.inputAccessoryView = _keyboardToolbar;
        txtfCarTypes.inputView = _pickerView;
        
    }
}

-(void)resignKeyboard:(id)sender
{
    [txtfCarTypes resignFirstResponder];
    //[_pickerView setHidden:YES];
}


-(void)setPickerView{
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,350, 320,216)];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.dataSource = self;
    //[_pickerView selectRow:0 inComponent:0 animated:YES];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    //[self.view addSubview:_pickerView];
    
}


#pragma mark --------------------------------------------------
#pragma mark - UIPickerViewDataSource Method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayMaximumNumberOfPayee count];
}



#pragma mark --------------------------------------------------
#pragma mark - UIPickerViewDelegate Method


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UIView *view1 =[[UIView alloc]init];
    UILabel *lbl = nil;
    [view1 setFrame:CGRectMake(0, 0, 320, 80)];
    lbl = [[UILabel alloc]init];
    lbl.frame = view1.frame;
    
    [lbl  setText:[arrayMaximumNumberOfPayee objectAtIndex:row]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont systemFontOfSize:20.0]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    
    
    [view1 addSubview:lbl];
    return view1;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    txtfCarTypes.text = [arrayMaximumNumberOfPayee objectAtIndex:row];
    
    NSDictionary *dict = [_arrayOfCarTypes objectAtIndex:row];
    
    [self fillDetailsOnCarTypesWithdetail:dict];
    //[self changeCarTypesWithdetail:dict];
    
    strSaveLastCarName =[NSString stringWithFormat:@"%@",txtfCarTypes.text];;
    NSLog(@"%@",txtfCarTypes.text);
    
    
}


- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    
    [_pickerView reloadAllComponents];
}

#pragma ------------------------------------
#pragma mark - UITextField Delegate Method

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if([txtfCarTypes isEqual:textField])
    {
        
        //[self setPickerView];
        //[self Set_ToolBar];
        
        NSLog(@"%@",arrayMaximumNumberOfPayee);
        NSLog(@"%@",txtfCarTypes.text);
        
        NSInteger index = [arrayMaximumNumberOfPayee indexOfObject:txtfCarTypes.text];
        NSLog(@"%ld",(long)index);
        
        [_pickerView selectRow:index inComponent:0 animated:YES];
        
        // Select the first row programmatically
        //[_pickerView selectRow:index inComponent:0 animated:YES];
        // The delegate method isn't called if the row is selected programmatically
        //[self pickerView:_pickerView didSelectRow:index inComponent:0];
        
        
        //[_pickerView viewForRow:index forComponent:0];
        NSLog(@"%ld",(long)index);
        
    }
    
}


@end
