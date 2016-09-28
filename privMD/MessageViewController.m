//
//  MessageViewController.m
//  UBER
//
//  Created by Rahul Sharma on 30/09/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "MessageViewController.h"
#define kDescriptionPlaceholder @"Send message to the driver directly by pressing done button."

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceholder;

@end

@implementation MessageViewController
@synthesize messageTextView,textViewPlaceholder;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"CONTACT"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg-568h"]];

    [self createNavRightButton];
    [self createNavLeftButton];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    [textViewPlaceholder setText:kDescriptionPlaceholder];
    [textViewPlaceholder setBackgroundColor:[UIColor clearColor]];
    [textViewPlaceholder setTextColor:[UIColor blackColor]];
    textViewPlaceholder.numberOfLines = 3;
    textViewPlaceholder.hidden = YES;
    messageTextView.textColor = [UIColor blackColor];
    messageTextView.delegate = self;
    messageTextView.text = @"";
    messageTextView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    messageTextView.returnKeyType = UIReturnKeyDone;
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [self.messageTextView becomeFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    [messageTextView resignFirstResponder];
    
}
-(void)createNavRightButton
{
    UIButton *navNextButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    [navNextButton setFrame:CGRectMake(0,0,buttonImage.size.width,buttonImage.size.height)];
    
    [navNextButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [Helper setButton:navNextButton Text:@"DONE" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor blueColor] ShadowColor:nil];
    [navNextButton setTitle:@"DONE" forState:UIControlStateNormal];
    [navNextButton setTitle:@"DONE" forState:UIControlStateSelected];
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
    
    [navCancelButton addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];
    
    [Helper setButton:navCancelButton Text:@"BACK" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateSelected];
    [navCancelButton setShowsTouchWhenHighlighted:YES];
    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    navCancelButton.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:11];
    //[navCancelButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
    // UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:segmentView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
}

- (void)dismissViewController:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [pi showPIOnView:self.view withMessage:@"Sending Message.."];
    
    //setup parameters
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceID = @"";
    if (IS_SIMULATOR) {
        
        deviceID = kPMDTestDeviceidKey;
    }
    else {
        deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *currentDate = [Helper getCurrentDateTime];
    NSString *review = messageTextView.text;
    NSString *number = [[NSUserDefaults standardUserDefaults]objectForKey:@"DriverTelNo"];
    NSString *base64number = [self toBase64String:number];

    NSDictionary *params = @{@"ent_sess_token":sessionToken,
                             @"ent_dev_id":deviceID,
                             @"ent_date_time":currentDate,
                             @"ent_message":review,
                             @"ent_to_num":base64number
                             };
    
    //setup request
    NetworkHandler *networHandler = [NetworkHandler sharedInstance];
    [networHandler composeRequestWithMethod:@"sendMessage"
                                    paramas:params
                               onComplition:^(BOOL success, NSDictionary *response){
                                   
                                   if (success) { //handle success response
                                       TELogInfo(@"response %@",response);
                                       [self parseSubmitReviewResponse:response];
                                   }
                               }];
}

-(IBAction)callDriver:(id)sender {
    
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

- (NSString *)toBase64String:(NSString *)string {
    NSData *data = [string dataUsingEncoding: NSUTF8StringEncoding];
    
    NSString *ret = [data base64Encoding];
    return ret;
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
           
        }
        else if ([[response objectForKey:@"errFlag"] integerValue] == 1)  {
            [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"errMsg"]];

        }
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
}

#pragma mark -
#pragma mark TextView Delegate methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
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
@end
