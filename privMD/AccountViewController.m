//
//  AccountViewController.m
//  privMD
//
//  Created by Rahul Sharma on 19/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "AccountViewController.h"
#import "XDKAirMenuController.h"
#import "PatientViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "CustomNavigationBar.h"
#import "Database.h"


#import "UpdatePasswordViewController.h"


@interface AccountViewController () <CustomNavigationBarDelegate>
@end

@implementation AccountViewController
@synthesize mainScroll;
@synthesize logoutButton;
@synthesize accFirstNameTextField;
@synthesize accLastNameTextField;
@synthesize accEmailTextField;
@synthesize accPasswordTextField;
@synthesize accPhoneNoTextField;
@synthesize accProfilePic;
@synthesize accProfileButton;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - WebService call

-(void)sendServiceForUpdateProfile
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Saving.."];
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *fName = accFirstNameTextField.text;
    NSString *lName = accLastNameTextField.text;
    NSString *eMail = accEmailTextField.text;
    NSString *phone = accPhoneNoTextField.text;
    
    NSDictionary *params =  @{ @"ent_sess_token":sessionToken,
                               @"ent_dev_id": deviceId,
                               @"ent_first_name":fName,
                               @"ent_last_name":lName,
                               @"ent_email":eMail,
                               @"ent_phone":phone,
                               @"ent_date_time":[Helper getCurrentDateTime]
                               };
    
    NetworkHandler *network = [NetworkHandler sharedInstance];
    [network composeRequestWithMethod:@"updateProfile" paramas:params
                         onComplition:^(BOOL success , NSDictionary *response){
                             
                             [[ProgressIndicator sharedInstance] hideProgressIndicator];
                             if (success) {
                                 [self updateProfileResponse:response];
                             }
                             else{
                                 [[ProgressIndicator sharedInstance] hideProgressIndicator];
                                 
                             }
                         }];

}

-(void)updateProfileResponse:(NSDictionary *)response
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
        
        
        NSDictionary *dictResponse=[response mutableCopy];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:accFirstNameTextField.text forKey:KDAFirstName];
            [[NSUserDefaults standardUserDefaults] setObject:accLastNameTextField.text forKey:KDALastName];
            [[NSUserDefaults standardUserDefaults] setObject:accEmailTextField.text forKey:KDAEmail];
            [[NSUserDefaults standardUserDefaults] setObject:accPhoneNoTextField.text forKey:KDAPhoneNo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    }
    
}

-(void)sendServiceForegetProfileData
{
   // [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
    CGRect fra = accProfilePic.frame;
    fra.origin.x = accProfilePic.frame.size.width/2-10;
    fra.origin.y = accProfilePic.frame.size.height/2-10;
    fra.size.width = 20;
    fra.size.height = 20;
    activityIndicator = [[UIActivityIndicatorView alloc]init];
    activityIndicator.frame = fra;
    [self.accProfilePic addSubview:activityIndicator];
    activityIndicator.backgroundColor=[UIColor clearColor];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];

    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSDictionary *params =  @{ @"ent_sess_token":sessionToken,
                               @"ent_dev_id": deviceId,
                               @"ent_date_time":[Helper getCurrentDateTime]
                               };
    
    NetworkHandler *network = [NetworkHandler sharedInstance];
    [network composeRequestWithMethod:@"getProfile" paramas:params
                         onComplition:^(BOOL success , NSDictionary *response){
                             
                             [[ProgressIndicator sharedInstance] hideProgressIndicator];
                             if (success) {
                                 [self getProfileResponse:response];
                             }
                             else{
                                 [[ProgressIndicator sharedInstance] hideProgressIndicator];
                                 
                             }
                         }];
    

    
}

-(void)getProfileResponse:(NSDictionary *)response
{
  //  ProgressIndicator *pi = [ProgressIndicator sharedInstance];
  //  [pi hideProgressIndicator];
    
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
        NSDictionary *dictResponse=[response mutableCopy];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
          
            
            NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForOriginalImage,dictResponse[@"pPic"]];
            
            __weak typeof(self) weakSelf = self;
            
          [accProfilePic sd_setImageWithURL:[NSURL URLWithString:strImageUrl]
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                  [weakSelf.activityIndicator stopAnimating];
                                  }];
            
            
            accFirstNameTextField.text = dictResponse[@"fName"];
            accLastNameTextField.text = dictResponse[@"lName"];
            accPhoneNoTextField.text = dictResponse[@"phone"];
            accEmailTextField.text = dictResponse[@"email"];

        }
        
        else if ([[dictResponse objectForKey:@"errFlag"] intValue] == 1)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KDAcheckUserSessionToken];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [XDKAirMenuController relese];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                        @"Main" bundle:[NSBundle mainBundle]];
            PatientViewController *viewcontrolelr = [storyboard instantiateViewControllerWithIdentifier:@"splash"];
            self.navigationController.viewControllers = [NSArray arrayWithObjects:viewcontrolelr, nil];
            
        }

        else
        {
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   // self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    self.navigationController.navigationBarHidden = YES;

    self.view.backgroundColor = [UIColor grayColor];
    
     accProfilePic.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"patitentprofile_imagethumbnail.png"]];
    
    accFirstNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KDAFirstName];
    accFirstNameTextField.textColor = UIColorFromRGB(0x000000);
    accFirstNameTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    
    accLastNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KDALastName];
    accLastNameTextField.textColor = UIColorFromRGB(0x000000);
    accLastNameTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    
  

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    accEmailTextField.userInteractionEnabled = NO;
    accFirstNameTextField.userInteractionEnabled = NO;
    accLastNameTextField.userInteractionEnabled = NO;
    accPhoneNoTextField.userInteractionEnabled = NO;
    accPasswordTextField.userInteractionEnabled = NO;
    
    accEmailTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KDAEmail];
    accEmailTextField.textColor = UIColorFromRGB(0x000000);
    
   
    accEmailTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];

    accPhoneNoTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:KDAPhoneNo];
    accPhoneNoTextField.textColor = UIColorFromRGB(0x000000);
    accPhoneNoTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    
    accPasswordTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:KDAPassword];
    accPasswordTextField.textColor = UIColorFromRGB(0x000000);
    accPasswordTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    
    accPasswordTextField.textColor = UIColorFromRGB(0x000000);
    accPasswordTextField.font = [UIFont fontWithName:Trebuchet_MS size:13];
    
    [logoutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
    [logoutButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [logoutButton setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
    CGRect frameTopview = logoutButton.frame;
    frameTopview.origin.y = self.view.bounds.size.height - 65;
    [self addCustomNavigationBar];
    
    [self sendServiceForegetProfileData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    [accPhoneNoTextField resignFirstResponder];
    [accFirstNameTextField resignFirstResponder];
    [accLastNameTextField resignFirstResponder];
    [accEmailTextField resignFirstResponder];
    
    
}
#pragma mark ButtonAction Methods -

- (void)menuButtonPressedAccount
{
    [self.view endEditing:YES];
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}
- (void)saveUserDetails:(id)sender
{
   
    UIButton *mBut = (UIButton *)sender;
    
    mBut.userInteractionEnabled = YES;
    {
        if(mBut.isSelected)
        {
            mBut.selected =NO;
           // [mBut setTitle:@"EDIT" forState:UIControlStateNormal];
            accEmailTextField.userInteractionEnabled = NO;
            accFirstNameTextField.userInteractionEnabled = NO;
            accLastNameTextField.userInteractionEnabled = NO;
            accPhoneNoTextField.userInteractionEnabled = NO;
            accPasswordTextField.userInteractionEnabled = NO;
            if(textFieldEditedFlag == 1)
            {
                [self sendServiceForUpdateProfile];
                textFieldEditedFlag = 0;
            }
        }
        else
        {
            mBut.selected = YES;
           // [mBut setTitle:@"SAVE" forState:UIControlStateSelected];
            accEmailTextField.userInteractionEnabled = YES;
            accFirstNameTextField.userInteractionEnabled = YES;
            accLastNameTextField.userInteractionEnabled = YES;
            accPhoneNoTextField.userInteractionEnabled = YES;
            accPasswordTextField.userInteractionEnabled = NO;

        }
    }
}

#pragma mark Custom Methods -

- (void) addCustomNavigationBar
{
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
     customNavigationBarView.tag = 78;
     customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"PROFILE"];
    [customNavigationBarView createRightBarButton];
    //[customNavigationBarView setRightBarButtonTitle:@"EDIT"];
    
    [customNavigationBarView setBackgroundColor:BUTTON_NG_Color];
    [self.view addSubview:customNavigationBarView];
    
}

-(void)rightBarButtonClicked:(UIButton *)sender{
    
    [self.view endEditing:YES];
    [self saveUserDetails:sender];
}
-(void)leftBarButtonClicked:(UIButton *)sender{
    [self menuButtonPressedAccount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (IBAction)profilePicButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Edit Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (IBAction)passwordButtonClicked:(id)sender
{
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *vc = nil;
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"updatePasswordViewController"];

   // [Helper showAlertWithTitle:@"Message" Message:@"Please visit our website texirtr.net to change your password."];
//[self performSegueWithIdentifier:@"gotoUpdatePassword" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"gotoUpdatePassword"])
    {
        
    }
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   /* UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Comming Soon!" message:@"Image Uploading feature is under Process! Sorry to redirect you to the home page!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    alert=nil;
    return;*/
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Uploading Profile Pic..."];
    //  _flagCheckSnap = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    TELogInfo(@"Image Info : %@",info);
    
    _pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    accProfilePic.image = _pickedImage;
    
   // NSData *data=UIImagePNGRepresentation(_pickedImage);
    
//    NSString *FileName=[NSString stringWithFormat:@"patient.png"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *tempPath = [documentsDirectory stringByAppendingPathComponent:FileName];
//    [data writeToFile:tempPath atomically:YES];
    
    UploadFile * upload = [[UploadFile alloc]init];
    upload.delegate = self;
    [upload uploadImageFile:_pickedImage];
}

#pragma UploadFileDelegate

-(void)uploadFile:(UploadFile *)uploadfile didUploadSuccessfullyWithUrl:(NSArray *)imageUrls
{
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
}
-(void)uploadFile:(UploadFile *)uploadfile didFailedWithError:(NSError *)error{
    TELogInfo(@"upload file  error %@",[error localizedDescription]);
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator hideProgressIndicator];
    {
        [Helper showAlertWithTitle:@"Oops!" Message:@"Your profile photo has not been updated try again."];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textFieldEditedFlag = 1;
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
   
    if(textField == accPasswordTextField)
    {
        
    }
    return YES;
}

-(void)moveViewUpToPoint:(int)point
{
    CGRect rect = self.view.frame;
    rect.origin.y = point;
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         self.view.frame = rect;
                     }
                     completion:^(BOOL finished){
                     }];
    
    
    
}

-(void)moveViewDown
{
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    
    
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         self.view.frame = rect;
                     }
                     completion:^(BOOL finished){
                     }];
    
}


@end
