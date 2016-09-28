//
//  RateViewController.m
//  privMD
//
//  Created by Rahul Sharma on 10/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "RateViewController.h"
#import <AXRatingView/AXRatingView.h>
#import "NetworkHandler.h"

#define kDescriptionPlaceholder @"Please share your experience with us, it will help us provide you better service."

@interface RateViewController ()


@property(nonatomic,strong)AXRatingView *ratingViewStars;
@property(nonatomic,assign) float rating;

@end

@implementation RateViewController
@synthesize writeLabel,ratingViewStars,reviewTextView,ratingView,reviewTextViewPlaceHolder,_ratingTextLabel;

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
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]]];
    
    [self createNavRightButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    
    
    [Helper setToLabel:writeLabel Text:@"WRITE REVIEW" WithFont:Trebuchet_MS_Bold FSize:18 Color:BLACK_COLOR];
    
    
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

    [Helper setToLabel:_ratingTextLabel Text:@"Somewhat satisfied" WithFont:Trebuchet_MS FSize:14 Color:BLACK_COLOR];
    
    [reviewTextViewPlaceHolder setText:kDescriptionPlaceholder];
    [reviewTextViewPlaceHolder setBackgroundColor:[UIColor clearColor]];
    [reviewTextViewPlaceHolder setTextColor:[UIColor lightGrayColor]];
    reviewTextViewPlaceHolder.numberOfLines = 3;
    reviewTextViewPlaceHolder.hidden = YES;
    reviewTextView.textColor = [UIColor lightGrayColor];
    reviewTextView.delegate = self;
    reviewTextView.text = @"";
    reviewTextView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    reviewTextView.returnKeyType = UIReturnKeyDone;


}
-(void)viewWillAppear:(BOOL)animated {
    [reviewTextView becomeFirstResponder];
    self.title = @"RATE YOUR DRIVER";

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
   
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

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    [reviewTextView resignFirstResponder];
 
}
-(void)createNavRightButton
{
    UIButton *navNextButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    [navNextButton setFrame:CGRectMake(0,0,buttonImage.size.width,buttonImage.size.height)];
    
    [navNextButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [Helper setButton:navNextButton Text:@"DONE" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [navNextButton setTitle:@"DONE" forState:UIControlStateNormal];
    [navNextButton setTitle:@"DONE" forState:UIControlStateSelected];
    [navNextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navNextButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [navNextButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navNextButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
}

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
    NSString *appointmntId = self.appointmentid;
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
                             @"ent_appnt_id":appointmntId,
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark TextView Delegate methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    reviewTextViewPlaceHolder.hidden = YES;
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (![textView hasText]) {
        reviewTextViewPlaceHolder.hidden = YES;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView.text.length == 0) {
        reviewTextViewPlaceHolder.hidden = NO;
    }
    else{
          reviewTextViewPlaceHolder.hidden = YES;
    }
}


@end
