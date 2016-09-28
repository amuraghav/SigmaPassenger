//
//  AccountViewController.h
//  privMD
//
//  Created by Rahul Sharma on 19/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadFiles.h"
#import "RoundedImageView.h"


@interface AccountViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UploadFileDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    BOOL textFieldEditedFlag;
}

@property (strong, nonatomic) IBOutlet UITextField *passwordLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIImageView *accProfilePic;
@property (strong, nonatomic) IBOutlet UIButton *accProfileButton;

@property (strong, nonatomic) IBOutlet UITextField *accFirstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *accLastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *accEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *accPhoneNoTextField;
@property (strong, nonatomic) IBOutlet UITextField *accPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) UIActivityIndicatorView * activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *accPasswordButton;

@property (assign ,nonatomic) BOOL isImageNeedsToUpload;
@property (strong, nonatomic) UIImage *pickedImage;
@property (strong, nonatomic) IBOutlet UIButton *pBtn;

//- (IBAction)logoutButtonClicked:(id)sender;
- (IBAction)profilePicButtonClicked:(id)sender;
- (IBAction)passwordButtonClicked:(id)sender;

@end
