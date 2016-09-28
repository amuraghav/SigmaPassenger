//
//  SignInViewController.m
//  privMD
//
//  Created by Rahul Sharma on 13/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "SignInViewController.h"
#import "ViewController.h"
#import "Database.h"
#import "SignUpViewController.h"
#import "PatientAppDelegate.h"


//TODO::GOOGLE PLUS
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <QuartzCore/QuartzCore.h>
typedef void(^AlertViewActionBlock)(void);



@interface SignInViewController ()<GPPSignInDelegate>{
    
    
}

@property (nonatomic, copy) void (^confirmActionBlock)(void);
@property (nonatomic, copy) void (^cancelActionBlock)(void);


@property (nonatomic, strong) PatientAppDelegate *appDelegate;

@property (nonatomic,strong)  NSMutableArray *arrayContainingCardInfo;

@end


//TODO::GOOGLE PLUS
static NSString *const kPlaceholderUserName = @"<Name>";
static NSString *const kPlaceholderEmailAddress = @"<Email>";
static NSString *const kPlaceholderAvatarImageName = @"PlaceholderAvatar.png";

// Labels for the cells that have in-cell control elements.
static NSString *const kGetUserIDCellLabel = @"Get user ID";
static NSString *const kSingleSignOnCellLabel = @"Use Single Sign-On";
static NSString *const kButtonWidthCellLabel = @"Width";

// Labels for the cells that drill down to data pickers.
static NSString *const kColorSchemeCellLabel = @"Color scheme";
static NSString *const kStyleCellLabel = @"Style";
static NSString *const kAppActivitiesCellLabel = @"App activity types";

// Strings for Alert Views.
static NSString *const kSignOutAlertViewTitle = @"Warning";
static NSString *const kSignOutAlertViewMessage =
@"Modifying this element will sign you out of G+. Are you sure you wish to continue?";
static NSString *const kSignOutAlertCancelTitle = @"Cancel";
static NSString *const kSignOutAlertConfirmTitle = @"Continue";

// Accessibility Identifiers.
static NSString *const kCredentialsButtonAccessibilityIdentifier = @"Credentials";








@implementation SignInViewController{
    
    NSArray *_sectionCellLabels;
    // These sets contain the labels corresponding to cells that have various
    // types (each cell either drills down to another table view, contains an
    // in-cell switch, or contains a slider).
    NSArray *_drillDownCells;
    NSArray *_switchCells;
    NSArray *_sliderCells;
    NSDictionary *_drilldownCellState;
}

@synthesize emailTextField;
@synthesize passwordTextField;
//@synthesize navCancelButton;
@synthesize navDoneButton;
@synthesize emailImageView;
@synthesize signinButton;
@synthesize _btnRegisterNow;



#pragma mark - View lifecycle

- (void)gppInit {
    _sectionCellLabels = @[
                           @[ kColorSchemeCellLabel, kStyleCellLabel, kButtonWidthCellLabel ],
                           @[ kAppActivitiesCellLabel, kGetUserIDCellLabel, kSingleSignOnCellLabel ]
                           ];
    
    // Groupings of cell types.
    _drillDownCells = @[
                        kColorSchemeCellLabel,
                        kStyleCellLabel,
                        kAppActivitiesCellLabel
                        ];
    
    _switchCells = @[ kGetUserIDCellLabel, kSingleSignOnCellLabel ];
    _sliderCells = @[ kButtonWidthCellLabel ];
    
    // Initialize data picker states.
    NSString *dictionaryPath =
    [[NSBundle mainBundle] pathForResource:@"DataPickerDictionary"
                                    ofType:@"plist"];
    NSDictionary *configOptionsDict =
    [NSDictionary dictionaryWithContentsOfFile:dictionaryPath];
    
    NSDictionary *colorSchemeDict =
    [configOptionsDict objectForKey:kColorSchemeCellLabel];
    NSDictionary *styleDict = [configOptionsDict objectForKey:kStyleCellLabel];
    NSDictionary *appActivitiesDict =
    [configOptionsDict objectForKey:kAppActivitiesCellLabel];
    
    [GPPSignInButton class];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.delegate = self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self gppInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self gppInit];
    }
    return self;
}


//*************



- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor=BG_Color;

    //TODO::GOOGLE PLUS
    self.credentialsButton.accessibilityIdentifier = kCredentialsButtonAccessibilityIdentifier;
    
    self.navigationItem.title = @"SIGN IN";
   
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"Oswald-Light" size:20]}];
    self.navigationController.navigationBar.translucent = NO;
    

    [self createNavLeftButton];
    [signinButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [signinButton.titleLabel setFont:[UIFont fontWithName:Trebuchet_MS size:15]];
    //[signinButton.titleLabel setFont:[UIFont fontWithName:SourceSansPro_Light size:15]]
    [signinButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [signinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    signinButton.titleLabel.font = [UIFont systemFontOfSize:15];
    signinButton.layer.cornerRadius = 2;
    signinButton.layer.borderWidth=1.0f;
    signinButton.layer.borderColor=[UIColor whiteColor].CGColor;
    
    [Helper setButton:_forgotPasswordButton Text:@"Forgot Password" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [_forgotPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_forgotPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [Helper setButton:self._btnRegisterNow Text:@"Register Now" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [self._btnRegisterNow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self._btnRegisterNow setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [emailTextField setValue:[UIColor blackColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [passwordTextField setValue:[UIColor blackColor]
                  forKeyPath:@"_placeholderLabel.textColor"];

    
    emailTextField.font = [UIFont fontWithName:Trebuchet_MS size:15];
    emailTextField.textColor = [UIColor blackColor];
    passwordTextField.font = [UIFont fontWithName:Trebuchet_MS size:15];
    passwordTextField.textColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Observe for the custom notification regarding the session state change.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    // Initialize the appDelegate property.
    self.appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
    

    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    CGRect frame = self.signInButton.frame;
    frame.size.width = 420;
    frame.size.height = 50;
    self.signInButton.frame = frame;
    
    //TODO::GOOGLE PLUS
    [self adoptUserSettings];
    [[GPPSignIn sharedInstance] trySilentAuthentication];
    [self reportAuthStatus];
    [self updateButtons];
}





-(void) createNavLeftButton
{
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navCancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];
    
    [Helper setButton:navCancelButton Text:@"BACK" WithFont:Oswald_Light FSize:11 TitleColor:[UIColor blackColor] ShadowColor:nil];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateSelected];
    [navCancelButton setShowsTouchWhenHighlighted:YES];
    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    navCancelButton.titleLabel.font = [UIFont fontWithName:Oswald_Light size:11];
    //[navCancelButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    //Adding Button onto View
    // [navView addSubview:navCancelButton];
    
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
}

-(void)createnavRightButton
{
    navDoneButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navDoneButton addTarget:self action:@selector(DoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [navDoneButton setFrame:CGRectMake(0.0f,0.0f, 60,30)];
    
    [Helper setButton:navDoneButton Text:@"Done" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor blueColor] ShadowColor:nil];
    
    
    [navDoneButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    // Create a container bar button
    UIBarButtonItem *containingnextButton = [[UIBarButtonItem alloc] initWithCustomView:navDoneButton];
    
    self.navigationItem.rightBarButtonItem = containingnextButton;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [emailTextField becomeFirstResponder];
    
}

-(void)dismissKeyboard
{
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
}

-(void)cancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self callPop];
}


-(void)callPop
{
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)signInUser
{
    NSString *email = emailTextField.text;
    
    NSString *password = passwordTextField.text;
    
    if((unsigned long)email.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Email ID"];
        [emailTextField becomeFirstResponder];
    }
    else if((unsigned long)password.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Password"];
        [passwordTextField becomeFirstResponder];
    }
    else if([self emailValidationCheck:email] == 0)
    {
        //email is not valid
        [Helper showAlertWithTitle:@"Message" Message:@"Invalid Email ID"];
        emailTextField.text = @"";
        [emailTextField becomeFirstResponder];
        
    }
    else
    {
        checkLoginCredentials = YES;
        [self sendServiceForLogin];
        
    }
    
}



-(void)DoneButtonClicked
{
    
    [self signInUser];
}

-(void)sendServiceForLogin
{
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
    
    [loginDict setObject:emailTextField.text forKey:KDALoginEmail];
    [loginDict setObject:passwordTextField.text forKey:KDALoginPassword];
    [loginDict setObject:deviceId forKey:KDALoginDevideId];
    [loginDict setObject:@"1" forKey:KDALoginDeviceType];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLat])
        [loginDict setObject:@"" forKey:KDASignUpLatitude];
    else
        [loginDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLat] forKey:KDASignUpLatitude];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLong])
        [loginDict setObject:@"" forKey:KDASignUpLongitude];
    else
        [loginDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLong] forKey:KDASignUpLongitude];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUserCurrentCity])
        [loginDict setObject:@"" forKey:KDASignUpCity];
    else
        [loginDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUserCurrentCity] forKey:KDASignUpCity];
    
    [loginDict setObject:[Helper getCurrentDateTime] forKey:KDALoginUpDateTime];
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken])
    {
        [loginDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken] forKey:KDASignUpPushToken];
        NSLog(@"push token%@",[[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken]);
    }
    else
    {
        [loginDict setObject:@"123" forKey:KDASignUpPushToken];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:[loginDict objectForKey:@"ent_email"] forKey:KDAEmail];
    [[NSUserDefaults standardUserDefaults] setObject:[loginDict objectForKey:@"ent_password"] forKey:KDAPassword];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSMutableURLRequest *request = [Service parseLogin:loginDict];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eLogin;
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(loginResponse:)];
    
    // Activating progress Indicator.
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Signing in"];
}


-(void)loginResponse:(NSDictionary *)dictionary
{
    TELogInfo(@"do nothing %@ ",dictionary);
    NSLog(@"response %@",dictionary);
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    itemList = [[NSMutableDictionary alloc]initWithDictionary:dictionary[@"ItemsList"]];
    
    
    if(!dictionary)
    {
        return;
    }
    
    if ([[dictionary objectForKey:@"Error"] length] != 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[dictionary objectForKey:@"Error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        
        if ([[itemList objectForKey:@"errFlag"]integerValue] == 0)
        {
            TELogInfo(@" Item List contains %@ ",itemList);
            NSLog(@"ausdhsjkhdsjkd%@",itemList);
            //save information
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[itemList objectForKey:@"token"] forKey:KDAcheckUserSessionToken];
            [ud setObject:itemList[@"chn"] forKey:kNSUPatientPubNubChannelkey];
            [ud setObject:itemList[@"email"] forKey:kNSUPatientEmailAddressKey];
            [ud setObject:itemList[@"apiKey"] forKey:kNSUMongoDataBaseAPIKey];
            [ud setObject:itemList[@"serverChn"] forKey:kPMDPublishStreamChannel];
            
            [ud synchronize];
            NSLog(@"pubnubchannel key %@ stream channel %@",kNSUPatientPubNubChannelkey,kPMDPublishStreamChannel);
            
            NSMutableArray *carTypes = [[NSMutableArray alloc]initWithArray:itemList[@"types"]];
            
            if (!carTypes || !carTypes.count){
                NSLog(@"No car types availble in ur area");
                TELogInfo(@"do nothing");
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:carTypes forKey:KUBERCarArrayKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
            _arrayContainingCardInfo = itemList[@"cards"];
            NSLog(@"array card info %@",_arrayContainingCardInfo);
            
            if (!_arrayContainingCardInfo || !_arrayContainingCardInfo.count){
                
            }
            else
            {
                //NSDictionary *mDict = [_arrayContainingCardInfo objectAtIndex:0];
                // NSDictionary *mDict = itemList[@"cards"];
                // if([mDict[@"errFlag"] isEqualToString:@"0"])
                // {
                    [self addInDataBase];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewCardAddedNameKey object:nil userInfo:nil];
                // }
                
            }
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                        @"Main" bundle:[NSBundle mainBundle]];
            ViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
            self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
            
        }
        else if ([[itemList objectForKey:@"errFlag"]integerValue] == 1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:[itemList objectForKey:@"errMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            checkLoginCredentials = NO;
            passwordTextField.text = @"";
            [passwordTextField becomeFirstResponder];
        }
        
    }
    
    
}

- (void)shakeView:(UIView *)viewToShake
{
    CGFloat t = 15.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}



#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField == emailTextField)
    {
        [passwordTextField becomeFirstResponder];
    }
    else
    {
        [passwordTextField resignFirstResponder];
        [self DoneButtonClicked];
        
    }
    return YES;
    
}


- (IBAction)forgotPasswordButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Can't sign in? "
                                        message:@"Enter your email address below and we will send your OTP to your mobile."
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Submit", nil];
    
    UITextField *emailForgot = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 225, 30)];
    emailForgot.delegate =self;
    
    emailForgot.placeholder = @"Email";
    
    emailImageView.frame = CGRectMake(220,110,18,18);
    
    [forgotPasswordAlert addSubview:emailForgot];
    [forgotPasswordAlert addSubview:emailImageView];
    
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
     forgotPasswordAlert.tag = 1;
    [forgotPasswordAlert show];
    
    //forgotView.hidden=NO;
    //TELogInfo(@"password recovery to be done here");
    
    
}

- (IBAction)signInButtonClicked:(id)sender {
    [self.view endEditing:YES];
    [self signInUser];
}

- (IBAction)btnRegisterNowButtonPressed:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignUpViewController *signUpViewController = [storyBoard instantiateViewControllerWithIdentifier:@"signUpViewController"];
    [self.navigationController pushViewController:signUpViewController animated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void) forgotPaswordAlertviewTextField
{
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Invalid Email ID"
                                        message:@"Reenter your email ID "
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Submit", nil];
    forgotPasswordAlert.tag = 1;
    UITextField *emailForgot = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 225, 30)];
    [forgotPasswordAlert addSubview:emailForgot];
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [forgotPasswordAlert show];
}


- (void)OTPAlertviewTextField
{
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Invalid OTP"
                                        message:@"Reenter your OTP"
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Submit", nil];
    forgotPasswordAlert.tag = 101;
    UITextField *emailForgot = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 225, 30)];
    [forgotPasswordAlert addSubview:emailForgot];
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [forgotPasswordAlert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (alertView.tag == 101) {
        
        if(buttonIndex == 1)
        {
            UITextField *forgotEmailtext = [alertView textFieldAtIndex:0];
            TELogInfo(@"Email Name: %@", forgotEmailtext.text);
            
            if (((unsigned long)forgotEmailtext.text.length ==0))
            {
                [self OTPAlertviewTextField];
            }
            else
            {
                [self retrievePasswordFromOtp:forgotEmailtext.text];
            }
        }
        else
        {
            TELogInfo(@"cancel");
            // emailTextField.text = @"";
            //passwordTextField.text = @"";
        }
        
    }
    else{
        
        if(buttonIndex == 1)
        {
            UITextField *forgotEmailtext = [alertView textFieldAtIndex:0];
            TELogInfo(@"Email Name: %@", forgotEmailtext.text);
            
            if (((unsigned long)forgotEmailtext.text.length ==0) || [Helper emailValidationCheck:forgotEmailtext.text] == 0)
            {
                [self forgotPaswordAlertviewTextField];
            }
            else
            {
                [self retrievePassword:forgotEmailtext.text];
            }
        }
        else
        {
            TELogInfo(@"cancel");
            // emailTextField.text = @"";
            //passwordTextField.text = @"";
        }
        
    }
    
   
    
}

- (void)retrievePassword:(NSString *)text
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    EmailStr=text;
    NSString *parameters = [NSString stringWithFormat:@"ent_email=%@&ent_user_type=%@",text,@"2"];
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    TELogInfo(@"request doctor around you :%@",parameters);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@generateforgotpasswordOtp",BASE_URL]];
    NSLog(@"%@",BASE_URL);
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(retrievePasswordResponse:)];
    
}

-(void)retrievePasswordResponse :(NSDictionary *)response
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    TELogInfo(@"response:%@",response);
    if (!response)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
        
    }
    else
    {
        
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            //[Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
            [self otpAlertviewTextField];
        }
        else
        {
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
            
        }
    }
}

//TODO:: Add Alert for OTP

- (void)otpAlertviewTextField
{
    [self.view endEditing:YES];
    UIAlertView *forgotPasswordAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Can't sign in?"
                                        message:@"Please enter your OTP"
                                        delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Submit", nil];
    
    UITextField *emailForgot = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 225, 30)];
    emailForgot.delegate =self;
    emailForgot.placeholder = @"OTP";
    emailImageView.frame = CGRectMake(220,110,18,18);
    [forgotPasswordAlert addSubview:emailForgot];
    [forgotPasswordAlert addSubview:emailImageView];
    forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    forgotPasswordAlert.tag=101;
    [forgotPasswordAlert show];

}

- (void)retrievePasswordFromOtp:(NSString *)text
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    NSString *parameters = [NSString stringWithFormat:@"ent_otp=%@&ent_user_type=%@&ent_email=%@",text,@"2",EmailStr];
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    TELogInfo(@"request doctor around you :%@",parameters);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@forgotPasswordPassenger",BASE_URL]];
    NSLog(@"%@",BASE_URL);
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(retrieveOtpResponse:)];
}

-(void)retrieveOtpResponse :(NSDictionary *)response
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
    TELogInfo(@"response:%@",response);
    if (!response)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
        
    }
    else
    {
        
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
        }
        else
        {
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
            [self otpAlertviewTextField];

            
        }
    }
}


- (BOOL) emailValidationCheck: (NSString *) emailToValidate
{
    NSString *regexForEmailAddress = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexForEmailAddress];
    return [emailValidation evaluateWithObject:emailToValidate];
}
-(void)addInDataBase
{
    Database *db = [[Database alloc] init];
    {
        for (int i =0; i<_arrayContainingCardInfo.count; i++)
        {
            [db makeDataBaseEntry:_arrayContainingCardInfo[i]];
        }
    }
    
}

- (IBAction)FBloginPressed:(id)sender;
{
    
    [self.view endEditing:YES];
    
    // Activating progress Indicator.
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Signing in"];
    
    if ([FBSession activeSession].state != FBSessionStateOpen &&
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        
        [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
        
    }
    else{
           // Close an existing session.
          [[FBSession activeSession] closeAndClearTokenInformation];
        
        // [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
        
       
    }

}


    
    
    
    


#pragma mark - Private method implementation
#pragma mark - Private method implementation for Facebook

-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification{
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    StatusStr = @"Logging you in...";
    
    // Handle the session state.
    // Usually, the only interesting states are the opened session, the closed session and the failed login.
    if (!error) {
        // In case that there's not any error, then check if the session opened or closed.
        if (sessionState == FBSessionStateOpen) {
            // The session is open. Get the user information and update the UI.
            
            //            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            //
            //                if (!error) {7
            //                    NSLog(@"%@", result);
            //                }
            //
            //            }];
            
            
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error) {
                                          // Set the use full name.
                                          fNameStr = [NSString stringWithFormat:@"%@",
                                                     [result objectForKey:@"first_name"]
                                                     ];
                                          
                                          NSLog(@"%@",fNameStr);
                                          
                                          lNameStr = [NSString stringWithFormat:@"%@",
                                                     [result objectForKey:@"last_name"]
                                                      ];
                                          
                                          NSLog(@"%@",lNameStr);
                                          
                                          
                                          
                                          
                                          // Set the e-mail address.
                                          EmailStr = [result objectForKey:@"email"];
                                          
                                            NSLog(@"%@",EmailStr);
                                         
                                          
//                                         NSString* GenderStr =[result objectForKey:@"gender"];
//                                          NSLog(@"gender :%@",GenderStr);
                                          // Get the user's profile picture.
                                       //   pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                          
                                          pictureURL =[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                                          
                                          
//                                          ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
//                                          [progressIndicator hideProgressIndicator];
                                          
                                          
                                          NSDictionary *params = @{@"fname":fNameStr,
                                                                   @"lname":lNameStr,
                                                                   @"email":EmailStr,
                                                                  @"picture":pictureURL,
                                                                   };
                                          
                                          [self ServiceForFBLogin:params];

                                     
                                      
                                          
                                          
                                          
                                      }
                                      else{
                                          NSLog(@"%@", [error localizedDescription]);
                                      }
                                  }];
            
            
            //  [_btnLoginWithFacebook setTitle:@"googlut" forState:UIControlStateNormal];
            
        }
        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            // A session was closed or the login was failed. Update the UI accordingly.
            //  [_btnLoginWithFacebook setTitle:@"Login" forState:UIControlStateNormal];
           StatusStr = @"You are log out.";
            
        }
    }
    else{
        // In case an error has occurred, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
        //  [_btnLoginWithFacebook setTitle:@"Login" forState:UIControlStateNormal];
        NSLog(@"email%@",EmailStr);
        NSLog(@"%@",fNameStr);
        NSLog(@"%@",lNameStr);
        NSLog(@"%@",pictureURL);

        
        
        
    }
}


-(void)ServiceForFBLogin:(NSDictionary *)dict
{
    
   
    
      NSString *fName =[dict objectForKey:@"fname"];
      NSString *lName =[dict objectForKey:@"lname"];
      NSString *Email =[dict objectForKey:@"email"];
      NSString *Picture =[dict objectForKey:@"picture"];
    
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSMutableDictionary *fbloginDict = [[NSMutableDictionary alloc] init];
    
    
    [fbloginDict setObject:fName forKey:KDALoginfName];
    [fbloginDict setObject:lName forKey:KDALoginlName];
    [fbloginDict setObject:Picture forKey:KDALoginPicture];
    [fbloginDict setObject:Email forKey:KDALoginEmail];
    [fbloginDict setObject:@"123456" forKey:KDALoginPassword];
    [fbloginDict setObject:deviceId forKey:KDALoginDevideId];
    [fbloginDict setObject:@"1" forKey:KDALoginDeviceType];
    
    [fbloginDict setObject:@"facebook" forKey:KDALoginType];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLat])
        [fbloginDict setObject:@"" forKey:KDASignUpLatitude];
    else
        [fbloginDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLat] forKey:KDASignUpLatitude];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLong])
        [fbloginDict setObject:@"" forKey:KDASignUpLongitude];
    else
        [fbloginDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLong] forKey:KDASignUpLongitude];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUserCurrentCity])
        [fbloginDict setObject:@"" forKey:KDASignUpCity];
    else
        [fbloginDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUserCurrentCity] forKey:KDASignUpCity];
    
    [fbloginDict setObject:[Helper getCurrentDateTime] forKey:KDALoginUpDateTime];
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken])
    {
        [fbloginDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken] forKey:KDASignUpPushToken];
        NSLog(@"push token%@",[[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken]);
    }
    else
    {
        [fbloginDict setObject:@"123" forKey:KDASignUpPushToken];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:[fbloginDict objectForKey:@"ent_email"] forKey:KDAEmail];
    [[NSUserDefaults standardUserDefaults] setObject:[fbloginDict objectForKey:@"ent_password"] forKey:KDAPassword];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSMutableURLRequest *request = [Service parseLogin:fbloginDict];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eFblogin;
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(loginResponseFB:)];
    
    // Activating progress Indicator.
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Signing in"];
}


-(void)loginResponseFB:(NSDictionary *)dictionary
{
    TELogInfo(@"do nothing %@ ",dictionary);
    NSLog(@"response %@",dictionary);
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    itemList = [[NSMutableDictionary alloc]initWithDictionary:dictionary[@"ItemsList"]];
    
    
    if(!dictionary)
    {
        return;
    }
    
    if ([[dictionary objectForKey:@"Error"] length] != 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[dictionary objectForKey:@"Error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        
        if ([[itemList objectForKey:@"errFlag"]integerValue] == 0)
        {
            TELogInfo(@" Item List contains %@ ",itemList);
            NSLog(@"ausdhsjkhdsjkd%@",itemList);
            //save information
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[itemList objectForKey:@"token"] forKey:KDAcheckUserSessionToken];
            [ud setObject:itemList[@"chn"] forKey:kNSUPatientPubNubChannelkey];
            [ud setObject:itemList[@"email"] forKey:kNSUPatientEmailAddressKey];
            [ud setObject:itemList[@"apiKey"] forKey:kNSUMongoDataBaseAPIKey];
            [ud setObject:itemList[@"serverChn"] forKey:kPMDPublishStreamChannel];
            
            [ud synchronize];
            NSLog(@"pubnubchannel key %@ stream channel %@",kNSUPatientPubNubChannelkey,kPMDPublishStreamChannel);
            
            NSMutableArray *carTypes = [[NSMutableArray alloc]initWithArray:itemList[@"types"]];
            
            if (!carTypes || !carTypes.count){
                NSLog(@"No car types availble in ur area");
                TELogInfo(@"do nothing");
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:carTypes forKey:KUBERCarArrayKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
            _arrayContainingCardInfo = itemList[@"cards"];
            NSLog(@"array card info %@",_arrayContainingCardInfo);
            
            if (!_arrayContainingCardInfo || !_arrayContainingCardInfo.count){
                
            }
            else
            {
                // NSDictionary *mDict = [_arrayContainingCardInfo objectAtIndex:0];
                
                // if([mDict[@"errFlag"] isEqualToString:@"0"])
                {
                    [self addInDataBase];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewCardAddedNameKey object:nil userInfo:nil];
                }
                
            }
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                        @"Main" bundle:[NSBundle mainBundle]];
            //
            ViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
            self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
            
        }
        else if ([[itemList objectForKey:@"errFlag"]integerValue] == 1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:[itemList objectForKey:@"errMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            checkLoginCredentials = NO;
            passwordTextField.text = @"";
            [passwordTextField becomeFirstResponder];
        }
        
    }
    
    
}








#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
    if (error) {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Authentication error: %@", error];
        return;
    }
    [self reportAuthStatus];
    [self updateButtons];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Failed to disconnect: %@", error];
    } else {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Disconnected"];
    }
    [self refreshUserInfo];
    [self updateButtons];
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    
    [[self navigationController] pushViewController:viewController animated:YES];
}

#pragma mark - Helper methods

// Updates the GPPSignIn shared instance and the GPPSignInButton
// to reflect the configuration settings that the user set
- (void)adoptUserSettings {
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    
}

// Temporarily force the sign in button to adopt its minimum allowed frame
// so that we can find out its minimum allowed width (used for setting the
// range of the width slider).
- (CGFloat)minimumButtonWidth {
    CGRect frame = self.signInButton.frame;
    //self.signInButton.frame = CGRectZero;
    
    CGFloat minimumWidth = self.signInButton.frame.size.width;
    //self.signInButton.frame = frame;
    
    return minimumWidth;
}

- (void)reportAuthStatus {
    if ([GPPSignIn sharedInstance].authentication) {
        _signInAuthStatus.text = @"Status: Authenticated";
    } else {
        // To authenticate, use Google+ sign-in button.
        _signInAuthStatus.text = @"Status: Not authenticated";
    }
    [self refreshUserInfo];
}

// Update the interface elements containing user data to reflect the
// currently signed in user.
- (void)refreshUserInfo {
    
    if ([GPPSignIn sharedInstance].authentication == nil) {
        
        self.userName.text = kPlaceholderUserName;
        self.userEmailAddress.text = kPlaceholderEmailAddress;
        self.userAvatar.image = [UIImage imageNamed:kPlaceholderAvatarImageName];
        return;
    }
    
    self.userEmailAddress.text = [GPPSignIn sharedInstance].userEmail;
    
    // The googlePlusUser member will be populated only if the appropriate
    // scope is set when signing in.
    GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
    if (person == nil) {
        return;
    }
    
    self.userName.text = person.displayName;
    // Load avatar image asynchronously, in background
    dispatch_queue_t backgroundQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(backgroundQueue, ^{
        NSData *avatarData = nil;
        NSString *imageURLString = person.image.url;
        if (imageURLString) {
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            avatarData = [NSData dataWithContentsOfURL:imageURL];
        }
        
        if (avatarData) {
            // Update UI from the main thread when available
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userAvatar.image = [UIImage imageWithData:avatarData];
            });
        }
    });
    
    
   // NSLog(@"%@",person.displayName);
    NSLog(@"%@",person.name.givenName);
    NSLog(@"%@",person.name.familyName);
   
    NSLog(@"%@",[GPPSignIn sharedInstance].userEmail);
    NSLog(@"%@",person.image.url);
   // NSLog(@"%@",person.identifier);
    
    NSDictionary *params1 = @{@"fname":person.name.givenName,
                             @"lname":person.name.familyName,
                             @"email":[GPPSignIn sharedInstance].userEmail,
                             @"picture":person.image.url
                             };
    [self ServiceForGPlusLogin:params1];

    
  }






-(void)ServiceForGPlusLogin:(NSDictionary *)dict
{
    NSString *fName =[dict objectForKey:@"fname"];
    NSString *lName =[dict objectForKey:@"lname"];
    NSString *Email =[dict objectForKey:@"email"];
    NSString *Picture =[dict objectForKey:@"picture"];
    
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSMutableDictionary *GPlusLoginDict = [[NSMutableDictionary alloc] init];
    
    
    [GPlusLoginDict setObject:fName forKey:KDALoginfName];
    [GPlusLoginDict setObject:lName forKey:KDALoginlName];
    [GPlusLoginDict setObject:Picture forKey:KDALoginPicture];
    [GPlusLoginDict setObject:Email forKey:KDALoginEmail];
    [GPlusLoginDict setObject:@"123456" forKey:KDALoginPassword];
    [GPlusLoginDict setObject:deviceId forKey:KDALoginDevideId];
    [GPlusLoginDict setObject:@"1" forKey:KDALoginDeviceType];
    
    [GPlusLoginDict setObject:@"gmail" forKey:KDALoginType];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLat])
        [GPlusLoginDict setObject:@"" forKey:KDASignUpLatitude];
    else
        [GPlusLoginDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLat] forKey:KDASignUpLatitude];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLong])
        [GPlusLoginDict setObject:@"" forKey:KDASignUpLongitude];
    else
        [GPlusLoginDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUCurrentLong] forKey:KDASignUpLongitude];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KNUserCurrentCity])
        [GPlusLoginDict setObject:@"" forKey:KDASignUpCity];
    else
        [GPlusLoginDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KNUserCurrentCity] forKey:KDASignUpCity];
    
    [GPlusLoginDict setObject:[Helper getCurrentDateTime] forKey:KDALoginUpDateTime];
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken])
    {
        [GPlusLoginDict setObject:[[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken] forKey:KDASignUpPushToken];
        NSLog(@"push token%@",[[NSUserDefaults standardUserDefaults]objectForKey:KDAgetPushToken]);
    }
    else
    {
        [GPlusLoginDict setObject:@"123" forKey:KDASignUpPushToken];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:[GPlusLoginDict objectForKey:@"ent_email"] forKey:KDAEmail];
    [[NSUserDefaults standardUserDefaults] setObject:[GPlusLoginDict objectForKey:@"ent_password"] forKey:KDAPassword];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSMutableURLRequest *request = [Service parseLogin:GPlusLoginDict];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType =  eGpluslogin;
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(loginResponseGPlus:)];
    
    // Activating progress Indicator.
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Signing in"];
    
}


-(void)loginResponseGPlus:(NSDictionary *)dictionary
{
    TELogInfo(@"do nothing %@ ",dictionary);
    NSLog(@"response %@",dictionary);
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    
    itemList = [[NSMutableDictionary alloc]initWithDictionary:dictionary[@"ItemsList"]];
    
    
    if(!dictionary)
    {
        return;
    }
    
    if ([[dictionary objectForKey:@"Error"] length] != 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[dictionary objectForKey:@"Error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        
        if ([[itemList objectForKey:@"errFlag"]integerValue] == 0)
        {
            TELogInfo(@" Item List contains %@ ",itemList);
            NSLog(@"ausdhsjkhdsjkd%@",itemList);
            //save information
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[itemList objectForKey:@"token"] forKey:KDAcheckUserSessionToken];
            [ud setObject:itemList[@"chn"] forKey:kNSUPatientPubNubChannelkey];
            [ud setObject:itemList[@"email"] forKey:kNSUPatientEmailAddressKey];
            [ud setObject:itemList[@"apiKey"] forKey:kNSUMongoDataBaseAPIKey];
            [ud setObject:itemList[@"serverChn"] forKey:kPMDPublishStreamChannel];
            
            [ud synchronize];
            NSLog(@"pubnubchannel key %@ stream channel %@",kNSUPatientPubNubChannelkey,kPMDPublishStreamChannel);
            
            NSMutableArray *carTypes = [[NSMutableArray alloc]initWithArray:itemList[@"types"]];
            
            if (!carTypes || !carTypes.count){
                NSLog(@"No car types availble in ur area");
                TELogInfo(@"do nothing");
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:carTypes forKey:KUBERCarArrayKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
            _arrayContainingCardInfo = itemList[@"cards"];
            NSLog(@"array card info %@",_arrayContainingCardInfo);
            
            if (!_arrayContainingCardInfo || !_arrayContainingCardInfo.count){
                
            }
            else
            {
                // NSDictionary *mDict = [_arrayContainingCardInfo objectAtIndex:0];
                
                // if([mDict[@"errFlag"] isEqualToString:@"0"])
                {
                    [self addInDataBase];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewCardAddedNameKey object:nil userInfo:nil];
                }
                
            }
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                        @"Main" bundle:[NSBundle mainBundle]];
            //
            ViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"home"];
            self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
            
        }
        else if ([[itemList objectForKey:@"errFlag"]integerValue] == 1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:[itemList objectForKey:@"errMsg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            checkLoginCredentials = NO;
            passwordTextField.text = @"";
            [passwordTextField becomeFirstResponder];
        }
        
    }
    
    
}






// Adjusts "Sign in", "Sign out", and "Disconnect" buttons to reflect
// the current sign-in state (ie, the "Sign in" button becomes disabled
// when a user is already signed in).
- (void)updateButtons {
    BOOL authenticated = ([GPPSignIn sharedInstance].authentication != nil);
    
    self.signInButton.enabled = !authenticated;
    self.signOutButton.enabled = authenticated;
    self.disconnectButton.enabled = authenticated;
    self.credentialsButton.hidden = !authenticated;
    
    if (authenticated) {
        self.signInButton.alpha = 0.5;
        self.signOutButton.alpha = self.disconnectButton.alpha = 1.0;
    } else {
        self.signInButton.alpha = 1.0;
        self.signOutButton.alpha = self.disconnectButton.alpha = 0.5;
    }
}

// Creates and shows an UIAlertView asking the user to confirm their action as it will log them
// out of their current G+ session

- (void)showSignOutAlertViewWithConfirmationBlock:(void (^)(void))confirmationBlock
                                      cancelBlock:(void (^)(void))cancelBlock {
    if ([[GPPSignIn sharedInstance] authentication]) {
        self.confirmActionBlock = confirmationBlock;
        self.cancelActionBlock = cancelBlock;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kSignOutAlertViewTitle
                                                            message:kSignOutAlertViewMessage
                                                           delegate:self
                                                  cancelButtonTitle:kSignOutAlertCancelTitle
                                                  otherButtonTitles:kSignOutAlertConfirmTitle, nil];
        [alertView show];
    }
}

#pragma mark - IBActions

- (IBAction)signOut:(id)sender {
    
    [[GPPSignIn sharedInstance] signOut];
    [self reportAuthStatus];
    [self updateButtons];
}

- (IBAction)disconnect:(id)sender {
    [[GPPSignIn sharedInstance] disconnect];
}



- (void)toggleUserID:(UISwitch *)sender {
    
    if ([[GPPSignIn sharedInstance] authentication]) {
        [self showSignOutAlertViewWithConfirmationBlock:^(void) {
            [GPPSignIn sharedInstance].shouldFetchGoogleUserID = sender.on;
        }
                                            cancelBlock:^(void) {
                                                [sender setOn:!sender.on animated:YES];
                                            }];
    } else {
        [GPPSignIn sharedInstance].shouldFetchGoogleUserID = sender.on;
    }
}

- (void)toggleSingleSignOn:(UISwitch *)sender {
    [GPPSignIn sharedInstance].attemptSSO = sender.on;
}

- (void)changeSignInButtonWidth:(UISlider *)sender {
    
    
    CGRect frame = self.signInButton.frame;
    frame.size.width = sender.value;
    //self.signInButton.frame = frame;
}





@end