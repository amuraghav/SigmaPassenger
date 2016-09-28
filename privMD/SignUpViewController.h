//
//  SignUpViewController.h
//  privMD
//
//  Created by Rahul Sharma on 13/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadFiles.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate, UploadFileDelegate>
{
    NSMutableArray *array;
    BOOL checkSignupCredentials;
    BOOL isTnCButtonSelected;
    __weak IBOutlet UIButton *_btnRegisterNow;
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property(strong,nonatomic) UITextField *activeTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *conPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *creatingLabel;

@property (strong, nonatomic) IBOutlet UIButton *tncCheckButton;


@property (strong, nonatomic) IBOutlet UIButton *tncButton;

@property(nonatomic, strong) NSMutableArray *helperCountry;
@property(nonatomic, strong) NSMutableArray *helperCity;
@property (strong, nonatomic)  UIButton *navNextButton;
@property (strong, nonatomic) UIImage *pickedImage;

@property (assign,nonatomic)  NSMutableArray *arrayContainingCardInfo;



@property (strong, nonatomic) NSArray *saveSignUpDetails;
- (IBAction)profileButtonClicked:(id)sender;
- (IBAction)TermsNconButtonClicked:(id)sender;
- (IBAction)checkButtonClicked:(id)sender;

- (IBAction)btnRegisterNowPressed:(id)sender;

@end
