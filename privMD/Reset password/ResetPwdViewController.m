//
//  ResetPwdViewController.m
//  CarConnect
//
//  Created by Appypie Inc on 12/04/16.
//  Copyright © 2016 Rahul Sharma. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "CustomNavigationBar.h"
#import "XDKAirMenuController.h"

@interface ResetPwdViewController () <CustomNavigationBarDelegate>

@end

@implementation ResetPwdViewController
@synthesize OldpasswordTextField,NewpasswordTextField,ConfirmpasswordTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomNavigationBar];
    
}
- (void) addCustomNavigationBar
{
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"RESET PASSWORD"];
    [self.view addSubview:customNavigationBarView];
    
    [customNavigationBarView setBackgroundColor:BUTTON_NG_Color];
    
    [OldpasswordTextField setValue:[UIColor blackColor]
                        forKeyPath:@"_placeholderLabel.textColor"];
    [NewpasswordTextField setValue:[UIColor blackColor]
     
                        forKeyPath:@"_placeholderLabel.textColor"];
    [ConfirmpasswordTextField setValue:[UIColor blackColor]
                            forKeyPath:@"_placeholderLabel.textColor"];
  
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
}

-(void)leftBarButtonClicked:(UIButton *)sender{
    
    //    CGRect frame = mainScrollView.frame;
    //    frame.origin.x = 0;
    //    frame.origin.y = 64;
    //    [mainScrollView scrollRectToVisible:frame animated:YES];
    [self menuButtonPressedAccount];
}
- (void)menuButtonPressedAccount
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

-(void)dismissKeyboard
{
    [OldpasswordTextField resignFirstResponder];
    [NewpasswordTextField resignFirstResponder];
    [ConfirmpasswordTextField resignFirstResponder];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)resetpassword_Action:(id)sender{
    
    
    [self signInUser];
}



-(void)signInUser
{
    NSString *oldpassword = OldpasswordTextField.text;
    
    NSString *newpassword = NewpasswordTextField.text;
    
    NSString *confirmpassword = ConfirmpasswordTextField.text;
    
    if((unsigned long)oldpassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter Old Password"];
        [OldpasswordTextField becomeFirstResponder];
    }
    else if((unsigned long)newpassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter New Password"];
        [NewpasswordTextField becomeFirstResponder];
    }
    else if((unsigned long)confirmpassword.length == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Enter New Password"];
        [ConfirmpasswordTextField becomeFirstResponder];
        
    }
    else if ([newpassword isEqualToString:confirmpassword] == 0)
    {
        [Helper showAlertWithTitle:@"Message" Message:@"Password Mismatched"];
        
    }
    
    else
    {
      
        [self sendServiceForLogin];
        
    }
    
}

-(void)sendServiceForLogin
{
    
    
     NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
    
    [loginDict setObject:OldpasswordTextField.text forKey:KDAoldPassword];
    [loginDict setObject:NewpasswordTextField.text forKey:KDAnewPassword];
    [loginDict setObject:deviceId forKey:KDAResetpswDevideId];
    [loginDict setObject:@"2" forKey:KDAUserType];
    [loginDict setObject:sessionToken forKey:KDASeesionToken];
    

    
    NSMutableURLRequest *request = [Service parseResetpassword:loginDict];
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    handler.requestType = eResetpwd;
    [handler placeWebserviceRequestWithString:request Target:self Selector:@selector(ResetResponse:)];
    
    // Activating progress Indicator.
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Signing in"];
}

-(void)ResetResponse:(NSDictionary *)dictionary
{
    NSLog(@"%@",dictionary);
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
    NSLog(@"response:%@",dictionary);
    if (!dictionary)
    {
        
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[dictionary objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }
    else if ([dictionary objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[dictionary objectForKey:@"Error"]];
        
    }
    else
    {
        
        
        NSDictionary *dictResponse=[dictionary objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            OldpasswordTextField.text=@"";
            NewpasswordTextField.text =@"";
            ConfirmpasswordTextField.text =@"";
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
        }
        else
        {
            OldpasswordTextField.text=@"";
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
        }
    }

    
}






@end
