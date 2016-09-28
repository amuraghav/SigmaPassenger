//
//  fareCalculatorViewController.h
//  UBER
//
//  Created by Rahul Sharma on 12/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fareCalculatorViewController : UIViewController

@property(nonatomic,assign) BOOL isComingFromMapVC;
@property (weak, nonatomic) IBOutlet UIView *sourceView;
@property (weak, nonatomic) IBOutlet UILabel *sourceLoactionLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickupLAbel;

@property (weak, nonatomic) IBOutlet UILabel *sourceDistanceLabel;

@property (weak, nonatomic) IBOutlet UIView *destinationView;
@property (weak, nonatomic) IBOutlet UILabel *destinationLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropoffLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationDistanceLabel;
@property (weak, nonatomic) IBOutlet UIView *centerView;


@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIButton *changeLocationButton;
@property (strong,nonatomic) NSDictionary *locationDetails;
@property (assign, nonatomic) NSInteger carTypesForLiveBookingServer;

- (IBAction)changeLocationButtonClicked:(id)sender;
- (IBAction)goBack_Action:(id)sender;

@end
