//
//  InvoiceViewController.m
//  privMD
//
//  Created by Surender Rathore on 29/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "InvoiceViewController.h"
#import "NetworkHandler.h"
#import "RoundedImageView.h"
#import "UIImageView+WebCache.h"
#import <Canvas/CSAnimationView.h>
#import <AXRatingView.h>
#import "AppointedDoctor.h"
#import "RateViewController.h"
#import "SAMenuDropDown.h"

#define keyPadHeight 216
#define kDescriptionPlaceholder @"Please share your experience with us, it will help us provide you better service."

@interface InvoiceViewController () <UITextViewDelegate,SAMenuDropDownDelegate,UITextFieldDelegate>
{
    NSString *curreny;
   UIButton *payButton;
}
@property (weak, nonatomic) IBOutlet UILabel *totaltravellingExpense;
@property (nonatomic, strong) SAMenuDropDown *menuDrop;
@property(nonatomic,strong)AXRatingView *ratingViewStars;
@property (strong, nonatomic) UIImageView *disputeMsgView;
@property (weak, nonatomic) IBOutlet UIView *centerContainerView;
@property (weak, nonatomic) IBOutlet UILabel *pickupLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupLocationLabel;

@property (weak, nonatomic) IBOutlet UILabel *dropDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalDistanceLabel;
@property(nonatomic,assign) float rating;
@property(nonatomic,assign) double totalAmountToPay;
@end

@implementation InvoiceViewController
@synthesize appointmentDate,bookingID,bookingIDText,avgSpeed,avgSpeedText,appointmentid;
@synthesize doctorEmail,disputeMsgView,mainScrollView ;
@synthesize reviewTextView,ratingView,textViewPlaceholder,ratingViewStars,submitreviewBtn,cancelviewBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)leftButtonClicked:(id)sender {
    
    [self clearUserDefaultsAfterBookingCompletion];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark - CustomNavigation Button

-(void)createNavLeftButton
{
    UIButton *navNextButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    [navNextButton setFrame:CGRectMake(0,0,buttonImage.size.width,buttonImage.size.height)];
    
    [navNextButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [Helper setButton:navNextButton Text:@"BACK" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor blackColor]ShadowColor:nil];
    [navNextButton setTitle:@"BACK" forState:UIControlStateNormal];
    [navNextButton setTitle:@"BACK" forState:UIControlStateSelected];
    [navNextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navNextButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [navNextButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navNextButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
}
-(void)createPayButton{
    
    payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, 320, 40);
    NSLog(@"button frame %f%f%f%f",payButton.frame.origin.x,payButton.frame.origin.y,payButton.frame.size.width,payButton.frame.size.height);
//    [payButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_pickup_bg.png"] forState:UIControlStateNormal];
//    [payButton setBackgroundImage:[UIImage imageNamed:@"conformation_btn_pickup_bg_on.png"] forState:UIControlStateSelected];
    
    payButton.backgroundColor = NavBarTint_Color;
    
    
    //curreny =  [NSString stringWithFormat:@"$%f",_totalAmountToPay];
    double tot=_totalAmountToPay+_totalAmountToPay*25/100;
    curreny=[NSString stringWithFormat:@"$ %0.02f",tot];
    curreny = [curreny stringByAppendingString:@"                           Pay"];
    [Helper setButton:payButton Text:curreny WithFont:Trebuchet_MS_Bold FSize:20 TitleColor:WHITE_COLOR ShadowColor:nil];
    [payButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [payButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateHighlighted];
    [payButton addTarget:self action:@selector(payButtonButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
}
-(void)createNavRightButton
{
    //    UIButton *navNextButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    //    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    //    [navNextButton setFrame:CGRectMake(0,0,buttonImage.size.width,buttonImage.size.height)];
    //    navNextButton.enabled=NO;
    //    [navNextButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [Helper setButton:navNextButton Text:@"DONE" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor blueColor] ShadowColor:nil];
    //    [navNextButton setTitle:@"DONE" forState:UIControlStateNormal];
    //    [navNextButton setTitle:@"DONE" forState:UIControlStateSelected];
    //    [navNextButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    //    [navNextButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
    //    [navNextButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    //
    //    // Create a container bar button
    //    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navNextButton];
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
    //                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    //                                       target:nil action:nil];
    //    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    //    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
}
#pragma mark - ViewController LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *arrname = [[NSArray alloc] initWithObjects:@"20%", @"25%", @"other", nil] ;
    _menuDrop = [[SAMenuDropDown alloc] initWithSource:_tip menuHeight:80 itemName:arrname];
    //_menuDrop.rowHeight = 20;
    _menuDrop.delegate = self;
    self.tipField.delegate=self;
    [Helper setToLabel:_pickupLabel Text:@"PICKUP" WithFont:Trebuchet_MS FSize:11 Color:UIColorFromRGB(0x969797)];
    [Helper setToLabel:_dropLabel Text:@"DROP OFF" WithFont:Trebuchet_MS FSize:11 Color:UIColorFromRGB(0x969797)];
    [Helper setToLabel:avgSpeed Text:@"AVG SPEED" WithFont:Trebuchet_MS FSize:11 Color:UIColorFromRGB(0x969797)];
    [Helper setToLabel:_distanceLabel Text:@"DISTANCE" WithFont:Trebuchet_MS FSize:11 Color:UIColorFromRGB(0x969797)];
    [Helper setToLabel:_durationLabel Text:@"DURATION" WithFont:Trebuchet_MS FSize:11 Color:UIColorFromRGB(0x969797)];
    
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS-Bold" size:17]}];
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    
    if(_isComingFromBooking == YES)
    {
        [self createNavLeftButton];
        [ratingView setHidden:YES];
        [reviewTextView setHidden:YES];
        [textViewPlaceholder setHidden:YES];
        [_ratingTextLabel setHidden:YES];
        [submitreviewBtn setHidden:YES];

        
    }
    else {
        [textViewPlaceholder setHidden:NO];
        [self createNavRightButton];
        [submitreviewBtn setHidden:NO];
    }
    [self.centerContainerView.layer setCornerRadius:3.25f];
    [self.centerContainerView.layer setBorderWidth:1.0f];
    [self.centerContainerView.layer setBorderColor:(__bridge CGColorRef)([UIColor lightGrayColor])];
    
    
    
    [UIView animateWithDuration:2 animations:^{
        _centerContainerView.transform = CGAffineTransformScale(_centerContainerView.transform,1.2,1.2);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            
            _centerContainerView.transform = CGAffineTransformTranslate(_centerContainerView.transform, 0,-10);
            
        } completion:^(BOOL finished) {
        }];
    }];
    
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    reachability.target = self;
    if ( [reachability isNetworkAvailable]) {
        
        [self sendRequestForAppointmentInvoice];
    }
    else {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi showMessage:kNetworkErrormessage On:self.view];
    }
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
    
    _rating = 3.5;
    
    ratingViewStars = [[AXRatingView alloc] initWithFrame:CGRectMake(20,0,280,100)];
    ratingViewStars.stepInterval = 0.0;
    ratingViewStars.markFont = [UIFont systemFontOfSize:50.0];
    ratingViewStars.baseColor = [UIColor colorWithRed:0.293 green:0.303 blue:0.322 alpha:1.000];
    ratingViewStars.highlightColor = [UIColor colorWithRed:0.975 green:0.736 blue:0.056 alpha:1.000];
    ratingViewStars.value = _rating;
    [ratingViewStars addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
    ratingViewStars.userInteractionEnabled = YES;
    [ratingView addSubview:ratingViewStars];
    
    
    [textViewPlaceholder setText:kDescriptionPlaceholder];
    [textViewPlaceholder setBackgroundColor:[UIColor clearColor]];
    [textViewPlaceholder setTextColor:[UIColor lightGrayColor]];
    textViewPlaceholder.numberOfLines = 3;
    reviewTextView.textColor = [UIColor lightGrayColor];
    reviewTextView.delegate = self;
    reviewTextView.text = @"";
    reviewTextView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:1.000];
    reviewTextView.returnKeyType = UIReturnKeyDone;
    [Helper setToLabel:_ratingTextLabel Text:@"Good" WithFont:Trebuchet_MS FSize:15 Color:UIColorFromRGB(0x000000)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
  //  [self createNavDisputeButton];
    
    
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    [reviewTextView resignFirstResponder];
    
}

- (void)ratingChanged:(AXRatingView *)sender
{
    _rating = sender.value;
    
    if (0 < _rating && _rating < 1 ) {
        _ratingTextLabel.text = @"Poor";
    }
    else if (1 < _rating && _rating < 2 ) {
        
        _ratingTextLabel.text = @"Fair";
    }
    else if (2 < _rating && _rating < 3 ) {
        
        _ratingTextLabel.text = @"Average";
    }
    else if (3 < _rating && _rating < 4 ) {
        
        _ratingTextLabel.text = @"Good";
    }
    else if (4 < _rating && _rating < 5 ) {
        
        _ratingTextLabel.text = @"Excellent";
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    self.title = @"REVIEW";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView .contentSize = CGSizeMake(320, CGRectGetMaxY(reviewTextView.frame)+ CGRectGetHeight(reviewTextView.frame));
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebServiceRequest

#pragma mark - ButtonAction
-(void)doneButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    if ( [reachability isNetworkAvailable]) {
        
        [self sendRequestForReviewSubmit];
    }
    else {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi showMessage:kNetworkErrormessage On:self.view];
    }
    
}

- (IBAction)submit_reviewAction:(id)sender{
    
    UIButton *button = sender;
    
    NSInteger buttonTagIndex = button.tag;
    
    [self.view endEditing:YES];
    
    if (buttonTagIndex == 0) {
        if ([reviewTextView.text isEqualToString:@""]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please write a review." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }else{
            
            PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
            if ( [reachability isNetworkAvailable]) {
                
               // [self sendRequestForReviewSubmit];
                
             [self payButtonButtonClicked];
                
            }
            else {
                ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                [pi showMessage:kNetworkErrormessage On:self.view];
            }
            
        }
    }else if (buttonTagIndex ==1)
    {
        
        
        PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
        if ( [reachability isNetworkAvailable]) {
            
            [self sendRequestForReviewSubmit];
            
            
        }
        else {
            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
            [pi showMessage:kNetworkErrormessage On:self.view];
        }
        
    }else{
        NSLog(@"no index");
    }
    
    
    
    
    
}


-(void)sendRequestForReviewSubmit{
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Saving.."];
    
    //setup parameters
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *docEmail = self.doctorEmail;
    NSString *appointmntDate = self.appointmentDate;
    NSString *currentDate = [Helper getCurrentDateTime];
    int rating = (int)_rating;
    NSString *review = reviewTextView.text;
    
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_dri_email":docEmail,
                             @"ent_appnt_dt":appointmntDate,
                             @"ent_date_time":currentDate,
                             @"ent_rating_num":[NSNumber numberWithInt:rating],
                             @"ent_review_msg":review,
                             };
    
    
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:kSMUpdateSlaveReview
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       TELogInfo(@"response %@",response);
                                       [self parseSubmitReviewResponse:response];
                                   }
                               }];
}

-(void)parseSubmitReviewResponse:(NSDictionary*)response {
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
            //Local Notification to notifyi HomeViewController
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JOBCOMPLETED" object:nil userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
}

-(void)payButtonButtonClicked{
    
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
  
    NSLog(@"%@",self.tipField.text);
    
   
   
    if ( [reachability isNetworkAvailable]) {
        if(self.tipField.text.length==0  || [tipAmount isEqualToString:@"Enter tip %"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Tip Amount" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else
        {
            [self sendRequestForPayAmount];
        }
    }
    else {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi showMessage:kNetworkErrormessage On:self.view];
    }
}

-(void)sendRequestForPayAmount{
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Paying..."];
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    
   
    
    NSString *appointmntDate = self.appointmentDate;
     NSString *appointmntid = self.appointmentid;
    NSString *currentDate = [Helper getCurrentDateTime];
    NSString *actual_amount=[NSString stringWithFormat:@"%0.02f",self.totalAmountToPay];
    tipAmount =[NSString stringWithFormat:@"%0.02f",[self.tipField.text doubleValue]];
    double tot=[self.tipField.text doubleValue]+[actual_amount doubleValue];
    NSString *total_amount=[NSString stringWithFormat:@"%0.02f",tot];
    NSDictionary *params = @{@"ent_sess_token":sessionToken,@"ent_dev_id":deviceID,@"ent_appnt_dt":appointmntDate,@"ent_date_time":currentDate,@"ent_actual_amount":actual_amount,@"ent_tip_amount":tipAmount,@"ent_total_amount":total_amount,@"ent_appnt_id":appointmntid
                             };
    
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:@"payForBooking"
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       
                                       [self parsePayAmountResponse:response];
                                   }
                                   else{
                                       ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                                       [pi hideProgressIndicator];
                                   }
                               }];
    
    
}
-(void)parsePayAmountResponse:(NSDictionary*)response{
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
    if (response != nil) {
        [self clearUserDefaultsAfterBookingCompletion];
        [self performSegueWithIdentifier:@"rateVC" sender:self];
    }
}

-(void)clearUserDefaultsAfterBookingCompletion {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kNSUAppoinmentDoctorDetialKey];
    [ud removeObjectForKey:kNSUPassengerBookingStatusKey];
    [ud removeObjectForKey:@"subscribedChannel"];
    [ud setBool:NO forKey:kNSUIsPassengerBookedKey];
    [ud setBool:NO forKey:@"isServiceCalledOnce"];
    [ud removeObjectForKey:@"MODEL"];
    [ud removeObjectForKey:@"PLATE"];
    
    [ud synchronize];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"rateVC"]){
        RateViewController *rateVC  = [segue destinationViewController];
        rateVC.doctorEmail = doctorEmail;
        rateVC.appointmentDate = appointmentDate;
        rateVC.appointmentid = appointmentid;
    }
}
-(void)createNavDisputeButton
{
    
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *disputeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [disputeButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];
    [disputeButton addTarget:self action:@selector(disputeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [Helper setButton:disputeButton Text:@"DISPUTE" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor blackColor] ShadowColor:nil];
    [disputeButton setTitle:@"DISPUTE" forState:UIControlStateNormal];
    [disputeButton setTitle:@"DISPUTE" forState:UIControlStateSelected];
    [disputeButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [disputeButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
    [disputeButton setShowsTouchWhenHighlighted:YES];
    disputeButton.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:11];
    [disputeButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:disputeButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
    
}
-(void)disputeButtonClicked {
    
    
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Dispute Message? "
                                        message:@"Please provide us valid reason for which you are disputing."
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Submit", nil];
    
    UITextField *disMsg = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 225, 30)];
    disMsg.delegate =self;
    
    disMsg.placeholder = @"Dispute reason";
    
    disputeMsgView.frame = CGRectMake(220,110,18,18);
    
    [forgotPasswordAlert addSubview:disMsg];
    [forgotPasswordAlert addSubview:disputeMsgView];
    
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [forgotPasswordAlert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
        UITextField *disputeMsgText = [alertView textFieldAtIndex:0];
        
        PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
        if ( [reachability isNetworkAvailable]) {
            
            if(disputeMsgText.text.length == 0)
                disputeMsgText.text = @"";
            [self sendRequestForDisputeSubmit:disputeMsgText.text];
        }
        else {
            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
            [pi showMessage:kNetworkErrormessage On:self.view];
        }
        
    }
    
}

-(void)sendRequestForDisputeSubmit:(NSString *)disputeMsgText{
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@"Disputing"];
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *appointmntDate = self.appointmentDate;
    NSString *currentDate = [Helper getCurrentDateTime];
    
    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_appnt_dt":appointmntDate,
                             @"ent_date_time":currentDate,
                             @"ent_report_msg":disputeMsgText,
                             };
    
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:@"reportDispute"
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       
                                       [self parseDisputeResponse:response];
                                   }
                                   else{
                                       ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                                       [pi hideProgressIndicator];
                                   }
                               }];
    
    
}

-(void)parseDisputeResponse:(NSDictionary*)response{
    
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
            [self clearUserDefaultsAfterBookingCompletion];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JOBCOMPLETED" object:nil userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }
    
    
}


-(void)sendRequestForAppointmentInvoice {
    
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
    
    NSString *docEmail = self.doctorEmail;
    NSString *appId = self.appointmentid;
    NSString *appointmntDate;
    if (self.appointmentDate.length == 0 && self.appointmentDate == nil) {
        appointmntDate = self.appointmentDate;
    }
    else {
        appointmntDate = self.appointmentDate;
    }
    
    NSString *currentDate = [Helper getCurrentDateTime];
    
    @try {
        NSDictionary *params = @{@"ent_sess_token":sessionToken,
                                 @"ent_dev_id":deviceID,
                                 @"ent_email":docEmail,
                                 @"ent_user_type":@"2",
                                 @"ent_appnt_dt":appointmntDate,
                                 @"ent_date_time":currentDate,
                                 @"ent_appnt_id":appId,
                                 };
        
        TELogInfo(@"kSMGetAppointmentDetialINVOICE %@",params);
        //setup request
        NetworkHandler *networHandler = [NetworkHandler sharedInstance];
        [networHandler composeRequestWithMethod:kSMGetAppointmentDetial
                                        paramas:params
                                   onComplition:^(BOOL success, NSDictionary *response){
                                       
                                       if (success) { //handle success response
                                           TELogInfo(@"response %@",response);
                                           [self parseAppointmentDetailResponse:response];
                                       }
                                   }];
    }
    @catch (NSException *exception) {
        TELogInfo(@"Invoice Exception : %@",exception);
    }
    
    
}

#pragma mark - WebService Response
-(void)parseAppointmentDetailResponse:(NSDictionary*)response{
    NSLog(@"payment %@",response);
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
            // NSString *curreny =  [PatientGetLocalCurrency getCurrencyLocal:[flStrForObj(response[@"fare"]) floatValue]];
            //            float tot=[response[@"fare"] floatValue];
            //            tot=tot+25*tot/100;
            NSString *curreny1=[NSString stringWithFormat:@"$%0.02f",[flStrForObj(response[@"fare"]) floatValue]];
            [Helper setToLabel:_totaltravellingExpense Text:curreny1 WithFont:Trebuchet_MS_Bold FSize:30 Color:BLACK_COLOR];
            
            
            NSString *pTime = [self getTime:flStrForObj(response[@"pickupDt"])];
            [Helper setToLabel:_pickupDateLabel Text:pTime WithFont:Trebuchet_MS FSize:11 Color:UIColorFromRGB(0x969797)];
            _pickupDateLabel.textAlignment = NSTextAlignmentLeft;
            
            [Helper setToLabel:_pickupLocationLabel Text:flStrForObj(response[@"addr1"]) WithFont:Trebuchet_MS FSize:14 Color:UIColorFromRGB(0x000000)];
            
            NSString *dTime = [self getTime:flStrForObj(response[@"dropDt"])];
            [Helper setToLabel:_dropDateLabel Text:dTime WithFont:Trebuchet_MS FSize:11 Color:UIColorFromRGB(0x969797)];
            _dropDateLabel.textAlignment = NSTextAlignmentLeft;
            [Helper setToLabel:_dropLocationLabel Text:flStrForObj(response[@"dropAddr1"]) WithFont:Trebuchet_MS FSize:14 Color:UIColorFromRGB(0x000000)];
            
            NSInteger mint = [flStrForObj(response[@"dur"])integerValue];
            NSInteger durations = 0;
            if (mint >= 60) {
                durations = mint / 60;
                mint = mint % 60;
            }
            
            [Helper setToLabel:_totalDurationLabel Text:[NSString stringWithFormat:@"%ldH : %ldM ",(long)durations,(long)mint] WithFont:Trebuchet_MS FSize:14 Color:UIColorFromRGB(0x000000)];
            
            NSString *bid = [NSString stringWithFormat:@"BOOKING ID :%@",flStrForObj(response[@"bid"])];
            
            [Helper setToLabel:bookingIDText Text:bid WithFont:Trebuchet_MS FSize:18 Color:BLACK_COLOR];
            
            [Helper setToLabel:avgSpeedText Text:[NSString stringWithFormat:@"%.2f MPH",[response[@"avgSpeed"] doubleValue]] WithFont:Trebuchet_MS FSize:12 Color:UIColorFromRGB(0x000000)];
            
            [Helper setToLabel:_totalDistanceLabel Text:[NSString stringWithFormat:@"%@ Miles",flStrForObj(response[@"dis"])] WithFont:Trebuchet_MS FSize:14 Color:UIColorFromRGB(0x000000)];
            
            //added
            if([response[@"payStatus"]integerValue] == 0 ){
                
                _totalAmountToPay = [response[@"fare"] doubleValue];
                self.tipText.text=[NSString stringWithFormat:@"%0.02f",_totalAmountToPay*25/100];
                
                [self createPayButton];
                if ([response[@"reportMsg"] length] != 0) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Dispute Message" message:response[@"reportMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            else {
                
                [self createNavLeftButton];
            }
            //added
        }
        else
        {
            [Helper showAlertWithTitle:@"Message" Message:@"errmsg"];
        }
        
    }
}

-(NSString*)getTime:(NSString *)aDatefromServer{
    
    NSString *mGetting = [NSString stringWithFormat:@"%@",aDatefromServer];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date  = [dateFormatter dateFromString:mGetting];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm a"];
    NSString *retTime = [dateFormatter stringFromDate:date];
    return retTime;
    
}


#pragma mark -
#pragma mark TextView Delegate methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    
    submitreviewBtn.frame=CGRectMake(166, 600, 132, 30);
    cancelviewBtn.frame=CGRectMake(20, 600, 150, 30);
    self.activeTextField = textView;
    textViewPlaceholder.hidden = YES;
    return YES;
   }


-(void)textViewDidChange:(UITextView *)textView
{
    if (![textView hasText]) {
        textViewPlaceholder.hidden = NO;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(![textView hasText]) {
        textViewPlaceholder.hidden = NO;
    }
    else{
        textViewPlaceholder.hidden = YES;
    }
}

-(void) keyboardWillShow:(NSNotification *)note
{
    if(_isKeyboardIsShown)
    {
        return;
    }
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    CGSize keyboardSize = [[note.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.mainScrollView.frame;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the scroll view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height -= keyboardBounds.size.height;
    else
        frame.size.height -= keyboardSize.width; //not used just for testing
    
    // Apply new size of scroll view
    self.mainScrollView.frame = frame;
    
    // Scroll the scroll view to see the TextField just above the keyboard
    if (self.activeTextField)
    {
        CGRect textFieldRect = [self.mainScrollView convertRect:self.activeTextField.bounds fromView:self.activeTextField];
        [self.mainScrollView scrollRectToVisible:textFieldRect animated:NO];
    }
    [UIView commitAnimations];
    _isKeyboardIsShown = YES;
}


-(void) keyboardWillHide:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.mainScrollView.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    
    // Reduce size of the scroll view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height += keyboardBounds.size.height;
    else
        frame.size.height += keyboardBounds.size.width;
    
    // Apply new size of scroll view
    
    self.mainScrollView.frame = frame; //CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
    
    [UIView commitAnimations];
    _isKeyboardIsShown = NO;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField==self.tipField)
    {
        self.tipText.text=[NSString stringWithFormat:@"%0.02f",_totalAmountToPay*[self.tipField.text doubleValue]/100];
        double tot=_totalAmountToPay+_totalAmountToPay*[self.tipField.text doubleValue]/100;
        curreny =  [NSString stringWithFormat:@"$%0.02f",tot];
        curreny = [curreny stringByAppendingString:@"                           Pay"];
        [Helper setButton:payButton Text:curreny WithFont:Trebuchet_MS_Bold FSize:20 TitleColor:WHITE_COLOR ShadowColor:nil];
    }
}



- (IBAction)tipAction:(id)sender {
    [_menuDrop showSADropDownMenuWithAnimation:kSAMenuDropAnimationDirectionBottom];
    [_menuDrop menuItemSelectedBlock:^(SAMenuDropDown *menu, NSInteger index) {
        NSLog(@"\n<<Block: Item = %li>>", (long)index);
    }];
}
- (void)saDropMenu:(SAMenuDropDown *)menuSender didClickedAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"\n\n##<<%@>>##", menuSender);
    NSLog(@"\n\n\nClicked \n\n<<Index#%li>>", (long)buttonIndex);
    if(buttonIndex==0)
    {
        self.tipField.hidden=YES;
        self.tipText.text=[NSString stringWithFormat:@"%0.02f",_totalAmountToPay*20/100];
        double tot=_totalAmountToPay+_totalAmountToPay*20/100;
        curreny =  [NSString stringWithFormat:@"$%0.02f",tot];
        curreny = [curreny stringByAppendingString:@"                           Pay"];
        [Helper setButton:payButton Text:curreny WithFont:Trebuchet_MS_Bold FSize:20 TitleColor:WHITE_COLOR ShadowColor:nil];
        
    }
    else if(buttonIndex==1)
    {
        self.tipField.hidden=YES;
        self.tipText.text=[NSString stringWithFormat:@"%0.02f",_totalAmountToPay*25/100];
        double tot=_totalAmountToPay+_totalAmountToPay*25/100;
        curreny =  [NSString stringWithFormat:@"$%0.02f",tot];
        curreny = [curreny stringByAppendingString:@"                           Pay"];
        [Helper setButton:payButton Text:curreny WithFont:Trebuchet_MS_Bold FSize:20 TitleColor:WHITE_COLOR ShadowColor:nil];
        
    }
    else if(buttonIndex==2)
    {
        self.tipField.hidden=NO;
        
        
        
    }
}
@end
