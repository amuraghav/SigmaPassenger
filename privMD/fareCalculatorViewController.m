//
//  fareCalculatorViewController.m
//  UBER
//
//  Created by Rahul Sharma on 12/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "fareCalculatorViewController.h"
#import "PMDReachabilityWrapper.h"
#import "NetworkHandler.h"
#import "PickUpViewController.h"
#import "PatientGetLocalCurrency.h"

@interface fareCalculatorViewController ()

@end

@implementation fareCalculatorViewController
@synthesize changeLocationButton;
@synthesize locationDetails;
@synthesize carTypesForLiveBookingServer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

#pragma mark - WEB SERVICES

-(void)sendAServiceForFareCalculator{
    
    
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
    //setup parameters
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }

    
    if(self.isPopLockSelected){
        NSDictionary *params = @{@"ent_sess_token":sessionToken,
                                 @"ent_dev_id":deviceID,
                                 
                                 };
        NetworkHandler *networHandler = [NetworkHandler sharedInstance];
        [networHandler composeRequestWithMethod:MethodServiceEstimate
                                        paramas:params
                                   onComplition:^(BOOL success, NSDictionary *response){
                                       
                                       if (success) { //handle success response
                                           TELogInfo(@"response %@",response);
                                           
                                           
                                           
                                           [self parsegetBookingAppointment:response];
                                       }
                                       else
                                       {
                                           ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                                           [pi hideProgressIndicator];
                                       }
                                   }];
    }
    
    
    
    else{
    
    
    NSString *currentLatitude = [locationDetails objectForKey:@"cLat"];
    NSString *currentLongitude = [locationDetails objectForKey:@"cLoc"];
    NSString *pickupLatitude = [locationDetails objectForKey:@"pLat"];
    NSString *pickupLongitude = [locationDetails objectForKey:@"pLoc"];
    NSString *dropLatitude = [locationDetails objectForKey:@"dLat"];
    NSString *dropLongitude = [locationDetails objectForKey:@"dLon"];
    NSString *dateTime = [Helper getCurrentDateTime];
    
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_type_id":[NSString stringWithFormat:@"%ld",(long)self.carTypesForLiveBookingServer],
                             @"ent_curr_lat":currentLatitude,
                             @"ent_curr_long":currentLongitude,
                             @"ent_from_lat":pickupLatitude,
                             @"ent_from_long":pickupLongitude,
                             @"ent_to_lat":dropLatitude,
                             @"ent_to_long":dropLongitude,
                             @"ent_date_time":dateTime
                             };
    
    
    
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:MethodFareCalculator
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       TELogInfo(@"response %@",response);
                                       [self parsegetBookingAppointment:response];
                                   }
                                   else
                                   {
                                       ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                                       [pi hideProgressIndicator];
                                   }
                               }];

    }
}

#pragma mark - WEB SERVICE RESPONSE

-(void)parsegetBookingAppointment:(NSDictionary *)responseDictionary
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
    TELogInfo(@"responseDictionary:%@",responseDictionary);
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
//        NSMutableDictionary *mDict = [[responseDictionary objectForKey:@"ItemsList"] mutableCopy];
        if ([[responseDictionary objectForKey:@"errFlag"] intValue] == 0 && !self.isPopLockSelected)
        {
            
            [Helper setToLabel:_sourceLoactionLabel Text:[locationDetails objectForKey:@"pAddr"] WithFont:Trebuchet_MS FSize:14 Color:[UIColor blackColor]];
       NSString *curreny =  [PatientGetLocalCurrency getCurrencyLocal:[responseDictionary[@"fare"] floatValue]];
            [Helper setToLabel:_sourceDistanceLabel Text:[NSString stringWithFormat:@" %@",responseDictionary[@"curDis"]] WithFont:Trebuchet_MS FSize:11 Color:UIColorFromRGB(0x969797)];
            [Helper setToLabel:_pickupLAbel Text:@"Pick Up Location" WithFont:Trebuchet_MS FSize:11 Color:[UIColor blackColor]];
            
            [Helper setToLabel:_destinationLocationLabel Text:[locationDetails objectForKey:@"dAddr"] WithFont:Trebuchet_MS FSize:14 Color:[UIColor blackColor]];
            [Helper setToLabel:_destinationDistanceLabel Text:[NSString stringWithFormat:@" %@",responseDictionary[@"dis"]]  WithFont:Trebuchet_MS FSize:11 Color:[UIColor blackColor]];
            [Helper setToLabel:_dropoffLabel Text:@"Drop Off Location" WithFont:Trebuchet_MS FSize:11 Color:[UIColor blackColor]];
            [Helper setToLabel:_paymentLabel Text:curreny WithFont:Trebuchet_MS_Bold FSize:40 Color:[UIColor blackColor]];
            NSString *stri = @"Fares may vary due to traffic,weather and other factors.Estimate doesnot include discount or promotions.";
            [Helper setToLabel:_messageLabel Text:stri WithFont:Trebuchet_MS FSize:12 Color:[UIColor blackColor]];
            
        }
        else if([[responseDictionary objectForKey:@"errFlag"] intValue] == 0 && self.isPopLockSelected){
            
            [Helper setToLabel:_sourceLoactionLabel Text:[locationDetails objectForKey:@"pAddr"] WithFont:Trebuchet_MS FSize:14 Color:[UIColor blackColor]];
//            NSString *curreny =  [PatientGetLocalCurrency getCurrencyLocal:[responseDictionary[@"fare"] floatValue]];
//            [Helper setToLabel:_sourceDistanceLabel Text:[NSString stringWithFormat:@" %@",responseDictionary[@"curDis"]] WithFont:Trebuchet_MS FSize:11 Color:UIColorFromRGB(0x969797)];
            [Helper setToLabel:_pickupLAbel Text:@"Pick Up Location" WithFont:Trebuchet_MS FSize:11 Color:[UIColor blackColor]];
            _paymentLabel.hidden = YES;
           
            
            NSArray *fareArr = [responseDictionary objectForKey:@"content"];
            self.firstFarelabel.text = [NSString stringWithFormat:@"%@ KM =  %@ \n",[[fareArr objectAtIndex:0] objectForKey:@"description"],[[fareArr objectAtIndex:0]  objectForKey:@"amount"]];
            self.secondFareLabel.text = [NSString stringWithFormat:@"%@ KM =  %@ \n",[[fareArr objectAtIndex:1] objectForKey:@"description"],[[fareArr objectAtIndex:1]  objectForKey:@"amount"]];
            self.thirdFareLable.text = [NSString stringWithFormat:@"%@ KM =  %@ \n",[[fareArr objectAtIndex:2] objectForKey:@"description"],[[fareArr objectAtIndex:2]  objectForKey:@"amount"]];
//            _messageLabel.backgroundColor = [UIColor grayColor];
            
        }
        else
        {
            [Helper showAlertWithTitle:@"Message" Message:[responseDictionary objectForKey:@"errMsg"]];
        }
    }
}





#pragma mark - CustomNavigation Button

-(void)cancelButtonClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void) createNavLeftButton
{
  // UIView *navView = [[UIView new]initWithFrame:CGRectMake(0, 0,50, 44)];
     UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navCancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];

    [Helper setButton:navCancelButton Text:@"BACK" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateSelected];
    [navCancelButton setShowsTouchWhenHighlighted:YES];
    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    navCancelButton.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:11];
    //[navCancelButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];

     //Adding Button onto View
     //[navView addSubview:navCancelButton];
 
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
   // UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:segmentView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createNavLeftButton];
   
   // [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
    _centerView.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2-138/2,300,138);
//
    
    changeLocationButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50-64, 320, 50);

    NSLog(@"%ld",(long)self.carTypesForLiveBookingServer);
    
    self.navigationController.navigationBar.barTintColor= CLEAR_COLOR;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS-Bold" size:17]}];
    self.navigationController.navigationBar.translucent = NO;
   
    
    if(self.isPopLockSelected){
        
        self.changeLocationButton.hidden = YES;
        self.carImageView.hidden = YES;
        _centerView.hidden = YES;
        self.fareContentView.hidden = NO;
    }
    else{
         [_centerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"fc_price_bg.png"]]];
        self.changeLocationButton.hidden = NO;
        self.carImageView.hidden = NO;
         _centerView.hidden = NO;
        self.fareContentView.hidden = YES;
    }
    
    [self sendAServiceForFareCalculator];
    
}

- (IBAction)goBack_Action:(id)sender{
    [self cancelButtonClicked];
}

-(void)viewDidAppear:(BOOL)animated
{ 
    self.navigationItem.title = (self.isPopLockSelected)?@"SERVICE ESTIMATE":@"FARE CALCULATOR" ;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS-Bold" size:17]}];
    self.navigationController.navigationBar.translucent = NO;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)changeLocationButtonClicked:(id)sender {
    TELogInfo(@"button clicked");
    if (_isComingFromMapVC == YES) {
        
        PickUpViewController *pickController = [self.storyboard instantiateViewControllerWithIdentifier:@"pick"];
        [self.navigationController pushViewController:pickController animated:YES];
        [self SwipeLeft:pickController.view];
    }
    else{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
                        /*ANIMATION LIKE PUSH AND POP */

-(void)SwipeRight:(UIView *)view{
    
    CATransition* transition = [CATransition animation];
    [transition setDuration:0.3];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setFillMode:kCAFillModeBoth];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:transition forKey:kCATransition];
}

-(void)SwipeLeft:(UIView *)view{
    CATransition* transition = [CATransition animation];
    [transition setDuration:0.3];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [transition setFillMode:kCAFillModeBoth];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:transition forKey:kCATransition];
}

-(void)callPush
{
    // LoginViewController *LVC=[[LoginViewController alloc] init];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
//   Call Pop
-(void)callPop
{
     PickUpViewController *pickController = [self.storyboard instantiateViewControllerWithIdentifier:@"pick"];
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController pushViewController:pickController animated:YES];
    [UIView commitAnimations];
    
}

@end
