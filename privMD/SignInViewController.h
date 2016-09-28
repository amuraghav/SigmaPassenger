//
//  SignInViewController.h
//  privMD
//
//  Created by Rahul Sharma on 13/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface SignInViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,GPPSignInDelegate>
{
    NSDictionary *itemList;
    BOOL checkLoginCredentials;
    
    NSString *fNameStr;
    NSString *lNameStr;
    NSString *EmailStr;
    NSString *StatusStr;
    NSString *pictureURL;
    
    
    
    
  }


@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (strong, nonatomic) IBOutlet UIView *containEmailnPass;
@property (weak, nonatomic) IBOutlet UILabel *fNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (weak, nonatomic) IBOutlet UIButton *_btnRegisterNow;

@property (strong, nonatomic)  UIButton *navDoneButton;
//@property (strong, nonatomic)  UIButton *navCancelButton;
@property (strong, nonatomic) UIImageView *emailImageView;

- (IBAction)forgotPasswordButtonClicked:(id)sender;

- (IBAction)signInButtonClicked:(id)sender;

- (IBAction)btnRegisterNowButtonPressed:(id)sender;

- (IBAction)FBloginPressed:(id)sender;








//TODO::GOOGLE PLUS
@property(weak, nonatomic) IBOutlet GPPSignInButton *signInButton;
// A label to display the result of the sign-in action.
@property(weak, nonatomic) IBOutlet UILabel *signInAuthStatus;
// A label to display the signed-in user's display name.
@property(weak, nonatomic) IBOutlet UILabel *userName;
// A label to display the signed-in user's email address.
@property(weak, nonatomic) IBOutlet UILabel *userEmailAddress;
// An image view to display the signed-in user's avatar image.
@property(weak, nonatomic) IBOutlet UIImageView *userAvatar;
// A button to sign out of this application.
@property(weak, nonatomic) IBOutlet UIButton *signOutButton;
// A button to disconnect user from this application.
@property(weak, nonatomic) IBOutlet UIButton *disconnectButton;
// A button to inspect the authorization object.
@property(weak, nonatomic) IBOutlet UIButton *credentialsButton;
// A dynamically-created slider for controlling the sign-in button width.
@property(weak, nonatomic) UISlider *signInButtonWidthSlider;

// Called when the user presses the "Sign out" button.
- (IBAction)signOut:(id)sender;
// Called when the user presses the "Disconnect" button.
- (IBAction)disconnect:(id)sender;
// Called when the user presses the "Credentials" button.
- (IBAction)showAuthInspector:(id)sender;
//*****************

- (void)reportAuthStatus;
- (void)updateButtons;







@end
