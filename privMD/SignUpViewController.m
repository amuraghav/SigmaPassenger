//
//  SignUpViewController.m
//  privMD
//
//  Created by Rahul Sharma on 13/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "SignUpViewController.h"
#import "CardLoginViewController.h"
#import "TermsnConditionViewController.h"
#import "SignInViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "Database.h"
#import "ViewController.h"

#define REGEX_PASSWORD_ONE_UPPERCASE @"^(?=.*[A-Z]).*$"  //Should contains one or more uppercase letters
#define REGEX_PASSWORD_ONE_LOWERCASE @"^(?=.*[a-z]).*$"  //Should contains one or more lowercase letters
#define REGEX_PASSWORD_ONE_NUMBER @"^(?=.*[0-9]).*$"  //Should contains one or more number
#define REGEX_PASSWORD_ONE_SYMBOL @"^(?=.*[!@#$%&_]).*$"  //Should contains one or more symbol


@interface SignUpViewController ()
@property (assign ,nonatomic) BOOL isImageNeedsToUpload;
@property (assign ,nonatomic) BOOL isKeyboardIsShown;
typedef enum {
    PasswordStrengthTypeWeak,
    PasswordStrengthTypeModerate,
    PasswordStrengthTypeStrong
}PasswordStrengthType;

//-(PasswordStrengthType)checkPasswordStrength:(NSString *)password;
-(int)checkPasswordStrength:(NSString *)password;

@end

@implementation SignUpViewController

@synthesize mainView;
@synthesize mainScrollView;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize conPasswordTextField;
@synthesize phoneNoTextField;
@synthesize zipCodeTextField;
@synthesize helperCountry;
@synthesize helperCity;
@synthesize navNextButton;
@synthesize saveSignUpDetails;
@synthesize profileButton;
@synthesize profileImageView;
@synthesize tncButton;
@synthesize tncCheckButton;
@synthesize creatingLabel;
@synthesize isKeyboardIsShown;

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
    // Do any additional setup after loading the view from its nib.
    
    // TODO::Befor code for BG image
    // self.view.backgroundColor = BG_Color;
    //TODO::After  code for BG Color
    self.view.backgroundColor = BG_Color;
    
    
    // self.mainView.backgroundColor = [UIColor greenColor];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton = NO;
    
    
    self.navigationController.navigationBar.barTintColor= BUTTON_NG_Color;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"oswald-light" size:17]}];
   
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    [self createNavLeftButton];
    [Helper setToLabel:creatingLabel Text:@"By creating an account you agree to our Terms and Conditions" WithFont:HELVETICANEUE_LIGHT FSize:14 Color:BLACK_COLOR];
    
    [firstNameTextField setValue:[UIColor blackColor]
                      forKeyPath:@"_placeholderLabel.textColor"];
    [lastNameTextField setValue:[UIColor blackColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
    [emailTextField setValue:[UIColor blackColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [passwordTextField setValue:[UIColor blackColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
    [conPasswordTextField setValue:[UIColor blackColor]
                     forKeyPath:@"_placeholderLabel.textColor"];
    [phoneNoTextField setValue:[UIColor blackColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    [zipCodeTextField setValue:[UIColor blackColor]
                                  forKeyPath:@"_placeholderLabel.textColor"];
    firstNameTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    firstNameTextField.textColor = [UIColor blackColor];
    lastNameTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    lastNameTextField.textColor = [UIColor blackColor];
    emailTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    emailTextField.textColor = [UIColor blackColor];
    passwordTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    passwordTextField.textColor = [UIColor blackColor];
    conPasswordTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    conPasswordTextField.textColor = [UIColor blackColor];
    phoneNoTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    phoneNoTextField.textColor = [UIColor blackColor];
    zipCodeTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    zipCodeTextField.textColor = [UIColor blackColor];
    
    profileImageView.image = [UIImage imageNamed:@"signup_profile_image.png"];
    mainScrollView.scrollEnabled = YES;
    isTnCButtonSelected = NO;
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    if (screenSize.size.height == 480)
    {
        mainScrollView.frame = CGRectMake(0, 0, 320, 480);
        mainScrollView.contentSize = CGSizeMake(320,750);
    }
    else
    {
        mainScrollView.contentSize = CGSizeMake(320,tncButton.frame.size.height+tncButton.frame.origin.y);
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    //self.mainView.frame = CGRectMake(0,0, 320, 504);
    
    [_btnRegisterNow setTitle:@"Register Now" forState:UIControlStateNormal];
    [_btnRegisterNow.titleLabel setFont:[UIFont fontWithName:Trebuchet_MS size:15]];
    [_btnRegisterNow setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnRegisterNow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnRegisterNow setShowsTouchWhenHighlighted:YES];
    _btnRegisterNow.titleLabel.font = [UIFont systemFontOfSize:15];
    _btnRegisterNow.layer.cornerRadius = 2;
    _btnRegisterNow.layer.borderWidth = 1;
    _btnRegisterNow.layer.borderColor = [UIColor whiteColor].CGColor;
   // _btnRegisterNow.clipsToBounds = true;
   
    
    
    [self createNavView];
    // Register notification when the keyboard will be show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    isKeyboardIsShown = YES;
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [firstNameTextField becomeFirstResponder];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationItem.titleView  = nil;
}
-(void)createNavView
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(80,0, 160, 50)];
    UILabel *navTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,10, 147, 30)];
    navTitle.text = @"REGISTER";
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font = [UIFont fontWithName:Oswald_Light size:15];
    [navView addSubview:navTitle];
    self.navigationItem.titleView = navView;
}

-(void) createNavLeftButton
{
  // UIView *navView = [[UIView new]initWithFrame:CGRectMake(0, 0,50, 44)];
     UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navCancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];

  
    [Helper setButton:navCancelButton Text:@"BACK" WithFont:Oswald_Light FSize:11 TitleColor:[UIColor blackColor]ShadowColor:nil];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateSelected];
    [navCancelButton setShowsTouchWhenHighlighted:YES];
    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    navCancelButton.titleLabel.font = [UIFont fontWithName:Oswald_Light size:11];
    //[navCancelButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    //Adding Button onto View
   // [navView addSubview:navCancelButton];

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


-(void)createNavRightButton
{
    navNextButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    [navNextButton setFrame:CGRectMake(0,0,buttonImage.size.width,buttonImage.size.height)];

    [navNextButton addTarget:self action:@selector(NextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
   
    
    [Helper setButton:navNextButton Text:@"Next" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor blackColor] ShadowColor:nil];
    [navNextButton setTitle:@"Next" forState:UIControlStateNormal];
    [navNextButton setTitle:@"Next" forState:UIControlStateSelected];
    [navNextButton setShowsTouchWhenHighlighted:YES];
    [navNextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navNextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //[navNextButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navNextButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];

}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    [self moveViewDown ];
    [firstNameTextField resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [conPasswordTextField resignFirstResponder];
    [phoneNoTextField resignFirstResponder];
   // [self moveViewDown];
}

-(void)signUp
{
    NSString *signupFirstName = firstNameTextField.text;
    NSString *signupLastName = lastNameTextField.text;
    NSString *signupEmail = emailTextField.text;
    NSString *signupPassword = passwordTextField.text;
    NSString *signupConfirmPassword = conPasswordTextField.text;
    NSString *signupPhoneno = phoneNoTextField.text;
    NSString *signupZipcode = zipCodeTextField.text;
    
    if ((unsigned long)signupFirstName.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter First Name"];
        [firstNameTextField becomeFirstResponder];
    }
    else if ((unsigned long)signupLastName.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Last Name"];
        [lastNameTextField becomeFirstResponder];
    }
    else if ((unsigned long)signupPhoneno.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter your Mobile No."];
        [phoneNoTextField becomeFirstResponder];
    }
    else if ((unsigned long)signupEmail.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Email ID"];
        [emailTextField becomeFirstResponder];
    }
    else if ([Helper emailValidationCheck:signupEmail] == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Invalid Email Id"];
        emailTextField.text = @"";
        [emailTextField becomeFirstResponder];
    }
    else if ((unsigned long)signupPassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Password"];
        [passwordTextField becomeFirstResponder];
    }
    else if ((unsigned long)signupConfirmPassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Password to Confirm"];
        [conPasswordTextField becomeFirstResponder];
    }
   
    else if ([signupPassword isEqualToString:signupConfirmPassword] == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Password Mismatched"];
        passwordTextField.text = @"";
        conPasswordTextField.text = @"";
        [conPasswordTextField becomeFirstResponder];
    }
    else if ((unsigned long)signupZipcode.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter zipcode"];
        [zipCodeTextField becomeFirstResponder];
    }

    else if (!isTnCButtonSelected)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Please select our Terms and Condition"];
    }
    else
    {
        if ((unsigned long)lastNameTextField.text.length == 0)
        {
            lastNameTextField.text = @"";
        }
        
        [self validateEmailAndPostalCode];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MainView Up/Down
-(void)moveViewUpToPoint:(int)point
{
    CGRect rect = mainScrollView.frame;
    rect.origin.y = point;
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         mainScrollView.frame = rect;
                     }
                     completion:^(BOOL finished){
                     }];
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:.2];
    //    [mainScrollSignUp setFrame:rect];
    //    [UIView commitAnimations];
    
}

-(void)moveViewDown
{
    CGRect rect = mainScrollView.frame;
    
    rect.origin.y = 0;
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:.2];
    //    [mainScrollSignUp setFrame:rect];
    //    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         mainScrollView.frame = rect;
                     }
                     completion:^(BOOL finished){
                     }];
    
}

- (void) validateEmailAndPostalCode
{
   // [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Validating Email.."];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    
    NSString *parameters = [NSString stringWithFormat:@"ent_email=%@&zip_code=%@&ent_user_type=%@&ent_date_time=%@",emailTextField.text,zipCodeTextField.text,@"2",[Helper getCurrentDateTime]];
    
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    TELogInfo(@"request doctor around you :%@",parameters);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@validateEmailZip",BASE_URL]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    
    NSLog(@"%@",url);
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(validateEmailResponse:)];
    
}

-(void)validateEmailResponse :(NSDictionary *)response
{
       // ProgressIndicator *pi = [ProgressIndicator sharedInstance];
       // [pi hideProgressIndicator];
        
        NSLog(@"response:%@",response);
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
//TODO COMMENT this code
                
   //                saveSignUpDetails = [[NSArray alloc]initWithObjects:firstNameTextField.text,lastNameTextField.text,emailTextField.text,phoneNoTextField.text,zipCodeTextField.text,passwordTextField.text,conPasswordTextField.text, nil];
               
 //                    [self performSegueWithIdentifier:@"CardController" sender:self];
                
                //Add new code
                [self genrateOtpCode];
                
            }
            else
            {
                [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
                
            }
        }
}

//Add new method
- (void)genrateOtpCode
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Please wait...."];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    
    NSString *parameters = [NSString stringWithFormat:@"ent_mobile=%@&ent_user_type=%@",phoneNoTextField.text,@"2"];
    
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    TELogInfo(@"request doctor around you :%@",parameters);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@generateOtp",BASE_URL]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    
    NSLog(@"%@",url);
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(getOtpResponse:)];
    
}

-(void)getOtpResponse:(NSDictionary *)response
{
    
     ProgressIndicator *pi = [ProgressIndicator sharedInstance];
     [pi hideProgressIndicator];
    
    NSDictionary  *dictrespone =response[@"ItemsList"];
    
    if ([dictrespone[@"errFlag"] intValue] == 0) {
        
        saveSignUpDetails = [[NSArray alloc]initWithObjects:firstNameTextField.text,lastNameTextField.text,emailTextField.text,phoneNoTextField.text,zipCodeTextField.text,passwordTextField.text,conPasswordTextField.text, nil];
        
        [self performSegueWithIdentifier:@"CardController" sender:self];
        
    }else{
        
        
        [Helper showAlertWithTitle:@"Message" Message:[dictrespone objectForKey:@"errMsg"]];
        
    }
    NSLog(@"%@",response);

    
}




#pragma mark - TextFields
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if((textField == zipCodeTextField) || (textField == passwordTextField) || (textField == conPasswordTextField))
    {
        int point;// = textField.frame.origin.y + textField.frame.size.height - 174;
        
        if(textField == zipCodeTextField)
        {
            point =30;
           
            
        }
        else if(textField == passwordTextField)
        {
            point = 50;
            
        }
        else
        {
            point = 85;
        }
       
        [self moveViewUpToPoint:(-point)];
        
    }
    else
    {
        [self moveViewDown];
    }
    self.activeTextField = textField;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == conPasswordTextField)
    {
        int strength = [self checkPasswordStrength:passwordTextField.text];
        if(strength == 0)
        {

            [passwordTextField becomeFirstResponder];
        }
    }
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
    if(textField == firstNameTextField)
    {
        // [textField resignFirstResponder];
        [lastNameTextField becomeFirstResponder];
    }
    else if(textField == lastNameTextField)
    {
        //  [textField resignFirstResponder];
        [emailTextField becomeFirstResponder];
    }
    
    
    else if (textField == emailTextField)
    {
        // [textField resignFirstResponder];
        [phoneNoTextField becomeFirstResponder];
    }
    
    else if (textField == phoneNoTextField)
    {
        // [textField resignFirstResponder];
        [zipCodeTextField becomeFirstResponder];
        // [self moveViewUp];
    }
    else if (textField == zipCodeTextField)
    {
        // [textField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
        //[self moveViewUp];
       
    }
    else if (textField == passwordTextField)
    {
        // [textField resignFirstResponder];
        int strength = [self checkPasswordStrength:passwordTextField.text];
        if(strength == 0)
        {
            [passwordTextField becomeFirstResponder];
        }
        else
        {
            [conPasswordTextField becomeFirstResponder];

        }
        // [self moveViewUp];
    }
    
    else
    {
        [conPasswordTextField resignFirstResponder];
        [self NextButtonClicked];
        
    }
    return YES;
}


- (void)NextButtonClicked
{
    [self signUp];
    
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CardController"])
    {

        CardLoginViewController *CLVC = (CardLoginViewController*)[segue destinationViewController];

        CLVC.getSignupDetails = saveSignUpDetails;
        CLVC.pickedImage = _pickedImage;
        for(int i=0;i< saveSignUpDetails.count;i++)
            TELogInfo(@"contents of array %@ ",[saveSignUpDetails objectAtIndex:i]);
        
        CLVC =[segue destinationViewController];
        
    }
    else if ([[segue identifier] isEqualToString:@"gotoTerms"])
    {
        TermsnConditionViewController *TNCVC = (TermsnConditionViewController*)[segue destinationViewController];
        TELogInfo(@"enabledTypes %@",TNCVC);

    }
}

- (void)cancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    
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

- (IBAction)TermsNconButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"gotoTerms" sender:self];
}

- (IBAction)checkButtonClicked:(id)sender
{
    [self moveViewDown ];
    
    
    UIButton *mBut = (UIButton *)sender;
    // [self setSelectedButtonByIndex:((UIButton *)sender).tag] ;
    
    mBut.userInteractionEnabled = YES;
    
    if(mBut.isSelected)
    {
        isTnCButtonSelected = NO;
        mBut.selected=NO;
        //[tncCheckButton setTitle:@"N" forState:UIControlStateNormal];
        [tncCheckButton setImage:[UIImage imageNamed:@"signup_btn_checkbox_off.png"] forState:UIControlStateNormal];

    }
    else
    {
        isTnCButtonSelected = YES;
        mBut.selected=YES;
        //[tncCheckButton setTitle:@"Y" forState:UIControlStateSelected];
        [tncCheckButton setImage:[UIImage imageNamed:@"signup_btn_checkbox_on.png"] forState:UIControlStateSelected];
        
    }
}


- (IBAction)profileButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [self cameraButtonClicked:nil];
                break;
            }
            case 1:
            {
                [self libraryButtonClicked:nil];
                break;
            }
            default:
                break;
        }
    }
}


-(void)cameraButtonClicked:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate =self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"Camera is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
-(void)libraryButtonClicked:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate =self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = YES;
    // picker.contentSizeForViewInPopover = CGSizeMake(400, 800);
    //    [self presentViewController:picker animated:YES completion:nil];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        
        
        
        //[popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    // [progressIndicator showPIOnView:self.view withMessage:@"Uploading Profile Pic..."];
    //  _flagCheckSnap = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    _pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //  [_signUpPhotoButton setImage:pickedImage forState:UIControlStateNormal];
    
    profileImageView.image = _pickedImage;
    
    NSData *data=UIImagePNGRepresentation(_pickedImage);
    
    NSString *FileName=[NSString stringWithFormat:@"patient.png"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tempPath = [documentsDirectory stringByAppendingPathComponent:FileName];
    [data writeToFile:tempPath atomically:YES];
    
}

//-(NSURL *) getImagePathWithURL
//{
//    NSString *strPath= [NSString stringWithFormat:@"NexPanama.png"];
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:strPath];
//    NSURL *targetURL = [NSURL fileURLWithPath:path];
//    //    NSData *returnData=[NSData dataWithContentsOfURL:targetURL];
//    //    UIImage *imagemain=[UIImage returnData];
//    return targetURL;
//}

#pragma mark - Password Checking

-(int)checkPasswordStrength:(NSString *)password
{
    unsigned long int  len = password.length;
    //will contains password strength
    int strength = 0;
    
//    if (len == 0) {
//        [Helper showAlertWithTitle:@"Message" Message:@"Please enter password first"];
//
//        return 0;//PasswordStrengthTypeWeak;
//    }
//    } else if (len <= 5) {
//        strength++;
//    } else if (len <= 10) {
//        strength += 2;
//    } else{
//        strength += 3;
//    }
//    int kp = strength;
//    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_UPPERCASE caseSensitive:YES];
//    if (kp >= strength)
//    {
//        [Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast one Uppercase alphabet"];
//        return 0;
//    }
//    else
//    {
//        kp++;
//    }
//    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_LOWERCASE caseSensitive:YES];
//    if (kp >= strength)
//    {
//        [Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast one Lowercase alphabet"];
//        return 0;
//    }
//    else
//    {
//        kp++;
//    }
//    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_NUMBER caseSensitive:YES];
//    if (kp >= strength) {
//        [Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast  one Number"];
//       // [passwordTextField becomeFirstResponder];
//        return 0;
//    }
    return 1;
  //  strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_SYMBOL caseSensitive:YES];
   // if (kp >= strength) {
        //[Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast one special symbol"];
        //[passwordTextField becomeFirstResponder];
       // return 0;
   // }
   
    
//    if(strength <= 3){
//        return PasswordStrengthTypeWeak;
//    }else if(3 < strength && strength < 6){
//        return PasswordStrengthTypeModerate;
//    }else{
//        return PasswordStrengthTypeStrong;
//    }
}

// Validate the input string with the given pattern and
// return the result as a boolean
- (int)validateString:(NSString *)string withPattern:(NSString *)pattern caseSensitive:(BOOL)caseSensitive
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:((caseSensitive) ? 0 : NSRegularExpressionCaseInsensitive) error:&error];
    
    NSAssert(regex, @"Unable to create regular expression");
    
    NSRange textRange = NSMakeRange(0, string.length);
    //NSLog(@"test range %ld",textRange);
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:textRange];
    
    BOOL didValidate = 0;
    
    // Did we find a matching range
    if (matchRange.location != NSNotFound)
        didValidate = 1;
   
    return didValidate;
}

/**
 *  KeyBoard Methods
 */

-(void) keyboardWillShow:(NSNotification *)note
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.

    if(isKeyboardIsShown)
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
    isKeyboardIsShown = YES;
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
    isKeyboardIsShown = YES;

}



- (IBAction)btnRegisterNowPressed:(id)sender {
    
    [self signUp];
}




@end
