//
//  UpdatePasswordViewController.m
//  CarConnect
//
//  Created by puran on 01/10/15.
//  Copyright (c) 2015 Rahul Sharma. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#define REGEX_PASSWORD_ONE_UPPERCASE @"^(?=.*[A-Z]).*$"  //Should contains one or more uppercase letters
#define REGEX_PASSWORD_ONE_LOWERCASE @"^(?=.*[a-z]).*$"  //Should contains one or more lowercase letters
#define REGEX_PASSWORD_ONE_NUMBER @"^(?=.*[0-9]).*$"  //Should contains one or more number
#define REGEX_PASSWORD_ONE_SYMBOL @"^(?=.*[!@#$%&_]).*$"  //Should contains one or more symbol



@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton = NO;
    
    self.view.backgroundColor = WHITE_COLOR;
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS-Bold" size:17]}];
    self.navigationController.navigationBar.translucent = NO;
    [self createNavView];
    [self createNavLeftButton];
    
    _btnSend.layer.cornerRadius = 7;
   // _btnSend.layer.borderWidth = 1;
   // _btnSend.layer.borderColor = [UIColor blackColor].CGColor;
   // _btnSend.clipsToBounds = true;
    [_btnSend.titleLabel setFont:[UIFont fontWithName:Trebuchet_MS size:15]];
    
    [_btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _txtfEmailId.text = [[NSUserDefaults standardUserDefaults] objectForKey:KDAEmail];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //self.navigationItem.title = @"Update Your Password?";
   
}

-(void)createNavView
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(80,0, 180, 50)];
    
    UILabel *navTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,10, 167, 30)];
    navTitle.text = @"UPDATE YOUR PASSWORD?";
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font = [UIFont fontWithName:Trebuchet_MS size:15];
    [navView addSubview:navTitle];
    self.navigationItem.titleView = navView;
}


-(void)viewDidAppear:(BOOL)animated
{
    [_txtfOldPassword becomeFirstResponder];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton = NO;
    
    [_txtfEmailId setTextColor:[UIColor darkGrayColor]];
    [_txtfOldPassword setTextColor:[UIColor darkGrayColor]];
    [_txtfNewPassword setTextColor:[UIColor darkGrayColor]];
    [_txtfConfirmPassword setTextColor:[UIColor darkGrayColor]];
    
}


-(void) createNavLeftButton
{
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navCancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];
    
    [Helper setButton:navCancelButton Text:@"BACK" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor blackColor] ShadowColor:nil];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateSelected];
    [navCancelButton setShowsTouchWhenHighlighted:YES];
    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    navCancelButton.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:11];

    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
}

-(void)cancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}


-(void)dismissKeyboard
{
    [_txtfOldPassword resignFirstResponder];
    [_txtfNewPassword resignFirstResponder];
    [_txtfConfirmPassword resignFirstResponder];
    
}


#pragma mark -------- UITEXTFIELD DELEGATE METHODS ------------------------

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _txtfOldPassword)
    {
        
    }
    else if(textField == _txtfNewPassword)
    {
        
    }
    else if(textField == _txtfConfirmPassword)
    {
        
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _txtfOldPassword)
    {
        [_txtfNewPassword becomeFirstResponder];
    }
    else if(textField == _txtfNewPassword)
    {
        [_txtfConfirmPassword becomeFirstResponder];
    }
    else
    {
        [_txtfConfirmPassword resignFirstResponder];
        [self NextButtonClicked];
        
    }
    return YES;
}

- (void)NextButtonClicked
{
    [self UpdatePassword];
}





- (IBAction)btnPressed:(id)sender {
    
    [self UpdatePassword];
}

-(void)UpdatePassword{
    
    if ([_txtfOldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter your old password first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
        [_txtfOldPassword setText:@""];
        [_txtfOldPassword becomeFirstResponder];
        return;
    }
    else if ([_txtfNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please enter your new password here" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
        [_txtfNewPassword setText:@""];
        [_txtfNewPassword becomeFirstResponder];
        return;
        
    }
    else if ([_txtfNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0 ){
        
        int strength = [self checkPasswordStrength:_txtfNewPassword.text];
        if(strength == 0){
            
            [_txtfNewPassword becomeFirstResponder];
            return;
        }
        
    }
    if ([_txtfConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 ){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please confirm your new password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
        [_txtfConfirmPassword setText:@""];
        [_txtfConfirmPassword becomeFirstResponder];
        return;
    }
    else if ([_txtfConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0 ){
        
        int strength = [self checkPasswordStrength:_txtfConfirmPassword.text];
        if(strength == 0){
            
            [_txtfConfirmPassword becomeFirstResponder];
            return;
        }
        
    }
    if ([_txtfNewPassword.text isEqualToString:_txtfConfirmPassword.text] == FALSE) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Your Password and Confirm Password did not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
        [_txtfNewPassword setText:@""];
        [_txtfConfirmPassword setText:@""];
        [_txtfNewPassword becomeFirstResponder];
        return;
    }
    
    NSLog(@"HIT SERVICE HERE");
    [self upDateMyPassword];
    
}






#pragma mark - Password Checking

-(int)checkPasswordStrength:(NSString *)password
{
    unsigned long int  len = password.length;
    //will contains password strength
    int strength = 0;
    
    if (len == 0) {
        [Helper showAlertWithTitle:@"Message" Message:@"Please enter password first"];
        
        return 0;//PasswordStrengthTypeWeak;
    } else if (len <= 5) {
        strength++;
    } else if (len <= 10) {
        strength += 2;
    } else{
        strength += 3;
    }
    int kp = strength;
    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_UPPERCASE caseSensitive:YES];
    if (kp >= strength)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast one Uppercase alphabet"];
        return 0;
    }
    else
    {
        kp++;
    }
    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_LOWERCASE caseSensitive:YES];
    if (kp >= strength)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast one Lowercase alphabet"];
        return 0;
    }
    else
    {
        kp++;
    }
    strength += [self validateString:password withPattern:REGEX_PASSWORD_ONE_NUMBER caseSensitive:YES];
    if (kp >= strength) {
        [Helper showAlertWithTitle:@"Message" Message:@"Please enter atleast  one Number"];
        // [passwordTextField becomeFirstResponder];
        return 0;
    }
    return 1;

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




#pragma mark ------ SERVICE CALL --------------------

- (void) upDateMyPassword
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Validating Email.."];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    
    NSString *parameters = [NSString stringWithFormat:@"ent_email=%@&ent_old_password=%@&ent_user_type=%@&ent_new_password=%@",_txtfEmailId.text,_txtfOldPassword.text,@"2",_txtfNewPassword.text];
    NSLog(@"%@",parameters);
    
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    TELogInfo(@"request doctor around you :%@",parameters);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@updatePassword",BASE_URL]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    
    NSLog(@"%@",url);
    
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(updatePasswordResponse:)];
    
}
-(void)updatePasswordResponse :(NSDictionary *)response
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
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
    else{
        
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:_txtfNewPassword.text forKey:KDAPassword];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //[[NSUserDefaults standardUserDefaults]objectForKey:KDAPassword]
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}







@end
