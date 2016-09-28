//
//  CardLoginViewController.m
//  privMD
//
//  Created by Rahul Sharma on 13/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "CardLoginViewController.h"
#import "MapViewController.h"
#import "CardIO.h"
#import "UploadFiles.h"
#import "ViewController.h"
#import "Database.h"
#import "Entity.h"
#import "PTKTextField.h"
#import "PKView+Private.h"

@interface CardLoginViewController ()<CardIOPaymentViewControllerDelegate>
@property(nonatomic,strong)PTKCard *card;
@property(nonatomic,strong)STPCard *stripeCard;
@end

@implementation CardLoginViewController

@synthesize agreeButton;
@synthesize agreeLabel;
@synthesize tncLabel;
@synthesize tncButton;
@synthesize navNextButton;
@synthesize getSignupDetails;
@synthesize scanButton;
@synthesize infoLabel;
@synthesize cvvLabel;
@synthesize postalLabel;
@synthesize expLabel;
@synthesize doneButton;
@synthesize stripeCard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//pkviewDelegate
- (void) paymentView:(PTKCard*)paymentView withCard:(PTKCard *)card isValid:(BOOL)valid
{
    _card = card;
    TELogInfo(@"Card number: %@", card.number);
    TELogInfo(@"Card expiry: %lu/%lu", (unsigned long)card.expMonth, (unsigned long)card.expYear);
    TELogInfo(@"Card cvc: %@", card.cvc);
    TELogInfo(@"Address zip: %@", card.addressZip);
    
}

- (void)setupCardPostalField
{
    postalText = [[UITextField alloc] initWithFrame:CGRectMake(290,0,55,20)];
    postalText.delegate = self;
    postalText.placeholder = @"Postal";
    postalText.keyboardType = UIKeyboardTypeNumberPad;
    postalText.textColor = [UIColor lightGrayColor];
    [postalText.layer setMasksToBounds:YES];
    
    [self.view addSubview:postalText];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;

    TELogInfo(@"getsignup details %@ ",getSignupDetails);
    self.infoLabel.text = @"";
    
    self.view.backgroundColor = BG_Color;
    
    //TODO:: this for only when add card from menu
    
    PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
   
    if (appDelegate._IsShowPaymentMODE == YES) {
        
        
        self.paymentView = [[PTKView alloc] initWithFrame:CGRectMake(11,70,250,43)];
        self.paymentView.delegate = self;
        [self.view addSubview:self.paymentView];
        
        CGRect frameOfDoneButton = doneButton.frame;
        frameOfDoneButton.origin.x = 262;
        frameOfDoneButton.origin.y = 70;
        frameOfDoneButton.size.height = 43;
        frameOfDoneButton.size.width = 48;
        doneButton.frame = frameOfDoneButton;
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
         doneButton.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:13];
        [doneButton setBackgroundColor:BUTTON_BG_Color];
        [scanButton setTitle:@"Scan the card" forState:UIControlStateNormal];
        [scanButton setImage:[UIImage imageNamed:@"signuppayment_icn_camera_on.png"] forState:UIControlStateNormal];
        [scanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [scanButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [scanButton setBackgroundColor:BUTTON_BG_Color];
         scanButton.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:13];
        [scanButton addTarget:self action:@selector(scanCardClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        PinEnterView.hidden=YES;
        
        infoLabel.hidden=NO;
        cvvLabel.hidden=NO;
        postalLabel.hidden=NO;
        expLabel.hidden=NO;
        doneButton.hidden=NO;
        scanButton.hidden=NO;
        
    }else{
        
     PinEnterView.hidden=NO;
        
        infoLabel.hidden=YES;
        cvvLabel.hidden=YES;
        postalLabel.hidden=YES;
        expLabel.hidden=YES;
        doneButton.hidden=YES;
        scanButton.hidden=YES;
    }
   
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    if((_isComingFromPayment ==1)||(_isComingFromPayment == 2))
    {
        if (_isComingFromPayment == 2)
        {
            self.paymentView.frame = CGRectMake(4,70,250,43);
            CGRect frameOfDoneButton = doneButton.frame;
            frameOfDoneButton.origin.y = 70;
            doneButton.frame = frameOfDoneButton;
            CGRect fr = scanButton.frame;
            fr.origin.y = 130;
            scanButton.frame = fr;

        }
        
         self.navigationItem.title = @"ADD CARD";
        [self createNavLeftButton];

    }
    else
    {
        [self createNavView];
        
         //Add Comment
        [self createNavLeftButton];

    }
    
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"Oswald-light" size:17]}];
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
   // [OtpTextfield resignFirstResponder];
    [self.view endEditing:YES];
    
}


-(void)createNavView
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(80, -10, 160, 50)];
    
    UILabel *navTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 147, 30)];
    navTitle.text = @"Create Account";
    navTitle.textColor = UIColorFromRGB(0xffffff);
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font = [UIFont fontWithName:Oswald_Light size:14];
    [navView addSubview:navTitle];
    
    UIImageView *navImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,30,147,7)];
    navImage.image = [UIImage imageNamed:@"signup_timer_second.png"];
    [navView addSubview:navImage];
    
    self.navigationItem.titleView = navView;
}

-(void)createNavRightButton
{
    navNextButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    [navNextButton setFrame:CGRectMake(0,0,buttonImage.size.width,buttonImage.size.height)];

    [navNextButton addTarget:self action:@selector(NextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
  
    [Helper setButton:navNextButton Text:@"SKIP" WithFont:Oswald_Light FSize:11 TitleColor:[UIColor blueColor] ShadowColor:nil];
    [navNextButton setTitle:@"SKIP" forState:UIControlStateNormal];
    [navNextButton setTitle:@"SKIP" forState:UIControlStateSelected];
    [navNextButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [navNextButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
    [navNextButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navNextButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];

}

-(void) createNavLeftButton
{
  // UIView *navView = [[UIView new]initWithFrame:CGRectMake(0, 0,50, 44)];
     UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navCancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];

    [Helper setButton:navCancelButton Text:@"BACK" WithFont:Oswald_Light FSize:11 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateSelected];
    [navCancelButton setShowsTouchWhenHighlighted:YES];
    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    navCancelButton.titleLabel.font = [UIFont fontWithName:Oswald_Light size:11];
    //[navCancelButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
   // UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:segmentView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
    
  //  self.navigationItem.leftBarButtonItem = containingcancelButton;
}

-(void)checkMandatoryFields
{
    NSString *cardno = _card.number;
    NSUInteger cardexpMnt = _card.expMonth;
    NSUInteger cardexpYr = _card.expYear;
    NSString *cardcvc = _card.cvc;
    
    TELogInfo(@"%lu ",(unsigned long)infoLabel.text.length);
    
    if (((unsigned long)cardno.length == 0) && ((unsigned long)infoLabel.text.length== 0))
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Card No"];
        
    }
    else if (((unsigned long)cardcvc.length == 0) && ((unsigned long)infoLabel.text.length== 0))
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter CVC"];
    }
    else if (((unsigned long)infoLabel.text.length== 0) && (((unsigned long)cardexpMnt == 0) || ((unsigned long)cardexpYr == 0)))
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter expiry details"];
    }
    else
    {
     
        checkMandatoryCard = YES;
        checkMandatoryCamera = YES;
    }
}

-(void)NextButtonClicked
{
    [self checkSignUp:nil];
    [self.view endEditing:YES];
}

-(IBAction)SubmitButtonClicked:(id)sender{
    
    [self checkSignUp:nil];
    [self.view endEditing:YES];
    
}

#pragma TODO:: Add new submit Action


-(void) checkSignUp:(NSString *)accessToken
{
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Signing In..."];
    
    NSMutableDictionary *signUpUser = [[NSMutableDictionary alloc]init];
    
    [signUpUser setObject:[getSignupDetails objectAtIndex:0] forKey:KDASignUpFirstName];
    [signUpUser setObject:[getSignupDetails objectAtIndex:1] forKey:KDASignUpLastName];
    [signUpUser setObject:[getSignupDetails objectAtIndex:2] forKey:KDASignUpEmail];
    [signUpUser setObject:[getSignupDetails objectAtIndex:3] forKey:KDASignUpMobile];
    
    [signUpUser setObject:[getSignupDetails objectAtIndex:4] forKey:KDASignUpZipCode];
    
    [signUpUser setObject:[getSignupDetails objectAtIndex:5] forKey:KDASignUpPassword];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken])
    {
         [signUpUser setObject:[[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken] forKey:KDASignUpPushToken];
    }
    else
    {
        [signUpUser setObject:@"123" forKey:KDASignUpPushToken];
    }

    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUserCurrentCountry])
        [signUpUser setObject:@"" forKey:KDASignUpCountry];
    else
        [signUpUser setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUserCurrentCountry] forKey:KDASignUpCountry];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUserCurrentCity])
        [signUpUser setObject:@"" forKey:KDASignUpCity];
    else
        [signUpUser setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUserCurrentCity] forKey:KDASignUpCity];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLat])
        [signUpUser setObject:@"" forKey:KDASignUpLatitude];
    else
        [signUpUser setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLat] forKey:KDASignUpLatitude];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLong])
        [signUpUser setObject:@"" forKey:KDASignUpLongitude];
    else
        [signUpUser setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLong] forKey:KDASignUpLongitude];
    
    [signUpUser setObject:@"1" forKey:KDASignUpDeviceType];
    NSString *deviceId;
    if (IS_SIMULATOR) {
        
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    [signUpUser setObject:deviceId forKey:KDASignUpDeviceId];

    if(accessToken.length == 0)
    {
        [signUpUser setObject:@"" forKey:KDASignUpAccessToken];
        
    }
    else
    {
        [signUpUser setObject:accessToken forKey:KDASignUpAccessToken];
    }
     [signUpUser setObject:@"Noida" forKey:KDASignUpCity];
    [signUpUser setObject:@"1" forKey:KDASignUpTandC];
    [signUpUser setObject:@"1" forKey:KDASignUpPricing];
    [signUpUser setObject:[Helper getCurrentDateTime] forKey:KDASignUpDateTime];
    [signUpUser setObject:OtpTextfield.text forKey:KDASignUpOTP];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[signUpUser objectForKey:@"ent_first_name"] forKey:KDAFirstName];
    [[NSUserDefaults standardUserDefaults] setObject:[signUpUser objectForKey:@"ent_last_name"] forKey:KDALastName];
    [[NSUserDefaults standardUserDefaults] setObject:[signUpUser objectForKey:@"ent_email"] forKey:KDAEmail];
    [[NSUserDefaults standardUserDefaults] setObject:[signUpUser objectForKey:@"ent_password"] forKey:KDAPassword];
    [[NSUserDefaults standardUserDefaults] setObject:[signUpUser objectForKey:@"ent_mobile"] forKey:KDAPhoneNo];
    [[NSUserDefaults standardUserDefaults]synchronize];
     NSMutableURLRequest *request = [Service parseSignUp:signUpUser];
    
    NSLog(@"Request : %@",request);
    
    WebServiceHandler *handler = [[WebServiceHandler alloc]init];
    handler.requestType = eSignUp;
    
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(signupResponse:)];
    
}


-(void)signupResponse:(NSDictionary*)response
{
    //check if response is not null
    if(response == nil)
    {
        //hide progress indicator
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        return;
    }
    
    //check for network error
    if (response[@"Error"])
    {
        //hide progress indicator
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        [Helper showAlertWithTitle:@"Error" Message:response[@"Error"]];
    }
    else
    {
 
        //handle response here
        NSDictionary *itemList = [[NSDictionary alloc]init];
        itemList = response[@"ItemsList"];
        
        if ([itemList[@"errFlag"] intValue] == 1) { //error
            
            ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
            [progressIndicator hideProgressIndicator];
            [Helper showAlertWithTitle:@"Error" Message:itemList[@"errMsg"]];
        }
        else {
            
            TELogInfo(@"ItemList DIct %@ ,",itemList);
            
            NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
            [ud setObject:[itemList objectForKey:@"token"] forKey:KDAcheckUserSessionToken];
            [ud setObject:itemList[@"chn"] forKey:kNSUPatientPubNubChannelkey];
            [ud setObject:itemList[@"email"] forKey:kNSUPatientEmailAddressKey];
            [ud setObject:itemList[@"apiKey"] forKey:kNSUMongoDataBaseAPIKey];
            [ud setObject:itemList[@"serverChn"] forKey:kPMDPublishStreamChannel];
            [ud synchronize];
            [Crashlytics setUserEmail:itemList[@"email"]];
            [Crashlytics setUserIdentifier:itemList[@"chn"]];
            NSMutableArray *carTypes = [[NSMutableArray alloc]initWithArray:itemList[@"types"]];
            
            
            if (!carTypes || !carTypes.count) {
                TELogInfo(@"no data in array car types");
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:carTypes forKey:KUBERCarArrayKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }

           // NSMutableArray
            _arrayContainingCardInfo = itemList[@"card"];

            if (!_arrayContainingCardInfo || !_arrayContainingCardInfo.count)
            {
            }
            else
            {
                NSDictionary *mDict = [_arrayContainingCardInfo objectAtIndex:0];
              //  if(mDict[@"errFlag"] == 0)
                if([mDict[@"errFlag"] isEqualToString:@"0"])
                {
                [self addInDataBaseAtSignUp];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewCardAddedNameKey object:nil userInfo:nil];
                }

            }
            
            if(![ud objectForKey:KDAcheckUserSessionToken])
            {
                return;
            }
            
            if(_pickedImage)
            {
                UploadFile * upload = [[UploadFile alloc]init];
                upload.delegate = self;
                //  [upload calcImageSetting1length:_pickedImage];
                [upload uploadImageFile:_pickedImage];
                
            }
            else
            {
                ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
                [progressIndicator hideProgressIndicator];
                //  [self performSegueWithIdentifier:@"homeView" sender:self];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                            @"Main" bundle:[NSBundle mainBundle]];
                ViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
                self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
            }
        }
       
    }
}

#pragma UploadFileDelegate

-(void)uploadFile:(UploadFile *)uploadfile didUploadSuccessfullyWithUrl:(NSArray *)imageUrls
{
           {
            ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
            [progressIndicator hideProgressIndicator];
            //[self performSegueWithIdentifier:@"homeView" sender:self];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                        @"Main" bundle:[NSBundle mainBundle]];
            //
            ViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
            self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
            
            
        }
}
-(void)didFileUploaded:(BOOL)success
{
    
    if (success)
    {
        ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
        [progressIndicator hideProgressIndicator];
        //[self performSegueWithIdentifier:@"homeView" sender:self];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:[NSBundle mainBundle]];
       
        ViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
        self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];


    }
    else{
        ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
        [progressIndicator hideProgressIndicator];
        //[self performSegueWithIdentifier:@"homeView" sender:self];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:[NSBundle mainBundle]];
       
        ViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
        self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
        

    }
    
}

#pragma UploadFileDelegate
-(void)uploadFile:(UploadFile *)uploadfile didFailedWithError:(NSError *)error{
    TELogInfo(@"upload file  error %@",[error localizedDescription]);
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:[NSBundle mainBundle]];
    
    ViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
    self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
    
     [Helper showAlertWithTitle:@"Oops!" Message:@"Your profile photo has not been updated try again."];
    
   
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if((_isComingFromPayment == 1) || (_isComingFromPayment == 2))
    {
        [self checkMandatoryFields];
        if(checkMandatoryCard)
        {
            
        [self callStripeForCreatingToken];
        
        }
    }
    else
    {
        [self checkMandatoryFields];
        if(checkMandatoryCard)
        {
            [self callStripeForCreatingToken];
        }
    }

}

-(void)callStripeForCreatingToken
{
    if((_isComingFromPayment == 1) || (_isComingFromPayment == 2))
    {
        [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading..."];
    }
    else
    {
        [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Signing In..."];
    }
        self.stripeCard = [[STPCard alloc] init];
        self.stripeCard.number = _card.number;
        self.stripeCard.cvc = _card.cvc;
        self.stripeCard.expMonth = _card.expMonth;
        self.stripeCard.expYear = _card.expYear;
        
        //2
        [self performStripeOperation];
    
}
-(void)getcardWithToken:(NSString*)token
{
    [Stripe requestTokenWithID:token publishableKey:kPMDStripeTestKey completion:^(STPToken *token , NSError *error){

    }];
}
- (void)performStripeOperation {
    
    //1
    self.doneButton.enabled = NO;
    
    //2
    
    [Stripe createTokenWithCard:stripeCard publishableKey:kPMDStripeTestKey completion:^(STPToken *token , NSError *error){
        NSString *accesstoken = @"";
        if (error) {
            //handle strip error
            accesstoken = @"";
            if((_isComingFromPayment == 1) || (_isComingFromPayment == 2))
            {
                [self sendServiceAddCardsDetails:accesstoken];
            }
            else
            {
                [self checkSignUp:accesstoken];
            }

        }
        else if(token != nil) {
            accesstoken = token.tokenId;
            if((_isComingFromPayment == 1) || (_isComingFromPayment == 2))
            {
                [self sendServiceAddCardsDetails:accesstoken];
            }
            else
            {
                [self checkSignUp:accesstoken];
            }
            //card
            STPCard *card = token.card;
            TELogInfo(@"card number %@",card.number);
        }
    }];
}

-(void)cancelButtonClicked
{
    if(_isComingFromPayment == 2)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - User Actions

- (void)scanCardClicked:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    scanViewController.appToken = @"0b71815705d7471da1938fc17824279f";
    scanViewController.disableManualEntryButtons = YES;
    scanViewController.collectCVV = NO;
    [self presentViewController:scanViewController animated:YES completion:nil];
    
    

}
+ (BOOL)canReadCardWithCamera
{
    return YES;
}


#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    TELogInfo(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    TELogInfo(@"info.cardNumber : %@",info.cardNumber);
    self.infoLabel.text = [NSString stringWithFormat:@"%@", info.cardNumber/*info.redactedCardNumber*/];
    NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)info.expiryYear];
    str = [str substringFromIndex:2];
    self.expLabel.text = [NSString stringWithFormat:@"%02lu/%@",(unsigned long)info.expiryMonth,str];
    self.cvvLabel.text = [NSString stringWithFormat:@"%@",info.cvv];
    self.postalLabel.text = [NSString stringWithFormat:@"%02lu",(unsigned long)info.postalCode];
    
    [self startWithCardNumber:info.cardNumber];
    [self startWithExpNo:self.expLabel.text];
    
    UIImageView *cardTypeImageView = nil;
    [cardTypeImageView setImage:[CardIOCreditCardInfo logoForCardType:info.cardType]];

}
-(void)startWithCardNumber:(NSString*)cardNumberString
{
    PTKCardNumber *cardNumber = [PTKCardNumber cardNumberWithString:cardNumberString];
    
    if ( ![cardNumber isPartiallyValid] )
        return;
    
    self.paymentView.cardNumberField.text = [cardNumber formattedStringWithTrail];
    
    [self.paymentView setPlaceholderToCardType];
    
    if ([cardNumber isValid]) {
        [self.paymentView textFieldIsValid:self.paymentView.cardNumberField];
        [self.paymentView stateMeta];
        
    } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
        [self.paymentView textFieldIsInvalid:self.paymentView.cardNumberField withErrors:YES];
        
    } else if (![cardNumber isValidLength]) {
        [self.paymentView textFieldIsInvalid:self.paymentView.cardNumberField withErrors:NO];
    }
    
}
-(void)startWithExpNo:(NSString*)expDetailsString
{
    PTKCardExpiry *cardExpiry = [PTKCardExpiry cardExpiryWithString:expDetailsString];
    
    if (![cardExpiry isPartiallyValid])
        return ;
    
    // Only support shorthand year
    if ([cardExpiry formattedString].length > 5)
        return ;
    
    self.paymentView.cardExpiryField.text = [cardExpiry formattedStringWithTrail];
    
    if ([cardExpiry isValid]) {
        [self.paymentView textFieldIsValid:self.paymentView.cardExpiryField];
        [self.paymentView stateCardCVC];
        
    } else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]) {
        [self.paymentView textFieldIsInvalid:self.paymentView.cardExpiryField withErrors:YES];
    } else if (![cardExpiry isValidLength]) {
        [self.paymentView textFieldIsInvalid:self.paymentView.cardExpiryField withErrors:NO];
    }
    
}
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    TELogInfo(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebService call

-(void)sendServiceAddCardsDetails:(NSString *)token
{
    NSLog(@"tyt%@",token);
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading..."];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    
    NSString *parameters = [NSString stringWithFormat:@"ent_sess_token=%@&ent_dev_id=%@&ent_token=%@&ent_date_time=%@",[[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken],deviceId,token,[Helper getCurrentDateTime]];
    
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    TELogInfo(@"request doctor around you :%@",parameters);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@addCard",BASE_URL]];
    NSLog(@"%@",url);
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(addCardDetails:)];
    
}

-(void)addCardDetails:(NSDictionary *)response
{
    TELogInfo(@"ADD CardDetails:%@",response);
    NSLog(@"card response ---%@",response);
    if (!response)
    {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"])
    {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
        
    }
    else
    {
        
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        NSLog(@"dict response%@",dictResponse);
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
             _arrayContainingCardInfo = dictResponse[@"cards"];
            if (!_arrayContainingCardInfo || !_arrayContainingCardInfo.count){
                
            }
            else
            {
                [self addInDataBase];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewCardAddedNameKey object:nil userInfo:nil];
            }
            
            if(_isComingFromPayment == 2)
            {
                ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                [pi hideProgressIndicator];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewCardAddedNameKey object:nil userInfo:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewCardAddedNameKey object:nil userInfo:nil];

                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else if ([[dictResponse objectForKey:@"errFlag"] intValue] == 1) {
            
            if(_isComingFromPayment == 2)
            {
                ProgressIndicator *pi = [ProgressIndicator sharedInstance];
                [pi hideProgressIndicator];
                [Helper showAlertWithTitle:@"Message" Message:@"Sorry!your card was declined."];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [Helper showAlertWithTitle:@"Message" Message:@"Sorry!your card was declined."];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

-(void)addInDataBase
{
    Database *db = [[Database alloc] init];
   
   // if(isPresentInDBalready != 1)
    {
        for (int i =0; i<_arrayContainingCardInfo.count; i++)
        {
            NSLog(@"card info %@",_arrayContainingCardInfo);
            // Entity *fav = _arrayContainingCardInfo[i];
            NSString *str = _arrayContainingCardInfo[i][@"id"];
                                                          
            [self checkCampaignIdAddedOrNot:str:i];
            if(isPresentInDBalready == 1)
            {
                
            }
            else
            {
                [db makeDataBaseEntry:_arrayContainingCardInfo[i]];
            }
        }
    }
    
}

- (void)checkCampaignIdAddedOrNot:(NSString *)cardId :(int)arrIndex
{
    isPresentInDBalready = 0;
    NSArray *array = [Database getCardDetails];
    if ([array count]== 0)
    {
        // if(flag)
        //[self AddToFavButtonClicked:nil];
    }
    else
    {
        for(int i=0 ; i<[array count];i++)
        {
            Entity *fav = [array objectAtIndex:i];
            if ([fav.idCard isEqualToString:_arrayContainingCardInfo[arrIndex][@"id"]])
            {
                isPresentInDBalready = 1;
                
            }
            
            
        }
}
    
}

-(void)addInDataBaseAtSignUp
{
    Database *db = [[Database alloc] init];
    // [self checkCampaignIdAddedOrNot];
    //  if(isPresentInDBalready != 1)
    {
        for (int i =0; i<_arrayContainingCardInfo.count; i++)
        {
            [db makeDataBaseEntry:_arrayContainingCardInfo[i]];
        }
    }
    
}



@end
