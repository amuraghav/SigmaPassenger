//
//  CardLoginViewController.h
//  privMD
//
//  Created by Rahul Sharma on 13/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadFiles.h"
#import "PTKView.h"
#import <Stripe.h>
@interface CardLoginViewController : UIViewController<UploadFileDelegate,UITextFieldDelegate,PTKViewDelegate, UIGestureRecognizerDelegate>
{
    BOOL checkMandatoryCard;
    BOOL checkMandatoryCamera;
    UITextField *postalText;
    int isPresentInDBalready;
    IBOutlet UITextField *OtpTextfield;
    
    IBOutlet UIView *PinEnterView;
}



@property (strong, nonatomic) IBOutlet UIButton *scanButton;
@property (strong, nonatomic) IBOutlet UILabel *tncLabel;

@property (strong, nonatomic) IBOutlet UILabel *agreeLabel;
@property (strong, nonatomic) IBOutlet UIButton *tncButton;

@property (strong, nonatomic) IBOutlet UIView *agreeButton;

@property (strong, nonatomic)  UIButton *navNextButton;

@property (strong, nonatomic)  NSArray *getSignupDetails;
@property (strong,nonatomic)   NSArray *getInfoDetails;
@property (strong, nonatomic) UIImage *pickedImage;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *cvvLabel;
@property (strong, nonatomic) IBOutlet UILabel *postalLabel;
@property (strong, nonatomic) IBOutlet UILabel *expLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (assign,nonatomic) int isComingFromPayment;
@property (assign,nonatomic)  NSMutableArray *arrayContainingCardInfo;
@property IBOutlet PTKView *paymentView;
- (IBAction)doneButtonClicked:(id)sender;

- (IBAction)SubmitButtonClicked:(id)sender;



@end
