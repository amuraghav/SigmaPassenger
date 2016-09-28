//
//  PaymentDetailsViewController.h
//  privMD
//
//  Created by Rahul Sharma on 05/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OfferApplyCallback)();

@interface PaymentDetailsViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIGestureRecognizerDelegate>
{
}
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UILabel *cardNoLabel;

@property (strong, nonatomic) IBOutlet UILabel *expLabel;
@property (strong, nonatomic) IBOutlet UITextField *expTextField;
@property (strong, nonatomic) IBOutlet UITextField *cvvTextField;
@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) IBOutlet UIButton *personalButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) NSDictionary *containingDetailsOfCard;


@property(nonatomic,copy)OfferApplyCallback callback;

- (IBAction)personalButtonClicked:(id)sender;

- (IBAction)deleteButtonClicked:(id)sender;


@end
