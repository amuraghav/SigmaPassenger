//
//  InvoiceViewController.h
//  privMD
//
//  Created by Surender Rathore on 29/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceViewController : UIViewController<UITextFieldDelegate>
{
    NSString *tipAmount;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
- (IBAction)tipAction:(id)sender;

- (IBAction)submit_reviewAction:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *avgSpeed;
@property (weak, nonatomic) IBOutlet UILabel *avgSpeedText;
@property (weak, nonatomic) IBOutlet UILabel *tipText;

@property (weak, nonatomic) IBOutlet UILabel *bookingID;
@property (weak, nonatomic) IBOutlet UILabel *bookingIDText;
@property (weak, nonatomic) IBOutlet UILabel *ratingTextLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIButton *tip;
@property (weak, nonatomic) IBOutlet UITextField *tipField;

@property (weak, nonatomic) IBOutlet UIButton *submitreviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelviewBtn;


@property(nonatomic,assign) BOOL isComingFromBooking;
@property(nonatomic,strong)NSString *appointmentDate;
@property(nonatomic,strong)NSString *appointmentid;
@property(nonatomic,strong)NSString *doctorEmail;

@property(strong,nonatomic) UITextView *activeTextField;
@property (assign ,nonatomic) BOOL isKeyboardIsShown;

@end
